{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TupleSections #-}

-- http://hackage.haskell.org/package/text-icu-0.7.0.0/docs/Data-Text-ICU.html

module TextICU where

import Control.Applicative
import Data.Maybe (fromJust)
import Data.Text (Text)
import Data.Text.ICU
import Data.Text.IO (putStrLn)
import Prelude hiding (putStrLn,compare)

---

txt:: Text
txt = "Can manipulate text in interesting ways.日本語も？ Oh yes"

brk :: [Break ()]
brk = breaks (breakSentence Current) txt

up :: Text
up = toUpper Current txt

-- Just seems to `toLower` it:
-- toCaseFold True t

-- | Allows nice comparisons of the various String types.
ci1 :: CharIterator
ci1 = fromText "foo bar baz"

ci2 :: CharIterator
ci2 = fromUtf8 "foo bar baz"

ciTest :: Bool
ciTest = ci1 == ci2  -- This is True!

-- | Normalizing Text. Doesn't do what I thought it would.
n1 :: Text
n1 = normalize FCD "Hande"

n2 :: Text
n2 = normalize FCD "Hände"

nTest :: Ordering
nTest = compare [InputIsFCD] n1 n2

-- | Regular Expressions
-- The `Regex` type has a `IsString` instance.

r1 :: Regex
r1 = regex [CaseInsensitive] "in"

r2 :: Regex
r2 = regex [] "本"

r3 :: Regex
r3 = regex [] "yes"

-- Use the safer `regex'` when the pattern is constructed at runtime.
-- `pattern` returns the Text form of a Regex or Match.

f1 :: [Match]
f1 = findAll r1 txt

f2 :: Maybe Match
f2 = find r2 txt

-- | Beginning, Middle, End
bma :: Regex -> Text -> Maybe (Text,Text,Text)
bma r t = find r t >>= \m -> (,pattern m,) <$> prefix 0 m <*> suffix 0 m

(=~) :: Text -> Regex -> Maybe Match
(=~) = flip find
