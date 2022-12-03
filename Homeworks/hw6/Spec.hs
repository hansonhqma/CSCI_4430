import Interpreter

{- HLINT ignore "Use isNothing" -}

assert :: Bool -> String -> String
assert test_result label = 
  if test_result then "[PASSED] - " ++ label else "\t[FAILED] - " ++ label

test :: (Bool, String) -> IO ()
test (result, label) = putStrLn (assert result label)

testBatch :: String -> [(Bool, String)] -> IO ()
testBatch batchLabel tests = do
  putStrLn ("========== " ++ batchLabel ++ " ==========")
  mapM_ test tests
  putStr "\n"

main :: IO ()

main = do
  let simpleVariable = Var "x"
  let combinedVariable = App (Var "x") (Var "y")
  let combinatorAbstraction = Lambda "x" (Var "x")
  let simpleAbstraction = Lambda "x" (App (Var "x") (Var "y"))
  let moderateApplication = App (Lambda "x" (Lambda "y" (App (Var "x") (Var "y")))) (App (Var "y") (Var "w")) 
  let multistepReducible = App (App (Lambda "x" (Lambda "y" (App (App (Var "w") (Var "x")) (Var "y")))) (App (Var "a") (Var "b"))) (Var "z")

  testBatch "Free Variables" [
    (freeVars simpleVariable == ["x"], "Simple variable [x]"),
    (freeVars combinedVariable == ["x", "y"], "Variable application [x y]"),
    (freeVars (App (Var "x") (Var "x")) == ["x"], "Duplicate variables [x x]"),
    (freeVars simpleAbstraction == ["y"], "Simple abstraction [\\x.xy]"),
    (null (freeVars combinatorAbstraction), "Combinator abstraction [\\x.x]"),
    (freeVars moderateApplication == ["y", "w"], "Moderate application [(\\x.\\y.xy)(yw)]")
    ]

  -- testBatch "Infinite Fresh Variables" [
  --   (take 5 (freshVars []) == ["1_", "2_", "3_", "4_", "5_"], "Get fresh no bound"),
  --   (take 5 (freshVars ["1_", "3_", "5_", "7_", "9_"]) == ["2_", "4_", "6_", "8_", "10_"], "Get fresh with bounds"),
  --   (take 3 (freshVars ["1_", "x_"]) == ["2_", "3_", "4_"], "Fresh driver")
  --   ]

  testBatch "Substitution" [
    (subst ("y", Var "y") simpleVariable == simpleVariable, "Variable no sub"),
    (subst ("x", Var "y") simpleVariable == Var "y", "Variable sub"),
    (subst ("a", Var "z") (App (Var "x") (Var "y")) == App (Var "x") (Var "y"), "Application no sub"),
    (subst ("x", Var "z") (App (Var "x") (Var "y")) == App (Var "z") (Var "y"), "Application sub"),
    (let replacement = App (Var "a") (Var "b") in subst ("z", replacement) (App (App (Var "x") (Var "z")) (App (Var "y") (Var "z"))) == App (App (Var "x") replacement) (App (Var "y") replacement), "Application nested sub"),
    (subst ("x", Var "y") simpleAbstraction == simpleAbstraction, "Abstraction no sub"),
    (subst ("y", App (Var "a") (Var "b")) simpleAbstraction == Lambda "1_" (App (Var "1_") (App (Var "a") (Var "b"))), "Abstraction sub")
    ]

  testBatch "One reduce" [
    (normNF_OneStep (Var "x") == Nothing, "Variable no reduction"),
    (normNF_OneStep combinatorAbstraction == Nothing, "Abstraction no reduction"),
    (normNF_OneStep (Lambda "x" (App (Lambda "y" (Var "y")) (Var "x"))) == Just combinatorAbstraction, "Abstraction with reduction"),
    (normNF_OneStep combinedVariable == Nothing, "Application no reduction"),
    (normNF_OneStep (App (Lambda "z" (App (Var "z") (Var "y"))) (Var "x")) == Just combinedVariable, "Application of abstraction"),
    (normNF_OneStep (App (App combinatorAbstraction (Var "x")) (Var "y")) == Just combinedVariable, "Reduction of first element"),
    (normNF_OneStep (App (Var "x") (App combinatorAbstraction (Var "y"))) == Just combinedVariable, "Reduction of second element"),
    (normNF_OneStep multistepReducible == Just (App (Lambda "1_" (App (App (Var "w") (App (Var "a") (Var "b"))) (Var "1_"))) (Var "z")), "Complex reduction")
    ]

  testBatch "n-reduce" [
    (normNF_n 0 multistepReducible == multistepReducible, "0 reductions"), 
    (normNF_n 1 multistepReducible == App (Lambda "1_" (App (App (Var "w") (App (Var "a") (Var "b"))) (Var "1_"))) (Var "z"), "1 reduction"),
    (normNF_n 2 multistepReducible == App (App (Var "w") (App (Var "a") (Var "b"))) (Var "z"), "2 reductions"),
    (normNF_n 4 multistepReducible == App (App (Var "w") (App (Var "a") (Var "b"))) (Var "z"), "More than needed reductions")
    ]
