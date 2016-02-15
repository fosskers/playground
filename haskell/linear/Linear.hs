module Linear where

import Lens.Micro
import Data.Monoid
import Linear.Matrix
import Linear.V3
import Linear.Vector

-----------
--- VECTORS
-----------
manual :: V3 Int
manual = V3 1 2 3

-- | Unit vector in the x direction. `_x` is a Lens into vector spaces.
x :: V3 Int
x = unit _x

-- | Unit vector in the y direction.
y :: V3 Int
y = unit _y

-- | Cross product always produces a vector orthogonal to the first two.
-- Note that: @cross y x == V3 0 0 (-1)@
z :: V3 Int
z = cross x y

-- | We get bases for free by constraining the return type.
basis' :: [V3 Int]
basis' = basis

-- | The existance of `sumV` seems redundant.
sums :: Bool
sums = sumV [x,y,z] == sum [x,y,z]

-- | Vector types are foldable.
sums2 :: Int
sums2 = sum $ sum [x,y,z]

-- | Lenses are hip. Vector types are traversable.
sums3 :: Sum Int
sums3 = [x,y,z] ^. traverse . traverse . to Sum

------------
--- MATRICES
------------
-- | M* matrix types are all aliases of Vs embedded in other Vs.
m :: M44 Int
m = identity

-- | Extract submatrices. The identity here is an `M22`.
yes :: Bool
yes = identity == (m ^. _m22)

mult :: M33 Float
mult = v1 !*! v2
  where v1 = V3 (V3 1 2 3) (V3 4 5 6) (V3 7 8 9)
        v2 = V3 (V3 1 2 8) (V3 3 4 9) (V3 4 5 0)

-- | Comes with inverse functions for up to 4x4 matrices.
inv :: M33 Float
inv = inv33 mult
