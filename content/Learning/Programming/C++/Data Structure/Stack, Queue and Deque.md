---
created: 2025-08-03T14:22
updated: 2025-09-10T18:23
title:
---
2025-09-10 17:34

Status:

Tags:[[Array and Linked list]]

# Stack, Queue and Deque
## Stack
![[Pasted image 20250910174645.png]]
* Stack 是一種FILO(First In Last Out)的資料結構，如同疊盤子一樣，只能往上疊，且要拿的時候也只能從最上面拿
* 有STL，要使用時要記得`#include<stack>
	* 宣告: `stack<int> stk;` 
	* 將資料放在頂部:`push()`
	* 將資料從頂部取出:`pop()`
	* 查詢頂部資料: `top()`
	* 查詢stack大小:`size()`
	* 查詢是否是空的:`empty()`
## Queue
![[Pasted image 20250910174659.png]]
* Queue是一種FIFO的資料結構，跟排隊一樣，先進去排的會先出來。
* Ｑueue有STL，使用前要先`#include<queue>
	* 宣告: `queue<int> que;` 
	* 將資料放在尾端:`push()`
	* 將資料從前端取出:`pop()`
	* 查詢前端資料: `front()`
	* 查詢queue大小:`size()`
	* 查詢是否是空的:`empty()`
## Deque
* 是一種資料結構支援從尾端跟前端放入移出元素
* Deque有STL，在使用前要先`#include<deque>` 
	* 宣告: `deque<int> deq;` 
	* 將資料放在前端:`push_front()`
	* 將資料從前端取出:`pop_front()`
	* 將資料放在尾端:`push_back()`
	* 將資料從尾端取出:`pop_back()`
	* 查詢前端資料: `front()`
	* 查詢尾端資料: back()
	* 查詢stack大小:`size()`
	* 查詢是否是空的:`empty()`
## 缺點
* 既然deque如此好用，那我們還需要stack, queue做什麼？
* deque的缺點是所占的**時間與空間常數太大了**，會使compile時間變慢，而在STL裡call stack跟queue，也是以deque作為容器，因此用這三個資料結構的代價是產生巨大常數，上述資料節夠功能可以被vector跟list所代(stack -> vector, queue -> list)
* 或是改變容器種類
	* `queue<int, list<int>> que;`
	* `stack<int, vector<int>> stk;`

# Reference
https://guide.ntucpc.org/BasicDataStructure/stack_queue_deque/
