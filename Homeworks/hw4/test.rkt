(define test
    '(prog (myor (myand true (myignore (myor true false))) (myand true false)))
)

(define expr (cdr test))

(cdr test)

