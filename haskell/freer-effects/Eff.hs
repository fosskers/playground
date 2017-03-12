{-# LANGUAGE TypeOperators, FlexibleContexts, DataKinds, ScopedTypeVariables #-}

-- A replacement for Monad Transformers.
-- Note that Reader/Writer/State here are reimplemented and are not
-- Monads in themselves.
-- That said, their usual functions ask/tell/get/etc. *are* Monadic
-- in the `Eff` Monad.

module Eff where

import Control.Monad (when)
import Control.Monad.Freer
import Control.Monad.Freer.Exception
import Control.Monad.Freer.Fresh
import Control.Monad.Freer.Reader
import Control.Monad.Freer.State
import Control.Monad.Freer.Trace
import Control.Monad.Freer.Writer
import Data.Monoid

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
w1 :: Member (Writer (Sum Int)) r => [Int] -> Eff r ()
w1 = mapM_ (\n -> when (even n) . tell $ Sum n)

w1t :: Int
w1t = getSum . snd . run . runWriter $ w1 [1..10]

w2 :: Member (Writer String) r => String -> Eff r ()
w2 s = tell $ s ++ "!"

-- | Piping different effects within the `Eff` Monad.
w3 :: (Member (Writer (Sum Int)) r, Member (Writer String) r) => Eff r Bool
w3 = w1 [1..10] >> w2 "Hello" >> return True

-- | Multiple effects of similar type at once.
-- Just use `run*` for each effect in the Effect set.
w3a :: ((Bool, String), Sum Int)
w3a = run . runWriter $ runWriter w3

-- | Run the `Writer`s in a different order, but with the same code!
-- Only the type signature differs.
w3b :: ((Bool, Sum Int), String)
w3b = run . runWriter $ runWriter w3

-- | Interleaving functions of "simpler" effects with more complicated ones.
w4 :: (Member (Writer (Sum Int)) r, Member (Writer String) r) => Eff r Bool
w4 = w1 [1..5] >> w2 "Interleaving" >> w3

-----------------
--- EXCEPTION ---
-----------------
-- | The infinite list will never be mapped over.
e1 :: (Member (Writer (Sum Int)) r, Member (Exc String) r) => Eff r ()
e1 = w1 [1..10] >> throwError "Oh no!" >> w1 [1..]

-- | Good idea to always `runError` last? Having an `Either` at the top
-- seems better than embedding it in a tuple.
e1t :: Either String ((), Sum Int)
e1t = run . runError $ runWriter e1

--------------
--- CHOOSE ---
--------------

{-
How do we inject values into `NonDet`? extensible-effects has `choose`, but
there doesn't seem to be an analogue for freer-effects.
-}

-- | This is just the List Monad.
--c1 :: Member Choose r => [Int] -> Eff r Int
--c1 ns = (*) <$> choose ns <*> choose ns

--c1t :: [Int]
--c1t = run . runChoice $ c1 [1..10]

-- | Reinventing the wheel.
--map' :: (a -> b) -> [a] -> [b]
--map' f = run . runChoice . fmap f . choose

-------------
--- FRESH ---
-------------

{- Admittedly, I'm not sure what `Fresh` is used for. -}

-- | Should produce all the Ints.
f1 :: Member Fresh r => Eff r [Int]
f1 = sequence $ repeat fresh

-- | Doesn't terminate for `take n f1t` where n > 0.
-- Why is it called runFresh'? Why the quote?
f1t :: [Int]
f1t = run $ runFresh' f1 1

-------------
--- TRACE ---
-------------
-- | Trace and a lifted IO can't be mixed, as both `runTrace` and
-- `runLift` are meant to be the last effects unwrapped.
t1 :: Member Trace r => Eff r ()
t1 = trace "Something happened."

t2 :: Member Trace r => Eff r ()
t2 = trace "Something else happened."

t3 :: Member Trace r => Eff r ()
t3 = trace "A third thing happened."

t1t :: IO ()
t1t = runTrace $ t1 >> t2 >> t3

t2t :: IO ((), String)
t2t = runTrace . runWriter $ t1 >> tell "Kittens"

-- | As proof of `runTrace` being terminal, the following won't compile.
--t3t :: (String, IO ())
--t3t = run $ runWriter (++) "" $ runTrace $ t1 >> tell "Kittens"

-------------------------
--- EFF'd MONADS (IO) ---
-------------------------
-- | Don't need a `Lift` mechanic like extensible-effects, we just `send`
-- aribtrary effects here. There can only be one lifted `Monad` per effect set,
-- since Monads don't commute.
l1 :: Member IO r => Eff r ()
l1 = send $ putStrLn "sup!"

-- | Notice we *don't* use `run` here. We use `runM` instaed of EE's `runLift`.
l1t :: IO ()
l1t = runM $ l1 >> l1

-- | Mixing lifted IO with other effects which evaluate to IO.
l2 :: (Member IO r, Member Trace r) => Eff r ()
l2 = trace "Will this work?" >> send (putStrLn "I hope so")

-- | There's no way to actually run `l2`, since both `runTrace` and `runM`
-- are "terminal" operations.
-- l2t :: IO ()
-- l2t = runM $ runTrace l2

-------------------
--- INTERLEAVED ---
-------------------
-- | Our effect stack, explicitely defined with no existential `r`.
-- Note: This constrains the unwrapping order.
type Effects = Eff (Writer String ': State [Dilithium] ': Exc String ': IO ': '[])

data Dilithium = Dilithium

-- | Why can't the type of the State value be inferred?
engage :: (Member (State [Dilithium]) r, Member (Exc String) r) => Eff r ()
engage = get >>= \(ds :: [Dilithium]) -> do
  if length ds < 5
     then throwError "We're short on Dilithium, Cap'n!"
     else modify (drop 5 :: [Dilithium] -> [Dilithium])

loadCrystals :: Member (State [Dilithium]) r => [Dilithium] -> Eff r ()
loadCrystals = modify . (++)

captLog :: Member (Writer String) r => String -> Eff r ()
captLog s = tell $ "Captain's Log: " ++ s

fire :: IO ()
fire = print "Kaboom!"

voyage :: Effects ()
voyage = do
  captLog "Time for a cosmic adventure!"
  captLog "Need to fill the tanks."
  loadCrystals . take 25 $ repeat Dilithium
  captLog "Engage!"
  engage >> engage >> engage >> engage
  captLog "We made it to our destination."
  captLog "Fire torpedos!"
  send fire

vt :: IO (Either String ((), String))
vt = runM . runError $ evalState (runWriter voyage) []
