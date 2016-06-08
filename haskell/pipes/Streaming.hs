{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

module Streaming where

import Pipes
import Pipes.Parse
import Pipes.Aeson
import qualified Pipes.Aeson.Unchecked as A
import qualified Pipes.Prelude as P
import qualified Pipes.ByteString as P
import Data.ByteString (ByteString)
import Data.Aeson hiding (decode)
import Lens.Micro hiding (each)
import Lens.Micro.Aeson
import Lens.Micro.Mtl
import Data.Functor.Identity

---

{- PRODUCERS -}

-- | Yields "Goods" forever.
gimme :: Producer String IO ()
gimme = yield "Goods" *> gimme

-- | An `Effect` is just a `Producer` that never yields.
-- Use `runEffect` to evaluate a top-level effect.
loopy :: Effect IO ()
loopy = for gimme $ lift . putStrLn

-- | `each` can be used on any `Foldable`. It converts the Foldable
-- into a `Producer`.
overList :: Monad m => Producer Int m ()
overList = each [1..5]

-- | Yield multiple times in one producer
dub :: Monad m => a -> Producer a m ()
dub a = yield a *> yield a

runIt :: Show a => Producer a IO () -> IO ()
runIt p = runEffect $ for p dubPrint

-- | (~>) is the (>=>) for Producers.
-- Together, (~>) and `yield` form a Category.
dubPrint :: Show a => a -> Effect IO ()
dubPrint = dub ~> lift . print

{- CONSUMERS -}

-- | Wait for results. To run: @runEffect $ lift getLine >~ consume@
consume :: Consumer String IO String
consume = do
  lift $ putStr "What's your name? "
  l <- await
  pure $ "Hi " ++ l

{- PIPES -}

-- | Connect Producers to Consumers with (>->)
askName :: Producer String IO ()
askName = do
  lift (putStr "What's your name? ") -- *> P.stdinLn *> askName
  name <- lift getLine
  yield name
  askName

greet :: Consumer String IO ()
greet = do
  name <- await
  lift $ putStrLn ("Well hi, " ++ name ++ "!")
  greet

{- ListT -}

-- | The List Monad transformer "done right".
-- Use `every` to turn a `ListT` into a `Producer`.
cross :: Monad m => ListT m Int
cross = (*) <$> Select (each [1..3]) <*> Select (each [1..3])

{- PARSING -}

-- | A `Parser` is just a `StateT` with a `Producer` as the state.
-- Parsing may not consume all the input the producer gives. In this case,
-- one can use `runStateT` and collect the left over producer.
drawThree :: Monad m => Parser a m (Maybe a, Maybe a, Maybe a)
drawThree = (,,) <$> draw <*> draw <*> draw

-- This appears to be a library of primatives for defining parsers,
-- rather than a library which does complex text parsing.
-- `pipes-attoparsec` probably does that.

{- AESON -}

bytes :: Monad m => Producer ByteString m ()
bytes = do
  yield "{"
  yield " \"fun\": 4,"
  yield " \"joy\": 5,"
  yield " \"happy\": 6"
  yield "}"
  yield "1"

-- | The entire Producer is consumed, despite my tricks.
res :: (Maybe Double, [ByteString])
res = (r',p')
  where (r,p) = runIdentity $ runStateT decode bytes
        p' = P.toList p
        r' = r ^? _Just . _Right . key @Value "fun" . _Double

-- Looks like the `json-stream` package does what I want.
