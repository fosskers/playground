{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}

module ExtensibleEffects where

import qualified Control.Eff as E
import           Control.Eff hiding ((:>))
import           Control.Eff.Exception
import           Control.Eff.Lift
import           Control.Monad.IO.Class
import           Control.Monad.Trans.Either
import           Data.Aeson
import qualified Data.ByteString.Lazy.Char8 as B
import           Data.Void
import           GHC.Generics
import           Lens.Micro
import           Network.Wai (Application)
import qualified Network.Wai.Handler.Warp as W
import           Servant

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

type API = "cats" :> Get '[JSON] [Cat]
           :<|> "cat" :> QueryParam "name" String :> Get '[JSON] Cat

data Cat = Cat { name :: String, collar :: Bool } deriving Generic

instance ToJSON Cat

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
catLookup Nothing = throwExc "No cat name given!"
catLookup (Just n) = do
  case cats ^? each . filtered ((== n) . name) of
    Nothing -> throwExc $ "There is no cat named " ++ n ++ "!"
    Just c -> (lift . putStrLn $ "Found cat: " ++ n) *> catNoises *> pure c

-- | A server using our custom handler Monad.
serverT :: ServerT API Effect
serverT = pure cats :<|> catLookup

-- | Our `ServerT` mapped backed to a vanilla `Server` via the N.T. above.
server :: Server API
server = enter effToEither serverT

api :: Proxy API
api = Proxy

app :: Application
app = serve api server

main :: IO ()
main = W.run 8081 app
