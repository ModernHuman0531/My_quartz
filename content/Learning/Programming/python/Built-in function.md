2024-11-05 19:44

Status:

Tags:[[python]]

# Built-in function
### Zip
* A function combined two `iterable` stuff together, and return an **Zip object** we should use **list function** to list the zip out.
```python
lst1 = [1,2,3]
lst2 = [4,5,6]
zipped = zip(lst1, lst2)
>>> list(zipped)
[(1,4),(2,5),(3,6)]
```
### Set
* Set is method to store data, like tuple and list, but the **element in Set can't repeat**.
```python
# Create set object
set1 = set((1,2,3,4,5))
>>> set1 
>>> {1,2,3,4,5}
# Add element into set
set1.add(6)
>>> set1
>>> {1,2,3,4,5,6}
# Remove element in set
set1.remove(1)
>>> set1
>>> {2,3,4,5,6}

```
## Strings
### `isdigit()`
* To check the element in string is whether only have numbers or not.
```python
str1 = '1234'
str2 = 'hi i'm dunkun'
>>> str1.isdigit()
>>> True
>>> str2.isdigit()
>>> False
```
### `split()`
* Syntax:`<string>.split(sep, maxspilt)`
* split function will split the string by parameter `sep`, and `maxspilt` can let us choose how many times should we split `<string>`, the default is -1, means separate all.
### `join()`
* Syntax:`<sep>.join(<iterable>)`
* join function let us change `iterable` stuff into string. `<sep>`  tells us how to combine the string.
```python
str1 = "I love programming"
list1 = ['I','r','i','s']
>>> str1.split()
>>> ["I', "love" ,"programming"]
>>> ''.join(list1)
>>> "Iris"
```
## `enumerate()`
* `enumerate()` usually used with the `iterable object`(etc. tuple, list ...).
* The function of the `enumerate()` is to give the **index to the content** in the `iterable object`.
```python
seq = ['one', 'two', 'three']
for index, element in enumerate(seq):
	print index, element
>>> 0 one
>>> 1 two
>>> 2 three
```
## Numpy function
* np.bitcount()
* np.argmax()
# Reference