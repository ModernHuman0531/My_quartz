2024-11-04 17:27

Status:

Tags:[[python]]
# Reduce function
Combing elements of s pairwise using function f, starting with initial.
```python
"""
>>> reduce(mul, [2, 4, 8], 1)# mul(8,mul(4,mul(1 ,2)))
64
"""
def reduce(f, s, initial):
	if len(s) == 0:
		return initial
	else:
	initial = f(s[0], initial)
	return reduce(f, s[1:], initial)
```


# Reference