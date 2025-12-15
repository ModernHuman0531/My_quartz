---
created: 2025-08-03T14:22
updated: 2025-11-27T14:52
title:
---
2025-11-25 13:42

Status:

Tags:[[Dynamic programming]] [[Greedy]]
目錄:
# Lab 4
## pA 
經典的背包問題(Knapsack Problem)
### Subtask 0,1,2 : ci=1
* ci=1代表每一個物品都只能選一次，這是一個**0/1背包問題**
0-1 背包dp
#### Method 1
* 狀態  : f_i,j，代表只考慮前i個item拿或是不拿，目前背包所佔用空間為j最大value的值。
* 狀態轉移方程 : 假設只考慮前i-1個的最大value已經決定，現在考慮第i個item，不放的話，價值不變容量也不變，與f_i-1,j相等，如果放的話，代表目前的容量足夠放a_i，價值則是f_i-1,j-a_i+b_i，我們要在放與不放間選擇最大的價值，即**f_i,j=max(f_i-1,j , f_i-1,j-a_i + b_i)**
* 用二維陣列來實做
```c++
#include<bits/stdc++.h>
using namespace std;
const int MAXN=1e4;
const int MAXW=100;
const long long INF=MAXN*1000000000ll;

long long dp[MAXN][MAXW];
int ai[MAXN],bi[MAXN],ci[MAXN];
int main(){
    ios::sync_with_stdio(false),cin.tie(nullptr);
    int n,w;
    cin>>n>>w;
    for(int i=1;i<=n;++i){
        cin>>ai[i]>>bi[i]>>ci[i];
    }
    // Initialization, dp[0][0] means put nothing in it, the current used space is 0
    dp[0][0]=0;
    // 0 item can't have i size
    for(int i=1;i<=w;++i){
        dp[0][i]=-INF;
    }
    for(int i=1;i<=n;++i){
        // If current space can't put item i, then don't put it, the state stay the same
        for(int j=0;j<ai[i];++j){
            dp[i][j]=dp[i-1][j];
        }
        // If current space can put item i, we choose the maximum value of put or not put
        for(int j=ai[i];j<=w;++j){
            dp[i][j]=max(dp[i-1][j],dp[i-1][j-ai[i]]+bi[i]);
        }
    }
    // Choose the maximum value consider the first n element
    cout<<*max_element(dp[n],dp[n]+w+1)<<"\n";
    return 0;
}
```
#### Method 2
* 但可以用[[滾動dp]]來優化轉移式，因為我們用迴圈實做時通常是按照`dp[1][j],dp[2][j],...,dp[n][j]`下來實做的，當我們做完第i排時，第i-1排就沒有用了，因此可以簡化成`dp[2][MAXW]`，用now變數來追蹤現在在做哪行，做完now那行後，將now上下交換
```c++
#include<bits/stdc++.h>
using namespace std;
const int MAXN=1e4;
const int MAXW=100;
const long long INF=MAXN*1000000000ll;

long long dp[2][MAXW];
int ai[MAXN],bi[MAXN],ci[MAXN];
int main(){
    ios::sync_with_stdio(false),cin.tie(nullptr);
    int n,w;
    cin>>n>>w;
    for(int i=1;i<=n;++i){
        cin>>ai[i]>>bi[i]>>ci[i];
    }
    // Initialization, dp[0][0] means put nothing in it, the current used space is 0
    dp[0][0]=0;
    // 0 item can't have i size
    for(int i=1;i<=w;++i){
        dp[0][i]=-INF;
    }
    int now=1;
    for(int i=1;i<=n;++i){
        // If current space can't put item i, then don't put it, the state stay the same
        for(int j=0;j<ai[i];++j){
            dp[now][j]=dp[!now][j];
        }
        // If current space can put item i, we choose the maximum value of put or not put
        for(int j=ai[i];j<=w;++j){
            dp[now][j]=max(dp[!now][j],dp[!now][j-ai[i]]+bi[i]);
        }
        now^=1;
    }
    // Choose the maximum value consider the first n element
    cout<<*max_element(dp[!now],dp[!now]+w+1)<<"\n";
    return 0;
}
```

