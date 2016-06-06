{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE ApplicativeDo #-}
{-# LANGUAGE TypeApplications #-}

module GHC8 where

---

-- | Duplicate Record Fields
data Foo = Foo { x :: Int } deriving (Eq,Show)

data Food = Food { x :: String } deriving (Eq,Show)

foo :: Int -> Foo
foo n = Foo { x = n }

-- | Record Pattern Synonyms

-- Example given in docs, but does not compile.
--pattern Point :: (Int,Int)
--pattern Point{a,b} = (a,b)

-- | Applicative `do`. Looks monadic, but this will be desugared into
-- `(,) <$> [1,2,3] <*> [4,5,6]`
appDo :: [(Int,Int)]
appDo = do
  x <- [1,2,3]
  y <- [4,5,6]
  pure (x,y)

-- | Visible Type Applications.
-- Use these to force polymorphism down a certain path.
typeApp = read @Int "5"
