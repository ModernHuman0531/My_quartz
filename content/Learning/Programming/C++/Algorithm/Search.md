---
created: 2025-08-03T14:22
updated: 2025-10-12T14:37
title:
---
2025-09-17 15:44

Status:

Tags:[[Learning/Programming/C++/Algorithm/Tree|Tree]],  [[Sort]], [[Lab1|Lab1]]
目錄:
- [[#Linear search|Linear search]]
- [[#Binary search|Binary search]]
	- [[#Binary search#第一個>=k的數問題|第一個>=k的數問題]]
	- [[#Binary search#Binary search的原理|Binary search的原理]]
	- [[#Binary search#Ternary search(三分搜)|Ternary search(三分搜)]]

# Search
* 搜尋問題通常是要找出在這個容器裡第k大的數值，或是第一個index使`x_i>=k` 或是做大的index使得`x_i<k` 。
## Linear search
* 從頭到尾用迴圈搜尋一遍，複雜度是`O(n)`。

## Binary search
* Binary search(二分搜)以猜數字當作例子，要猜0-100的數字時，最好的策略便是先猜50(也就是切一半)，問比50大還比50小，如果比50大代表範圍在51-100之間，這是再切一半猜75，依此類推直到猜中數字，這種猜中間樹自來限縮答案範圍至原本一半的技巧稱為binary search(二分搜)。
### 第一個>=k的數問題
* 那假設現在我們有一個數列,(x1,x2,x3,...xn)，且這個數列為非嚴格遞增數列，我們想找到第一個index i，使`xi>=k`。，我們可以猜m，並根據`xm`與k的比較結果來判斷index的範圍
* 目標是:**找到第一個index i，使`xi>=k`**，index的候選是`l,l+1,...,r-1,r`，當:
	* `xm<k`時，代表目標index一定比m大，所以範圍更新成`m+1,m+2,...,r`(或是講成`l=m+1`)
	* `xm>=k`時，代表m可能是答案也可能目標比m更小，所以範圍更新成`l,l+1,...,m`(或是講成r=m)
* 但我們將目標改變成:**找到最大的index，使xi<k**，則當:
	* `xm<k`時，代表m可能是目標index，也可能目標index比m大，所以範圍更新成`m,m+1,m+2,...,r`(也可說是`l=m`)
	* `xm>=k`時，代表目標index一定比m小，所以範圍更新成`l,l+1,...,m-1`(或講成`r=m-1`)
* 我們一直以來都將`m=[(l+r)/2]`，但這種取法在一些時候會出問題，例如當`r=l+1`時，`m=l`，這時當在`xm<k`這個case裡，會陷入無限迴圈，因為中止條件是當`l=r`。
* 方法一實做:
```c++
int binary_search(int *array,int n,int k){
	int l=1,r=n;
	while(l<r){
		int m=(l+r)/2;
		if(array[m]>=k){
			l=m+1;
		}
		else{
			r=m;
		}
	}
	return l;
}
```
* 在上面情況在根據目標不同`l`跟`r`要設的數值也不同，到底`l`要設成m還是m+1，`r`到底要設成m還是m-1?
* 我們先不糾結要設成什麼，二分搜的本質是把**所有index分成兩類`>=k`跟`<k`**，既然如此不妨改一下`l`跟`r`的定義，將`l`定義成左邊那類最後數字，`r`定義成最右邊的第一個數字，`<=l`的一定是屬於左邊那類，`r<=`的一定是屬於右邊那類，剩下中間不確定的部份則用`m`去試探，如果`m<k`，則將`l`更新成`m`，如果`m>=k`就將`r`更新成`m，中止條件則是當`r=l+1`時，要左邊最後一個選`l`，要右邊最後一個選`r`>。
* 注意:index的範圍是從`1`到`n`，而這個方法首先要確保的是`l`一定要是左邊那類，`r`一定要是右邊那類，因此一開始假設的時候一定是先從範圍外的開始。
![[binary_search.gif]]
* 實做
```c++
int binary_search(int *array, int n,int k){
	int l=0,r=n+1;
	while(l+1<r){
		int m=(l+r)/2;
		if(array[m]>=k)
			r=m;
		else
			l=m;
	}
	return r;
}
```
### Binary search的原理
* **可以被二分搜**的事情一定具備單調性，即是非嚴格遞增或是分嚴格遞減之類(我們統稱此類事情為**單調性**)的才適用於二分搜
* 二分搜每次把搜索的範圍都切一半，因此最慢最慢的複雜度是$$O(n)=\log n$$
  ### STL's binary search
  * `lower_bound(first,last,val,cmp):`從`[first,last)`裡找出第一個元素element使的cmp(element,val)為false的位置
  * `upper_bound(first,last,val,cmp)`:從`[first,last)`裡找出第一個元素element使的cmp(element,val)為true的位置
### Ternary search(三分搜)
* 常用於尋找凸函數(例如二次函數，絕對值的線性函數)的最小值
* 維護兩個變數`l`(左邊界),`r`(右邊界)，然後以這兩個變數再來決定`ml=l+(r-l)/3`跟`mr=r-(r-l)/3`，根據`f(mr)`跟`f(ml)`的回傳值來決定邊界範圍
* 如果`f(mr)`>`f(ml)`，代表`ml`比`mr`更靠近最低點，將右邊界從`r`調到`mr`，反之則將左邊界從`l`調到`ml`，而中止條件是當`l`跟`r`的差距夠小(插多少依題目要求，能過測資就行)停止
![[trenary_search.png]]
* 範例程式(以二次函式為例)
```c++
double function1(double input){
	return input*input;
}
double l=-1e3,r=1e3;
while(r-l>1e-10){
	double ml=l+(r-l)/3, mr=r-(r-l)/3;
	if(function1(ml)<function1(mr))
		r=mr;
	else
		l=ml;
}
return l;
```
* 複雜度(根據master theorem):$$T(n)=T(\frac{2n}{3})+O(1)), O(n)=\log(n)$$
# Reference
[Binary search](https://guide.ntucpc.org/BasicAlgorithm/searching/)
[Ternary search](https://hackmd.io/@ShanC/ternary-search)