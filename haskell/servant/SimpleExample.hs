{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

{-| This follows the `servant` tutorial, found at:
http://haskell-servant.github.io/tutorial/api-type.html
-}

module SimpleExample where

import Data.Text
import Servant.API

---

-- | The `/users` endpoint. Use `:<|>` to add more endpoints.
type UserAPI = "users" :> QueryParam "sortBy" SortBy :> Get '[JSON] [User]
  -- Take JSON in on a POST
  :<|> "users" :> ReqBody '[JSON] User :> Post '[JSON] User

  -- Equivalent to `/user/:userid` in other frameworks
  :<|> "user" :> Capture "userid" Integer :> Get '[JSON] User

  -- Pass the `User-Agent` header to the handler
  :<|> "users" :> Header "User-Agent" Text :> Get '[JSON] User

  -- Serve static files local to the project
  :<|> Raw


data SortBy = Age | Name

data User = User { name :: String, age :: Int }