#### Method 3
* dp array 還可以更加簡化成一維陣列，仔細觀察dp轉移式實做
$$
\begin{cases}
dp[i][j]&=dp[i-1][j],\text{if j<a[i]}  \\
dp[i][j]&=\max(dp[i-1][j],dp[i-1][j-a[i]]+b[i]),else
\end{cases}
$$
當`j>=a[i]`時才要更新，其他的只要複製上一行即可，但要倒過來更新為了避免重複選擇，因為只用一維陣列來紀錄，若先更新`j>=a[i]`，原本應該要看前面一個的i-1個的`j-a[i]`會被第i個更新到
```
舉例來說
w=3, v=5, w_max=6

dp[0]=0,dp[else]=-INF
dp[3]=max(dp[3],dp[0]+5)
dp[5]=max(dp[6],dp[3]+5)
但本輪已經更新過i=3的值了，dp[6]會被算成拿兩次w
```
因此轉移方程可被簡化成
$$
dp[j]=max(dp[j],dp[j-ai[i]]+bi[i])
$$
### Subtask 3 : ci>=1
* 沒有ci=0的case，ci=0代表可以選無限多次(完全背包)，ci>=1代表每個物品可以選有限多次，為多重背包問題(有界背包)
* 多重背包是0/1背包一個變化，差別在於每一個物品有ci個而非一個，我們可以將"每個物品可以選k次"轉為有"k個相同的物品每個選一次"，若決定要選，則考慮過每一種可能，從選1個到選ci個，但仍不能超過容量範圍
* 狀態：f_i,j = 考慮前第i個item，總體積為j所能得到的最大value，但根據[[滾動dp]]我們可以將儲存空間化至一維陣列
* 轉移方程：
$$
dp[j]=\max_{k=0}^{k=c_{i}}(dp[j],dp[j-kai[i]]+kbi[i])
$$
```c++
for(int i=0;i<=n;++i){
	for(int j=w;j>=a[i];--j){
		for(int k=1;k<=ci[i]&&k*ai[i]<=j;++k){
			dp[j]=max(dp[j],dp[j-k*ai[i]]);
		}	
	}
}
```
### Subtask 4 : ci has no constraints
* ci沒有限制，代表物品可以選1次，有限多次或無限多次，屬於混和背包問題
* 看每一個item的ci值來決定要使用0/1背包，完全背包或是無限背包的轉移方程
* 無限背包轉移方程：
代表item i拿的數量沒有限制，可以從前面開始更新
```
舉例來說
w=3, v=5, w_max=6

dp[0]=0,dp[else]=-INF
dp[3]=max(dp[3],dp[0]+5)
dp[6]=max(dp[6],dp[3]+5)
dp[9]=max(dp[9],dp[6]+5)
本輪已經更新過i=3的值了，dp[6]會被算成拿兩次,dp[9]會被算拿三次
```
混和背包問題：根據不同的ci來決定轉移方程的種類，多重背包可被視為0/1背包的沿身，因此可以合併處理，而無限背包則是從前面開始更新，自成一派
混和背包的轉移方程
$$
\begin{cases}
dp[j]&=\max_{k=0}^{k=c_{i}}(dp[j],dp[j-k*ai[i]]+k*bi[i]),\text{j<=w -> j>=ai[i]} \\
dp[j]&=\max(dp[j],dp[j-ai[i]]+bi[i]),\text{j>=ai[i] -> j<=bi[i]}
\end{cases}
$$

