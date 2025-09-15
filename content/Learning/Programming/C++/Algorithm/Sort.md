---
created: 2025-08-03T14:22
updated: 2025-09-15T22:16
title:
---
2025-09-13 15:49

Status:

Tags:

**目錄**
- [[#Selection sort|Selection sort]]
	- [[#Selection sort#Champion problem|Champion problem]]
	- [[#Selection sort#Selection sort|Selection sort]]
- [[#Insertion sort|Insertion sort]]
	- [[#Insertion sort#Insert|Insert]]
	- [[#Insertion sort#Insertion sort|Insertion sort]]
- [[#Merge sort|Merge sort]]
	- [[#Merge sort#Merge|Merge]]
	- [[#Merge sort#Merge sort|Merge sort]]
- [[#Heap and Heap sort|Heap and Heap sort]]
	- [[#Heap and Heap sort#Heap|Heap]]
	- [[#Heap and Heap sort#Heap sort|Heap sort]]
- [[#Quick Sort|Quick Sort]]
- [[#STL sort usage|STL sort usage]]




# Sort
## Selection sort
### Champion problem
* Champion problem是在一個容器裡找出最小數字的index，方法是用ret來存最小的index，然後用`vec[ret]`與容器裡每個數字做比較，如果比`vec[ret]`小，就與ret交換。
* C++ 實做
```c++
int champion(int *vec, int n){
	int ret=0;//1 assignment
	for(int i=0;i<n;++i){// 2n comparsion, n addition, n-1 assignment 
		if(vec[i]<vec[ret]){
			ret=i;
		}
	}
	return ret;
}
// Total 4n+c operation
```
![[champion.png]]
### Selection sort
* Selection sort是champion problem的延伸，起始點從第一個元素開始找到整個容器中最小值得index再與起始點交換，做完再將起始點往後移一個
* C++ 實做
```c++
void selection_sort(int* vec, int n){
	for(int i=0;i<n;++i){
		int ret = champion(vec+i, n-i) + i; // champion is find relative index compare to start point, so we have to add start point index
		swap(vec[i], vec[ret]);// 3 operation
	}
	return;
}
// Total (4n+c+3)*n operations
```
* Selection sort 的complexity 是$$O(n)= n^2$$

![[selection.png]]
## Insertion sort
### Insert
* 首先我們有一個**sorted的array**，跟一個待插入的數字，我們要將那個數字插入array裡但仍要維持increasing order
* 實現想法: 從array最後一個開始與要插入的數值比較，如果比較大則將array的下一個index數值等於現在這個數值，如果比較小，則下一個index的數值被要插入的數值代替，會一直檢查到第一個index如果比第一個index還要小，直接替換第一個index數值。
* 實做:
```c++
void insert(int* vec, int n, int val){
	bool inserted=false;
	for(int i=n-1;i>=0&&!(inserted);--i){
		if(vec[i]>=val){
			vec[i+1]=vec[i];
		}
		else{
			vec[i+1]=val;
			inserted=true;
		}
	}
	if(!(inserted)){
		vec[0]=val;
	}
	return;
}
```
![[insert.png]]
### Insertion sort
* Insertion sort是藉由insert實做，只不過起始array是array裡的第一個元素待插入的數值是array的第二元素，做完後第1跟2個是已經排序好的，待插入的是第三個，依此類推直到array結束
* 實做:
```c++
void insertion_sort(int* vec, int n){ 
	for(int i=1;i<n;++i){// n times
		insert(vec, i, vec[i]);// O(n) of insert is n
	}
}
```
* Complexity of insertioon sort is:$$O(n)=n^2$$
![[insertion_sort.png]]
## Merge sort
### Merge
* 兩個已經排序的array要如何merge在一起，拿兩個array的第一個元素比較，選較小的放進新array，重複這個步驟直到有一個array全部放完，接下來把剩下的放進新array就行了
* 實做:
```c++
int* merge(int* arr1, int size1, int *arr2, int size2){
	int* arr = new int [size1+size2];
	int i=0,j=0,k=0;
	while(i<size1||j<size2){
		if(i<size1&&j<size2){
			if(arr1[i]<=arr2[j]){
				arr[k]=arr1[i];
				i++;
			}
			else{
				arr[k]=arr2[j];
				j++;
			}
		}
		else{
			if(i<size1){
				arr[k]=arr1[i];
				i++;
			}
			else{
				arr[k]=arr2[j];
				j++;
			}
		}
		k++;
	}
	return arr;
}
```
* 總共要做n次比較，merge的複雜度為:$$O(n)=n$$
![[merge.png]]

### Merge sort
* merge sort是用遞迴的方法每次都切成一半，相信merge_sort會把兩個array都排序好最後再做merge
![[merge_sort.png]]
* 實做:
```c++
void merge_sort(int* arr, int n){
	if(n==1)return; //only have 1 element, don't need to sort
	int k=n/2;
	merge_sort(arr,k);
	merge_sort(arr+k,n-k);
	int* ret = merge(arr,k,arr+k,n-k);
	memcpy(arr,ret,sizeof(int)*n);
	return;
}
```
* 複雜度推算: 假設merge_sort n個花的時間是T(n)，由實做可以得出$$T(n)=2T\left( \frac{n}{2} \right)+n$$
這是一個樹結構，**每一層都會花n來merge**，每個節點都可以分成兩個子節點直到n變成1，代表共有x層，2^x=n，x=log(n)，故merge sort複雜度為:$$O(n)=n\log(n)$$
![[merge_comp.png]]
## Heap and Heap sort
### Heap

### Heap sort

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
[memcpy用法](https://shengyu7697.github.io/cpp-memcpy/)
[楊表實做](https://www.techiedelight.com/young-tableau-insert-search-extract-min-delete-replace/)
