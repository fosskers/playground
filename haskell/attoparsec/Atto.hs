{-# LANGUAGE OverloadedStrings #-}

module Atto where

import           Data.Attoparsec.ByteString.Char8
import qualified Data.Attoparsec.ByteString.Streaming as A
import qualified Data.ByteString as B
import qualified Data.ByteString.Streaming.Char8 as Q
import           Streaming
import qualified Streaming.Prelude as S

---

-- Quote: If you write an attoparsec-based parser carefully, it can be
-- realistic to expect it to perform similarly to a hand-rolled C parser
-- (measuring megabytes parsed per second).

--------------------
-- INCREMENTAL INPUT
--------------------

i0 :: B.ByteString
i0 = "thisisaline"

i1 :: B.ByteString
i1 = "andthisisanother"

-- | Accepts any `Char`.
p0 :: Parser B.ByteString
p0 = takeWhile1 (const True)

-- | Feeding more bytes into a `Partial` result of an initial parse.
-- This will return a `Left` because an EOF wasn't found.
r0 :: Either String B.ByteString
r0 = eitherResult $ feed (parse p0 i0) i1

-- | This succeeds.
r1 :: Either String B.ByteString
r1 = eitherResult $ feed (feed (parse p0 i0) i1) ""

-- | Supply a monadic action that will provide more input.
r2 :: IO (Either String B.ByteString)
r2 = eitherResult <$> parseWith B.getLine p0 i0

-- Otherwise, a similar API to Parsec is exposed.

----------------
-- SIMPLE PARSER
----------------

-- Some garbage on the end, added on purpose.
c :: B.ByteString
c = "name: Jack, age: 3, cool: 10arsoitensarositna"

data Cat = Cat { _name :: B.ByteString, _age :: Int, _cool :: Double } deriving (Show)

-- | Parse a `Cat`.
cat :: Parser Cat
cat = Cat <$> (name <* ", ") <*> (age <* ", ") <*> cool

name :: Parser B.ByteString
name = "name: " *> takeTill (== ',')

age :: Parser Int
age = "age: " *> decimal

cool :: Parser Double
cool = "cool: " *> double

-- Run with: parseOnly cat c

--------------------
-- STREAMING PARSING
--------------------

-- | A streaming ByteString. The parser finds the split between `10` and
-- `name` automatically without error.
cs :: Q.ByteString IO ()
cs = "name: Jack, age: 3, cool: 10name: Qtip, age: 9, cool: 8"

-- | Example of `parsed`, which yields a proper `Stream (Of a)` stream
-- of the results of the parser.
s0 :: Stream (Of Cat) IO ()
s0 = void $ A.parsed cat cs

-- Run with: S.print s0

-- | Example of `parse`, which will yield a single parsed value in the
-- parent Monad, as well as the rest of the `ByteString` stream.
s1 :: IO (Either Cat A.Message, Q.ByteString IO ())
s1 = A.parse cat cs

-- Run with: s1 >>= print . fst
