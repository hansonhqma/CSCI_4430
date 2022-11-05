;; Contract: checkDecrease? (list ls) -> bool
;; Purpose: check if a list is non-decreasing list
;; Example: (checkDecrease? '(1 2 3 2 4 1 2)) should produce #f
;; Definition:
(define (checkDecrease? ls)
  (if (< (length ls) 2) #t
      (and (<= (car ls) (cadr ls))
           (checkDecrease? (cdr ls))
      )
  )
)

;; Contract: isNonDecrease? (list ls) -> bool
;; Purpose: if a list is non-decreasing list
;; Example: (not-decrease? '(1 2 3 2 4 1 2)) should produce #f
;; Definition:
(define (isNonDecrease ls)
  (cond 
        ((null? ls) #f)
        ((checkDecrease? (car ls)) (car ls))
        (else (isNonDecrease (cdr ls)))
        )
  )
        
;; Contract: searchsubList (list ls) * number * number -> bool * (list)
;; Purpose: extends the list from given index to requested length
;; Example: (searchsubList '(1 2 3) 0 1) yields '(1)
;; Definition:
(define (searchsubList ls i len)
  (if (> len 0)
      (if (< i (length ls))
           (let*
              (
               (x (searchsubList ls (+ i 1) (- len 1)))
               (y (searchsubList ls (+ i 1) len))
              )
             (letrec
                 (
                  (a (lambda () (list-ref ls i)))
                  (b (lambda () (cond
                                ((eq? x #f) '())
                                ((eq? x #t) (cons (cons (a) '()) '()))
                                (else (map (lambda (z) (cons (a) z)) x)))
                            ))
                  (c (lambda () (cond
                               ((eq? y #f) '())
                               ((eq? y #t) '())
                               (else y)
                               )
                            ))
                 )
               (append (b) (c))
               )
             )
            #f
           )
      #t
      )
  )

;; Contract: lisRecursive (list ls) * number -> (list (list number))
;; Purpose: returns all possible list of sequences with a given length
;; Example: (lisRecursive '(5 3 2 1) 1) yields '((5) (3) (2) (1))
;; Definition:
(define (searchList ls length)
  (if (< length 0) #f
      (let (
            (seq
             (let ((currentL (searchsubList ls 0 length)))
               (isNonDecrease currentL)
               )
             )
            )
        (if (eq? seq #f) (searchList ls (- length 1)) seq)
        )
     )
  )

;; Contract: (list int) -> (list int)
;; Purpose: returns a given list's longest non-decreasing sub list
;; Example: (lis_slow '(1 2 3 2 4 1 2)) should produce '(1 2 3 4)
;; Definition:
(define (lis_slow ls)
  (if
   (null? ls)
   '()
   (searchList ls (length ls))
   )
  )