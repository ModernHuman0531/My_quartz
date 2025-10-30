---
created: 2025-08-03T14:22
updated: 2025-10-29T20:10
title:
---
2025-10-21 22:10

Status:

Tags:[[Shortest path]]

目錄:
# Graph
基本名詞介紹
* Undirectd graphs(無相圖)
	* V代表頂點(Vertics)的集合
	* E代表邊(edges)的集合
	* 用**G={V,E}** 來代表這張圖，undirected graphs代表連接頂點的邊沒有方向，從A到B或從B到A都行
	* Degree V: 代表頂點V有多少邊連接著，例如degree of vertex 4 is 2。
	* Neighbor V: 代表頂點V有被edges連結著的頂點，例如Neighbor of vertex 4 is vertex 3 and vertex 2
![[undirected_graph.png]]
* Directed graph
	* V代表頂點的集合
	* E代表**有向邊**的集合
	* 用G={V,E}來表示這張圖
	* In-degree of V: 代表有多少邊**進來**頂點V，例如In-degree of vertex 4 is 2
	* Out-degree of V:代表有多少邊從頂點V**出去**，例如Out-degree of vertex 4 is 1
	* In-coming neighbor of V:代表進來V的邊是連結到哪個vertex，例如In-coming neighbor of vertex 4 are vertex 2 and vertex 3
	* Out-coming neighbor of V:代表從頂點V連出去的邊連到哪個vertex，例如Out-coming neighbor of vertex 4 is vertex 3

![[directed_graph.png]]
儲存圖的方法
1. Adjacency Matrix
	* 用一個`V*V`的矩陣來存vertex 和vertex是否有連接，直行代表source，橫行代表destination
	* 對角線有值代表自己與自己形成循環
	* 缺點是當頂點很多但邊很少時會浪費記憶體
	* 找vertex i跟vertex j是否有邊只要查`G[i][j]`是否等於1(O(1))
	* 要看頂點V有多少個neighbor，遍歷第V row，看有多少個1(O(V))
	* 空間複雜度(O(n^2))<-太大了
![[Adjacency_matrix.png]]
2. Adjacency lists
	* 每個點連接的點都由linked-list來連結
	* 要看vertex i跟vertex j是否相連，看第i行的linked-list有沒有vertex j(O(V))
	* 要看頂點V有多少個neighbor，看第V個linked-list，看有多少個vertex(O(V))
	* 空間複雜度只要**O(V)+O(E)** (推薦！！！)
![[Adjacency_list.png]]
## DFS(Depth First Search)
每個vertex要紀錄的資訊(有其他DFS寫法但這種是對之後的應用最適合的想法)
* Status:
	* unvisited
	* In progress
	* Done
* Start time
* Finish time
![[DFS_graph.png]]
### PESUDO code of DFS
```
DFS(W,currentTime)
	W.startTime=currentTime
	currentTime++
	Mark W as in progress
	for V in W.neighbors: // Run through all the neighbor
		if V is unvisited:
			currentTime=DFS(V,currentTime)
			currentTime++
	// After run through all neighbors, mark finish time
	W.finishTime=currentTime
	W.status=Done
	return currentTime
```
* DFS可以找到從起始點開始相連的元件，我們在undirected graph 裡稱做 **connected component**。
* 將DFS走過得edges作為樹支，建立一個樹稱作DFS tree，紅線是在DFS過程裡有用到的edges，而藍虛線則是存在在圖裡，但DFS沒有用到的edges。
![[DFS_tree.png]]
### DFS runtime
* 用Adjacnecy list 來儲存圖。
* 假設C={V,E}是一個**connected component**(DFS的結果)
* 遍歷所有節點在V裡面，我們只會**拜訪每一個節點一次**(拜訪代表對該節點做DFS)
	* DFS裡會做的事:
		* 做一些紀錄(start time, finish time, status...) => O(1)
		* 對節點V能到的點繼續做DFS下去 => O(degree(V))
	* 每個邊最多只會經過一次
因此計算複雜度為

$$
\begin{align}
\sum_{W\in V}(O(\deg(W))+1) &= O(E) + O(V) \\
&= O(E) \quad \text{(since $E$ dominates $V$)}
\end{align}
$$


### DFS's Application
* DFS在有向圖(Directed graph)依然是可以使用。
* 以下是一個例子在有DFS在有向圖的應用
在電腦安裝packages時有些package要先安裝才能安裝令一個package，我們想知道安裝這些package的先後順序。
![[Application_DFS.png]]
* 解決方法:
	1. 對圖做DFS
	2. 依據結束時間做**Decreasing order(從大到小)** 來決定安裝順序的先後

