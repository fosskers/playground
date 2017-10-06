{-# LANGUAGE DeriveFunctor #-}

module RS2 where

-- https://medium.com/@jaredtobin/practical-recursion-schemes-c10648ec1c29
-- Using Ed Kmett's `recursion-schemes`

import Data.Functor.Foldable
import Data.List.Ordered (merge)
import Prelude hiding (Foldable, succ, pred)

---

-- | A parameterized recursive type for Natural numbers.
-- A "base functor".
data NatF a = Zero | Succ a deriving (Show, Functor)

-- | Handy alias.
type Nat = Fix NatF

zero :: Nat
zero = Fix Zero

succ :: Nat -> Nat
succ = Fix . Succ

-- Use `:kind!` in GHCi to evaluate type families.
natsum :: Nat -> Integer
natsum = cata f
  where f Zero = 0
        f (Succ n) = n + 1

nat :: Int -> Nat
nat = ana f
  where f 0 = Zero
        f n = Succ (n - 1)

fact :: Nat -> Integer
fact = para f
  where f Zero = 1
        f (Succ (fx, n)) = natsum (succ fx) * n

pred :: Nat -> Nat
pred = para f
  where f (Succ (n, _)) = n
        f Zero = zero

-------
-- HYLO
-------

data TreeF a r = EmptyF | LeafF a | NodeF r r deriving (Show, Functor)

mergeSort :: Ord a => [a] -> [a]
mergeSort = hylo alg coalg
  where alg EmptyF = []
        alg (LeafF c) = [c]
        alg (NodeF l r) = merge l r

        coalg [] = EmptyF
        coalg [x] = LeafF x
        coalg xs = NodeF l r where
          (l, r) = splitAt (length xs `div` 2) xs
