---
created: 2025-08-03T14:22
updated: 2025-09-10T17:28
title:
---
2025-09-06 16:12

Status:

Tags:

# Array and Linked list
## Array and Vector
### Array
* Array(陣列)是一個儲存大小**固定的容器**
* C++ 的stl有提供一個std::array的容器，不用像傳統c裡使用`[]` 來宣告array
* 使用前要`#include<array>`
#### 用法
1. 宣告
	* array<int, 3> myArray;` 建立一個size為3，裡面存int的array
2. 初始化
	* `array<double, 3> array2 = {1.1, 2.2, 3.3}
3. 訪問元素
	* double num1 = array[2] // num1 = 3.3
4. array 的大小
	*  int size1 = array2.size() //size1 = 3
5. 遍歷所有的element
	* ```c++
	  array<int, 3> myarray = {1,2,3}
	  // 1. 僅遍歷，沒有要改變裡面的element
	  for(const auto& element : myarray){
		  cout << element << endl;
	  }
	  
	  // 2.用it pointer，可以改變裡面的element
	  for(array<int, 3>::iterator it = myarray.begin();it != myarray.end();++it){
		  cout << *it << endl;
	  }
```
6. 檢查是否為空
	* `myarray.empty()`
7. 用== or != 來判斷兩個array是否相同
	
	
### Vector
* Vector是一個能改變大小的動態陣列
* 使用時要先`#include <vector>`
#### 用法
1. 初始化
	* `vector<int> v1 = {1,2,3};`
2. 存取元素
	* `int num1 = v1[1]; //num1=2`
3. 新增尾端元素與刪除尾端元素
	* ```c++
	  // 用push_back來新增
	  v1.push_back(4);
	  v1.push_back(5);
	  // v1 = {1,2,3,4,5}
	  // 用pop_back來移除元素
	  v1.pop_back();
	  v1.pop_back();
	  //v1 = {1,2,3}
	  ```
4. 遍歷
	* ```c++
	  // 1. 用it pointer作為變數來便利整個vector
	  for(auto it = v1.begin();it != v1.end();++it){
		  cout << *it << endl;
	  }
	  // 2. 更懶的寫法
	  for(auto &v : v1){
		  cout << v << endl;
	  }
	  ```
5. 取得vector裡有多少元素
	* `int size = v1.size(); //size=3`
