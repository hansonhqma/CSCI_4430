module Interpreter where
import Control.Exception
import Debug.Trace
import Data.List

---- Data types ----

type Name = String

data Expr = 
  Var Name
  | Lambda Name Expr
  | App Expr Expr
  deriving
    (Eq,Show)


-- function to remove e element from list
remove:: (Eq e) => e -> [e] -> [e]
remove x ls = case (x, ls) of
  (_, []) -> [] -- base case
  (n, lh:lt) -> if lh==n then remove n lt else (lh:(remove n lt))


---- Functions  ----

fv = (Lambda "y" (App (Var "x") (Var "y")))

-- for each case of adt:
-- Var Name: only need to return [Name]
-- Lambda Name Expr: Name is not free var, remove from result of freevar Expr
-- App Expr Expr: set union of evaluation of both
-- from lecture 15
freeVars::Expr -> [Name]
freeVars x = case x of
  Var id -> [id]
  Lambda id x1 -> remove id (freeVars x1)
  App x1 x2 -> union (freeVars x1) (freeVars x2)

-- need function to build variables that are not free in expression
-- uses freeVars
v = [Lambda "1_" (App (Var "x") (App (Var "1_") (Var "2_")))]
inUseVars::[Expr] -> [Name]
inUseVars expList = foldl
  (\varlist currentexp -> varlist \\ (freeVars currentexp))
  (map (\x-> show x ++ "_") [1..]) -- makes ["1_"..]
  expList -- call on list of expressions


-- 3 cases for each type of Expr
-- var -> return specific expression
-- app -> subst each individual expression
-- lambda -> (\y.E1)[M/x] = \z.((E1[z/y])[M/x])
-- lecture 15 algo
subst::(Name,Expr) -> Expr -> Expr
subst (name, exp1) exp2 = case exp2 of
  Var x -> if name==x then exp1 else exp2
  Lambda lname lexp -> if name == lname then Lambda lname lexp -- if var is the same no reduction
    else -- find newest used variable and replace in tail of new reduction
      let _freevar = head (inUseVars [exp1, lexp, Var name])
        in (Lambda _freevar (subst (name, exp1) (subst (lname, Var _freevar) lexp)))
  App e1 e2 -> App (subst (name, exp1) e1) (subst (name, exp1) e2)

normNF_OneStep::Expr -> Maybe Expr
normNF_OneStep exp = case exp of
  Var _ -> Nothing -- can't reduce a variable

  Lambda name exp -> let expval = normNF_OneStep exp in case expval of
    Just exp' -> Just (Lambda name exp')
    _ -> Nothing

  App exp1 exp2 -> case exp1 of
    Lambda n e -> Just (subst (n, exp2) e)

    _ -> let n1 = normNF_OneStep exp1 in let n2 = normNF_OneStep exp2 in case n1 of
      Just n1' -> Just (App n1' exp2)
      _ -> case n2 of
        Just n2' -> Just (App exp1 n2')
        _ -> Nothing

normNF_n::Int -> Expr -> Expr
normNF_n i exp = case i of
  0 -> exp
  _ -> let exp' = normNF_OneStep exp in case exp' of
    Just x -> normNF_n (i - 1) x
    _ -> exp


