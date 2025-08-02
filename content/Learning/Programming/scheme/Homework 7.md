2024-11-04 22:37

Status:

Tags:[[Basic syntax]] [[Lab 10]]

# Homework 7
## Problem 2
* Description: Implement the function interleave, which takes a two lists as arguments. interleave will return a new list that interleaves the elements of the two lists. Refer to the tests for sample input/output.
* Idea:
	* Use recursive since scheme don't have for and while
	* Base case is when one of the list is empty, then use **(append `s1` `s2`)** to merge them together
	* Recursion case: we can build a list that take first's first element and Second's first element and the rest is (Interleave (`cdr` first) (`cdr` second)). 
	
```scheme
(define (interleave first second)
  'YOUR-CODE-HERE
  (if (or (null? first) (null? second))
	  (append first second)
	  (cons (car first) (cons (car second) (interleave (cdr first) (cdr second))       ))
  )
)

(interleave (list 1 3 5) (list 2 4 6))
; expect (1 2 3 4 5 6)
(interleave (list 1 3 5) nil)
; expect (1 3 5)
(interleave (list 1 3 5) (list 2 4))
; expect (1 2 3 4 5)
```
## Problem 4
* Description: Implement `no-repeats`, which takes a list of numbers `lst` as input and returns a list that has all of the unique elements of `lst` in the order that they first appear, but no repeats. For example, `(no-repeats (list 5 4 5 4 2 2))` evaluates to `(5 4 2)`.
* Idea: 
	* Base case: When `lst` is null, return '()
	* Recursion case: Form a list that the first is `(car lst)` and modify the `(cdr lst)` by using the filter function, the condition is if there is any number in `(cdr lst)` not equals to `(car lst)` then that element will be saved, otherwise will be removed.
```scheme
(define (no-repeats lst)
  'YOUR-CODE-HERE
  (if (null? lst)
	  '()
	  (cons (car lst) (no-repeats (filter (lambda (x) (not (= (car lst) x))) (cdr lst))))
  )
)
```
# Reference