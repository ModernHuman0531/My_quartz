---
created: 2025-08-03T14:22
updated: 2025-11-03T22:16
title:
---
2025-11-03 21:15

Status:

Tags:

目錄:
# Topological sorting
在[[Graph_Basic]]裡的DFS有提過，拓普排序是DFS的應用，找到DAG(有向無環圖)頂點的先後順序，利用了DFS tree的一個特性，當A->B時，A.finish_time>B.finish_time，詳細證明可以回去看。
## 實做
用vector reverse後便為答案
```c++
#include<bits/stdc++.h>
using namespace std;
class Vertex{
    public:
        int a_i;
        list<int> li;
        bool is_visited;
        Vertex(){
            is_visited=false;
        }
};
vector<Vertex> adj;
vector<int> topoOrder;
void DFS(int v){
	adj[v].is_visited=true;
	for(auto u:adj[v].li){
		if(!adj[u].is_visit){
			dfs(u);
		}
	}
	topoOrder.push_back(v);
}

int main(){
	for(int i=1;i<=n;i++){
		if(!adj[i].is_visit){
			DFS(i)
		}
	}
	
	// Reverse the topoOrder, because have to be descending order of finish time
	reverse(topoOrder.begin(),topoOrder.end());
}
```
# Reference