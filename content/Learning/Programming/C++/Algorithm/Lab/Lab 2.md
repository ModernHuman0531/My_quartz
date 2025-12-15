---
created: 2025-08-03T14:22
updated: 2025-11-08T00:27
title:
---
2025-10-12 14:38

Status:

Tags:[[Special tricks]]
目錄:
# Lab2
## pA
* show value Fn in the following recursive formula
$$F_{i}=aF_{i-1}+bF_{i-2}+c$$
### 想法：開一個vector存第i個fib number如果有的話就不用算了，然後在帶入遞迴fib function並回傳long long
## pB
* Input a,b,p, in range of 1 to 10^9
* find 

$$
a^b \bmod p =
\begin{cases}
(a^{b/2})^2, & \text{if $b$ is even} \\
a \cdot a^{b-1}, & \text{if $b$ is odd}
\end{cases}
\quad \text{(fast exponentiation property)}
$$
* dp版本的
```c++
#include<bits/stdc++.h>
using namespace std;

long long dp[20]={0};
bool visited[20]={0};
int n,a,b,c;

long long fib(int n){
	if(n<1) return 0;
	if(visited[n]) return dp[n];
	visited[n]=1;
	return dp[n]=a*fib(n-1)+b*fib(n-2)+c;
}

int main(){
	long long f1,f2;
	cin>>n>>a>>b>>c>>f1>>f2;
	dp[1]=f1,dp[2]=f2;
	visited[1]=1,visited[2]=1;
	long long ans;
	ans=fib(n);
	cout<<ans<<"\n";
	return 0;
}

```
### 想法
* 原本想說跟先算完`a^b`再取mod，但當`a^b`或`p`太大時，中間結果會爆炸(超過long long 的邊界 10的18次方)，因此要善用模性質
* 乘法模性質(乘法取模＝先各自取模相乘後再取模)：
$$(a*b)mod(p)=(amod(p)*bmod(p))mod(p)$$
* 在遞迴式如何應用這個性質：做一步，mod一次
```
分解2^10 mod 7
=((2^5)^2)mod7
=((2^5)mod7*(2^5)mod7)mod7

2^5mod7
=(2^4*2)mod7
=((2^4)mod7*2^1mod7)mod7

2^4mod7
=((2^2)*(2^2))mod7
=((2^2)mod7*(2^2)mod7)mod7

2^2mod7
=(2^1mod7*2^1mod7)mod7
```
* 快速冪利用mod乘法性質實做(還是要開long long因為可能在過程中就算邊取餘編算還是可能爆int)
```c++
long long my_exp(long long a,long long b,long long p){
	if(b==0) return 1;//1 mod p一定等於1
	if(b==1) return a%p; //a^1modp=a%p
	long long modP_n=(b%2?my_exp(a,b-1,p)*my_exp(a,1,p):my_exp(a,b/2,p)*my_exp(a,b/2,p))%7;
	return modP_n;
}
```
## pC
* 經典的8皇后問題，要用divide and conquer解決，最大的不同是檢查有沒有衝突函數的不同
* 位置存取方法:我用一個`vector<int>`來存取(row,column)，index代表row，而`vector[int]`代表在該row要放column在哪個位置
* 八皇后代表每一個row都要放，如果有一行沒辦法放代表這個組合是不可行的。
* 從row0開始放，對所有可能的column進行迴圈選擇，將(row,column)丟進檢查函數檢查，如果出來的都沒有衝突到之前放的皇后則將column推進對應的index，然後繼續遞迴下一個row+1，然後把column拿出來換下一個column，終止條件是當row=8時，代表有找到一組解了
* solve函數是以row跟current_weight，來追蹤現在的row跟現在的weight是多少
```c++
void solve(int row,int current_weight){
	if(row==8){ //Find one set solution
		if(max_num<current_weight)
			max_num=current_weight;
		return;
	}
	for(int col=0;col<=7;++col){
		if(check(row,col)){
			vec.push_back(col);
			solve(row+1,current_weight+weights[row][col]); //有將皇后放到到(row,col)，才要將currnet_weight加上weights[row][col]
			vec.pop_back();//把對應row的col拿出來換其他可能性
		}
	
}
```

