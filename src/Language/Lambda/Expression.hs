{-# LANGUAGE FlexibleInstances #-}
module Language.Lambda.Expression where

import Prelude hiding (uncurry)

import Language.Lambda.Util.PrettyPrint

data LambdaExpr name
  = Var name
  | App (LambdaExpr name) (LambdaExpr name)
  | Abs name (LambdaExpr name)
  | Let name (LambdaExpr name)
  deriving (Eq, Show)

-- Pretty printing
instance (PrettyPrint a, Eq a) => PrettyPrint (LambdaExpr a) where
  prettyPrint = prettyPrint . pprExpr' empty

-- Pretty print a lambda expression
pprExpr :: (PrettyPrint n, Eq n) => PDoc String -> LambdaExpr n -> PDoc String
pprExpr pdoc (Var n)      = prettyPrint n `add` pdoc
pprExpr pdoc (Abs n body) = pprAbs pdoc n body
pprExpr pdoc (App e1 e2)  = pprApp pdoc e1 e2
pprExpr pdoc (Let n expr) = pprLet pdoc n expr

-- try to pretty print church numeral
pprExpr' :: (PrettyPrint n, Eq n) => PDoc String -> LambdaExpr n -> PDoc String
pprExpr' pdoc expr@(Abs a (Abs b body)) = guard (tryNumeral 0 a b body) (pprExpr pdoc expr)
    where
        guard Nothing a = a
        guard (Just b) _ = (PDoc [(show b)]) `mappend` pdoc
        tryNumeral n a b (App x y)
            | (Var b) == y = Just (n+1)
            | (Var a) == x = tryNumeral (n+1) a b y
            | otherwise    = Nothing
        tryNumeral n a b (Var x)
            | b == x = Just n
            | otherwise = Nothing
        tryNumeral n a b _ = Nothing
pprExpr' pdoc a = pprExpr pdoc a

-- Pretty print an abstraction 
pprAbs :: (PrettyPrint n, Eq n) => PDoc String -> n -> LambdaExpr n -> PDoc String
pprAbs pdoc n body
  = between vars' [lambda] ". " (pprExpr pdoc body')
  where (vars, body') = uncurry n body
        vars' = intercalate (map prettyPrint vars) " " empty

-- Pretty print an application
pprApp :: (PrettyPrint n,
           Eq n)
        => PDoc String
        -> LambdaExpr n
        -> LambdaExpr n
        -> PDoc String
pprApp pdoc e1@(Abs _ _) e2@(Abs _ _) = betweenParens (pprExpr pdoc e1) pdoc
  `mappend` addSpace (betweenParens (pprExpr pdoc e2) pdoc)
pprApp pdoc e1 e2@(App _ _) = pprExpr pdoc e1
  `mappend` addSpace (betweenParens (pprExpr pdoc e2) pdoc)
pprApp pdoc e1 e2@(Abs _ _) = pprExpr pdoc e1
  `mappend` addSpace (betweenParens (pprExpr pdoc e2) pdoc)
pprApp pdoc e1@(Abs _ _) e2 = betweenParens (pprExpr pdoc e1) pdoc
  `mappend` addSpace (pprExpr pdoc e2)
pprApp pdoc e1 e2
  = pprExpr pdoc e1 `mappend` addSpace (pprExpr pdoc e2)

pprLet :: (PrettyPrint n, Eq n)
       => PDoc String
       -> n
       -> LambdaExpr n
       -> PDoc String
pprLet pdoc name expr
  = intercalate ss " " pdoc
  where ss = ["let", prettyPrint name, "=", prettyPrint expr]

uncurry :: n -> LambdaExpr n -> ([n], LambdaExpr n)
uncurry n = uncurry' [n]
  where uncurry' ns (Abs n' body') = uncurry' (n':ns) body'
        uncurry' ns body'          = (reverse ns, body')
