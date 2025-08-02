2024-11-14 16:16

Status:

Tags:[[Tree]]

# Tree
* Tree is a data structure that have label and branches, which branches is  `[]` or a tree.

```python
class tree():
	# Default argument of branches is empty list
	def __init__(self, label, branches = []):
		# Check every argument are the branches all trees
		for branch in branches:
			isinstance(branch, tree)
		self.label = label
		self.branches = branches
	def __repr__(self):
		 return 'Tree({0}, ({1}))'.format(self.label, self.branches)
```

# Reference