* 為什麼是按照結束時間做**Decreasing order**來決定順序呢？
這用到Directed Graph DFS的一個性質
在有向圖裡，有向邊是從A->B，則結束時間一定是**B.finish<A.finish**
![[DFS_property.png]]
證明此性質透過DFS tree
* 對於無相圖
* 如果v是w的後代:**V.finish<W.finish**
* 如果W是V的後代:**W.finish<V.finish**
* 如果W跟V沒有祖先跟後代的關係，則結束時間先後順序沒有一定
![[Undirected_statement.png]]
開始看有相圖，可以分成兩種情況:
case 1:
B是A的後代，則根據無向圖的性質:**B.finish<A.finish**
case 2:
B跟A沒有關係，那就要看會先到哪個點了，必然事先到B點完再到A點，因為A->B是虛線，代表對A做BFS時B已經被造訪過了，如果先造訪A再造訪B則A->B應該是實線，因此**B.finish<A.finish**
![[Directed_case2.png]]
回到topological sorting問題，結束時間晚的點代表安裝順序應該要在前面！！！
* DFS c++ implement
* 實做細節:
	* 有兩個vector，第一個verctor G是用linked-list來存vertex間的關係，用int來表示而令一個`vector<int>`vertices是存第i個節點的資訊，vertices[i]是代表vertex i的資訊。
```c++
#include<iostream>
#include<vector>
#include<list>
#include<string>
using namespace std;
class Vertex{
	public:
		int startTime,FinishTime;
		string Status;
		Vertex(){
			Status="unvisited";
		}
};
vector<list<int>> G;// Used to store relationships between vertices
vector<Vertex> vertices; //Used to store vertex information
void addEdge(vector<list<int>>& G,int u,int v){
	// For undirected graph
	G[u].push_back(v);
	G[v].push_back(u);
}
void addDirectedEdge(vector<list<int>>& G,int u,int v){
	// For directed graph
	G[u].push_back(v);
}

int DFS(int v,int currentTime){
	vertices[v].startTime=currentTime;
	currentTime++;
	vertices[v].Status="In progress";
	for(int n:G[v]){
		if(vertices[n].Status=="unvisited"){
			currentTime=DFS(n,currentTime);
			currentTime++;
		}
	}
	vertices[v].FinishTime=currentTime;
	vertices[v].Status="Done";
	return currentTime;
}

int main(){
	// Use adjacency list representation for the graph
	int vertex_num;
	cin>>vertex_num;
	G.resize(vertex_num);
	// Start from 0 node
	for(int i=0;i<vertex_num;++i){
		vertices.push_back(Vertex());
	}
	// Build the graph
	addEdge(G,0,1);
	addEdge(G,0,4);
	addEdge(G,1,2);
	addEdge(G,1,3);
	addEdge(G,1,4);
	addEdge(G,2,3);
	addEdge(G,3,4);

	// Use DFS
	DFS(0,0);
	// Print the start and end time of each vertex
	for(int i=0;i<vertex_num;++i){
		cout<<"Vertex "<<i<<"'s starttime="<<vertices[i].startTime<<", finishtime="<<vertices[i].FinishTime<<"\n";
	}
	return 0;
}
```
## BFS(Breadth First Search)
深度優先搜索：先遍歷鄰居而非子孫。
vertex紀錄資訊:
* status
假設起點為W，我們要有n個lists(Li)，i代表從起點W到該vertex需要花幾步，將V存到Li並標示已經走過。
![[BFS_graph.png]]
### PESUDO of BFS
```
L_i=[], for i=0~n-1(n is node number)
L_0=[W] //自己到自己花0步
紀錄W為visited
for i in range 0~i-1:
	for v in Li:
		for u in v's neighbor:
			if u is unvisit:
				Mark it as visited and add it in Li+1
```
### BFS runtime
跟DFS的推論一樣，複雜度為**O(V)+O(E)**。
為何他叫廣度優先探索，因為他會將同樣深度的在BFS tree標示為同樣顏色。
![[BFS_tree.png]]
### Implementation of BFS
#### 1.Shortest path
對於**無權重的圖(unweighted graph)** 來說，要找W到V間的最短路程只要用BFS就行了。
比起單純做BFS遍歷，印出先到哪個點就好，如果要印出從M到V的最短路徑，vertex裡面的element要加上：
* distance:紀錄從W到V的距離
* parent:紀錄vertex V的父節點(是從哪個vertex 到V的)
先做完BFS，再從V藉由parent往回推到W。
```c++
#include<iostream>
#include<vector>
#include<list>
#include<string>
#include<algorithm>
using namespace std;
class Vertex{
	public:
		string Status;
		int parent,distance;
		Vertex(){
			Status="unvisited";
			parent=-1;
			distance=-1;
		}
};
vector<list<int>> G;// Used to store relationships between vertices
vector<Vertex> vertices; //Used to store vertex information
void addEdge(vector<list<int>>& G,int u,int v){
	// For undirected graph
	G[u].push_back(v);
	G[v].push_back(u);
}
void addDirectedEdge(vector<list<int>>& G,int u,int v){
	// For directed graph
	G[u].push_back(v);
}

void BFS(int v,int vertex_num){
	vector<vector<int>> L;
	L.resize(vertex_num);
	// Push start node into L[0]
	L[0].push_back(v);
	vertices[v].Status="visited";
	vertices[v].distance+=1;
	for(int i=0; i < vertex_num-1; ++i){  // 改為 < vertex_num-1
		if(L[i].empty()) break;  // 如果當前層沒有節點，提前結束
		for(int vertex:L[i]){
			for(int q:G[vertex]){
				if(vertices[q].Status=="unvisited"){
					L[i+1].push_back(q);
					vertices[q].Status="visited";
					vertices[q].distance=vertices[vertex].distance+1;
					vertices[q].parent=vertex;
				}
			}
		}
		cout<<"L"<<i<<": ";
		for(int vertex:L[i]){
			cout<<vertex<<" ";
		}
		cout<<"\n";
	}
	cout<<"BFS result: "<<"\n";
	for(int i=0;i<vertices.size();++i){
		cout<<"Vertex "<<i<<": "<<"distance "<<vertices[i].distance<<", parent="<<vertices[i].parent<<"\n";
	}
	return;
}
void shortestPath(int start,int end){
	vector<int> path;
	cout<<"Shortest Path from "<<start<<" to "<<end<<": ";
	for(int v=end;v!=-1;v=vertices[v].parent){
		path.push_back(v);
	}
	reverse(path.begin(),path.end());
	for(int v:path){
		cout<<v<<" ";
	}
	cout<<"\n";
}

int main(){
	// Use adjacency list representation for the graph
	int vertex_num;
	cin>>vertex_num;
	G.resize(vertex_num);
	// Start from 0 node
	for(int i=0;i<vertex_num;++i){
		vertices.push_back(Vertex());
	}
	// Build the graph
	addEdge(G,0,1);
	addEdge(G,0,4);
	addEdge(G,1,2);
	addEdge(G,1,3);
	addEdge(G,1,4);
	addEdge(G,2,3);
	addEdge(G,3,4);

	// Use DFS
	BFS(0,vertex_num);
	shortestPath(0,4);
	return 0;
}
```

