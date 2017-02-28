{-# LANGUAGE OverloadedStrings #-}

module Atto where

import           Data.Attoparsec.ByteString
import qualified Data.ByteString as B

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

-- | Accepts any `Word8`.
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
