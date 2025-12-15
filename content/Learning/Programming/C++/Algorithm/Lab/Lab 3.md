---
created: 2025-08-03T14:22
updated: 2025-11-06T20:08
title:
---
2025-11-01 15:20

Status:

Tags:
目錄:
# Lab 3
pA
樹直徑問題，在網路上找通常是用兩次DFS解決。
算法思想
1. 從任一一點出發，找到他最遠的點Q藉由DFS
2. 再從Q做DFS找到最遠的點W
3. 直徑即為WQ
實做細節
 * 在vertex裡要存的內容有status，dist
 * 因為要做兩次DFS做完第一次後找到最遠的vertex後，要再做第二次前要將status跟dist恢復原狀
 * `vector<list<int>>`是用紀錄邊和邊之間的關係
 * `class vertex`是用來紀錄每個vertex需要包含的資訊，再用`vector<vertex>`來紀錄全部vertex
 * input range: vertex是從1<=u<=N
pB
迷宮問題，在不碰到障礙物的前提下到達終點的最短路徑。
無權圖的最短路徑問題，用BFS
地圖是一個`N*M` 的地圖，所以用`N*M`矩陣來存地圖資訊。
用一個`m*n`矩陣來存到(m,n)的距離，一開始先把所有點初始化成-1代表還沒到過，如果沒到過或沒超過邊界，就把他放進queue裡。

## pC
題意：有一個有權無向圖G={n,m}，我們想要從vertex 1到vertex n的最短路徑(花的時間最少的路徑)，每條邊有四個參數
* ui: 起始vertex
* vi: 結束vertex
* wi: 該條邊的權重，有就是走完該條路需要花多少時間
* ti: 總時間為T，當**Tmodk=ti**時該條路不能走，如果在走進去前發現ti，在T～T＋wi-1的區間裡代表該路也不能走，只能等待，當ti=-1時代表該路並沒有需要維護
所求為vertex1到vertex n的最短路徑，如果走不到則回傳-1。

想法：有權邊但無負權環的最短路徑，用Dijkstra algorithm，但要如何解決時間問題？
儲存的容器：
* S:用來存已經找到的最短路徑的點，要注意vertex在不同的time mod k時間點可以走得道路不同，所以在紀錄的時候也要將time mod k存進去，是用`set<pair<int vertex,int Time_mod_k>>`
* Q:因為要在為找到最短路徑的點中找到最短距離的點提出來，因此要用priority queue，所以要存的是`priority_queue<pair<long long distance,pair<int vertex,int Time_mod_k>>>`，priority_queue原本是從大到小，我們要用從小到大，pq會讓同樣點但狀態不一樣的依據離短到長排序，會先提出最短的距離
* dist:用來儲存(vertex,Time_mod_p)對應到的最短距離，用`map<pair<int vertex,int Time_mod_k>,distance>`
用dijkstra algorithm + query 去詢問現在至時間點通過道路會不會遇到維護來實做這題目
用兩函數來去詢問
* find_next_maintaince(start_time,t_i,k):查詢在`[start_time,start_time+w-1]`中是否會碰到x％k=t_i，當`x%k<=t_i`代表在這個週期理裡會遇到，`x%k>t_i`代表要在下一個週期才會遇到
* find_earliest_departure(current_time,w,t_i,k)用來尋找如果當前時間不能出發，要等到什麼時候
但這個方法太慢了！！！

* 更好的解法
核心仍然是Dijkstra algoritjm+詢問區間，但我們可以優化這兩個部份。
1. 詢問區間：一開使得方法是不斷的增加出發時間來找到一個出發時間不會與維護路段時間重複到，但其實我們要找的是其實是:
假設出發時間為t，我們在這個路段的區間是`[t,t+wi-1]`，我們要的是在這個區間的任意一個x，都不會讓x%k=ti，因此我們要找x的範圍可能會使x%k=ti，然後將這些排除在外。
* start_t:t+wi-1 mod k恰好碰到ti，因此start=(ti-wi+1+k)%k，+k不會影響模數，但能保證裡面的值是正的。
* finish_t:t=ti,finish_t=ti。
只要t(現在的時間)不在`[start_t,finish_t]`這個區間裡就代表現在的時間是可以的，不會遇到維護。
若在這個區間裡，則分兩個情況
* start_t<=finish_t：看t有沒有符合start_t<=t<=finish_t
* strat_t>finish_t:看t有沒有符合start_t < t||finish > t
若是有符合則要回傳從現在開始要等多長時間才能走，下一次可出發的時間是t=(ti+1)%k，假設現在的時間為mod，則總共要等的時間是t=(ti+1-mod)%k，+k是為了讓裡面的值為正，不影響實際值。
2. Dijkstra演算法的實做，在講義裡的dijkstra裡，有三個容器S,Q,dist，但在實做時我們只須要用兩個，Q跟dist，不用S的原因是我們會將可能最好的值更新後放進Q裡，然後更新dist，code裡會有一行if(old_value<new_value) continue，是用來驗證如果有達到這個點但非最短距離，就不用更新(若是最短距離則不用處理他)，
 然後跟講義的dijkstra一樣將除了出發點以外的距離設成無限大，因為距離很明顯會大於int的範圍，開long long 給他，而long long 最大數字為`LLONG_MAX`，用動態陣列(vector)快速resize 跟初始化他們。
 * 確認pq裡pop出的是否為n，如果是n代表`dist[n]`以被更新過，必然是最短距離。
 **第一次更新dist[n]不代表最短，但從pq裡pop出來必然代表最短**因為pq從的是每個點已知距離的最短距離，所以每次pop出v時代表dist[v]為最小值
