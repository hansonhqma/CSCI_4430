
(define (f lis)
  (foldl (lambda (x y) (if (and (number? x) (> x 5))
                         (cons x y) y)) lis '()))

(define (sumlist nums)
  (if (null? (cdr nums)) ;; single item list
    (car nums) ;; return only item
    ;; else
    (+ (car nums) (sumlist (cdr nums)))
    )
  )

(define a '(1 2 3 4))

(sumlist a)
