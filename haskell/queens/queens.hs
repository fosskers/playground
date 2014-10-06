-- 8 Queens in Haskell
-- Just a copy of the Scala and probably terrible.

import Data.List (permutations)

---

areDiag :: (Int,Int) -> (Int,Int) -> Bool
areDiag (a1,a2) (b1,b2) = abs (a1 - b1) == abs (a2 - b2)

diagsClear :: [Int] -> Bool
diagsClear board = f $ map (\x -> (x, index x board)) board
    where f []     = True
          f (x:xs) = (and $ map (\y -> not $ areDiag x y) xs) && f xs

index :: Eq a => a -> [a] -> Int
index a xs = f xs 0
    where f (y:ys) n | a == y    = n
                     | otherwise = f ys (n+1)

solve = filter diagsClear ps
    where ps = permutations [1..8]
