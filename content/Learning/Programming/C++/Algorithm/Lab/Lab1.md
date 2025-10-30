---
created: 2025-08-03T14:22
updated: 2025-10-30T14:38
title:
---
2025-09-15 22:22

Status:

Tags:[[sorted]] [[Search]],[[Enumerate]]

LAB1 CMS: [https://114algo.cs.nycu.edu.tw/archive/](https://114algo.cs.nycu.edu.tw/archive/)
LAB1 assistant answer: [https://www.notion.so/Lab-Solution-Introduction-to-Algorithm-2778f0b8782c800da165e3bdb0590310?source=copy_link](https://www.notion.so/Lab-Solution-Introduction-to-Algorithm-2778f0b8782c800da165e3bdb0590310?source=copy_link)
# Homework 1
## pA
* 題意簡化: 依成績排序，輸入是第一行分別代表人數(N)跟科目(M)
* 想法:一個新的class 包含ID(int)跟每科成績(`vector<int>`)，會有N個，然後根據最後一行的輸入來決定排序先後，例如最後一行是3 2 1，那我先排第三科 ，排第二科的時候是當第三科成績一樣在排就行了，排第一科的時候是當第二科成績一樣在排就行了，排第id科的時候是當第一科成績一樣在排就行了，用STL 的sorted排，這個解法是可行的嗎
## pB
* 從成績是不嚴格遞增排序，給一個target score 要找出第一個比x大或跟x一樣成績的學生id，一眼看是二分搜
* 但他是不會直接給我那個array，而是要我詢問每個位子(index)對應的成績來判斷現在這個index是`l`還是`r`，而當我目標比所有的陣列裡的數都大時會傳-1
* 解釋為啥binary search能cover到這個case
```
// 隱藏陣列
a[5]={1,3,4,7,10},N=5
target x=20;

l=0,r=N+1=6; //找第一個比x大的數字的index代表要回傳r
mid=(l+r)/2;
//第1次遞迴
mid=(0+6)/2=3;
a[3]=4<20,l=mid=3;
//第2次遞迴
mid=(3+6)/2=4;
a[4]=7<20,l=mid=4;
//第3次遞迴
mid=(4+6)/2=5;
a[5]=10<20,l=mid=5;

l+1=5+1=6=r, stop return r
當r比N大時代表target不存在在這個array裡
```
## pC
* 對任意一個vi的，一個系統有n個安全系統，對一參數x，第i個安全系統的安全係數為$$v_{i}=a_{i}x+b_{i}$$
* 安全係數越靠近0越安全，我們是要選一個x使得下式最小$$max_{1\le i\le n} \lvert a_ix+b\rvert$$
* 想法與涉及觀念:凸函數優化，三分搜
* 拆解問題:
	* 所以其實我們要找的是$$f(x)=max(\mid a_{1}x+b_{1}\mid, \dots ,\mid a_{n}x+b_{n}\mid)$$的最低點，而上式其實是一個凸函數，而我們要找的就是這個凸函數的最低點，因此需要用到三分搜。
	* 證明上式是一個凸函數，首先我們要證明`f(x)=|ax + b|`是凸函數，利用凸函數定義我們可以得到$$\mid a(\lambda x_{1}+(1-\lambda )x_{2}+b) \mid=\mid \lambda(a_{1}x+b_{1}+(1-\lambda)(a_{2}x+b)) \mid\leq \lambda( \mid a_{1}x+b\mid)+(1-\lambda)(\mid a_{2}x+b\mid) $$根據三角不等式因而成立。
	* 再來證明目標函數是凸函數
	```
	g(λx₁ + (1-λ)x₂) = max(f₁(λx₁ + (1-λ)x₂), ..., fₙ(λx₁ + (1-λ)x₂))
                  ≤ max(λf₁(x₁) + (1-λ)f₁(x₂), ..., λfₙ(x₁) + (1-λ)fₙ(x₂))
                  ≤ λ·max(f₁(x₁), ..., fₙ(x₁)) + (1-λ)·max(f₁(x₂), ..., fₙ(x₂))
                  = λg(x₁) + (1-λ)g(x₂)
	```
* 這是一個多重折線，用三分搜來尋找在哪個點$$f(x)=max(\mid a_{1}x+b_{1}\mid, \dots ,\mid a_{n}x+b_{n}\mid)$$的回傳值是最小

* 凸函數定義與性質:
	* **定義**: 對一個凸函數`f(x)`，取任一兩點`x₁, x₂` 和任意 `λ ∈ [0,1]`，必然會符合`f(λx₁ + (1-λ)x₂) ≤ λf(x₁) + (1-λ)f(x₂)`，這個在幾何上的意義是在**函數上任意取兩點的連線都會在函數本身的上面**。
	* 凸函數重要性質
		* local minimum=global minimum
		* 最小值出現在不可微點或邊界(?二次函數最低點不是可微嗎？)
		* 可以用**三分搜找最小值**(不能用二分搜，因為資料不具備單調性)
* 解法: 
## pD
* 題意: 總共有n道菜，每道菜的分數是`wi`，每道有兩種選擇
	* 1. 只上一道菜，味道分數為`wi`
	* 2. 一次有兩道菜，味道分數為(`wi1+wi2`)/2`
* 這樣總共有$$n+C^{n}_{2}=\frac{(n)(n+1)}{2}$$種可能，我們要找的是第k大的味道分數
* 解法1:先將每道菜的分數存進一個vector裡，然後新開一個vector，列出存進所有可能的分數，包含單道菜與combo菜(for loop)，用sort排序好後，直接找第k-1個element=>吃了TLE跟MLE，時間跟儲存空間都爆掉了。
```c++
#include <bits/stdc++.h>
using namespace std;
vector<double> total_score;
bool cmp(double num1, double num2){
    return num1<num2;
}
int main(){
    ios::sync_with_stdio(false),cin.tie(nullptr);
    int n,k;
    cin>>n>>k;
    int p,q;
    double ans;
    vector<double> each_score;
    for(int i=0;i<n;++i){
        int score;
        cin>>score;
        each_score.push_back(score);
        total_score.push_back(score);
    }
    for(int i=0;i<each_score.size()-1;++i){
        for(int j=i+1;j<each_score.size();++j){
            total_score.push_back((each_score[i]+each_score[j])/2.);
        }
    }
    sort(total_score.begin(),total_score.end(),cmp);
    int size=total_score.size();
    ans=total_score[size-k];
    if(ans<0){
        int int_ans=ceil(ans);
        if(int_ans-ans<0.1)
            p=ans,q=1;
        else
            p=ans*2,q=2;
    }
    else{
        int int_ans=ceil(ans);
        if(int_ans-ans<0.1)
            p=ans,q=1;
        else  
            p=ans*2,q=2;
    }
    cout<<p<<"\n"<<q<<"\n";
    return 0;
}
```
* 解法二:
	* 兩個餐點的平均值，就是要枚舉所有的`(wi,wj)`，所要花O(n^2)，但如果用雙指標只須花O(n)的時間
	* 用二分搜找出一個`wi`使得有k個餐點組合分數比他大，但因為`wi`不一定存在在現有組合之中，所以要掃描整個組合找出小於他的組合裡最大的(感覺很笨ㄟ，就不想用loop枚舉但最後找答案還是要用，感覺怪怪的)。
	* 為了避免double發生不准的情形，全部 `*2` 來進行二分搜.
	* 要注意輸入範圍，有些變數可能超過int的邊界(`2*10^9`)可能會吃TLE
* 最終解法: 
	* 輸入範圍注意，k跟w都可會爆int，因此跟這兩個有關的都要開long long int。
	* 找出第k大的得分=>一眼二分搜
	* 二分搜實做細節
		* 實做的是當一個數字num傳進一個函數count裡，count函數會計算所有大於等於num的數字，並回傳那個數量，第k大的數字代表要找第一個數字剛好會讓count(num)>=k，也就是說count(mid)<k時代表mid太大，讓r=mid，當count(mid)>=k時l=mid，因為l包含在解答裡，因此這是一個**左閉右開的二分搜**，l要取排序過的`array[0]*2`，但r不能取最後一個元素，因為不能保證在範圍外，因此r要取`arr[n-1]*2+2`，`*2`是不想要有double的比較，且不會影響到大小順序
	* count函數實做
		* count要比單點跟combo裡有多少比num大，並輸出數量
		* 單點: 簡單用for loop計算
		* combo: 原本是用窮舉出所有可能性在比較，但時間複雜度會爆掉，因此用雙指標，l=0,r=n-1,r_start=r,
	![[HW1_pD.png]]
## pE

## pF

# Reference
[凸函數解釋與定義](https://claude.ai/chat/297ea2c0-df2d-48e7-b2ef-6bf81352bb5e)