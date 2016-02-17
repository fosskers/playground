{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module ExtensibleEffects where

import qualified Control.Eff as E
import           Control.Eff hiding ((:>))
import           Control.Eff.Exception
import           Control.Eff.Lift
import           Control.Monad.IO.Class
import           Control.Monad.Trans.Either
import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as B
import qualified Data.Text.Lazy as TL
import           Data.Text.Lazy.Encoding (encodeUtf8)
import           Data.Void
import           GHC.Generics
import           Lens.Micro
import           Network.HTTP.Types
import           Network.Wai (Application, responseLBS)
import qualified Network.Wai.Handler.Warp as W
import           Servant
import           Servant.Docs

---

-- | A nice alias for our combined effect set. Since we know every
-- effect present in the final set, we can write it explicitely like this
-- to avoid the usual `r` variable. `r` complicates the Natural Transformation
-- we define below.
type Effect = Eff (Exc String E.:> Lift IO E.:> Void)

-- | The meat of our Natural Transformation between our Effect set
-- and the default `EitherT ServantErr IO` that servant uses.
effToEither' :: Effect a -> EitherT ServantErr IO a
effToEither' eff = liftIO (runLift $ runExc eff) >>= f
  where f = either (\e -> left err404 { errBody = B.pack e }) right

-- | The Natural Transformation
effToEither :: Effect :~> EitherT ServantErr IO
effToEither = Nat effToEither'

type CatAPI = "cats" :> Get '[JSON] [Cat]
              :<|> "cat" :> QueryParam "name" String :> Get '[JSON] Cat

instance ToParam (QueryParam "name" String) where
  toParam _ = DocQueryParam "name"
    ["Jack","Miso","Turbo","Pip","Qtip"]
    "Lookup cat info by their name."
    Normal

data Cat = Cat { name :: String, collar :: Bool } deriving Generic

instance ToJSON Cat

instance ToSample Cat Cat where
  toSample _ = Just (Cat "Jack" True)

instance ToSample [Cat] [Cat] where
  toSample _ = Just ([Cat "Jack" True, Cat "Miso" False])

cats :: [Cat]
cats = [ Cat "Jack" True
       , Cat "Miso" False
       , Cat "Turbo" False
       , Cat "Pip" False
       , Cat "Qtip" True ]

catNoises :: SetMember Lift (Lift IO) r => Eff r ()
catNoises = lift $ putStrLn "Meow meow."

-- | Here we see nice mixing of two effects, Exc and IO.
-- Notice we also call "child" effects (which claim less effects than
-- the whole set) with no overhead.
catLookup :: Maybe String -> Effect Cat
catLookup Nothing = throwExc ("No cat name given!" :: String)
catLookup (Just n) = do
  case cats ^? each . filtered ((== n) . name) of
    Nothing -> throwExc $ "There is no cat named " ++ n ++ "!"
    Just c -> (lift . putStrLn $ "Found cat: " ++ n) *> catNoises *> pure c

-- | A server using our custom handler Monad.
serverT :: ServerT CatAPI Effect
serverT = pure cats :<|> catLookup

type DocsAPI = CatAPI :<|> Raw

-- | Our `ServerT` mapped backed to a vanilla `Server` via the N.T. above.
server :: Server DocsAPI
server = enter effToEither serverT :<|> serveDocs
  where serveDocs _ respond = respond $ responseLBS ok200 [plain] docsBS
        plain = ("Content-Type", "text/plain")

docsBS :: B.ByteString
docsBS = encodeUtf8 . TL.pack . markdown $ docsWithIntros [intro] api
  where intro = DocIntro "Cat API" ["The only API the internet needs."]

api :: Proxy DocsAPI
api = Proxy

app :: Application
app = serve api server

main :: IO ()
main = W.run 8081 app