#### 2. Bipartite graph(二分圖)
二分圖的定義:對**同一層的BFS tree vertex**(同一層代表從原點到vertex的step數相同)進行著色，紅黑間隔(常用表示法為：未著色：-1，黑色：0，紅色：1)，只要相連的兩個vertex沒有同顏色我們就稱為二分圖。
![[Bipartite_graph.png]]
* 可不可能是因為起始點選的不同，如果選A起始點發現不是二分圖，有沒有可能換起始點就變二分圖了呢？Ans: **不可能**
* 證明:
	* 當我們發現鄰居有被著成同樣的顏色代表他們會在同一層或是同一層+偶數倍，其路徑長為(`2*同一層＋偶數倍＝Even`)，但要相連還要再加一邊兩個頂點相連的edge，代表總共是**odd edges cycle**。
	* 如果你用紅黑顏色相間去圖一個odd edges cycle，你不可能塗成沒有相鄰顏色是沒有重複的情況，因此只要確認一個vertex開始不是bipartite graph，不論換哪個起點都不會改變結果。

![[Bipartite_proof.png]]
* 實做時將vertex的資訊要多加一個color。
* c++實做
```c++
#include<iostream>
#include<vector>
#include<list>
#include<string>
#include<algorithm>
using namespace std;
class Vertex{
	public:
		int color;
		Vertex(){
			color=-1;
		}
};
vector<list<int>> G;// Used to store relationships between vertices
vector<Vertex> vertices; //Used to store vertex information
void addEdge(vector<list<int>>& G,int u,int v){
	// For undirected graph
	G[u].push_back(v);
	G[v].push_back(u);
}
void addDirectedEdge(vector<list<int>>& G,int u,int v){
	// For directed graph
	G[u].push_back(v);
}

void BFS(int v,int vertex_num){
	vector<vector<int>> L;
	L.resize(vertex_num);
	// Push start node into L[0]
	L[0].push_back(v);
	vertices[v].color=0;
	for(int i=0; i < vertex_num-1; ++i){  // 改為 < vertex_num-1
		if(L[i].empty()) break;  // 如果當前層沒有節點，提前結束
		for(int vertex:L[i]){
			for(int q:G[vertex]){
				if(vertices[q].color==-1){
					L[i+1].push_back(q);
					vertices[q].color=((i+1)%2?1:0);
				}
			}
		}
		cout<<"L"<<i<<": ";
		for(int vertex:L[i]){
			cout<<vertex<<" ";
		}
		cout<<"\n";
	}
	return;
}
bool isBipartite(int vertex_num){
	for(int i=0;i<vertex_num;++i){
		for(int q:G[i]){
			if(vertices[i].color==vertices[q].color) return false;
		}
	}
	return true;
}

int main(){
	// Use adjacency list representation for the graph
	int vertex_num;
	cin>>vertex_num;
	G.resize(vertex_num);
	// Start from 0 node
	for(int i=0;i<vertex_num;++i){
		vertices.push_back(Vertex());
	}
	// Build the graph
	addEdge(G,0,1);
	addEdge(G,0,2);
	addEdge(G,1,3);
	addEdge(G,2,4);
	addEdge(G,2,5);
	addEdge(G,3,6);
	addEdge(G,4,6);
	addEdge(G,5,6);

	// Use DFS
	BFS(0,vertex_num);
	if(isBipartite(vertex_num)){
		cout<<"The graph is bipartite.\n";
	}else{
		cout<<"The graph is not bipartite.\n";
	}
	return 0;
}
```

