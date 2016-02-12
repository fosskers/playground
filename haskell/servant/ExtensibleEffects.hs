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
import           Data.Void
import           GHC.Generics
import           Network.Wai (Application)
import qualified Network.Wai.Handler.Warp as W
import           Servant

---

type Effect = Eff (Exc String E.:> Lift IO E.:> Void)

effToEither' :: Effect a -> EitherT ServantErr IO a
effToEither' eff = liftIO (runLift $ runExc eff) >>= f
  where f = either (\e -> left err404 { errReasonPhrase = e }) right

effToEither :: Effect :~> EitherT ServantErr IO
effToEither = Nat effToEither'

type API = "cats" :> Get '[JSON] [Cat]

data Cat = Cat { name :: String, collar :: Bool } deriving Generic

instance ToJSON Cat

cats :: [Cat]
cats = [ Cat "Jack" True
       , Cat "Miso" False
       , Cat "Turbo" False
       , Cat "Pip" False
       , Cat "Qtip" True ]

api :: Proxy API
api = Proxy

server :: Server API
server = pure cats

app :: Application
app = serve api server

main :: IO ()
main = W.run 8081 app
