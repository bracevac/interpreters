{-# LANGUAGE MultiParamTypeClasses, ConstraintKinds #-}
module Language where

-- The core components under our language
class Expr val where
  int_ :: Int -> val Int
  plus_ :: val Int -> val Int -> val Int
  times_ :: val Int -> val Int -> val Int

class IfNZ rep where
  ifNonZero :: rep Int -> rep t -> rep t -> rep t 

class Func rep where
  lam :: (rep a -> rep b) -> rep (rep a -> rep b)
  app :: rep (rep a -> rep b) -> (rep a -> rep b)
  fix :: (rep a -> rep a) -> rep a
  
type Syntax rep = (Expr rep, Func rep, IfNZ rep)

--
-- Basically, what happens in the Scala version is that the 
-- Labeling trait really changes the signature of everything in a 
-- non-trivial way, even though this is 'invisible' in Scala.
-- Haskell forces one to be explicit about it.

data Label = Root | InLam Label | InThen Label | InElse Label | InFix Label

-- So, rather than functions, we'll call these procedures.
-- and we'll also forget the above modularity
class Proc rep where
  -- a block gives a state transformer. Laziness is important.
  block :: Label -> rep a -> (Label -> (Label, rep a))
  lam' :: (rep a -> rep b) -> rep ((Label, a) -> (Label, b))
