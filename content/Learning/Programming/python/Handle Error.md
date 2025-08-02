2024-11-03 01:18

Status:

Tags[[python]]

# Handle Error
## Exception
* Python will **raise the exception** every time the program face the error, and we can handled the exception  by the program, to let the program stop halting every the program face error.
* Exceptions are different kinds of class that also contain the constructor.
### Assert
* Assert statement can raise the exception that the type is `AssertionError(The type of the class)`.
* It can be inserted at the middle of the program.
*  Syntax
```python
assert <expression>, <string>
# If the expression return False, then it'll make an object of AssertionError, and teh constructor will take the string as parameter
"""
>>> assert false, "Miss input"
AssertionError:Miss input
"""
```
* We also can choose to disable assert to enhance the program's efficiency, using **__debug__** 
### Type of exception
| Exception name | Content                                                                    |
| -------------- | -------------------------------------------------------------------------- |
| TypeError      | The arguments that passed in the function have wrong numbers or wrong type |
| NameError      | Can't find the name of the variables or the functions                      |
| KeyError       | Can't find the keys in the dictionary                                      |
| RecursionError | Infinite recursion                                                         |
## Try Statement
* Try statement can handle exception in python.
* syntax:
```python
"""
try:
	#This will be executed first, if facing exception, then will jump into except part
	<try suite>
except <exception class> as <name>:
	<exception suite>
(optional)--------
finally:
	...this will always be executed at the end of the program.
"""
# Example:
def invert(x):# Don't have to deal with x = 0 issue
	inverse = 1/x
	print('Never print inverse if x is 0')
	return inverse

def inverse_safe(x):# Don't have to know how to do invert, just deal with the x=0
	try:
		inverst(x)
	except ZeorDivisionError as e:# e store the error message 
		return str(e)
"""
>>>invert_safe(0)
division by zero
```

# Reference