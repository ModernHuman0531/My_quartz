---
created: 2025-08-03T14:22
updated: 2025-09-22T14:36
title:
---
2025-09-22 12:36

Status:

Tags:

# Enumerate
## 雙指針
### Q:子序列合
```
給定一個長度為N的序列a以及一個目標數字t，請找出最短的子序列使其總和大於等於t
，並輸出他的長度。
正式一點來說，對於所有滿足al+...+ar>=t的(l.r) ，你需要找到r-l+1的最小值並回傳，如果這樣的子序列不存在，請回傳0。
```
* 最簡單的想法: 用迴圈枚舉所有的`l`跟`r`，然後確認`(al+..+ar)>=t`，如果有再跟之前找到的長度與`r-l+1`比，選小的，這個方法的複雜度為`O(n)=n^3`
* 但其實不用一直loop相加得到總和，可以先固定`l`，發現`S(l,r)+a(r+1)=S(l,r+1)`，得到以`l`為起點的所有區間合只要花`O(n)`，對於所有`l`的複雜度為`O(n^2)`
* **進階想法(雙指標)**:假設我們恰好找第一組`(l,r)`恰好`al+...+ar>=t`，對於所有的`R>r`來說，找不到比`(l,r)`更好的解，因為`R-l+1`必然比`r-l+1`大，因此只要找到`r`就可以停止了，接下來將`l`往右移一格變`l+1`，而右界線從r開始找就好了，因為當`(a(l+1)+...+a(r-1))>=t`時，`(a(l)+...+a(r-1))>=t`一定發生，但後面不成立所以前面也不成立，因此從`r`開始找
	* 這種想法就像我們有兩個指標，左指標跟右指標，先固定左指標，找到第一個右指標後紀錄下長度，將左指標往右移一格，接著在從之前的右指標繼續尋找
	* 實做:
	```c++
	int main(){
		int n; //Length
		int t; //Target number
		int arr[1000000];
		// Input number into array
		for(int i=0;i<n;++i){
			int num;
			cin>>num;
			arr[i]=num;
		}
		int l=0,r=0;
		int sum=0;
		int ret=INT_MAX;
		for(;l<n;l++){
			while(sum<t&&r<n){
				sum+=arr[r];
				r++;
			}
			if(sum>=t){
				ret=min(ret,(l-r));
			}
			// change sum with l shift to right
			sum-=arr[l];
		}
		cout<<(ret==INT_MAX?0;ret)<<"\n";
		return 0;
	}
	```
### 兩個數字合問題
```
Two Sum -sorted
給定一個長度為N的序列a以及目標t，請找出所有的ai,aj(i不等於j)使得ai+aj=t
```
* 我們用上個問題所使用的方法先找的第一組`(l,r)`使得`al+ar>=t`，確認是否`al+ar=t`，如果比較大則往右走，但我們很會發現這樣會出問題，因為$$
\left\{
    \begin{matrix}
        a_{l+1}\geq a_{l}\\
        a_{{r+1}}\geq a_{r} \\
        a_{l}+a_{r}\geq t
    \end{matrix}
\right.
$$因此$$a_{l+1}+a_{r+1}>t$$必然發生，所以其實右邊界其實不應該往右迭代而是應該往左迭代，我們應該一開始應該設定右邊界為極右點，找到`al+ar>=t`的最左點，確認`al+at=t`是否成立，若大於，則將`l=l+1`，在從`r`繼續往左找
* 實做:
```c++
int main(){
	int n;
	int t;
	int arr[30001];
	for(int i=1;i<=n;++i){
		int num;
		cin>>num;
		arr[i]=num;
	}
	int l=1,r=n;
	int sum=arr[l]+arr[r];
	for(;l<r;l++){
		while(sum>t&&r>l){
			sum-=arr[r];
			r-=1;
			sum+=arr[r];
		}
		if(sum==t){
			cout<<l<<" "<<r<<"\n";
			return 0;
		}
		sum-=arr[l];
		sum+=arr[l+1];
	}
	return 0;
}
```
# Reference