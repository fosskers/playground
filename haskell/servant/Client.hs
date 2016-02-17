{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}

module Client where

import Control.Monad.Trans.Either
import Data.Aeson
import Data.Proxy
import GHC.Generics
import Servant.API
import Servant.Client

---

-- | Near-copy of the Server's API. In theory, when we write API accessors
-- like this, we know the entire API specification, so we know if each
-- endpoint needs `Capture` or `QueryParam`, etc.
type API = "cats" :> Get '[JSON] [Kitty]
           :<|> "cat" :> QueryParam "name" String :> Get '[JSON] Kitty

-- | Analagous to the `Cat` datatype in the Server.
data Kitty = Kitty { name :: String, collar :: Bool } deriving (Show,Generic)

instance FromJSON Kitty

api :: Proxy API
api = Proxy

-- | We get our query functions for free!
cats :<|> cat = client api (BaseUrl Http "localhost" 8081)

queries :: EitherT ServantError IO ([Kitty],Kitty)
queries = (,) <$> cats <*> cat (Just "Jack")

go :: IO ()
go = do
  res <- runEitherT queries
  case res of
    Left err -> putStrLn $ "Error: " ++ show err
    Right (ks,k) -> print ks *> print k