### 方法一
檢查函數check(row,col)，是用來檢查與之前的皇后位子是否有衝突，第一個方法是傳進去row跟col然後檢查之前column，主對角線跟副對角線
從第一個row開始放，照著順序放，所以在每個row開始放之前，都要確認以以放過的row跟column每有重複，要看的是column，主對角線，副對角線。
* column：從vector裡pop出來的值為之前的column，現在要放進去的column不能和之前重複
* 主對角線：主對角線的性質是**row-column的值會相同**，prev_row-prev_column=row-column的話代表現在要放的點會跟之前放過的主對角線相互攻擊到
* 副對角線：副對角線的性質是**row+column**的值會相同，當prev_row+prev_column=row+column發生時，代表現在要放的點會跟之前放的副對角線互相攻擊到

### 方法二(方便之後優化)
多三個array 來分別紀錄column,主對角線跟副對角線

## pD
* 前綴和?
* 有一個陣列大小為n，裡面每個index內容都有一個數值(long long)，會有兩個operation，1 代表是將位子p的值換成x，2會給定一個範圍`[l.r]`，計算這個範圍數值的XOR
### 想法
subtack 1:最簡單的照著他實做，沒用什麼特殊技巧，但我猜可能會報TLE
問AI後，會用到的技巧有:
1. 前綴和
[[Advanced Data structure]]2. 線段數
所以我要先學習XOR的運算->前綴和->線段樹
* A^B 就代表A跟B的XOR了
```
XOR 運算：
0 XOR 0         0
0 XOR 1         1
1 XOR 0         1
1 XOR 1         0
```
* 方法一如我所料爆TLE了，只過subtask 1
subtasl2:加入前綴和
* 對於區間`[l,r]`的XOR做前綴和，原本要算的是
$$XOR[l,r]=a_{l}⊕a_{l+1}\dots⊕a_{r}$$
我們先計算`[a1,a2,...,an]`的前綴和
$$S_{i}=a_{1}⊕a_{2}*\dots⊕a_{i}$$
因此要計算區間`[l,r]`的XOR為
$$XOR[l,r]=S_{r}⊕S_{l-1}$$
上式會成立是利用XOR的性質
$$
\begin{aligned}
A \oplus B \oplus B &= A \oplus 0 = A \\
S_r \oplus S_{l-1} &= (S_1 \oplus S_2 \oplus \dots \oplus S_r) \oplus (S_1 \oplus \dots \oplus S_{l-1}) \\
&= (S_r \oplus S_{r-1} \oplus \dots \oplus S_1) \oplus (S_1 \oplus \dots \oplus S_{l-1}) \\
&= S_r \oplus \dots \oplus S_l \\
&= S_l \oplus \dots \oplus S_r
\end{aligned}
$$

