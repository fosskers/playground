{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
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
import Control.Eff.Lift
import Control.Eff.Reader.Lazy
import Control.Eff.State.Lazy
import Control.Eff.Trace
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

t2t :: IO (String, ())
t2t = runTrace $ runWriter (++) "" $ t1 >> tell "Kittens"

-- | As proof of `runTrace` being terminal, the following won't compile.
--t3t :: (String, IO ())
--t3t = run $ runWriter (++) "" $ runTrace $ t1 >> tell "Kittens"

-----------------
--- LIFT (IO) ---
-----------------
-- | Monads don't commute, so there can only be one Lifted Monad per
-- Effect set.
-- `SetMember` appears here because it is the mechanism by which
-- the lifted effect is guaranteed to be unique.
l1 :: SetMember Lift (Lift IO) r => Eff r ()
l1 = lift $ print "時計が壊れた"

-- | Notice we *don't* use `run` here.
l1t :: IO ()
l1t = runLift $ l1 >> l1

-------------------
--- INTERLEAVED ---
-------------------
-- | This is thanks to the ConstraintKinds extension.
type Effects r = ( Member (Writer String) r
                 , Member (State [Dilithium]) r
                 , Member (Exc String) r )

data Dilithium = Dilithium

-- | Why can't the type of the State value be inferred?
engage :: (Member (State [Dilithium]) r, Member (Exc String) r) => Eff r ()
engage = get >>= \(ds :: [Dilithium]) -> do
  if length ds < 5
     then throwExc "We're short on Dilithium, Cap'n!"
     else modify (drop 5 :: [Dilithium] -> [Dilithium])

loadCrystals :: Member (State [Dilithium]) r => [Dilithium] -> Eff r ()
loadCrystals = modify . (++)

captLog :: Member (Writer String) r => String -> Eff r ()
captLog s = tell $ "Captain's Log: " ++ s

fire :: IO ()
fire = print "Kaboom!"

voyage :: (Effects r, SetMember Lift (Lift IO) r) => Eff r ()
voyage = do
  captLog "Time for a cosmic adventure!"
  captLog "Need to fill the tanks."
  loadCrystals . take 25 $ repeat Dilithium
  captLog "Engage!"
  engage >> engage >> engage >> engage
  captLog "We made it to our destination."
  captLog "Fire torpedos!"
  lift fire

vt :: IO (String, Either String ())
vt = runLift $ evalState ([] :: [Dilithium]) $ runWriter f "" $ runExc voyage
  where f acc s = acc ++ "\n" ++ s
