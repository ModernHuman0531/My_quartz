---
created: 2025-08-03T14:22
updated: 2025-11-05T16:57
title:
---
2025-10-29 16:54

Status:

Tags:[[Graph_Basic]]

目錄:
# Shortest path
Weight of path的定義：有一張有向圖G={V,E}，The weight of parh p=v1->v2->...-?vl，被定義為：
$$
w(p)=\sum_{i=0}^{i=k-1}w(i,i+1)
$$
而從u到v的最短路徑的定義是，路徑p從u到v，使得w(p)的值最小。
$$
\delta(u,v)=min(w(p):\text{p is a path from u to v})
$$

## Dijkstra
* 用來尋找**無負權邊** 圖的最短路徑。 
理論演算法：
* 需要容器
 1. S來儲存已經確定最短路徑的vertex
 2. Q是一個priority queue來儲存已經確定的節點的鄰居所算出了距離存進pq裡，距離從小到大排序
 3. dist[v]是儲存vertex v的最短距離
 * PESUDO code:(v is start node)
 ```
 // Initialization
 d[s]<-0
 for(each v in V-{s})
	 d[v]<- infinity
 S<-空集合
 Q<-v
 while Q is not empty: // V times
	 do u<-extract-min(Q)
		 push u into s
		 for each v in adj[u]// degree(V)(maximum E times)
			 if d[v]>d[u]+w(u,v)
				 d[v]<-d[u]+w(u,v) //decrease-key
 ```
 複雜度為
 Time=V * T_extract_min + E * T_decrease_key，如果是用binary heap 來執行以上兩個動作，複雜度都為lg(n)，因此Dijkstra的複雜度為
 $$O(n)=(E\log n)\text{, since E dominate V}$$
 c++實做細節

* BFS與Dijkstra 的關係
其實Dijkstra用在無權重的圖時就是BFS，由於我們不需要extract_min，因為v到鄰邊u的距離都相同，因此Q可以不用priority queue而是用queue代替就行了。
PESUDO code
```
d[s]<-0
for(each v in V-{s})
	d[v]<-infinity
while Q is not empty:
	do u<-Dequeue(Q)
	for v in adj[u]
		if d[v] is infinity(unvisited)
			d[v]<-d[u]+1
			push v into Q
```
 
## Bellman-Ford

# Reference