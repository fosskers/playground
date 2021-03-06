-- Playing around with dynamic programming.

module Dynamic where

import Control.Lens
import Data.Function (on)
import Data.Maybe (fromJust)

---

type Weight = Int
type Object = Int
type Value  = Int

---

{-| Max of two branches:
1. Take ith item, find `knapsack` of the `i-1` items and reduced weight.
2. Don't take ith item, find `knapsack` of the `i-1` items and same weight.
-}
knapsack :: Weight -> [(Object,Value,Weight)] -> ([Object],Value,Weight)
knapsack _ [] = ([],0,0)
knapsack w ((xo,xv,xw):xs)
  | w - xw < 0 = ([],0,0)
  | otherwise = fromJust $ maximumByOf both (compare `on` (^. _2)) (a,b)
  where a = knapsack w xs
        b = knapsack (w - xw) xs & _1 %~ (cons xo)
                                 & _2 +~ xv
                                 & _3 +~ xw

foo :: [(Object,Value,Weight)]
foo = [ (1,5,3)
      , (2,3,2)
      , (3,4,3)
      , (4,6,3)
      , (5,7,4)
      ]

{-| What is the greatest common subsequence between two Strings?
The characters of the subsequence must appear in the same order
between the two Strings, but the characters themselves don't need
to appear directly beside one another in the String.
-}
-- It would be nice to memoize this. State monad?
-- We can cull branches. If we know the current Max across the whole tree,
-- and we know the length of the current attempt,
-- if `length globalMax > length curr + length (max of xs ys)`, then
-- we don't have to recurse further, as this whole branch could never "win".
-- 2015 March 25 @ 21:48 - Yes, this is the terrible way. O(2^n)
subseqs :: String -> String -> String
subseqs [] _ = []
subseqs _ [] = []
subseqs (x:xs) (y:ys)
  | x == y    = x : subseqs xs ys
  | otherwise = fromJust $ maximumByOf both (compare `on` length) (a,b)
    where a = subseqs xs (y:ys)
          b = subseqs (x:xs) ys

bar :: String
bar = "ABCBDABDABCDABADCBAD"

baz :: String
baz = "BDCABBACDBADCBABCBCD"