如此一來我們就用前綴和成功優化了區間XOR了！！！
```c++
#include <bits/stdc++.h>
using namespace std;
int n;
vector<long long> vec;
vector<long long> prefix_sum;
void prefix_cal(int n);
void Update(int p,int x);
void Query(int l,int r);
void operation(int i,int j,int k){
    // i is operation,j and k are the input of Update/Query
    if(i==1) return Update(j,k);
    if(i==2) return Query(j,k);

}
void Update(int p,int x){
    vec[p]=x;
    prefix_cal(n);
    return;
}
void Query(int l,int r){
    long long ans=prefix_sum[r]^prefix_sum[l-1];
    cout<<ans<<"\n";
}
void prefix_cal(int n){
    prefix_sum.clear();
    prefix_sum.push_back(0); // prefix_sum[0] = 0
    long long sum=0;
    for(int i=1;i<=n;++i){
        sum=sum^vec[i];
        prefix_sum.push_back(sum);
    }
}
int main(){
    int q;
    cin>>n;
    vec.push_back(0);// Let the position start from 1
    // Input handle
    for(int i=0;i<n;++i){
        long long input;
        cin>>input;
        vec.push_back(input);
    }
    // 初始計算 prefix sum
    prefix_cal(n);
    
    cin>>q;
    for(int i=0;i<q;++i){
        int op,j,k;
        cin>>op>>j>>k;
        operation(op,j,k);
    }
    return 0;
}
```
subtask 3：加入線段樹
* 為何要加入線段樹:前綴和固然在計算區間XOR非常好用，但因為有另外一個operation Update，會改變array裡面的值，這樣一來整個前綴和就要重算一次
實做細節
* 存節點的資訊的vector在push第一個值之前要記得resize(4*n+1)，因為線段樹存值通常要4*n。
## pE(偏序問題)
* 題目簡介：
	在空間中的點是由x,y,z座標構成的，首先會輸入一個N代表空間中會有幾個點，接著會有N行，每一行輸入(xi,yi,zi)，(xi,yi,zi)要跟空間中的其他點比，看有多少點是在他的右上方，也就是
	$$x_{i}<x_{j}和y_{i}<y_{j}和z_{i}<z_{j}$$
	且x,y,z的輸入範圍為
	$$1\leq x_{i},y_{i},z_{i}\leq N$$
* subtask1:暴力解，建一個class包含三個點，在建一個vector儲存這些點，共N個，輸入完後，用雙重迴圈跑第i個點去算有多少點是在他的右上方
缺點就是會爆TLE，而且沒用到subtask1的性質
$$x_{i}=y_{i}=z_{i}$$
仔細觀察subtask條件:
1. subtask1:xi=yi=zi(一維偏序)
2. subtask2:yi=zi(二維偏序)
3. subtask3:沒有限制(三維偏序)
所以我們用排序來降低subtask1 的複雜度，因為在排序後可以快速知道有多少點比現在大。
但因為排序會打亂原本的點的順序，因此原本點裡面的內容要多加一個idx。

* 在一維時因為xi=yi=zi,等於一個點只要看xi就知道跟其他點的相對大小，假設用xi從大到小進行排序則，在他前面有多少個點就代表有多少點比他大
* 但那是再沒有考慮有點x座標一樣的前提，因為**相同不算偏序**，那該如何解決這個問題呢？
* 用雙指標去追蹤相同數值！！！
```
輸入（假設都是一維）：
索引:  0  1  2  3  4  5  6  7  8  9
值:   [7, 8, 6, 3, 8, 8, 7, 5, 1, 7]


**步驟 1：配對**

[(7,0), (8,1), (6,2), (3,3), (8,4), (8,5), (7,6), (5,7), (1,8), (7,9)]


**步驟 2：排序（按值遞減）Array sorted**

位置 i:  0      1      2      3      4      5      6      7      8      9
       (8,1)  (8,4)  (8,5)  (7,0)  (7,6)  (7,9)  (6,2)  (5,7)  (3,3)  (1,8)
值:  8      8      8      7      7      7      6      5      3      1

用雙指針去找到相同的數值
從i=0開始找
i=0;
while(i<n)
	// 找出與sorted[i]值相同的數量
	j=i;
	while(a[i]==a[j])
		j++;
	// 在[i,j)這個區間的數值都相同，將他們提取idx塞進ans array 裡
	for(int k=i;k<j;++k)
		ans[sorted[i].idx]=i;
	i=j;//將i移到下一個不同數值位置
	
```
結果就是ans 陣列的輸出
**先理解為何一維偏序要用排列，跟其實做，對理解2 3維偏序有幫助**
* subtask2:二維偏序問題有兩種建議方法1. CDQ 分治 2. 排序＋線段樹/BIT，先學比較簡單的方法二，再看CDQ分冶
* 方法1.排序+BIT
1. 先對x進行排序(先不討論x相同的情況)，將x從大到小進行排序後，對你要查看的那個點，只要看你前面有幾個點你就知道有多少點的x比你大。
2. 對y座標則以BIT來維護，傳統的BIT是有兩個operation 1.)是將位置p的數值加x 2.)是查詢`[1,i]`的區間和，但在這個case我們是要將y座標視為位置，一開始的陣列都是0，當y出現後我們要將y位置裡的數值+1代表y出現的次數，維護完BIT後查尋`[1,y]`有多少個，代表有多少點=<y，再將已經查詢過得點倒扣得到有多少點>y，並存進ans裡 **(注意:先查詢再插入，避免算到自己跟造成處理x相同時的困擾)**
3. 依照2.描述，來討論x相同的case如何影響sort跟如何解決x相同的case，假設有兩個點A(8.3),B(8.7)，如果B在A前面，在討論A的y時，維護線段樹會將B點視為A的偏序，但A跟B的x相同所以顯然不是偏序，所以在排序時要
	1. 將x從大到小排
	2. 將y從小到大排
