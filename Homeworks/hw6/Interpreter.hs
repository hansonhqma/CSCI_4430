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


---- Functions ----

freeVars::Expr -> [Name]
---- YOUR CODE HERE 


subst::(Name,Expr) -> Expr -> Expr
---- YOUR CODE HERE



normNF_OneStep::Expr -> Maybe Expr
---- YOUR CODE HERE



normNF_n::Int -> Expr -> Expr
---- YOUR CODE HERE


