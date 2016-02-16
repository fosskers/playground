module Eigen where

import           Data.Eigen.Matrix (MatrixXf, (!))
import qualified Data.Eigen.Matrix as M

---

-- | A Float matrix. Synonym for `Matrix Float CFloat`.
-- Row-major order (i.e. the sublists are the rows)
m0 :: MatrixXf
m0 = M.fromList [[1,2,3],[4,5,6],[7,8,9]]

-- | Generate an arbitrarily large Matrix.
m1 :: MatrixXf
m1 = M.generate 5 5 (\i j -> fromIntegral $ i * j)

-- | Identity Matrix.
m2 :: MatrixXf
m2 = M.identity 5 5

-- | Test math operations. (*) is proper matrix multiplication, not
-- element-wise multiplication. Can also use `mul` function.
m3 :: MatrixXf
m3 = m1 * m2

-- | Random matrices! Values in the range (1,-1).
m4 :: IO MatrixXf
m4 = M.random 5 5

-- | Lookup. Checks bounds, and throws an exception if outside legal range.
v0 :: Float
v0 = m1 ! (2,2)

-- | Extract submatrices.
m5 :: MatrixXf
m5 = M.block 1 1 2 2 m1

-- | Determinants. Also has `transpose`, `inverse`, etc.
v1 :: Float
v1 = M.determinant m1

-- | Higher-order operations. `filter` and `fold` also available.
m6 :: MatrixXf
m6 = M.map (* pi) m1