4.  x相同時當然也可以一個個處理，但最好還是分批處理，用 **雙指標找到x相同的情況**，先將全部查訊後放進ans，再將他們的數值全部一次插入
* 二維偏序實做(sort+BIT)
```c++
#include<bits/stdc++.h>
using namespace std;
int N;

class spaceNode{
    public:
        int x,y,z;
        int idx;
        spaceNode(int x_,int y_,int z_,int idx_):x{x_},y{y_},z{z_},idx(idx_){}
};

vector<spaceNode> vec;
vector<int> ans;
vector<int> BIT;
bool cmp(spaceNode x1,spaceNode x2){
    if(x1.x!=x2.x)
        return x1.x>x2.x;
    return x1.y<x2.y;
}
// lowbit,update,query and insert are the implement of BIT in 2d case.
int lowbit(int num){
    return (num)&(-num);
}
void update(int pos,int value){
    for(;pos<=N;pos+=lowbit(pos)){
        BIT[pos]+=value;
    }
    return;
}
int query(int pos){
    int ans=0;
    for(;pos>0;pos-=lowbit(pos)){
        ans+=BIT[pos];
    }
    return ans;
}
void insert(int value){
    update(value,1);
}
int count_greater(int pos){
    // The point has been insert
    int total=query(N); //Total number of point have been inserted
    int lq=query(pos);
    int greater=total-lq;
    return greater;
}
int main(){
    ios::sync_with_stdio(false),cin.tie(nullptr);
    // Input
    cin>>N;
    for(int i=1;i<=N;++i){
        int x,y,z;
        cin>>x>>y>>z;
        vec.push_back(spaceNode(x,y,z,i));
    }
    sort(vec.begin(),vec.end(),cmp);
    // Use double pointer to handle the same x
    ans.resize(N+1,0);
    BIT.resize(N+1,0);
    int j=0;
    while(j<N){
        int k=j;
        // Find the range where x is equal in [j,k)
        while(k<N && vec[j].x==vec[k].x){
            ++k;
        }
        // Handle range j to k-1 first
        for(int l=j;l<k;++l){
            int greater_num=count_greater(vec[l].y);
            ans[vec[l].idx]=greater_num;
        }
        // Insert y's number as position into BIT
        for(int l=j;l<k;++l){
            insert(vec[l].y);
        }
        j=k;
    }
    
    for(int i=1;i<=N;++i){
       cout<<ans[i]<<"\n";
    }
    return 0;
}
```
# Reference
[經典八皇后問題實做](https://blog.csdn.net/qq_64934572/article/details/129372328)
[前綴和教學](https://guide.ntucpc.org/BasicAlgorithm/partial_sum/)
[線段樹教學](https://cp.wiwiho.me/segment-tree/)
[偏序問題教學](https://blog.csdn.net/EQUINOX1/article/details/136305243)
