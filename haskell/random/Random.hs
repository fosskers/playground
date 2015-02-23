{-
From `System.Random`:
This implementation uses the Portable Combined Generator of L'Ecuyer for
32-bit computers, transliterated by Lennart Augustsson. It has a period of
roughly 2.30584e18.
-}

module Random where

import Control.Applicative
import Data.List (partition,zipWith4)
import System.Random

---

areCoPrime :: Int -> Int -> Bool
areCoPrime n m = gcd n m == 1

-- | Pairs of random integers.
pairs :: StdGen -> [(Int,Int)]
pairs = f . randoms
  where f [] = []
        f (x:y:zs) = (x,y) : f zs

-- | The probability of two random integers being coprime is 6/(pi^2)
pi' :: ([Bool],[Bool]) -> Double
pi' (cs,ps) = sqrt $ 6 * (ps' + cs') / cs'
  where cs' = fromIntegral $ length cs
        ps' = fromIntegral $ length ps

mean :: Fractional a => [a] -> a
mean ns = sum ns / (fromIntegral $ length ns)

---

-- | Find the average result at each sample space size.
g :: IO [Double]
g = zipWith4 (\a b c d -> mean [a,b,c,d]) <$> h <*> h <*> h <*> h

-- | Run the solver over increasing sample space size.
h :: IO [Double]
h = mapM i $ map (10^) [1..5]

-- | Solves for pi, given `n` random integer pairs to sample from.
i :: Int -> IO Double  
i n = do
  ps <- fmap pairs newStdGen
  return . pi' . partition id . take n . map (uncurry areCoPrime) $ ps
