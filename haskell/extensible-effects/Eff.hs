{-# LANGUAGE FlexibleContexts #-}

-- A replacement for Monad Transformers

module Eff where

import Control.Eff
import Control.Eff.Reader.Lazy
import Control.Eff.Writer.Lazy
import Control.Monad (when)

-- | Reader

--------------
--- WRITER ---
--------------
-- | Write all even numbers given.
w1 :: Member (Writer Int) r => [Int] -> Eff r ()
w1 = mapM_ (\n -> when (even n) $ tell n)

w1t :: Int
w1t = fst . run $ runWriter (+) 0 (w1 [1..10])
