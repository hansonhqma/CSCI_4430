;; some test lists
(define list1 '(1 2 3 2 4 1 2))
(define list2 '(2 4 3 1 2 1))


;; linear search algorithm
;; doesn't assume num is somewhere in nums
(define (linearSearch nums num)
  (if (<= num (car nums))
    0
    (+ 1 (linearSearch  (cdr nums) num))
    )
  )

;; returns last element of nums
(define (getLast nums)
  (if (null? (cdr nums))
      (car nums)
      (getLast (cdr nums))
   )
  )

;; append using reverse, O(n)
(define (addtotail list num)
  (reverse (cons num (reverse list)))
  )


;; list[index] = num, O(n)
;; assumes index is in bounds
(define (replaceAtIndexDriver list index cur_index num)
  (if (= index cur_index)
      ;; replace head and return
      (cons num (cdr list))
      ;; append recursed solution
      (cons (car list) (replaceAtIndexDriver
                        (cdr list)
                        index
                        (+ 1 cur_index)
                        num
                        ))
   )
  )

;; wrapper function for replace at index
(define (replaceAtIndex list index num) (replaceAtIndexDriver list index 0 num))


;; this needs to be called with (cdr nums) as nums
;; returns the next iteration of ans based on the ans passed to it
(define (driver nums cur_ans)
  (if (null? (cdr nums))
      ;; last element, don't recurse
      (if (>= (car nums) (getLast cur_ans)) ;; nums[i] >= ans[-1]
          ;; append to ans
          (addtotail cur_ans (car nums))
          ;; else replace
          (replaceAtIndex cur_ans (linearSearch cur_ans (car nums)) (car nums))
       )
      ;; not last element, make recursive calls to build ans
      (if (>= (car nums) (getLast cur_ans)) ;; nums[i] >= ans[-1]
          ;; modify ans by appending, recurse
          (driver (cdr nums) (addtotail cur_ans (car nums)))
          ;; modify ans by replacing, recurse
          (driver (cdr nums)
                  (replaceAtIndex cur_ans (linearSearch cur_ans (car nums)) (car nums))
                  )
          )
      )
  )

;; wrapper function
(define (lis_fast nums) (driver (cdr nums) (list (car nums))))

(lis_fast list2)
