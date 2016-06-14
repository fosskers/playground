module Main where

import           Criterion.Main
import qualified Data.Discrimination as D
import qualified Data.List as L
import qualified Data.Map.Lazy as M

---

{- GROUPING -}

-- | Groups elements, and they don't need to be clustered!
grouped :: [[Int]]
grouped = D.group [1,2,1,2,1,2]  -- [[1,1,1],[2,2,2]]

{- BENCHMARKS -}

theList :: [Int]
theList = concat $ replicate 10000 [1,6,3,7,9,3,0,4,5,8,2]

theAscList :: [(Int,Char)]
theAscList = zip ([100000,99999..1] ++ [100000,99999..1]) (concat $ repeat ['a'..'z'])

-- | D.sort has better time complexity, so sorts faster on larger lists.
-- D.toMap always seems to be slower, although it claims to opposite.
main :: IO ()
main = defaultMain [ bench "Data.List.sort" $ nf L.sort theList
                   , bench "Data.Discrimination.sort" $ nf D.sort theList
                   , bench "Data.Map.Lazy.fromList" $ nf M.fromList theAscList
                   , bench "Data.Discrimination.toMap" $ nf D.toMap theAscList
                   ]
