module Main where

import Lens.Micro.Platform
import Criterion.Main
import Criterion
import qualified Data.Text.Lazy as TL

main :: IO ()
main = defaultMain [ bench "native" $ nf barNative longText
                   , bench "good"   $ nf bar longText
                   , bench "bad"    $ nf barBad longText ]

longText :: TL.Text
longText = TL.replicate 1000000 (TL.pack "foobar")

-- No Op: 156ms 
-- O: 157ms 
-- O2: 187ms
barNative :: TL.Text -> Int
barNative = TL.foldl' (\n c -> n + fromEnum c) 0

-- No Op: 195ms
-- O: 196ms
-- O2: 190ms
bar :: TL.Text -> Int
bar t = sum (t ^.. each . to fromEnum)

-- No Op: 265ms
-- O: 266ms
-- O2: 283ms
barBad :: TL.Text -> Int
barBad t = sum (t ^.. unpacked . traversed . to fromEnum)
