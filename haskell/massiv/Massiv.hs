{-# LANGUAGE DataKinds #-}

module Massiv where

import           Data.Massiv.Array as A
import           Data.Massiv.Array.Manifest.Vector (fromVector)
import qualified Data.Vector.Unboxed as U

{- Differences between Repa and Massiv:

- Massiv has more "underlying representations".
- Much more powerful stencils, with more builtin border pixel handlers.

-}

-----------
-- CREATION
-----------

-- | A one-dimensional vector.
create0 :: Array U Ix1 Int
create0 = makeVectorR U Seq 11 id

{-
(Array U Par (3 :. 4)
  [ [ 0,0,0,0 ]
  , [ 0,1,2,3 ]
  , [ 0,2,4,6 ]
  ])

The inner-most index value is the COLUMN. Next is the ROW, followed by
the Z-axis.
-}
create1 :: Array U Ix2 Int
create1 = makeArrayR U Par (3 :. 4) (\(r :. c) -> r * c)

-- | New dimensions require the (:>) operator.
create2 :: Array U (IxN 3) Int
create2 = makeArrayR U Par (2 :> 3 :. 4) (\(z :> r :. c) -> z * r * c)

-- | Little guy.
create3 :: Array U Ix1 Int
create3 = singleton Seq 1

{-
(Array U Seq (3 :. 4)
[ [ 1,2,3,4 ]
, [ 5,6,7,8 ]
, [ 9,10,11,12 ]
])
-}
create4 :: Array U Ix2 Int
create4 = fromVector Seq (3 :. 4) $ U.fromList [1..12]

-----------------
-- MAPS AND FOLDS
-----------------

-- | Delayed (D) arrays are Functors.
manip0 :: Array D Ix2 Int
manip0 = (*2) <$> delay create1

-- | The usual folds exist (sum, product, etc.)
manip1 :: Int
manip1 = A.sum $ makeArrayR D Seq (10 :> 20 :> 30 :. 40) (\(i :> j :> k :. l) -> (i * j + k) * k + l)

----------
-- SLICING
----------

-- (Array M Seq (4)
--   [ 5,6,7,8 ])
slice0 :: Array M Ix1 Int
slice0 = create4 !> 1

-- (Array M Seq (3)
--   [ 2,6,10 ])
slice1 :: Array M Ix1 Int
slice1 = create4 <! 1

--------------
-- COMPUTATION
--------------

-- | Seq: Will be computed sequentially on one core.
comp0 :: Array D Ix2 Int
comp0 = makeArrayR D Seq (1000 :. 1000) (\(r :. c) -> r * c)

-- | Par: Will be computed in parallel across all cores.
comp1 :: Array D Ix2 Int
comp1 = makeArrayR D Par (1000 :. 1000) (\(r :. c) -> r * c)

-- | SeqOn: Will be computed in parallel on particular cores.
comp2 :: Array D Ix2 Int
comp2 = makeArrayR D (ParOn [1,2]) (1000 :. 1000) (\(r :. c) -> r * c)

-- | `compute` will run all fused computations and produce a real memory-backed
-- Array.
comp3 :: Array U Ix2 Int
comp3 = compute comp0

-- | Same as above, except the target representation is passed explicitely.
comp4 :: Array P Ix2 Int
comp4 = computeAs P comp1

-- | Change computation strategy on the fly.
comp5 :: Array D Ix2 Int
comp5 = setComp Par comp0

-----------
-- STENCILS
-----------

-- | Must indicate the stencil dimensions as well as the input/output types.
-- `f` is a "getter" that retrieves values based on an index relative to the
-- centre (the current pixel, say).
stencil0 :: Stencil Ix2 Int Int
stencil0 = makeStencil (Fill 0) (3 :. 3) (1 :. 1) $ \f ->
  f (0 :. -1) + f (0 :. 1) + f (-1 :. 0) + f (1 :. 0)

stencil1 :: Array DW Ix2 Int
stencil1 = mapStencil stencil0 $ makeArrayR P Par (1000 :. 1000) (const 1)

-- | Something with `DW` representation can't be printed - it must be calculated
-- first. `Array DW` is also a `Functor`.
stencil2 :: Array P Ix2 Int
stencil2 = computeAs P . extract' (0 :. 0) (10 :. 10) $ fmap (+1) stencil1