## Linked-list(鏈結串列)
* 上面介紹的容器都非常方便，但缺點也很明顯除非要插入的數值在最尾端不然插入數值還要移動原本儲存的內容與空間
* Linked-list是由一個個節點(node)所組成的，若是單向的linked-list是有一個往下一個node指的指標，而雙向的linked-list則由2個指標分別指向前一個跟下一個的node
### Singly linked-list
![[Pasted image 20250908212810.png]]
* 單向linked-list永遠都只能指向下一個node無法回頭，直到最後一個元素會指向一個**空指標(null)**
* #### C++ 實做
```c++
#include <bits/stdc++.h> // Include all needed headers
using namespace std;

class Node {
    public:
        int value;
        Node* next;
        Node(int _value){// Constructor
            value = _value;
            next = nullptr;
        }
};

class Linked_list{
    private:
        Node* head; // Pointer always point at the first node
    public:
        Linked_list(){
            head = nullptr; // At first, head pointer should point at nullptr
        }
        // Function 1: Insert Node at the head of linked-list
        void insert_at_head(int value){
            Node* newnode = new Node(value); // Add a new node that have the value
            newnode -> next = head; //Make newnode point at the current head
            head = newnode; // The newnode be the current head
        }

        // Function 2:Insert node at the button
        void insert_at_bottom(int value){
            Node* newnode = new Node(value);
            // Check if head is nullptr, if so then let newnode be head
            if(head == nullptr){
                head = newnode;
                return;
            }
            // Else run over the linked-list to find the next is point at nullptr
            Node *temp = head; // temp is now point at where head point at
            while(temp -> next != nullptr){
                temp = temp -> next;
            }
            // Now temp's next is point at nullptr, we insert the newnode after it
            temp -> next = newnode;
        }

        // Function3: delete the head node
        void delete_head_node(){
            // If the head is nullptr, then just return it.
            if(head == nullptr){
                return;
            }
            // Else, move head to the next node and delete the original head
            Node* node = head;
            head = head -> next;
            delete node;
        }

        // Function 4: Delete specific position node
        void deletenode(int pos){
            if(pos == 1){
                delete_head_node();
                return;
            }
            Node* current = head;
            for(int count = 1; count < pos - 1 ; ++count){
                current = current -> next;
            }
            // Find the previous position of node you want to delete
            // next pointer is point to temp->next->next
            Node* temp = current -> next;
            current -> next = temp -> next;
            delete temp;
        }

        // Function 5:Run over the whole linked-list
        void printList(){
            Node* temp = head;
            while(temp != nullptr){
                cout << temp -> value << endl;
                temp = temp -> next;
            }
            cout << endl;

        }
};

int main(){

    // Turn off the c input to make program faster
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    Linked_list list;
    list.insert_at_head(1);
    list.insert_at_head(0);
    list.insert_at_bottom(2);
    list.insert_at_bottom(3);
    list.delete_head_node();
    list.deletenode(2);
    list.printList();

    return 0;

}
```
### Doublly linked-list
![[Pasted image 20250908213215.png]]
* 雙向linked-list多了一個指標讓他可以不只指向下一個node也可以指向上一個node，只是A的perv跟E的next一樣是指向空指標(null pointer)
* 在C++ STL 裡有**doubly linked-list** 的實做叫做`list` ，在使用時要先`#include <list>`>
* 操作方法: 
	* push_back(): 在linked-list最後面插入元素 
	* push_front(): 在linked-list最前面插入元素
	* pop_back():　在linked-list最後面拿出元素
	* pop_front():　在linked-list最前面拿出元素
	* clear():　清空整個linked-list
	* empty(): 確認linked-list是否是空的
	* size():　確認linked-list大小
	* front():　得到linked-list最前面的元素
	* back():　得到linked-list最後面的元素
### Circularly linked-list
![[Pasted image 20250908213724.png]]
* 循環linked-list與單向linked-list十分類似，但唯一不同的點是單向linked-list結束點是指向null pointer，而循環linked-list是指向第一個node.
* 實做
```c++
class Node{
	int value;
	Node* next;
}
class circularLinkedList {
	public:
		// member is a pointer always point at beginnig of linked-list
		Node* head;
		circularLinkedList(){
			head = nullptr;
		}
		void insert(int value){
			// If  head is nullptr(beginning)
			Node* newNode = new Node(value);
			if(head == nullptr){
				head = newNode;
				head -> next = head;
			}
			// Else find the last node in linked-list add the newNode and rebound it with head
			else{
				Node* temp = head;
				while(temp -> next != head){
					temp = temp -> next;
				}
				temp -> next = newNode;
				newNode -> next = head;
			}
		}
}

```

### Array 跟linked-list複雜度比較 (STL 裡)

| 操作類型       | Array  (陣列) | List (鏈結串列) |
| ---------- | ----------- | ----------- |
| 存取         | O(1)        | O(n)        |
| 搜尋         | O(n)        | O(n)        |
| 插入(insert) |             |             |
| -開頭        | O(n)        | O(1)        |
| -中間        | O(n)        | O(n)        |
| -結尾        | O(1)        | O(1)        |
| 刪除         |             |             |
| -開頭        | O(n)        | O(1)        |
| -中間        | O(n)        | O(n)        |
| -結尾        | O(1)        | O(1)        |

### 實做linked-list可能會遇到的問題
* 當我要用for迴圈連續輸入來建造linked-list時，會必須要有一個起始點，如果你用`ListNode* head = nullptr` 來當作你的起始點往下接下去，在你要接下一個node時(像是`head -> next = new ListNode(1)`) 會造成segmentation fault， 因此建議使用`dummy node` 然後回傳`dummy -> next` 。
# Reference
[Array STL](https://shengyu7697.github.io/std-array/)
[Vector STL](https://shengyu7697.github.io/std-vector/)
[Link-list](https://hackmd.io/@LukeTseng/SyVd6T4xgl)