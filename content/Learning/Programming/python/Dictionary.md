2024-10-31 19:52

Status:

Tags:[[python]]

# Dictionary
It's a type of storing data's method, link the data content with it's **Key**
* Syntax
```python
	# Create a dictionary
	dict = {key1: content1,
			key2:content2
	}
	#Use key to get the value in it
	print(dict[key1])
	>>> content1
	# Add new data into dictionary
	dict[key3] = content3
	#Remove the data in dictionary
	#1.delete
	del dict[key3]
	#2.pop, this will return the pop out data
	dict.pop('key3')
	#Other useful built-in functions
	#1.Find the amounts in dictionary
	len(dict)
	#2.find all the keys in dictionary
	dict.keys()# Will return a list that contain all the key in dictionary
	#3.find all the values in dictionary
	dict.values()

	# Add a dictionary to another dictionary, use update methon
	dict1.update(dict2)
```
## Application: Build the graph
# Reference