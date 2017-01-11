module PGStreaming where

import           Streaming
import qualified Streaming.Prelude as S

---

-- | `Stream`s are Monads.
f0 :: IO (S.Of [Int] ())
f0 = S.toList $ number >> number >> number
  where number = lift (prompt >> readLn) >>= S.yield :: Stream (Of Int) IO ()
        prompt = putStrLn "Enter a number:"

-- | Stream the contents of a `Foldable`.
f1 :: IO ()
f1 = S.print . mapped S.toList . chunksOf 3 $ S.replicateM 5 getLine

-- | Transform the contents of a Stream.
f2 :: IO ()
f2 = S.stdoutLn $ S.map reverse S.stdinLn

-- | File IO.
f3 :: IO ()
f3 = runResourceT . S.stdoutLn . S.take 3 $ S.readFile fp
  where fp = "/home/colin/code/playground/haskell/streaming/pg-streaming.cabal"

-- | One way to create an infinite `Stream`. `iterateM` and `repeat` also exist.
f4 :: IO ()
f4 = S.print . S.take 10 $ S.iterate (+ 1) 0

-- | Cycle a `Stream`.
f5 :: IO ()
f5 = do
  rest <- S.print . S.splitAt 3 $ S.cycle (S.yield "Yes" >> S.yield "No")
  S.print $ S.take 3 rest

-- | Enumerating.
f6 :: IO ()
f6 = do
  rest <- S.print . S.zip (S.enumFrom 'a') . S.splitAt 3 $ S.each [1..] --S.enumFrom 1
  S.print $ S.take 3 rest

-- | Intercalating
f7 :: IO ()
f7 = S.print . intercalates (S.yield 99) . chunksOf 3 $ S.each [1..10]

-- | More intercalating with `with`.
f8 :: IO ()
f8 = S.print . intercalates (S.yield 99) $ S.with (S.each [1..10]) S.yield

-- | Most simply.
f9 :: IO ()
f9 = S.print . S.intersperse 99 $ S.each [1..10]

-- | `splitAt` past the end of the Stream. Still works!
f10 :: IO ()
f10 = do
  rest <- S.print . S.splitAt 15 $ S.each [1..10]
  pure ()

-- | Checking behaviour of `span`.
f11 :: IO ()
f11 = do
  rest <- S.print . S.span (< 5) $ S.each [1..10]
  liftIO $ putStrLn "HEY"
  S.print rest

-- | Checking behaviour of `next`. It _does_ pop the head element.
f12 :: IO ()
f12 = do
  n <- liftIO (S.next $ S.each [1..10])
  case n of
    Left _ -> pure ()
    Right (_, rest) -> S.print rest
