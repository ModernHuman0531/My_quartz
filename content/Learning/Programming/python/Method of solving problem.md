2024-11-14 16:35

Status:

Tags:[[Tree]],[[python]]

# Method of solving problem
* Idea:
	* Understand what is the question.
	* See what's the type of the input and output(like number, list,etc.)
	* Work through the example and thinking it for a while before starting write the code.
	* Draw the diagram of the example.
	* Label the physical meaning of the parameter.
	* Trace the thought
* Example 1:
* Analysis function: Input is tree object and the output is the total number.
* The node that smaller than the ancestor(1,4,5,3)
* ![[Screenshot_20241114_165229.png]]
* We need to keep track of the maximum number in the whole tree, so that when t.label > max_label, then add total with 1, else keep finding the rest of the branches to see if there is any branches correspond to this property.


```python
def bigs(t):
	"""Return the number of nodes in t that are larger than all of their ancestor.
	>>> a = Tree(1,[Tree(4,[Tree(4),Tree(5)], Tree(3,[Tree(0,[Tree(2)])])])
	>>> bigs(a)
	4
	"""
	def helper(a, max_num):# a is a node of tree, max_num is max number of the tree above the node
		if a.label > max_num:
			return 1 + sum([helper(branch, a.label) for branch in a.branches])
		else:
			return sum([helper(branch, max_num) for branch in a.branches])
	#t.label doesn't have ancestor, so it must be counted.
	return helper(t, t.label - 1)

```
* Example 2:
* Input is tree, and output is a list of trees that the label is smaller than all of it's descendant.
* ![[Screenshot_20241114_162012.png]]
* In the example case, it should return tree(2,[tree(4),tree(5)]) and tree(0,[tree(6)])
* We must keep track of the smallest element in tree(use helper function), and once we make sure that the label is smaller than all the element below, than we can add the tree in the result list.
```python
def smalls(t):
	"""Return the ""non-leaf"" nodes in t that are smaller than all their descendants.if a.label < min:

	>>> a = Tree(1, [Tree(2, [Tree(4),Tree(5)]), Tree(3, [Tree(0, [Tree(6)])])])
	>>> sorted[t.label for t in smalls(a)]
	>>> [0, 2]
	"""
	result = []
	def helper(t):
		# Since the root don't have any descedant, just return it's value.
		if t.is_leaf():
			return t.label
		# else go through all the branches, compare it's label with the snmallest, if it is smaller than the smallest, than add that tree into the result list.
		else:
			# Find the smallest number below the branches. 
			min_num = min([helper(branch) for branch in t.branches])
			if t.label < min_num:
				helper.append(t)
			return min(min_num, t.label)
	process(t)
	return result
```
# Reference