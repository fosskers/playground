{-# LANGUAGE TupleSections #-}
{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE OverloadedStrings #-}

module UC where

-- Also try hashset lens!

import           Control.Lens
import           Data.HashMap.Lazy
import qualified Data.HashSet as HS
import           Data.HashSet.Lens
import           Data.Hashable
import           Data.Text (Text)
import           Prelude hiding (lookup)

---

-- | HashMap. Usage == that of `Map`.
accounts :: HashMap Text Int
accounts = [("Colin",1000),("Jack",10000),("Fred",123),("Sam",456),("Abe",5)]

deposits :: HashMap Text Int
deposits = [("Colin",456),("Jack",45),("Sam",20)]

deposit :: HashMap Text Int -> HashMap Text Int -> HashMap Text Int
deposit ds as = foldrWithKey (insertWith (+)) as ds

---

-- | HashSet
nums :: HS.HashSet Int
nums = [-10 .. 10]

-- Result may be smaller than original! Hence no Functor instance.
fmap' :: (Hashable a, Eq a) => (b -> a) -> HS.HashSet b -> HS.HashSet a
fmap' f = HS.foldr (\x acc -> HS.insert (f x) acc) HS.empty

t :: (Hashable a, Eq a) => (Int -> a) -> HS.HashSet a
t f = fmap' f nums

pairs :: [(Int,Int)]
pairs = [(1,1),(2,2),(3,3),(4,4),(5,5)]

-- Similar to `_1`
l :: Lens' (a,b) a
l f (a,b) = (,b) `fmap` f a

-- Constructing sets after applying many lenses.
cool :: (Hashable a, Eq a) => [(a,b)] -> HS.HashSet a
cool = setOf (traverse . _1)
