2024-11-05 11:20

Status:

Tags: [[Interpreter-1]],[[python]]

# Interpreter 2
## Structure of interpreter
* Can divide into two parts: **Eval** and **Apply**, both of them are recursion structure.
* **Eval**:Is a function that evaluate the passed in expression, if it's just symbol or primitive, then just return it, if it's call function, then evaluate all the argument in it ,like operator and operands, and pass in the apply function.
	* Base case:
		* Primitive or Symbol
		* Look up the values bound to symbol(assignment)
	 * Recursion case: etc.(+ 1 2 3)
		 * Eval(operand, operators) to call expression
		 * Apply(procedure, arguments)(+, (1 2 3))
* **Apply** :
	* Base case:
		* Built-in primitive procedure (+,-,$*,$/)
	* Recursion case:
		* Eval the body of user-defined procedure. 
* Simple flow chart:(Read-evaluate-print loop), loads of interpreter using this.
![[Screenshot from 2024-11-05 12-48-48.png]]
## Scheme evaluation
* Scheme eval-function can choose it's behavior base on the expression form, which can be identified by the first element.
* Like (**if** `<condition> <consequent><alt>`) , (**lambda** `(<formal parameters> <body>`) and (**define** `<name> <expression>`), in this three expression have special form like if, lambda and define. All expression beside these that is just call-expression.
* How if statement is implied:
	* Evaluate the condition
	* Choose which sub-expression we want to applied `<consequent>` or `<alternative>`.
	* Finally evaluate that sub-expression and get the value it returns.
## Quote
* In scheme, `<expression>` itself is the value of the whole quote expression
* `'<expression>` is symbolized the expression that don't calculate itself value
* And `'<expression>` is the short-hand of the `(quote <expression>)` , so when we write the interpreter, we also convert `'<expression>` into `(quote <expression>)`
## Lambda expression 
* `(lambda (<formal parameter>) <body>)`, we defined a class called **`LambdaProcedure`** to help up store the information.
```python
class LambdaProcedure:
	def __init__(self, formals, body, env):
		self.formals = formals# Store the formal parameter
		self.body = body# Store the body 
		self.env = env# Store the current environment
```
## Define expression
* We can divide it into 2 parts, have parameter or don't have.
* Don't have parameter `(define <name> <expression>)`
	* Evaluate the expression
	* Bind the expression to the name
* Have parameter `(define (<name> <parameter>) <expression>)
	*  Convert it into `(define <name> (lambda (<parameter>) <expression>)`
	* And deal it as Don't have parameter case.
# Reference