還可以更加優化執行速度，使用二進制優化
## pB
Huffman code 是greedy演算法的經典題目
![[Huffman_code.png]]
我們的目標就是
$$
\min\left( \sum_{i=1}^{n} f_{i}*l_{i} \right),\text{where $f_{i}$ is frequency of symbol i and $l_{i}$ is the depth in huffman's tree }
$$
Greedy 的想法：
* 頻率越高，深度越淺(更靠近樹根)
* 頻率越低，深度越深(越遠離樹根)
這種想法才能使目標最小化。
Greedy 實做：
* 開一個pq，從頻率小排大頻率大。
* 將頻率最小的兩個symbol做結合成一個node，再將這個node放進pq裡重複步驟直到pq只剩一個數字
* pq 要記得開long long因為雖然f的範圍是在1<=f<=10^9，是屬於int的範圍內，但因為pq裡也會存合併的頻率，這樣一來就可會爆int，因此才要開long long
為何要將頻率相加後要再放進pq裡呢？
因為相加後的parent node包含了兩個小節點的頻率，每被提出來一次代表樹的深度距離該節點又多加了一層，因此用相加代替乘深度。

## pC
經典的stone merging problem (屬於matrix multiplication的一種變化)，是一個經典的[[區間dp]]問題。
題意：總共有n個石頭，要將全部石頭堆成一個石堆，每次只能將相鄰的兩個石頭堆成一堆，每次花的時間等於兩個重量相加，請問將全部石頭堆成一堆花的時間最少。

一開始我是想用greedy，算出每兩個相鄰石頭得和存成一個陣列，出和最小的進行合併，依此類推直到最後剩一個大石堆，但greedy 在這個問題找不到最佳解，原因是當選擇最小的和合併兩個時左邊跟右邊的和會改變，局部最小不代表全局最小
舉例：
```
[3,1,4,1]
=>兩兩和為[4,5,5]，最小的和是4，因此合併3,1
[4,4,1]
=>兩兩和為[8,5]，最小是5，因此合併4,1
=>[4,5]
9
加總：4＋5＋9＝18(用greedy 算出的解答)
但用dp算出的解答最小值是13，差了40％
```

利用[[區間dp]]來求解這題，把問題分為兩個區間，在兩個區間分別找到最優解再便利分割點找出合併最優解，此為區間dp的精神。
dp狀態f_i,j：代表在區間`[i,j]`的最佳解
狀態方程式：
$$
dp[i][j]=min\left( dp[i][k]+dp[k+1][j]+\sum_{m=i}^{m=j}a[m] \right),\text{k in [i,j]}
$$
為何狀態方程式是上式？
```
1. dp[i][i] 自己跟自己不能合併，因此dp[i][i]=0
2. 舉例：
   [3,4,5]
   (1,2,3):位置
   dp[1][2]=dp[1][1]+dp[2][2]+(1,2)=0+0+7=7
   dp[2][3]=dp[2][2]+dp[3][3]+(2,3)=0+0+9=9
   
   dp[1][3]=min(
		dp[1][2]+dp[3][3]+(1,2,3),
		dp[1][1]+dp[2][3]+(1,2,3)
   )
   =min(19,21)=19
```
實做方法：枚舉所有的長度，從2到n(總共石頭個數)

## pD
證明是greedy：如果在任意交換兩個元素後答案不會變得更好，則greedy就可以確保找到最佳解。

## pE
是weighted interval scheduling problem => 經典的dp題
### Subtask1
wi=1 for 1<=i<=n，所有人出的價錢都一樣，題目從weighted interval scheduling problem 變成單純的interval scheduling problem，盡可能排越多組越好。
* Greedy 的策略是從結束時間最早的開始選，因此要以結束時間升序來排序，每次都選結束時間最早的，但要注意不要選到重複的地方，因此要一直追蹤每次選的地方的完結位置(ri)，下一個選的起始位置(li)要比ri大。(位置重複有兩種可能，這一個ri在上一個區間內，或是這一個li在上一個區間內，但第一個不可發生，因為我們是以結束順序排，能確保上一個結束位置一定比這一個結束位置小，因此只要確保這一個的起始位置比上一個終點位置還要大)
### Subtask2
有加權後就不能使用greedy，我原本是想根據wi/interval做greedy的，但忽略位置的重要性，可能關鍵位置比起較大的wi/interval更有價值。

### Subtask3

# Reference
[各種背包dp說明](https://oi-wiki.org/dp/knapsack/)
[Huffman code greedy參考](https://www.csie.ntu.edu.tw/~yvchen/f111-ada/doc/221013_Greedy-1.pdf)
