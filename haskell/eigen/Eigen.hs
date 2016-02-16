module Eigen where

import           Data.Eigen.LA
import           Data.Eigen.Matrix (MatrixXf, (!))
import qualified Data.Eigen.Matrix as M

---

--------------
-- MATRICES --
--------------
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

-- | Extract submatrices. Going out of bounds with either the starting
-- point or the number of rows/cols throws an exception.
m5 :: MatrixXf
m5 = M.block 1 1 2 2 m1

-- | Determinants. Also has `transpose`, `inverse`, etc.
v1 :: Float
v1 = M.determinant m1

-- | Higher-order operations. `filter` and `fold` also available.
m6 :: MatrixXf
m6 = M.map (* pi) m1

-----------------------
-- LINEAR REGRESSION --
-----------------------
-- | Valentine's Day profits
lr :: ([Double], Double)
lr = linearRegression datas

-- | Money, SMTWTFS, mm of rain
-- We use one-hot encoding for the weekday and the weather
datas :: [[Double]]
datas = [ [ 1000, 0, 0, 0, 1, 0, 0, 0, 0.0] -- 2001
        , [ 1100, 0, 0, 0, 0, 1, 0, 0, 0.0]
        , [ 1200, 0, 0, 0, 0, 0, 1, 0, 0.0]
        , [ 1300, 0, 0, 0, 0, 0, 0, 1, 23.0] -- 2004
        , [ 1400, 1, 0, 0, 0, 0, 0, 0, 1.0]
        , [ 1500, 0, 0, 0, 1, 0, 0, 0, 22.6] -- 2007
        , [ 1600, 0, 0, 0, 0, 1, 0, 0, 0.0]
        , [ 1700, 0, 0, 0, 0, 0, 0, 1, 0.0] -- 2009
        , [ 1800, 1, 0, 0, 0, 0, 0, 0, 11.6]
        , [ 1900, 0, 1, 0, 0, 0, 0, 0, 38.0]
        , [ 2000, 0, 0, 1, 0, 0, 0, 0, 5.0] -- 2012
        , [ 2100, 0, 0, 0, 0, 1, 0, 0, 2.0]
        , [ 2200, 0, 0, 0, 0, 0, 1, 0, 6.1] -- 2014
        , [ 2300, 0, 0, 0, 0, 0, 0, 1, 0.2]
        , [ 2400, 1, 0, 0, 0, 0, 0, 0, 13.2] -- 2016
        ]
