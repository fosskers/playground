{-# LANGUAGE OverloadedStrings #-}

{-| Make `text8` smaller
Apparently `skipgram` works better the more individual sentences you have.
Write now, we only have one single line. Choosing sentences to be of
average length 8.
-}

import           Control.Monad ((>=>))
import qualified Data.Text as T
import qualified Data.Text.IO as TIO

---

-- | Form sublists, each of length `n`.
groupsOf :: Int -> [a] -> [[a]]
groupsOf _ [] = []
groupsOf n xs = take n xs : groupsOf n (drop n xs)

main :: IO ()
main = do
  TIO.putStrLn "Reading file..."
  ts <- (T.lines >=> T.words) <$> TIO.readFile "text8"
  let ts' = take (length ts `div` 3) ts
  TIO.putStrLn "Writing file..."
  TIO.writeFile "text8-smaller" . T.unlines . map T.unwords $ groupsOf 8 ts'
  TIO.putStrLn "Done."
