{-# LANGUAGE TupleSections #-}

-- Blog post explaining how Lenses are derived:
-- http://blog.jakubarnold.cz/2014/07/14/lens-tutorial-introduction-part-1.html

import Control.Lens
import Data.Text.Lens
import Data.Monoid
import Data.Functor.Identity
import Control.Applicative ((<$>),(<*>))

---

f :: [[(String,String)]] -> Sum Int
f s = s ^. traverse . traverse . _1 . to (Sum . length)

s1 = [[("this","is good")]]
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
h t = t ^. each  -- == foldOf each t == view each t

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
n :: [(Integer,Integer)]
n = [(1,2),(3,4)] & mapped . both %~ succ

-- `.~` sets to a given value.
o :: [(Integer,Integer)]
o = [(1,2),(3,4)] & mapped . both .~ 0

---

data User = User { userName :: String
                 , postsOf :: [Post] } deriving Show

data Post = Post { postOf :: String } deriving Show

posts :: Lens' User [Post]
posts f (User n p) = fmap (\p' -> User n p') (f p)

title :: Lens' Post String
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
goDeep :: Traversal' [User] String
goDeep = traverse . posts . traverse . title

-- Getting a list of the contents of all posts.
lensGet :: [String]
lensGet = users ^.. goDeep

-- Can only "get" this way.
manualGet :: [String]
manualGet = concat $ map (map postOf . postsOf) users

-- This is possible because the Applicative instance for Const demands
-- a Monoid.
together :: String
together = users ^. goDeep

lensSet :: String -> [User]
lensSet b = users & goDeep .~ b

-- _Very_ manual.
manualSet :: String -> [User]
manualSet b = map f users
    where f (User n ps) = User n $ map g ps
          g (Post _)    = Post b
