module Swap where

import Text.Regex.PCRE ((=~))

swap :: String -> String -> String -> String
swap orig toSwap ws =
  case ws =~ orig :: (String,String,String) of
   (_,"","") -> ws
   (b,_,a) -> b ++ toSwap ++ a
