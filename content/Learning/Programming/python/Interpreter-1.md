2024-11-04 20:16

Status:

Tags:[[Basic syntax]],[[python]]

# Interpreter-1

## Programming language
A programming language must have:
* Syntax: Legal statement or expression in a language
* Semantics: The rule of executing the Syntax
To build a new programming language, we must have:
* Specification:A document that describe the precise syntax and semantic of the language
* Canonical Implementation: An interpreter or compiler of the language
## Parsing
* It's a process the take the text we input and output a expression we can execute.
* First separate our input text into individual symbol and numbers, we call these **Token** .
* Since the expression in scheme always written as the element of parentheses. 
	`ex: (<expression 1> <expression 2>)`expression can be primitive (23) or combination (+ 2 3), we can define an pair class, turn **token** into the pair class, and we can define a execute rule for pair class.
![[Screenshot from 2024-11-04 21-06-17.png]]
### Syntactic analysis
* Takes the token of a pair of parentheses into 1 valid expression by using **pair class** so that can be executed in python interpreter.
* Since we use **recursion** to turn the token into expression, the base case is a symbol (+ - * /) or number, and the recursive call is using scheme_read to read sub-expression and combine them into pair.
```python
def scheme_read(src):
	"""Read the next expression from src, a buffer of tokens
	>>> lines = ['(+ 1 ', '(+ 23 4)) ('] #Our input
	>>> src = Buffer(tokenize_lines(lines)) #Lexical analysis
	>>> print(scheme_read(src))# Syntactic analysis
	"""
	if src.current() is None:# Current option has no content
		raise EOFError
	val = src.pop()# Take the first element(token) out of the src
	if vail = 'nil':#If the content is a list that just empty(nil in scheme)
		return nil
	elif val not in DELIMETERS: #( ),which means the content is just number or symbol
		return val#just return content itself
	elif val == '(':# If val is parentheses, means it start a combination
		return read_tail(src)
	else:
		raise SyntaxError("Unexpected token:{0}".format(val))

def read_tail(src):# Specify for deal with combination
	"""Return the remainder of a list in src, starting beforean element or ).
	>>> read_tail(Buffer(tokenize_lines([')'])))
	nil
	>>> read_tail(Buffer(tokenize_lines(['2 3)'])))
	Pair(2, Pair(3, nil))
	>>> read_tail(Buffer(tokenize_lines(['2 (3 4))'])))
	Pair(2, Pair(Pair(3,Pair(4, nil), nil))
	"""
	if src.current() is None:
		raise SynatxError("Unexpected end of file")
	if src == ')':
		src.pop()# Pop the ')' outm and go back to scheme_read to continue
		return nil
	first = scheme_read(src)# To judge the first element is a symbol or number
	rest = read_tail(src)
	Pair(first, rest)# Turn into Pair class expression
	```
### Pair class
* The reason why we need pair class, because the scheme expression always started with parentheses, and we can easily represent it with by pair
```python
"""
>>> s = Pair(4, Pair(3,Pair(2, nil)))
>>> print(s)
(4 2 3) #It's the scheme represntation form 
"""
class Pair:
	def __init__(self, first, second):
		self.first = first
		self.second = second# If second is nil or list, then the total object is a list 
```

# Reference