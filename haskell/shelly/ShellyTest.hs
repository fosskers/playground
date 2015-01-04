{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}

module ShellyTest where

import qualified Data.Text as T
import           Prelude hiding (FilePath)
import           Shelly

---

-- Notice the `pipe` operator.
foo :: IO T.Text
foo = shelly . silently $ run "cat" ["ShellyTest.hs"] -|- run "grep" ["Text"]

-- `get_env_all` also available.
env :: IO (Maybe T.Text)
env = shelly $ get_env "BROWSER"

-- Directories
here :: IO FilePath
here = shelly pwd

-- `withTmpDir` !!

-- Note: `cd` doesn't change dir of main thread.
-- So: `sandbox >> here` == `here`
sandbox :: IO FilePath
sandbox = shelly $ cd ".cabal-sandbox" >> pwd

bins :: IO [FilePath]
bins = shelly $ cd "/usr/bin" >> pwd >>= ls  -- >>= mapM which

-- There's a function called `terror` haha.
bad :: IO a
bad = shelly $ pwd >> terror "Noooo!"

-- Sleeping
hello :: Sh ()
hello = echo "Hello" >> sleep 1 >> echo "Still here?"

timing :: IO (Double,())
timing = shelly $ time hello

finding :: Sh [FilePath]
finding = cd "/home/colin/code/haskell" >> findWhen p "."
  where p = return . hasExt "hs"

-- shelly $ fst <$> time finding
