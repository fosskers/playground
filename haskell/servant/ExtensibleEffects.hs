{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}

module ExtensibleEffects where

import           Control.Eff hiding ((:>))
import           Data.Aeson
import           GHC.Generics
import           Network.Wai
import qualified Network.Wai.Handler.Warp as W
import           Servant

---

type API = "cats" :> Get '[JSON] [Cat]

data Cat = Cat { name :: String, collar :: Bool } deriving Generic

instance ToJSON Cat

cats :: [Cat]
cats = [ Cat "Jack" True
       , Cat "Miso" False
       , Cat "Turbo" False
       , Cat "Pip" False ]

api :: Proxy API
api = Proxy

server :: Server API
server = pure cats

app :: Application
app = serve api server

main :: IO ()
main = W.run 8081 app
