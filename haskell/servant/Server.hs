{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Server where

import           Data.Aeson
import           Data.List
import           Data.Time.Calendar
import           GHC.Generics
import           Lucid
import           Network.HTTP.Media
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Servant

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
    toJSON = toJSON . showGregorian

instance ToJSON User

users :: [User]
users = [ User "Colin W" 27 "colingw@gmail.com" (fromGregorian 1988 7 5)
        , User "Jack" 2 "jack@cat.com" (fromGregorian 2013 5 31) ]

userApi :: Proxy UserApi
userApi = Proxy

{-}
server :: Server UserApi
server = pure users

app :: Application
app = serve userApi server
-}
main :: IO ()
main = run 8081 app

---

type API = "position" :> Capture "x" Int :> Capture "y" Int :> Get '[JSON] Position
  :<|> "hello" :> QueryParam "name" String :> Get '[JSON] Hi
  :<|> "marketing" :> ReqBody '[JSON] ClientInfo :> Post '[JSON] Email

data Position = Position { x :: Int, y :: Int } deriving Generic

instance ToJSON Position

newtype Hi = Hi { msg :: String } deriving Generic

instance ToJSON Hi

data ClientInfo = ClientInfo
  { clientName :: String
  , clientEmail :: String
  , clientAge :: Int
  , clientInterestedIn :: [String]
  } deriving Generic

instance FromJSON ClientInfo
instance ToJSON ClientInfo

data Email = Email
  { from :: String
  , to :: String
  , subject :: String
  , body :: String
  } deriving Generic

instance ToJSON Email

emailForClient :: ClientInfo -> Email
emailForClient c = Email from' to' subject' body'
  where from' = "great@company.com"
        to'   = clientEmail c
        subject' = "Hey " ++ clientName c ++ ", we miss you!"
        body'    = "Hi " ++ clientName c ++ ",\n\n"
          ++ "Since you've recently turned " ++ show (clientAge c)
          ++ ", have you checked out our latest "
          ++ intercalate ", " (clientInterestedIn c)
          ++ " products? Give us a visit!"

eServer :: Server API
eServer = position :<|> hi :<|> marketing
  where position x y = pure $ Position x y
        hi mname = pure . Hi $ "Hi, " ++ maybe "coward" id mname
        marketing = pure . emailForClient

---

data HTMLLucid

instance Servant.Accept HTMLLucid where
  contentType _ = "text" // "html" /: ("charset", "utf-8")

instance ToHtml a => MimeRender HTMLLucid a where
  mimeRender _ = renderBS . toHtml

instance MimeRender HTMLLucid (Html a) where
  mimeRender _ = renderBS

type PersonAPI = "persons" :> Get '[JSON, HTMLLucid] [Person]

data Person = Person { firstName :: String, lastName :: String } deriving Generic

instance ToJSON Person

instance ToHtml Person where
  toHtml person = tr_ $ do
    td_ (toHtml $ firstName person)
    td_ (toHtml $ lastName person)

  toHtmlRaw = toHtml

instance ToHtml [Person] where
  toHtml ps = table_ $ do
    tr_ $ th_ "first name" *> th_ "last name"
    foldMap toHtml ps

  toHtmlRaw = toHtml

persons :: [Person]
persons = [ Person "Colin" "Woodbury"
          , Person "Jack" "Catworthy" ]

personAPI :: Proxy PersonAPI
personAPI = Proxy

server :: Server PersonAPI
server = pure persons

app :: Application
app = serve personAPI server
