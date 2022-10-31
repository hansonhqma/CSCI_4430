;; contract: myinterpreter : x -> list
;; purpose: to evaluate a list of boolean programs
;; example: (myinterpreter '((prog (true)) (prog (false))) produces (#t #f)
;; definition:
(define (myinterpreter x)
;; iterate through list and evaluate each expr
;; if its null (cdr returns nothing) return empty pair
(if (null? x)
  '() ;; empty list
  (cons (evaluate (car x) '()) ;; initialize empty variables list
        (myinterpreter (cdr x))
        )
    )
)

;; contract: varsearch : list, symbol -> boolean
;; purpose: to find the corresponding variable value for some symbol in varlist
;; example: (varsearch '((a #t)) 'a) produces #t
;; definition:
(define (varsearch varlist id)
  (if (null? varlist)
    #f
    ;; else
    (if (equal? (caar varlist) id)
      (cadar varlist) ;; found head->head match, return head->tail
      ;; else
      (varsearch (cdr varlist) id) ;; search tail
      )
    )
)

;; contract: addvar : list symbol boolean -> list
;; purpose: produces the result of adding the variable name, value pair to the given varlist
;; example: (addvar '() 'a #t) produces ((a #t))
;; definition:
(define (addvar varlist id const)
  (cons ;; append to varlist
    (cons ;; make pair
      id
      (cons (evaluate const varlist) '()) ;; make base list with evaluation
      )
    varlist
    )
)

;; contract: evaluate : list list -> boolean
;; purpose: evaluates a boolean program fully
;; example: (evaluate '(prog (myand true false))) produces #f
;; definition:
(define (evaluate expr varlist)
  ;; we store variables as pairs in a list:
  ;;    ((a #t) (b #f)) and so on
  ;;
  ;; there are 6 different car possibilities
  ;; prog, myignore, myor, myand, mynot, mylet
  ;; single terminal possiblities:
  ;; const (true, false), or id (look in varlist)
  ;; if its none of these then its false (should never happen here)

  (cond
    ;; some base cases (THESE HAVE TO COME FIRST)
    ((equal? expr 'true) #t)
    ((equal? expr 'false) #f)

    ;; if expr is some id -> search in varlist
    ((symbol? expr) (varsearch varlist expr))

    ((equal? (car expr) 'prog) (evaluate (cadr expr) varlist))
    ((equal? (car expr) 'myignore) #f)
    ((equal? (car expr) 'myor) (or ;; evaluate (tail->head) or (tail->tail)
                                 (evaluate (cadr expr) varlist)
                                 (evaluate (caddr expr) varlist)
                                 ))
    ((equal? (car expr) 'myand) (and ;; evaluate (tail->head) and (tail->tail)
                                 (evaluate (cadr expr) varlist)
                                 (evaluate (caddr expr) varlist)
                                 ))
    ((equal? (car expr) 'mynot) (not
                                  (evaluate (cadr expr) varlist)
                                  ))
    ((equal? (car expr) 'mylet) (evaluate (cadddr expr)
                                          ;; id: (cadr expr)
                                          ;; const: (caddr expr)
                                          (addvar varlist (cadr expr) (caddr expr))
                                 ))
    (else #f)
    )
)
