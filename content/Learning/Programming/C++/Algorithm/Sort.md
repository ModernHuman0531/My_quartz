---
created: 2025-08-03T14:22
updated: 2025-09-13T16:43
title:
---
2025-09-13 15:49

Status:

Tags:

**目錄**
- [[#Selection sort|Selection sort]]
- [[#Insertion sort|Insertion sort]]
- [[#Heap and Heap sort|Heap and Heap sort]]
	- [[#Heap and Heap sort#Heap|Heap]]
- [[#Quick Sort|Quick Sort]]
- [[#STL sort usage|STL sort usage]]



# Sort
## Selection sort

## Insertion sort

## Heap and Heap sort
### Heap

## Quick Sort

## STL sort usage
* 因為排序演算法太長使用了，因此我們通常不會自己實做，而是使用STL裡已經幫我們寫好的**std::sort**
* 使用時要`#include<algorithm>`
* **std::sort**的複雜度為**O(nlogn)**
* 語法: `sort(container.begin(), container.end(), comparefunction())`
	* 在預設情況時sort會依照ascending order做排序，如果想要輸出結果是descending order，則要自定義compare function.
	*  Example:
``` c++
#include <iostream>
#include <algorithm>

using namespace std;
bool compare(int num1, num2){
	return num1 > num2;
}

int main(){
	vector<int> vec1 = {3,5,4,2,1};
	vector<int> vec2 = vec1;
	// Method 1. No compare function
	sort(vec1.begin(), vec1.end()); // vec1={1,2,3,4,5}
	// Method 2. Have compare function
	sort(vec2.begin(), vec2.end(), compare); //vec2={5,4,3,2,1} 
	return 0;
}
```
# Reference