## pD
題意：一個有向圖，每個頂點都有一個a_i，第一次走過定點會的到a_i，可重複走相同的頂點但不會重複得分，想問最大得分會是多少分。
很難，先照subtask 來做。
subtask1 :N,M<=100，很小感覺可以直接對每個點做BFS找出最高得分。
* 注意，在做完每次BFS後要將visited改回false，程式碼要是
```c++
for(auto& v:adj){
	v.is_visit=false
}// 正確版本

// 不能這樣寫
for(auto v:adj){
	v.is.visit=false
}// 這只是代表複製一份adj，並將裡面的改成unvisit，沒有改到真正的adj
```
subtask2:整張圖是一個SCC(強連通分量)，代表途中每個點都可以相互連通，所以最高得分就是每個點得分總和
subtask3:整張圖由一個或多個有向鍊所組成，找出每條鍊，答案鍊的最大和
subtask4:整張圖是一個dag(有向無環圖)，subtask3是subtask4裡的一個特例
* 核心算法：[[Topological sorting]](拓普排序)+dp
* 但為何可以這樣用：dag跟dp間可以互相轉換，把節點當作成一個狀態，而有向邊則是為轉移，我們定義解決問題等於走訪節點，則dp就是用拓普排序的方式遍歷狀態圖。
### Dp實做
subtask4
*  dp定義：我們定義dp[v]代表從vertex v開始，沿著有向邊所能到達的最大總獎勵
* dp遞迴式推導：
	1. 從v當作起始點，我們能先獲得av
	2. 選一個有向邊從v->u，繼續走，始能獲得的總獎勵最大化
	3. 若選擇v->u的邊，則代表從u繼續旅程，而u能獲得的最大獎例已經在dp[u]裡了
	4. 因此從v出發能獲得的最大獎勵是，av+連接v->u的所有u中dp[u]最大的那個vertex
	因此遞迴式為
	$$
	dp[v]=av+max(dp[u],\text{for all u is connected by v})
	$$
	而順序是要從沒有出度的vertex開始，此時{Dp}裡是空的，Dp[vertex]=a_vertex，也就是**反向拓普排序**
	
subtask3
* dp定義：我們定義dp[v]為從v作為起點，沿著有向邊能獲得的最總獎勵
* dp遞迴式推導
	1. 我們從v出發，首先一定能獲得該城市的獎勵av
	2. 接著選定一個有向邊從v->u，始能或的的總獎勵最大化
	3. 但subtask3 是多條的單向鍊，因此從v->u只有一個選項，除非v已經是終點，則dp[v]=av
	因此遞迴式為
	$$
	\begin{align}
dp[v]=\begin{cases}
a_{v}+dp[u]\text{,if v is end vertex(no out degree)} \\
a_{v}\text{,if v is end vertex(no out degree)}
\end{cases}
\end{align}
	$$`
subtask5(圖沒有任何限制)
不能直接像subtask4 一樣直接用拓普+dp直接得出結論，因為dp的結果會基於自身的值會被下一個值定，但subtask5可能會有環，因此狀態轉移會轉一圈自己，變成自己的值會依賴於自己，因此要做一個轉換，找出圖裡所有的SCC，這樣一來將一個SCC視為一個超級節點，圖又會變DAG，因此又可以用拓普排序＋dp實做出來。
實做步驟：
1. 找出圖裡所有的SCC
2. 將每一個SCC視為一個超級節點，此時圖會變成DAG
3. 用拓普排序找到先後順序
4. dp(kahn alogrithm):讓我們可以一邊做拓普排序一邊做dp
kahn 簡單介紹：就是能讓我們一邊做dp一邊做拓普排序的作法，拓普排序本質上就是找到入度的先後順序，起點必定是要入度為0，我們才能確認到該點的值等於他本身的值，從後往前推，而kahn算法，我們紀錄了每個SCC vertex的入度，任何一個入度為0的vertex都可以當作起點，繼續做dp，被連結的vertex會扣掉1個入度，如果入度為0把他push進queue裡，代表已經確定那個SCC vertex最長路徑了，終止條件式存放入度為0的queue變成空的了。
* SCC細節
	* 做第一次DFS是紀錄結束點的順序
	* 第二次對每個點做DFS，在同一個DFS能達到的點代表在同一個SCC裡，走完所有的點就可以找到所有的SCC(所需容器:scc_id 紀錄每個vertex屬於哪個scc,scc_value紀錄每個scc的總共award)
* DAG細節
	* 走訪每一個點，有一個`set<pair<int,int>> edges`來存SCC vertex連結狀況，有一個vertex v他的SCC是scc_id[v]，他的連結點u的scc是scc_id[u]，當scc_v!=scc_u時代表兩個scc有連結，把這個邊推進edges裡，如果以後再次發現{scc_v,scc_u} edge不用再推一次，只要知道一次連結就好了, **set 是用insert**
	
* DP細節
	* 先把in_order=0的SCC vertex推進queue裡，queue專門存放in_degree=0的vertex
實做要注意細節，要注意vector不要越界存取，在存東西進去前請先resize他的大小，這時做很複雜，務必多練習！！！
```c++
#include<bits/stdc++.h>
using namespace std;
// Define the class
class Edge{
	public:
		int ai;
		list<int> li;
		Edge(){

		}
};


