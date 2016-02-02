{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}

module Server where

import           Data.Aeson
import qualified Data.Aeson.Parser
import           Data.Aeson.Types
import           Data.Attoparsec.ByteString
import           Data.ByteString (ByteString)
import           Data.Int
import           Data.List
import           Data.String.Conversions
import           Data.Time.Calendar
import           GHC.Generics
import           Lucid
import           Network.HTTP.Media
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Servant
import           System.Directory
import           Text.Blaze
import qualified Text.Blaze.Html
import           Text.Blaze.Html.Renderer.Utf8

---

type UserApi = "users" :> Get '[JSON] [User]

data User = User
  { name :: String
  , age :: Int
  , email :: String
  , registration_date :: Day
  } deriving (Eq, Show, Generic)

instance ToJSON Day where
    -- display a day in YYYY-mm-dd format
    toJSON d = toJSON (showGregorian d)

instance ToJSON User

users :: [User]
users = [ User "Colin W" 27 "colingw@gmail.com" (fromGregorian 1988 7 5)
        , User "Jack" 2 "jack@cat.com" (fromGregorian 2013 5 31) ]

server :: Server UserApi
server = pure users

userApi :: Proxy UserApi
userApi = Proxy

app :: Application
app = serve userApi server

main :: IO ()
main = run 8081 app
