{-# LANGUAGE QuasiQuotes #-}

module Main where

import Data.Array.Repa as R
import Data.Array.Repa.Stencil
import Data.Array.Repa.Stencil.Dim2
import Data.Functor.Identity
import Data.Vector (Vector)
--import qualified Data.Vector as V

---

-- | A 2-Dimensional realized Array of unboxed Ints.
square :: Array U DIM2 Int
square = R.fromListUnboxed (Z :. 100 :. 100) [1..10000]

-- | Simple sample convolution. We need to define a `Stencil`, which can be done
-- cleanly with some Template Haskell, and a `Boundary` which defines what to do
-- with indices who fall within stencil but outside the Array.
convolve :: Int
convolve = runIdentity . R.sumAllP $ mapStencil2 b s square
  where b = BoundConst 0
        s = [stencil2| 0 1 0
                       1 0 1
                       0 1 0 |]

main :: IO ()
main = print convolve
