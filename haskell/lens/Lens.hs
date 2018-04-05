{-# LANGUAGE Rank2Types #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}
{-# LANGUAGE OverloadedLists #-}

module Lens where

-- Blog post explaining how Lenses are derived:
-- http://blog.jakubarnold.cz/2014/07/14/lens-tutorial-introduction-part-1.html

import           Control.Applicative ((<$>),(<*>))
import           Control.Lens
import qualified Data.HashMap.Lazy as HM
import           Data.Monoid
import           Data.Text (Text)
import qualified Data.Text as T
import           Data.Tree
import           Data.Tree.Lens

---

fun :: [[(Text,Text)]] -> Sum Int
fun s = s ^. traverse . traverse . _1 . to (Sum . T.length)

s1 :: [[(Text,Text)]]
s1 = [[("this","is good")]]

s2 :: [[(Text,Text)]]
s2 = [[("this","is good"),("this","is also good")]]

-- Works with any tuple.
g1 :: (Field1 a a b b, Traversable t) => t a -> [b]
g1 s = s ^.. traverse . _1

-- Limited to a 2-tuple.
g2 :: Traversable t => t (a,b) -> t a
g2 = runIdentity . traverse (Identity . fst)

s3 :: [(Int,Int)]
s3 = [(1,1),(2,2),(3,3),(4,4),(5,5)]

---

-- Will fold the contents of most things.
h :: (Each t t a a, Monoid a) => t -> a
h x = x ^. each  -- == foldOf each t == view each t

i :: (Each t t a a, Num a) => [t] -> a
i = sum . map (productOf each)

{- 2014 August 17 @ 12:36
Why does the following not work:

  sumOf each . productOf each

-}
j :: (Each b b a a, Each s s b b, Num a) => s -> a
j = sumOf (each . to (productOf each))

---

-- Similar to `both`
k :: Traversal' (a,a) a
k f (x,y) = (,) <$> f x <*> f y

-- Similar to `_1`
l :: Lens' (a,b) a
l f (a,b) = fmap (,b) $ f a

-- Similar to `_2`
m :: Lens' (a,b) b
m f (a,b) = fmap (a,) $ f b

-- `%~` takes a pure transformation and sets with that.
n0 :: HM.HashMap Int (Int,Int,Int) --[(Integer,Integer)]
n0 = [(0,(1,2,3)),(1,(3,4,5))] & mapped . each %~ succ

-- `.~` sets to a given value.
o :: [(Integer,Integer)]
o = [(1,2),(3,4)] & mapped . both .~ 0

---

data User = User { userName :: Text
                 , postsOf :: [Post] } deriving Show

data Post = Post { postOf :: Text } deriving Show

posts :: Lens' User [Post]
posts f (User n p) = fmap (\p' -> User n p') (f p)

title :: Lens' Post Text
title f (Post t) = fmap Post (f t)

users :: [User]
users = [ User "john" [Post "hello", Post "world"]
        , User "bob" [Post "foobar"] ]

{- Traversals can be used as Getters, although the Lens UML
would have you believe otherwise.

In `Control.Lens.Traversal`, we have:

While a Traversal isn't quite a Fold, it _can_ be used for Getting
like a Fold, because given a Monoid m, we have an Applicative for (Const m).
-}
goDeep :: Traversal' [User] Text
goDeep = traverse . posts . traverse . title

-- Getting a list of the contents of all posts.
lensGet :: [Text]
lensGet = users ^.. goDeep

-- Can only "get" this way.
manualGet :: [Text]
manualGet = concat $ map (map postOf . postsOf) users

-- This is possible because the Applicative instance for Const demands
-- a Monoid.
together :: Text
together = users ^. goDeep

lensSet :: Text -> [User]
lensSet b = users & goDeep .~ b

-- _Very_ manual.
manualSet :: Text -> [User]
manualSet b = map f users
    where f (User n ps) = User n $ map g ps
          g (Post _)    = Post b

--------
-- Trees
--------
p0 :: Show a => Tree a -> IO ()
p0 = putStrLn . drawTree . fmap show

tree :: Tree Int
tree = Node 1
  [ Node 2
    [ Node 4 []
    , Node 5 []
    ]
  , Node 3 []
  ]

list :: [Int]
list = [1 .. 10]

t0 :: Tree Int
t0 = tree & deep (filtered (null . subForest) . root) .~ 99

list' :: [Int]
list' = list & deep'' (filtered (null . tail) . _head) .~ 99

deep' :: Plated a => Traversal' a b -> Traversal' a b
deep' t = failing t (plate . deep' t)

t' :: Tree Int
t' = tree & deep'' (filtered (null . subForest) . root) .~ 99

deepOf' ::
  (Conjoined p, Applicative f) =>
  ((s -> f t) -> s -> f t)
  -> Traversing p f s t a b -> p a (f b) -> s -> f t
deepOf' t1 t2 = failing t2 (t1 . deepOf' t1 t2)

deep'' :: Plated a => Traversal' a b -> Traversal' a b
deep'' = deepOf' plate
