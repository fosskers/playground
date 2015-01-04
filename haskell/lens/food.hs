module Food where

import Control.Applicative
import Control.Lens
import Data.Monoid hiding ((<>))
import Data.Semigroup

---

data Food = F { calories :: Sum Float
              , fat      :: Sum Float
              , carbs    :: Sum Float  -- Sugars!
              , protein  :: Sum Float } deriving (Eq,Show)

instance Semigroup Food where
  F c1 f1 s1 p1 <> F c2 f2 s2 p2 = F (c1 + c2) (f1 + f2) (s1 + s2) (p1 + p2)

foodLens :: Traversal' Food Float
foodLens = fLens . _Wrapping Sum

fLens :: Traversal' Food (Sum Float)
fLens g (F c f s p) = F <$> g c <*> g f <*> g s <*> g p

---

{-| MEALS -}
sandwich :: Food
sandwich = bread <> bread <> cheese <> chicken

meal :: Food
meal = sauce' <> pasta'
  where sauce' = sauce & foodLens //~ 4
        pasta' = pasta & foodLens //~ 2

sauce :: Food
sauce = sauceBase <> sauceBase <> groundChicken <> onion

-- Cambell's Chunky
soup :: Food
soup = F 150 5 20 7 & foodLens *~ 2.16

{-| INGREDIENTS -}
pasta :: Food
pasta = F 1660 16 307 66

sauceBase :: Food
sauceBase = F 364 15 47 10

groundChicken :: Food
groundChicken = F 650 30 0 100

onion :: Food
onion = F 64 0 15 2

-- 1 inch^3
cheese :: Food
cheese = F 120 10 0 7

-- 1 cup == 140g
chicken :: Food
chicken = F 231 5 0 43

bread :: Food
bread = F 110 2 17 6
