-- Playing around with dynamic programming.

module Dynamic where

import Control.Lens
import Data.Function (on)
import Data.Maybe (fromJust)

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
  where a = knapsack (w - xw) xs & _1 %~ (cons $ xo)
                                 & _2 +~ xv
                                 & _3 +~ xw
        b = knapsack w xs

foo :: [(Object,Value,Weight)]
foo = [ (1,5,3)
      , (2,3,2)
      , (3,4,3)
      , (4,6,3)
      , (5,7,4)
      ]
