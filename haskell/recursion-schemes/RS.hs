{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE OverloadedStrings #-}

module RS where

import           Control.Arrow
import           Data.Monoid ((<>))
import           Text.PrettyPrint (Doc)
import qualified Text.PrettyPrint as P

-- Testing: http://blog.sumtypeofway.com/an-introduction-to-recursion-schemes/

data Expr a = Literal Int | Ident String | Call a [a] | Paren a deriving (Eq, Show, Functor)

newtype Term f = In { out :: f (Term f) }

type Algebra f a = f a -> a

type Coalgebra f a = a -> f a

type RAlgebra f a = f (Term f, a) -> a

type RAlgebra' f a = Term f -> f a -> a

type RCoalgebra f a = a -> f (Either (Term f) a)

-- | Traverse a `Term` from the bottom upwards.
bottomUp :: Functor a => (Term a -> Term a) -> Term a -> Term a
bottomUp f = cata (f . In)

-- | Traverse a `Term` from the top downwards.
topDown :: Functor f => (Term f -> Term f) -> Term f -> Term f
topDown f = ana (out . f)

-- | A Catamorphism generalizes folds: it breaks down a `Functor` structure
-- into a single value.
cata :: Functor f => Algebra f a -> Term f -> a
cata f = para' (const f)
-- cata f = f . fmap (cata f) . out

-- | An Anamorphism generalizes unfolds: they create some `Functor` structure
-- from a starting value.
ana :: Functor f => Coalgebra f a -> a -> Term f
ana f = In . fmap (ana f) . f

-- | Like a Catamorphism, but the original Term is visible to the passed-in
-- function (the RAlgebra) at the same time as the mid-transformed value.
para :: Functor f => RAlgebra f a -> Term f -> a
para f = f . fmap (id &&& para f) . out

para' :: Functor f => RAlgebra' f a -> Term f -> a
para' f t = f t . fmap (para' f) $ out t

-- | An Apomorphism, the dual of a Paramorphism.
apo :: Functor f => RCoalgebra f a -> a -> Term f
apo f = In . fmap (id ||| apo f) . f

-- | Remove redundant parentheses from an expression.
flatten :: Term Expr -> Term Expr
flatten = bottomUp f
  where f (In (Paren e)) = e
        f other = other

countNodes :: Expr Int -> Int
countNodes (Literal _) = 1
countNodes (Ident _) = 1
countNodes (Paren _) = 1
countNodes (Call f args) = f + sum args + 1

{-
cata countNodes call
countNodes $ fmap (cata countNodes) $ out call
countNodes $ fmap (cata countNodes) (Call add [ten, ten])
countNodes $ Call (cata countNodes add) (map (cata countNodes) [ten, ten])
countNodes $ Call (cata countNodes add) [cata countNodes ten, cata countNodes ten]
countNodes $ Call (cata countNodes add) [countNodes $ fmap (cata countNodes) $ out ten, countNodes $ fmap (cata countNodes) $ out ten]
countNodes $ Call (cata countNodes add) [countNodes $ Literal 10, countNodes $ Literal 10]
countNodes $ Call (cata countNodes add) [1, 1]
countNodes $ Call (countNodes $ fmap (cata countNodes) $ out add) [1, 1]
countNodes $ Call (countNodes $ Ident "add") [1, 1]
countNodes $ Call 1 [1, 1]
4
-}

prettyPrint :: Algebra Expr Doc
prettyPrint (Literal i) = P.int i
prettyPrint (Ident s)   = P.text s
prettyPrint (Paren e)   = P.parens e
prettyPrint (Call f as) = f <> P.parens (mconcat $ P.punctuate "," as)

----------
-- TESTING
----------
ten, add, call :: Term Expr
ten  = In (Literal 10)
add  = In (Ident "add")
call = In (Call add [ten, ten])