// Define the container
int N,M;
// Graph
vector<Edge> graph;
vector<Edge> reverse_graph;

// For find SCC
stack<int> topoOrder;
vector<bool> visited;
vector<int> scc_id;
vector<long long> scc_value;
int scc_count=0;

// For build DAG made by SCC's
vector<vector<int>> DAG;
vector<int> in_degree;

// For dp
vector<long long> dp;
// Function
void addEdge(int v,int u){
	graph[v].li.push_back(u);
	reverse_graph[u].li.push_back(v);
}

// Build SCC part
void dfs1(int v){
	visited[v]=true;
	for(int u:graph[v].li){
		if(!visited[u]){
			dfs1(u);
		}
	}
	topoOrder.push(v);
}

void dfs2(int v,int scc_num){
	scc_id[v]=scc_num;
	scc_value[scc_num]+=graph[v].ai;

	for(int u:reverse_graph[v].li){
		if(scc_id[u]==-1){
			dfs2(u,scc_num);
		}
	}
}

void build_scc(){
	// Do the first dfs for all node
	for(int i=1;i<=N;++i){
		if(visited[i]==false)
			dfs1(i);
	}

	// Do the second dfs order by topological order
	while(!topoOrder.empty()){
		int v=topoOrder.top();
		topoOrder.pop();

		if(scc_id[v]==-1){
			dfs2(v,scc_count);
			scc_count++;
		}
	}

}

// Build dag composed by SCC
void buildDAG(){
	// Store the connected SCC's
	set<pair<int,int>> edges;

	for(int v=1;v<=N;++v){
		for(int u:graph[v].li){
			int scc_v=scc_id[v];
			int scc_u=scc_id[u];
			if(scc_v!=scc_u && edges.find({scc_v,scc_u})==edges.end()){
				edges.insert({scc_v,scc_u});
				in_degree[scc_u]++;
				DAG[scc_v].push_back(scc_u);
			}
		}
	}
}

// Build topoDP
void topoDP(){
	// Every in_degree=0's SCC vertex can be start point
	// Build a queue to store the in_degree=0's vertex
	queue<int> q;
	for(int i=0;i<scc_count;++i){
		if(in_degree[i]==0){
			// Initialize it's dp value and push it into q
			dp[i]=scc_value[i];
			q.push(i);
		}
	}

	// Check the q
	while(!q.empty()){
		// Pop the vertex from q
		int v=q.front();
		q.pop();
		
		// See v's connected scc vertex
		long long max_successor=0;
		for(int u:DAG[v]){
			dp[u]=max(dp[u],dp[v]+scc_value[u]);
			in_degree[u]--;
			if(in_degree[u]==0)
				q.push(u);
		}
	}

	long long ans=0;
	for(int i=0;i<scc_count;++i){
		ans=max(ans,dp[i]);
	}

	cout<<ans<<"\n";
	return;
}


int main(){
	ios::sync_with_stdio(false),cin.tie(nullptr);
	cin>>N>>M;

	// Resize the container
	graph.resize(N+1);
	reverse_graph.resize(N+1);
	visited.resize(N+1,false);
	scc_id.resize(N+1,-1);
	scc_value.resize(N+1,0);

	// Handle input
	for(int i=1;i<=N;++i){
		int ai;
		cin>>ai;
		graph[i].ai=ai;
		reverse_graph[i].ai=ai;
	}
	for(int i=0;i<M;++i){
		int v,u;
		cin>>v>>u;
		addEdge(v,u);
	}

	build_scc(); // After run build_scc(), we get scc_count
	// Resize the container that needs scc_count
	DAG.resize(scc_count);
	in_degree.resize(scc_count,0);
	dp.resize(scc_count);

	buildDAG();

	topoDP();

	return 0;


}
```
# Reference
[樹直徑算法](https://zhuanlan.zhihu.com/p/115966044)
[bfs在最短路徑實做](https://oi-wiki.org/graph/bfs/)
[Adjacent list 來儲存有權邊](https://www.geeksforgeeks.org/dsa/adjacency-list-meaning-definition-in-dsa/)
[Priority queue c++](https://yuihuang.com/cpp-stl-priority-queue/)
[DAG 找最短路徑](https://oi-wiki.org/graph/dag/)
[DAG跟dp關係推導](https://web.ntnu.edu.tw/~algo/DynamicProgramming.html)