{-|

`matrices` is a native matrix library based on `vectors`.

The basic type is an immutable `Matrix a`. Format (`show` output):

    Matrix i j n m [1,2,3...]
      i => Rows
      j => Columns
      n => Number of columns in the parent Vector
      m => Starting index of this Matrix within the parent Vector

PROs:
* No linking to foreign libs
* No contraint to `Num` types?
* Efficient: it's just a single `Vector`
* Many convenience functions (e.g. `zipWith` for element-wise operations)

CONs:
* Needs minor type hand-holding
* Throws exceptions, no safe indexing
* No pretty-printing / Unclear `Show` output

-}

module Matrices where

import Data.Matrix as M
import Data.Vector

---

l0 :: [[Int]]
l0 = [[1,2,3],[4,5,6],[7,8,9]]

v1 :: Vector Int
v1 = fromList [1..64]

v2 :: Vector Char
v2 = fromList ['a'..'d']

m0 :: Matrix Int
m0 = fromLists l0

m1 :: Matrix Int
m1 = ident 5

-- | From a given Vector, make a (Row,Column) size Matrix.
m2 :: Matrix Int
m2 = fromVector (8,8) v1

-- | Non-square
m3 :: Matrix Int
m3 = fromVector (4,16) v1

-- | Back to a Vector
v3 :: Vector Int
v3 = flatten m0

-- | Getting sub-matrices. Original matrix is retained internally.
-- Is it just a copied pointer or something? Using `flatten` gives
-- the proper reduced `Vector`.
m4 :: Matrix Int
m4 = subMatrix (3,3) (5,5) m2
