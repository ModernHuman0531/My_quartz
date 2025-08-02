2024-11-13 15:05

Status:

Tags:[[Basic syntax]]

# Macro function
* Normally the function will first evaluate the parameter, then evaluate the function it self. But macro function will first evaluate it's function body, the put the parameter in it.
* Example:
```scheme
(define (map fn s)
	  (if (nil? s)
		  '()
		(append (cons (fn (car s)) nil) (map fn (cdr s)))  
	)
)
;Normal ways
(map (lambda (x) (* x x)) '(2 3 4 5))
;macro function way
(define-macro (for sym vals expr)
	(list 'map (list 'lambda (list sym) expr) vals)
)
```


# Reference