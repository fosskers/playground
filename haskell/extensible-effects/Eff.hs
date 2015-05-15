{-# LANGUAGE FlexibleContexts #-}

-- A replacement for Monad Transformers.
-- Note that Reader/Writer/State here are reimplemented and are not
-- Monads in themselves.
-- That said, their usual functions ask/tell/get/etc. *are* Monadic
-- in the `Eff` Monad.

module Eff where

import Control.Eff
import Control.Eff.Choose
import Control.Eff.Exception
import Control.Eff.Fresh
import Control.Eff.Reader.Lazy
import Control.Eff.Writer.Lazy
import Control.Monad (when)

--------------
--- READER ---
--------------
r1 :: Member (Reader Int) r => Int -> Eff r Int
r1 n = (n +) <$> ask

-- | It seems `(100 :: Int)` is necessary or it won't compile.
r1t :: Int -> Int
r1t n = run $ runReader (r1 n) (100 :: Int)

--------------
--- WRITER ---
--------------
-- | Write all even numbers given.
w1 :: Member (Writer Int) r => [Int] -> Eff r ()
w1 = mapM_ (\n -> when (even n) $ tell n)

w1t :: Int
w1t = fst . run . runWriter (+) 0 $ w1 [1..10]

w2 :: Member (Writer String) r => String -> Eff r ()
w2 s = tell $ s ++ "!"

-- | Piping different effects within the `Eff` Monad.
w3 :: (Member (Writer Int) r, Member (Writer String) r) => Eff r Bool
w3 = w1 [1..10] >> w2 "Hello" >> return True

-- | Multiple effects of similar type at once.
-- Just use `run*` for each effect in the Effect set.
w3t :: (Int, (String,Bool))
w3t = run $ runWriter (+) 0 $ runMonoidWriter w3

-- | Interleaving functions of "simpler" effects with more complicated ones.
w4 :: (Member (Writer Int) r, Member (Writer String) r) => Eff r Bool
w4 = w1 [1..5] >> w2 "Interleaving" >> w3

w4t :: (Int, (String,Bool))
w4t = run $ runWriter (+) 0 $ runMonoidWriter w4

-----------------
--- EXCEPTION ---
-----------------
-- | The infinite list will never be mapped over.
e1 :: (Member (Writer Int) r, Member Fail r) => Eff r ()
e1 = w1 [1..10] >> die >> w1 [1..]

e1t :: (Int, Either () ())
e1t = run $ runWriter (+) 0 $ runExc e1

-- | Explicit error type.
e2 :: (Member (Writer Int) r, Member (Exc String) r) => Eff r ()
e2 = w1 [1..10] >> throwExc "Error!" >> w1 [1..]

--------------
--- CHOOSE ---
--------------
-- | This is just the List Monad.
c1 :: Member Choose r => [Int] -> Eff r Int
c1 ns = (*) <$> choose ns <*> choose ns

c1t :: [Int]
c1t = run . runChoice $ c1 [1..10]

-- | Reinventing the wheel.
map' :: (a -> b) -> [a] -> [b]
map' f = run . runChoice . fmap f . choose

-------------
--- FRESH ---
-------------
-- | Should produce all the Ints.
f1 :: Member (Fresh Int) r => Eff r [Int]
f1 = sequence $ repeat fresh

-- | Doesn't terminate for `take n f1t` where n > 0.
f1t :: [Int]
f1t = run $ runFresh f1 (1 :: Int)

-----------------
--- LIFT (IO) ---
-----------------
