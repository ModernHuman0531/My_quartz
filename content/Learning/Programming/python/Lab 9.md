2024-10-31 14:52

Status:

Tags:[[Generator]], [[Dictionary]],[[python]]

# Lab 9
## Sequences sub problem
### Problem 1
* nest_list is a list of lists, insert_to_all function should take a list of lists and a number, and insert the number to the front of each list
```python
"""
>>> insert_to_all([[1],[1,2][1,2,3]], 0)
[[0,1],[0,1,2],[0,1,2,3]]
"""
def insert_to_all(nested_list, num):
	return [[num] + sublist for sublist in nested_list]
```
### Problem 2
* Give a sorted list, we need to return a nested list of all subsequences of list S.
* Core idea: Believe the recursion will  give us  **All the combination of s except for the first element **,  and we only need to decide whether should we insert the first element of those list or not.

```python
def subseqs(S):
	"""
	>>> eqs = subseqs([1, 2, 3])
	>>> sorted(seqs)
	>>> [[], [1], [1, 2], [1, 2, 3], [1, 3], [2], [2, 3], [3]]
 	>>> subseqs([]) #Let this to be the base case
	>>> [[]]
	"""
	if len(s) == 0:
		return [[]]
	else:
		sublists = subseqs[1:]# Will give us all the combination for s[1:]
		return insert_to_all(sublists, s[0]) + sublists# Insert the first element + no insert the first element   
	
```
### Problem 3
* Now the given list is not sorted , but we still need to eturn a nested list of all subsequences of S (a list of lists) for which the elements of the subsequence are strictly nondecreasing.
```python
def inc_subseqs(s):
    """Assuming that S is a list, return a nested list of all subsequences
    of S (a list of lists) for which the elements of the subsequence
    are strictly nondecreasing. The subsequences can appear in any order.

    >>> seqs = inc_subseqs([1, 3, 2])
    >>> sorted(seqs)
    [[], [1], [1, 2], [1, 3], [2], [3]]
    >>> inc_subseqs([])
    [[]]
    >>> seqs2 = inc_subseqs([1, 1, 2])
    >>> sorted(seqs2)
    [[], [1], [1], [1, 1], [1, 1, 2], [1, 2], [1, 2], [2]]
    """
    def subseq_helper(s,prev):
	    if len(s) == 0:
		    return [[]]
		elif s[0] < prev:#The order is wrong
			subseq_helper(s[1:], prev)# Skip the one that order is wrong.
		else:
		a = subseq_helper(s[1:], s[0])# The order is correct
		b = subseq_helper(s[1:], prev)# The order is wrong
		return insert_into_all(s[0], a) + b# We only need insert the s[0] to the correct order list.
	return subseq_helper(s,0)
```
## Numbers of tree
### Problem 4
```python
def num_trees(n):

"""How many full binary trees have exactly n leaves? E.g.,
1   2      3      3 ...
*   *      *      *
   / \    / \    / \
  *   *  *   *  *   *
        / \ /  /    /\
        * * * *    *  *

  

>>> num_trees(1)

1

>>> num_trees(2)

1

>>> num_trees(3)

2

>>> num_trees(8)

429

"""
#We need to list all the combination in different leaf, for example we can see that when leaf = 3, we have the combinatin of (1,2) and (2,1)
if n == 1:
	return 1
else:
	sum([num_trees(n-k)* num_trees(k) for k in range(1,k)])
```
## Generator
### Problem 5
* Step
	* We already know pass in parameter g is a function, call it and it will return a generator
	* We want to yield the element in g() from 1 to all element, so create a **helper function gen(i)**, use i to control how many element we're going to yield
	* Outside the gen(i), we need to control the changing of i.
```python
def make_generators_generator(g):
    """Generates all the "sub"-generators of the generator returned by
    the generator function g.
    >>> def every_m_ints_to(n, m):
    ...     i = 0
    ...     while (i <= n):
    ...         yield i
    ...         i += m
    ...
    >>> def every_3_ints_to_10():
    ...     for item in every_m_ints_to(10, 3):
    ...         yield item
    ...
    >>> for gen in make_generators_generator(every_3_ints_to_10):
    ...     print("Next Generator:")
    ...     for item in gen:
    ...         print(item)
    ...
    Next Generator:
    0
    Next Generator:
    0
    3
    Next Generator:
    0
    3
    6
    Next Generator:
    0
    3
    6
    9
    """
    def gen(i):
	    for entry in gen():
		    if i <= 0:
			    return# Forced to jump out of the loop by return.
			yield entry
			i -= 1
	i = 1#Start from only yield 1 element
	for entry in g():
		yield gen(i)
		i += 1
```
# Reference