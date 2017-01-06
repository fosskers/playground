module Foldl where

import qualified Control.Foldl as F
import           Control.Lens
import           Control.Parallel.Strategies
import           Data.Vector (Vector)

---

-- | `Fold`s are fast, space-efficient aggregations across `Foldable` structures.
--
-- > fold :: Foldable f => Fold a b -> f a -> b
f0 :: Int
f0 = F.fold F.sum [1..1000000]

-- | You can do multiple "summaries" over the data in a single pass.
f1 :: (Integer, Int)
f1 = F.fold f [1..1000000]
  where f :: F.Fold Integer (Integer, Int)  -- Type signature not necessary, just for demonstration.
        f = (,) <$> F.sum <*> F.length

-- | Average / mean
f2 :: Double
f2 = F.fold f [1..1000000]
  where f :: F.Fold Double Double
        f = (/) <$> F.sum <*> F.genericLength

-- | Symbolic math via `Num` instances for `Fold`s.
f3 :: Double
f3 = F.fold f [1..1000000]
  where f :: F.Fold Double Double
        f = sqrt F.sum + F.genericLength

-- | Monadic Folds.
f4 :: IO ()
f4 = F.foldM (F.mapM_ print) [1..10]

-- | Two monadic operations in one pass.
f5 :: IO ((), ())
f5 = F.foldM ((,) <$> F.mapM_ print <*> F.mapM_ print) [1..10]

f6 :: IO (Maybe (Vector Int))
f6 = F.foldM (F.randomN 10) ([1..20] :: [Int])

-- | Folds for parallel operations.
--f7 = undefined
--  where s = undefined

-- | "Focused" Folds via lenses.
f8 :: Int
f8 = F.fold (F.handles _Just F.sum) [Just 1, Nothing, Just 2, Nothing, Just 3]

-- | Traverse both sides of an `Either` at once.
f9 :: Int
f9 = F.fold (F.handles _Right F.sum + F.handles _Left F.sum) [Right 1, Left 2, Right 3]

-- | Monads and Lenses
f10 :: IO ()
f10 = F.foldM (F.handlesM (filtered even) (F.mapM_ print)) [1..10]