## SCC (Strongly Connected Compenents)
* 定義：
在一個有向圖G={E,V}裡，對於所有在V裡面的頂點a,b都可以找到相互到的了的路徑，也就是說可以找的到a->b也可以找的到b->a的路徑。
![[SCC_example.png]]
觀察下圖，如果我們從d點開始做DFS可以照到一個SCC (D->E->F)然後把這個SCC拿掉後，再從A點開始做DFS就又可以找到一個SCC (A->B->C)那這是否代表我們只要用DFS就可以找到SCC呢？ 答案是否定的，如果我們先從A點開始做DFS就會發現找不到SCC了，因為**C到D有連結(向外指)**，所以我們發現選擇起始做DFS的點似乎很重要！！！
![[DFS_SCC.png]]
### SCC algorithm
1. 先任意選一個起始點對整個圖做DFS，紀錄下每個頂點的起始時間跟**結束時間**。
![[SCC_algo1.png]]
2. 將邊的方向反轉。
![[SCC_algo2.png]]
3. 轉完後再做DFS，但這次從**結束時間最大的頂點** 開始做起，做完後把在同一個SCC的頂點排除後，找結束時間最大的頂點重複以上步驟，直到所有頂點皆被遍歷過。
![[SCC_algo3.png]]
結束完上述步驟後所找到的圖我們稱為SCC graph，可以將每個SCC視為一個超大vertex。
SCC graph的特性：
* 對於每個大型vertex，start time為大型vertex裡所有小vertex的start time的最小值，finish time則是大vertex裡所有vertex finish time的最大值。
* SCC graph 一定是一個DAG(Directed acycle graph) ，因為如果有cycle，他會自動變成一個更大的SCC。
![[SCC_GRAPH.png]]
### Why the alogorithm works?
* 為啥我們要從最大的finish time 的vertex開始找？
首先我們要證明一個引理，就是對一個SCC A 指向一個SCC B時，A.finish>B.finish一定成立。
![[SCC_lemma.png]]
這個以分成兩個case討論，是先進到A還是進到B
* case 1:先進到A再進到B(在第一次DFS裡)
假設從SCC A裡的v點連到SCCＢ裡的w點，我們可以先簡單的知道結束時間先對關係
* A_finish >= v_finish
* B_finish = w_finish
而頂點之間(v->w)結束時間的先後順序我們已經在DFS tree裡證明過並得知了**v_finish>w_finish**，因此可以得到結論**A_finish>B_finish**。
* case 2:先到Ｂ才進到Ａ(在第一次DFS裡)
由於Ｂ沒有可以連結到Ａ的點，因此我們一定是先對Ｂ做完DFS才對Ａ做DFS，因此**A_finish>B_finish**必然成立。

我們可以得到結論，不論是先到Ａ還是先到Ｂ，**A_finish>B.finish**必然發生。
然後我們會把邊的方向反轉過來，此時B->A，**A_finish>B.finish**　，發現被指向的那個人finish time一定比較大，因此我們先做finish time大的DFS就不會有往外指的箭頭找到不是這個SCC的component了！！！
從最大的finish time開始找，代表所有的箭頭都指向他，對他做DFS就只能找到互相連通得元件也就是SCC，之後找到的SCC拿掉，再從最大的finish time開始做DFS，直到找完所有的頂點。
![[SCC_principle.png]]
* C++ 實做(之後補做)
```c++
```
# Reference
[Graph introduction](https://kopu.chat/%E5%AF%A6%E4%BD%9Cgraph%E8%88%87dfs%E3%80%81bfs%E8%B5%B0%E8%A8%AA/)
[list c++](https://shengyu7697.github.io/std-list/)