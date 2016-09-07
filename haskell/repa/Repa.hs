{-# LANGUAGE QuasiQuotes #-}

module Main where

import Data.Array.Repa as R
import Data.Array.Repa.Repr.Vector
import Data.Array.Repa.Stencil
import Data.Array.Repa.Stencil.Dim2
import Data.Functor.Identity

---

{-|

Chapter 5 of /Parallel and Concurrent Programming in Haskell/ focuses on Repa,
and is excellent as a starting point for learning its concepts.

-}

{- Array Creation -}

-- | A 2-Dimensional realized Array of unboxed Ints.
square :: Array U DIM2 Int
square = R.fromListUnboxed (Z :. 100 :. 100) [1..10000]

-- | An alias for a boxed `Data.Vector.Vector`.
boxedVec :: Array V DIM1 String
boxedVec = fromListVector (Z :. 5) $ words "My cat is very black"

{- Array Operations -}

-- | Common math operations.
summed :: Array D DIM2 Int
summed = square +^ square

-- | Interleave multiple arrays.
-- Try: @computeS inter :: Array V DIM1 String@
inter :: Array D DIM1 String
inter = interleave2 boxedVec boxedVec

-- | Fold the innermost dimension.
folded :: Array U DIM1 Int
folded = runIdentity . foldP (+) 0 $ extract (Z :. 100 :. 100) (Z :. 50 :. 50) square

{- Simple Convolution -}

-- | Simple sample convolution. We need to define a `Stencil`, which can be done
-- cleanly with some Template Haskell, and a `Boundary` which defines what to do
-- with indices who fall within stencil but outside the Array.
--
-- This methods is best used when you know the shape of your stencil at compile
-- time, and the stencil is small (7x7 or smaller).
convolve :: Int
convolve = runIdentity . R.sumAllP $ mapStencil2 b s square
  where b = BoundConst 0
        s = [stencil2| 0 1 0
                       1 0 1
                       0 1 0 |]

main :: IO ()
main = print convolve
