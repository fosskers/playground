module Pasta where

import Control.Applicative
import Control.Lens
import Data.Monoid hiding ((<>))
import Data.Semigroup

---

data Food = F { calories :: Sum Int
              , fat      :: Sum Int
              , carbs    :: Sum Int  -- Sugars!
              , protein  :: Sum Int } deriving (Eq,Show)

instance Semigroup Food where
  F c1 f1 s1 p1 <> F c2 f2 s2 p2 = F (c1 + c2) (f1 + f2) (s1 + s2) (p1 + p2)

foodLens :: Traversal' Food Int
foodLens = fLens . sumLens

fLens :: Traversal' Food (Sum Int)
fLens g (F c f s p) = F <$> g c <*> g f <*> g s <*> g p

sumLens :: Num a => Lens' (Sum a) a
sumLens f (Sum s) = Sum <$> f s

---

meal :: Food
meal = sauce' <> pasta'
  where sauce' = sauce & foodLens %~ (`div` 4)
        pasta' = pasta & foodLens %~ (`div` 2)

sauce :: Food
sauce = sauceBase <> sauceBase <> groundChicken <> onion

pasta :: Food
pasta = F 1660 16 307 66

sauceBase :: Food
sauceBase = F 364 15 47 10

groundChicken :: Food
groundChicken = F 650 30 0 100

onion :: Food
onion = F 64 0 15 2