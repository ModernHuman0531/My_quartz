---
created: 2025-08-03T14:22
updated: 2025-09-26T00:52
title:
---
2025-09-13 15:49

Status:

Tags:[[Array and Linked list]],[[Divide and Conquer]]

**目錄:**
- [[#Selection sort|Selection sort]]
	- [[#Selection sort#Champion problem|Champion problem]]
	- [[#Selection sort#Selection sort|Selection sort]]
- [[#Insertion sort|Insertion sort]]
	- [[#Insertion sort#Insert|Insert]]
	- [[#Insertion sort#Insertion sort|Insertion sort]]
- [[#Merge sort|Merge sort]]
	- [[#Merge sort#Merge|Merge]]
	- [[#Merge sort#Merge sort|Merge sort]]
- [[#Young's Tabelau|Young's Tabelau]]
	- [[#Young's Tabelau#Search|Search]]
	- [[#Young's Tabelau#Insertion|Insertion]]
- [[#Heap and Heap sort|Heap and Heap sort]]
	- [[#Heap and Heap sort#Heap|Heap]]
	- [[#Heap and Heap sort#Heap sort|Heap sort]]
- [[#Quick Sort and Quick select|Quick Sort and Quick select]]
	- [[#Quick Sort and Quick select#Quick sort|Quick sort]]
		- [[#Quick sort#Running time|Running time]]
		- [[#Quick sort#The power of randomness|The power of randomness]]
		- [[#Quick sort#Selection problem|Selection problem]]
- [[#STL sort usage|STL sort usage]]
	- [[#STL sort usage#Compare function原理與多重比較|Compare function原理與多重比較]]
		- [[#Compare function原理與多重比較#多重排序|多重排序]]







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
## Young's Tabelau
* 對於已經sorted的array，**searching 的complexity是O(logn)**, insert的complexity是O(n)，對於還沒sorted的array，searching的complexity是O(n)，insertion的complexity是O(1)，那我們是否有在searching跟insert都表現平均的排序法呢=>Young's tableau!!!
* `M*N Young Tableau` 代表一個M乘N矩陣，**每個row跟column(從左到右從上到下)數字要是increasing order**，這是楊表最重要的規則
### Search
![[Young search.png]]
* Search時，我們會從右上角開始比，如果目標數值比目前位置大，往下走，比現在位置小，則往左走，如果超過邊界仍沒找到則回傳否
* 實做:
```c++
bool search(vector<vector<int>>& tableau,int value){
    // Search forom the top right to buttom left
    int i=0,j=tableau[0].size()-1;
    if(tableau.empty()){
        return false;
    }
    while(i<=(tableau.size())-1&&j>=0){
        if(tableau[i][j]>value){
            j--; //go left
        }
        else if(tableau[i][j] < value){
            i++;
        }
        else{
            return true;
        }
    }
    return false;
}
```
在search裡要找到目標在`M*N楊表`花最多N+M-1步，所以search的複雜度是:**$$O(n)=\sqrt{ n }$$
### Insertion
![[Young insertion.png]]
* 插入規則: 從**最右下角開始插入**想要插入的數字，當楊表還沒滿時我們以**INT_MAX**來填充剩餘部份，每次都跟現在位置的左邊跟上面進行比較，當: 

| 情況       | 動作                               |
| -------- | -------------------------------- |
| 只有左邊比現在大 | 跟左邊交換後繼續以左邊位置insert(確認仍維持楊表規則)   |
| 只有上面比現在大 | 跟上面交換後繼續以上面位置insert(確認仍維持楊表規則)   |
| 兩邊都比現在大  | 比較上面跟左邊看哪個比較大就跟現在這個交換，然後繼續insert |
```c++
#include <iostream>
#include <climits>
#include <cmath>
#include <vector>

using namespace std;
void insertion(vector<vector<int>>& tableau,int i,int j){
    // Use i,j to keep track of value is obey the rule or not
    if(i==0&&j==0){return;}// Base case
    // Have to exclude i=0 or j=0 case in case of system check ther value like tableau[-1][0]
    if(i==0){
        if(tableau[i][j]<tableau[i][j-1]){ //Left larger than right
            swap(tableau[i][j-1],tableau[i][j]);
            insertion(tableau, i,j-1);
        }
        return;
    }
    if(j==0){
        if(tableau[i][j]<tableau[i-1][j]){
            swap(tableau[i-1][j],tableau[i][j]);
            insertion(tableau,i-1,j);
        }
        return;
    }
    if((tableau[i-1][j]>tableau[i][j])&&(tableau[i][j-1]>tableau[i][j])){
        // Choose big one to swap
        if(tableau[i-1][j]>tableau[i][j-1]){
            swap(tableau[i][j],tableau[i-1][j]);
            insertion(tableau,i-1,j);
        }
        else{
            swap(tableau[i][j-1],tableau[i][j]);
            insertion(tableau,i,j-1);
        }
    }
    else if(tableau[i-1][j]>tableau[i][j]){
        swap(tableau[i-1][j],tableau[i][j]);
        insertion(tableau,i-1,j);
    }
    else if(tableau[i][j-1]>tableau[i][j]){
        swap(tableau[i][j-1],tableau[i][j]);
        insertion(tableau,i,j-1);
    }
}
vector<vector<int>> insert(vector<int> input){
    int M=ceil(sqrt(input.size()));
    int N=M;
    vector<vector<int>> tableau(M,vector<int>(N,INT_MAX));
    for(auto &element: input){
        // If buttom right isn't INT_MAX, means tableau is full 
        if(tableau[M-1][N-1]!=INT_MAX){
            cout<<"Tableau are already filled\n";
        }
        else{
            // insertion is always start from buttom right
            tableau[M-1][N-1]=element;
            insertion(tableau,M-1,N-1);
        }
    }
    return tableau;
}

```
* 在insert裡要插入目標在`M*N楊表`花最多N+M-1步，所以insert的複雜度是:$$O(n)=\sqrt{ n }$$
## Heap and Heap sort
 Heapify 跟Buildheap的差別很重要
### Heap
* Heap(堆積)是一個二樹狀的資料結構(除了最底層)，但通常不會以樹的資料結構進行實做，而是以array/vector加上heap的規則進行實做
* Heap規則: (兩個是一樣的規則只是表達方式不同)
	* `parent[i]=[i/2]` :Node i的parent 會是`[i/2]`
	* `left[i]=2i, right[i]=2i+1` :Node i的左子節點是2i，右子節點2i+1
![[heap.png]]
* 我們以max heap為例，max heap的規則是`array[parent]>array[child]`，我們用heapify來維持一個節點開始遵守heap的規則
* Heapify(i): Heapify function是要讓點i跟他的children保持heap的規則，但有個**前提是左subtree跟右subtree都要已經是max heap了**(修正只有一個點壞heap規則的function)
	* 以下圖為例，只有第一個點沒有遵守規則，所以看左右子節點選大的交換，換完後`A[1],A[2],A[3]`有遵守heap規則，但`A[3]` 後的subtree又沒遵守heap，所以會選一邊一直遞迴直到樹的底部，而深度是log(n)，代表**每次heapify的複雜度是log(n)。**
![[heapify.png]]
* Build heap則是用遞回來建構整個heap，先確認左邊樹跟右邊樹已經是max heap，最後用本節點做heapify
* Extract max則是將最上面的點儲存後傳，將heap的最後一個點拉上電一個點並刪掉最後一點，然後對最頂點做heapify
* Heap 實做
```c++
#include <iostream>
#include <climits>
#include <vector>
#include <algorithm>
using namespace std;

class Heap{
    private:
        vector<int> array;
    public:
        Heap(){
            array.push_back(INT_MAX);
        }
        void insert(int input){
            array.push_back(input);
        } 
        void heapify(int i){
            int parent=i;
            int left=2*i,right=2*i+1;
            int max=parent; 
            if((left<array.size())&&(array[max]<array[left])){
                max=left;
            }
            if((right<array.size())&&(array[max]<array[right])){
                max=right;
            }
            if(max!=parent){
                // parent swap with max and do heapify recursively.
                swap(array[parent],array[max]);
                heapify(max);
            }
        }
        void buildHeap(int i){
            if(i>=array.size())return;
            buildHeap(2*i);
            buildHeap(2*i+1);

            heapify(i);
        }
        void printHeap(){
            for(int i=1;i<array.size();++i){
                cout<<array[i]<<" ";
            }
            cout<<"\n";
        }
        int extractMax(){
            int max=array[1];
            array[1]=array[array.size()-1];
            array.pop_back();
            heapify(1);
            return max;
        }
}; 
```
* Heap複雜度計算，T(n)=2T(n/2)+log(n)，(T(n)代表左子樹跟右子樹變成max heap的時間,log(n)則是本節點heapify花的時間)，根據master theorem，建立heap的複雜度是$$O(n)=n$$
### Heap sort
* 實做就是一直使用extract max將得到的結果存進容器裡直到Heap裡剩一個元素為止並回傳
* 實做:
```c++
vector<int> HeapSort(vector<int> input){
    Heap heap;
    vector<int> output;
    for(const auto& number: input){
        heap.insert(number);
    }
    heap.buildHeap(1);
    for(int i=0;i<input.size();++i){
        output.push_back(heap.extractMax());
    }
    return output;
}
```
* 複雜度就是extract max做n次，而extract max讀複雜度等於heapify的複雜度(log(n))，所以heap sort的複雜度是$$O(n)=n\log(n)$$
* Heap STL: STL 裡也有一個Heap稱為priority_queue，記的要`#include <queue>`

| 寫法                       | 功能              |
| ------------------------ | --------------- |
| `priority_queue<int> pq` | 宣告一個整數的max-heap |
| `push()`                 | 將資料丟進heap裡      |
| `pop()`                  | extract max功能相同 |
| `top()`                  | heap裡最大元素的值     |
| `size()`                 | heap大小          |
* 不同資料結構對不同動作複雜度比較:

| n elements     | search cost                 | insert cost         | extract max     |
| -------------- | --------------------------- | ------------------- | --------------- |
| sorted array   | O(log(n)) [[Binary search]] | O(n)                | O(n)            |
| unsorted array | O(n)                        | O(1)                | O(n)            |
| young tableau  | $$O(n)=\sqrt{ n }$$         | $$O(n)=\sqrt{ n }$$ | ?               |
| heap           | ?                           | $$O(n)=\log(n)$$    | $$O(n)=\log n$$ |

## Quick Sort and Quick select
### Quick sort
* Quick sort 的概念是選一個pivot(先假設選容器裡最後一個element)作為基準，比他大的放在他右邊，小於等於他的則放在他左邊，然後對他左邊的array跟右邊的array再做Quicksort(**他自己不用，因為已經是正確的位置了**)，遞迴中止條件則是當array裡只有他一個人的時候就回傳
	* 實做方法1(額外多O(runtime)空間)
		```c++
	void Quicksort(int *array,int n){
		if(n<=1)return;
		int pivot=array[n-1];
		int left=0,right=n-1;
		int* buf=int new[n];
		for(int i=0;i<n-1;++i){
			if(array[i]<=pivot){
				buf[left]=array[i];
				left++;
			}
			else{
				buf[right]=array[i];
				right--;
			}
			buf[left]=pivot;
		}
		memcpy(array,buf,sizeof(array[0])*n);
		delete[] buf;
		Quicksort(array,left);
		Quicksort(array_left+1,n-left-1);
	}
	```
	 ![[Quicksort1.jpg]]
	* 實做方法2(額外空間為O(1))被稱為**In-placed quicksort**:
		* 實做步驟與原理：
		* 用一個額外的變數(slast)來追蹤pivot的位置(有幾個比pivot小的數，pivot的位置就應該在他們後面)
		* 從頭開始loop整個array，當遇到小於等於pivot時，slast指的資料跟現在loop到的資料交換，slast往右指一個(slast++)
		* 大於則不做事，換到最後一個(pivot位置)換完後，slast左邊都是比pivot小，右邊都是比pivot大的
```c++
void Quicksort(int *array,int n){
    if(n<=1) return;
    int slast=0;
    int pivot=array[n-1];
    for(int i=0;i<n;++i){
        if(array[i]<=pivot){
            swap(array[slast],array[i]);
            slast++;
        }
    }
    Quicksort(array,slast-1);
    Quicksort(array+slast,n-slast);
}
```
#### Running time
* Quicksort 在大部份的case的時間，不論是(`S:L`=1:1 or `S:L`=9:1)，的時間複雜度幾乎都是**O(nlogn)**
* 但在最爛的case，例如(n,n-1,n-2,...,1)時
$$\begin{cases} 
T(n)=T(n-1)+O(n),n\geq2 \\
T(n)=1,n=1
\end{cases} 
$$假設c1>O(n)，c2>O(1)，c=max(c1,c2)
$$\begin{cases}
T(n)\leq T(n-1)+cn,n\geq2 \\
T(n)\leq c
\end{cases}$$
這個複雜度是
$$T(n)\leq T(n-1)+cn\leq T(n-2)+cn+c(n-1)\leq\dots\leq c(n+(n-1)+\dots+1)\leq O(n^2)$$
* 在都選最後一個當pivot的前提下，quick sort的複雜度為:
$$n\log n\leq O(n)\leq n^2$$
#### The power of randomness
* 為了將最差的case發生機率降到最低，要一個好的分割，因此我們要隨機決定pivot的點，那個點只要能分割成`[1/4,3/4]`就稱為一個好的分割，只要選的pivot能將array分割成`[1/4,3/4]`幾乎就可以確定Qucik sort的時間複雜度為O(nlogn)
#### Selection problem
* Quick Select原理:隨機選一個pivot如果數值小於等於pivot，則將他歸類在S(index 0-slast-1都在S)，大於pivot則歸類在L(Slast-n在L)，令一個變數**slast來計算<=pivot的個數**，如果`slast<k`代表第k個不在S，則繼續遞迴L，如果恰好等於k直接回傳pivot，如果小於則直接遞迴S
* 如果每次都是好的分割複雜度為
$$\begin{aligned}
O(n)=n+\left( \frac{3}{4} \right)n+\left( \frac{3}{4} \right)^2n+\dots\leq_{}4n＝O(n)
\end{aligned}$$
* 如果每次都是bad case的話複雜度則是
$$O(n)=n+n-1+\dots_{}+1=O(n^2)$$
* 實做
```c++
int Quickselect(int *array,int n,int k){
	if(n==1){
		if(k==1)
			return array[0];
	}
	int pivot=array[rand()%n];
	int slast=0;
	for(int i=0;i<n;++i){
		if(array[i]<=pivot){
			swap(array[i],array[slast]);
			slast++;
		}
	}
	if(slast<k)
		return Quickselect(array+slast,n-slast,k-slast);
	else if(slast=k)
		return pivot;
	else
		return Quickselect(array,slast,k); 
}
```
## STL sort usage
* 因為排序演算法太長使用了，因此我們通常不會自己實做，而是使用STL裡已經幫我們寫好的**std::sort**(背後原理是用Quick sort進行實做)
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
### Compare function原理與多重比較
* Compare function型態: `bool cmp(const T& a, const T& b)`
* 規則:
	* 當compare function回傳**True**時，**代表a要排在b前面**，**False**則是a不該在b前面
	* 但不可以同時cmp(a,b)跟cmp(b,a)都是true
#### 多重排序
* 當遇到多重排序時，compare function可以用if來決定要在哪一個項目上進行比較，因為compare 的項目也有優先程度，應該先把優先度高的把在前面，如果相同在繼續比。
* 舉裡來說，我想要排學生的先後順序，條件是1.先比score(降序)2.score相同則比age(升序)3. 再相同則比名子字母序，則compare function的寫法為:
```c++
bool compare(const student& a, const student& b){
	if(a.score!=b.score)
		return a.score>b.score
	if(a.age!=b.age)
		return a.age<b.age;
	return a.name<b.name;
}
```
# Reference
[memcpy用法](https://shengyu7697.github.io/cpp-memcpy/)
[楊表實做](https://www.techiedelight.com/young-tableau-insert-search-extract-min-delete-replace/)
[in order Quick sort](https://ithelp.ithome.com.tw/articles/10278644)
