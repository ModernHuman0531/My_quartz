2024-11-01 20:57

Status:

Tags: [[Basic syntax]]

# Lab 10
## Problem 6
* Implement a procedure `remove` that takes in a list and returns a new list with _all_ instances of `item` removed from `lst`. You may assume the list will only consist of numbers and will not have nested lists.
* Idea: 
	* We can use recursion to solve this question. The base case is when `lst` is empty will return '(). Otherwise see the list first value. 
	* If it equals to item, then don't add it in the list, just recurs the rest part of the list
	* If not equals to item, then turn first value into list and use append method to combine it with the rest part of the recursion.
	* **Warning**: We can't use `'((car lst))` to turn the first value into list, because `'` will make (car) symbolize and make it disable, we can use `(cons (car lst) nil)` instead.
	
```scheme
;;; Tests
(remove 3 nil)
; expect ()
(remove 3 '(1 3 5))
; expect (1 5)
(remove 5 '(5 3 5 5 1 4 5 4))
; expect (3 1 4 4)
(define (remove item lst)
  (if (null? lst)
	  '()
	  (if (= item (car lst))
		  (remove item (cdr lst))
		  (append (cons (car lst) nil) (remove item (cdr lst)))
	  )
	)
  )
```

# Reference