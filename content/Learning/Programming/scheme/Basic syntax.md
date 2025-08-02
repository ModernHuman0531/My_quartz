2024-11-01 13:09

Status:

Tags:

# Basic syntax
## Call Expression
* In scheme, call expression include an operator and 0 or more operands **in the parentheses**
* The space will be ignore in the call expression, but we still indent the code like python to help us reading.
```scheme
>>> (+ 1 2)
3
>>>(zero? 2)
#f
```
## Special form
* Key point: When the number of parameter is more than 1, we must group those parameter with **parentheses()**. 
* Purpose of **begin function** : Usually the function only have one body to do one stuff, if we want to do more than 1 thing use **(begin)** to bind two expression together.
*  Purpose of **let function**: In python when we assign a number to a variable, it will maintain until we change, but we can use **(let)** in scheme  to let the variable bind the value temporarily, ad long as we end the parentheses it will not be bounded anymore

| Expression name     | expression                                                                                | example                                                                                   |     |
| ------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | --- |
| if expression       | (if< condition >< consequence >< alternative >)                                           | (if (< x 2) (+ x 5) (+ x 1))                                                              |     |
| and / or expression | (and <1> <2>) / (or <1><2>)                                                               |                                                                                           |     |
| Assignment          | (define < symbol> < expression>)                                                          | (define x 3)                                                                              |     |
| Function            | (define (< name> < formal parameter>) < body>)                                            | (define (square x) (* x x))                                                               |     |
| lambda function     | (define name (lambda < parameter> < body>))                                               | (define square (lambda (x) (* x x))                                                       |     |
| if-elif-else        | ($cond$ (< condition 1>) (result 1) (<condition 2>)(result 2 )(< condition 3>)(result 3)) | ($cond$ (> x 10) (print 'large) (> x 5) (print 'middle) else (print 'small) )             |     |
| begin               | (begin (expression 1) (expression 2))                                                     | (if (> x 10) (begin (print 'big) (print 'number)) (begin (print 'small) (print 'number))) |     |
| let                 | (let < symbol> < value>)                                                                  | (let a 3)                                                                                 |     |
| filter              | (filter < condition> < scheme list)                                                       | (filter odd?  '(1 2 3)')                                                                  |     |
```scheme
;Good coding style for if-elif-else statement
(cond 
	  ((> x1 x2) -1)
	  ((= x1 x2) 0)
	  (else 1)
	  )
;filter implementation, that will iterate all element in list to check the condition
(filter (lambda (x) (= (car lst) x)) (cdr lst))
```
## List 
* The link in scheme is like linked-list in python, use **cons** instead of **Link class**, use **nil** instead of **Link.empty** 
* Get the first value in list is **(car < link>)** , and use **(cdr < link>)** to get the rest value. 

```scheme
>>> (cons 1 (cons 2 nil))
(1,2) ;How it is symboled in intepreter
>>>(define s (cons 1 (cons 2 nil)))
>>> (car s)
1
>>> (cdr s)
(2) ;(cons 2 nil)
```
![[Screenshot from 2024-11-01 14-21-43.png]]
* If the **first element is a list instead of number** , we can image the first value as a pointer point to the list of the first parameter in cons.
```scheme
(define s (cons (cons 1 (cons 2 nil)) (cons 1 (cons (cons 1 nil) nil))))
>>> s
((1 2) 1 (1))
```
![[Screenshot from 2024-11-01 14-38-16.png]]
* In fact, scheme do have function **(list)** that do exact the same thing as we use the **cons**
```scheme 
>>> (list (list 1 2) 1 (list 1))
((1 2) 1 (1))
```
* built-in function in list:
```scheme
(define s '(1 2 3)) ;s equals to (cons 1 (cons 2 (cons 3 nil))) or (list 1 2 3)
(define p '(4 5 6))
;null function: to check is there something in list
>>> (null? s)
#t
;append function: Can concatenates two list
>>> (append s p)
(1 2 3 4 5 6)
;length function: Find the amounts in list
>>> (length s)
3
```
## Symbolic programming
* Symbol always bind to value no matter we define it or not, but can we just refer to symbol itself instead of value?
* We can use **Quote (')** or **Quasiquote($`$)** to achieve this goal.
### Quote
* In scheme, when we refer a variable or a function, it will directly give us the value, but when we add an **Quote** before variable or function, it will only show us the symbol (**Can imagine it as a string**)
* If we want to know what happen when we run the content of the symbol, we can use the **(eval)** function to do that.
```scheme
(define b 4)
(define a 2)
>>> (a b)
(2 4)
>>> ('a ,b)
(a 4)
>>> (eval '(+ a b))
6
```
* Since we know the symbol of  the list in scheme is like (1 2 3 ... ) , we can use this property to backward induct the link.
```scheme
>>> '(1 2 3); This is equal to (list 1 2 3) or (cons 1 (cons 2 (cons 3 nil)))
(1 2 3)
```
### Quasiquote
* The biggest difference between Quote and Quasiquote is that we can use this symbol **<,>**  to reverse the impact of the Quasiquote.
* That is, we can choose the part we want to symbolize it or not.
```scheme
>>> `(+ (+ 2 3) 5)
(+ (+ 2 3) 5)
>>> `(+ ,(+ 2 3) 5)
(+ 5 5)
```
### Application
* Since scheme doesn't have the **while statement** , but we may use recursion and Quasiquote to achieve this goal.

```scheme
(define (sum-while initial-x condition add-to-total update-x)
		;sum-while1 1       `(< (* x x) 50) 'x      '(+ x 1)'
(begin
	 (define (f x total)
		 (if ,condition
			 (f ,update-x (+ total `add-to-total))
			 total))
	(f initial-x 0)))
```
# Reference