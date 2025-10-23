---
created: 2025-08-03T14:22
updated: 2025-10-22T14:31
title:
---
2025-09-17 15:44

Status:

Tags:

目錄:- [[#Binary Search Trees(二元搜尋樹,BST)|Binary Search Trees(二元搜尋樹,BST)]]
	- [[#Binary Search Trees(二元搜尋樹,BST)#Search(int target)|Search(int target)]]
- [[#Insert(int value)|Insert(int value)]]
	- [[#Insert(int value)#Delete(int value)|Delete(int value)]]
	- [[#Insert(int value)#BST C++ 實做|BST C++ 實做]]
	- [[#Insert(int value)#補充: 其他兩種遍歷方式|補充: 其他兩種遍歷方式]]
- [[#Red-Black Trees|Red-Black Trees]]
	- [[#Red-Black Trees#Search|Search]]
	- [[#Red-Black Trees#Insert and Delete|Insert and Delete]]


# Tree
## Binary Search Trees(二元搜尋樹,BST)

| Operation | Sorted-array                 | Linked-list | Binary-search tree(BST) |
| --------- | ---------------------------- | ----------- | ----------------------- |
| Search    | $$O(\log n)$$(Binary search) | $$O(n)$$    | $$O(\log n)$$           |
| Insert    | $$O(n)$$                     | $$O(n)$$    | $$O(\log n)$$           |
| Delete    | $$O(n)$$                     | $$O(1)$$    | $$O(\log n)$$           |
Binary Search Tree是一種二元樹狀資料結構，每個node都包含**一個數值跟三個指標指向左右子節點跟parent節點**
Binary Search Tree在search, Insert 跟Delete都表現平均的好。
* BST 條件(違反下述條件就不能稱為BST)
	* 在parent節點左邊的value一定比parent本身小
	* 在parent節點右邊的value一定比parent本身還要大
	![[BST.png]]
* In-order Traversal
是一種遍歷樹的方式，會先從左邊子節點遍歷，到parent節點(自身節點)最後再去右邊子節點。
而對BST做In-order Traversal，代表會從value小到大開始遍歷，是因為in-order traversal的順序與我們建樹時的規則相符。
c++實做
```c++
void InOrderTraversal(Node* root){
	if(root==null) return;
	InOrderTraversal(root->left);
	cout<<root->value<<"\n";
	InOrderTraversal(root->right);
}
```
### Search(int target)
* Search就是找BST裡有沒有我們要找的target，如果target比現在node的值還小，往左邊子樹走，如果target比現在的node值大，往右邊的子樹走
* 但如果該值不存在，代表我們會走到null，此時不要傳不存在，而是傳**進null的前一個點**，在實做insert時會有妙用
* 像是下圖，我們的目標是找到4.5，但經過搜尋後4.5應該在4的右下方，但4下面是null，此時會傳4的node回去
	![[BST_search.png]]
## Insert(int value)
* Insert是要插入一個數值為value的node，且要維持BST的規則，此時就可以利用Search了，直接search(value)他為幫你找到value應該要在的位置，在將value跟搜尋到的node做比較，比他小，插在左邊，比他大，插在右邊，相等就不用插入
* 以下圖為例，我們要將4.5插入BST裡，但他原本不存在在BST裡，此時用search(4.5)，會回傳Node(4)的位置，而4.5應該在的位置正是他的下方，4.5比4大因此插在右邊
![[BST_insert.png]]
### Delete(int value)
* 要刪除value在BST裡，先search(value)看存不存在，如果不存在，就不用刪，如果存在，則分兩種情況
1. 該value的點只有一個或沒有子節點，則直接將parent node跟子節點接上
	![[BST_delete1.png]]
2. 若該value點有兩個子節點，則要
	1. 從那個子節點開始往右下搜尋他的子樹，找到一個剛好大於value的數值，將value用那個數值替換掉
	2. 該數值的子樹只可能有1個或0個子節點(按照一個或沒有子節點的情況處理)，因為他必然沒有左子節點，因為value本該是他的左子節點，但我們已經在上面找到value了，所以不可能發生。
	![[BST_delete2.png]]
* 結論:搜尋的複雜度為從root到leaf的路徑長，也就是BST的高度，而BST為一個二元樹，所以高度等於複雜度等於
$$O(n)=\log(n)$$
### BST C++ 實做
```c++
class Node{
    public:
        double value;
        Node *left, *right, *parent;
        Node(double val){
            value=val;
            left=nullptr;
            right=nullptr;
            parent=nullptr;
        }
};

class BST{
    public:
        Node *root;
        BST(Node *start){
            root=start;
        }
        Node* search(int target,Node* startroot){
            /* Implement search function in BST
            1. Assume a variable current to keep track of the current node, starting from root node
            2. If target is equal to current node's value, return current node
            3. If target is larger than current node's value, then keep searching the right subtree
            4. If the target is smaller than current node's value, then keep searching the left subtree
            5. If the current node is null, return it's parent node, cause it means if it were to be inserted, it would be inserted as a child of the parent node
            */
           Node* current=startroot;
           bool found=false;
           while(!found){
                if(current->value==target){
                    found=true;
                    return current;
                }
                else if(current->value<target){
                    if(current->right==nullptr){
                        found=true;
                        return current;
                    }
                    else{
                        current=current->right;
                    }
                }
                else if(current->value>target){
                    if(current->left==nullptr){
                        found=true;
                        return current;
                    }
                    else{
                        current=current->left;
                    }
                }
           }
           return nullptr; // This should never be reached, but needed for compiler
        }
        void insert(double value){
            /*Implement insert function in BST
            6. Take good usage of search function to find the parent node of the new node to be inserted
            7. Find the parent node, and compare the value with the parent node's value
            8. If the number is larger than than the parent node's value, insert it as the right child of the parent node
            9. If the number is smaller than than the parent node's value, insert it as the left child of the parent node
            10. If the number is equal to the parent node's value, do nothing
            */
            Node* parent=search(value,root);
            if(parent->value<value){
                Node* newNode=new Node(value);
                parent->right=newNode;
                newNode->parent=parent;

            }
            else if(parent->value>value){
                Node* newNode=new Node(value);
                parent->left=newNode;
                newNode->parent=parent;
            }
            else{
                return;
            }
        }
        void deleteNode(double value){
            /*Implement delete function in BST
            11. Take good usage of search function to find the node to be deleted
            12. If the node to be deleted has no children, than simply deleted it and set its parent's child pointer to null
            13. If the node to be deleted has one child, link its parent to its child and delete it
            14. If the node to be deleted has two children, find the immediate successor (the smallest node's value in the right subtree), 
            replace the value of the node to be deleted with the immediate successor's value, and delete the immediate successor's (which at most has one child)
            15. If the node to be deleted is not found, do nothing
            */
           Node* deletedNode=search(value,root);
           if(deletedNode->value!=value){
                return;
           }
		   else{
				//case1: no child
				if(deletedNode->left==nullptr&&deletedNode->right==nullptr){
					deletedNode->parent->left==deletedNode?deletedNode->parent->left=nullptr:deletedNode->parent->right=nullptr;
					deletedNode=nullptr;
				}
				//case2: one child
				else if(deletedNode->left==nullptr||deletedNode->right==nullptr){
					//Make sure deletedNode is whether a left child or right child of its parent
					if(deletedNode->parent->left==deletedNode){
						// Make sure which child is not null,connect the parent and the child
						if(deletedNode->left!=nullptr){
							deletedNode->parent->left=deletedNode->left;
							deletedNode->left->parent=deletedNode->parent;
							delete deletedNode;
						}
						else{
							deletedNode->parent->left=deletedNode->right;
							deletedNode->right->parent=deletedNode->parent;
							delete deletedNode;
						}
					} 
					else{
						// deletedNode is right child of its parent
						if(deletedNode->left!=nullptr){
							deletedNode->parent->right=deletedNode->left;
							deletedNode->left->parent=deletedNode->parent;
							delete deletedNode;
						}
						else{
							deletedNode->parent->right=deletedNode->right;
							deletedNode->right->parent=deletedNode->parent;
							delete deletedNode;
						}

					}
				}

				// case3. two children
				else{
					// Find the deletedNode's immediate successor
					Node* successor=search(value,deletedNode->right);
					deletedNode->value=successor->value;
					// Delete the successor node, which at most has one child, must be right child

					//make sure successor is whether a left child or right child of its parent
					if(successor->parent->left==successor){
						successor->parent->left=successor->right;
						if(successor->right!=nullptr){
							successor->right->parent=successor->parent;
						}
						successor=nullptr;
					}
					else{
						successor->parent->right=successor->right;
						if(successor->right!=nullptr){
							successor->right->parent=successor->parent;
						}
					}
					delete successor;
				}
		   }
        }
		void inordertraversal(Node* start){
			if(start==nullptr){
				return;
			}
			inordertraversal(start->left);
			cout<<start->value<<" ";
			inordertraversal(start->right);
		}
};
```
* BST在正常的情況下搜尋的複雜度是O(logn)，但在**極度不平衡狀況下會到O(n)**
### 補充: 其他兩種遍歷方式
* Pre-order traversal
Pre-order 代表會先拜訪parent node再拜訪left child node最後在拜訪right child node。
c++實做
```c++
void PreOrderTraversal(Node* start){
	if(start==nullptr) return;
	cout<<start->value<<" ";
	PreOrderTraversal(start->left);
	PreOrderTraversal(start->right);
}
```
* Post-order traversal
Post-order會先拜訪left child node再拜訪right child node最後才拜訪自己這個node
c++實做
```c++
void PostOrderTraversal(Node* start){
	if(start==nullptr) return;
	PostOrderTraversal(start->left);
	PostOrderTraversal(start->right);
	cout<<start->value<<" ";
	
}
```
## Red-Black Trees
* A BST that can be balanced itself(自平衡的二分搜樹)
我們要自平衡的原因是當紅黑數在極度不平衡的情況下搜索的時間複雜度會從O(logn)變成O(n)這是我們不希望看到的。
而當不平衡發生時我們**用rotation(旋轉)來幫助我們回到平衡的狀態，但仍要滿足BST的性質**。
![[BST_rotation.png]]
要怎麼判斷是否平衡，在紅黑數的情況，只要滿足組成紅黑數的條件，我們就稱之為平衡的BST。
* 紅黑數(BR tree)的條件有五個:
	1. 所有node不是red node就是black node
	2. root node必然是black node
	3. Nil 點必然是black node
	4. red node的子節點必然要是black node
	5. 對於所有node x而言，從x到nil的的所有路徑經過的**black node數量都相同**
	![[BR_tree.png]]
* 對於像是insert/delete可會導致RB tree性質不符合的行為，我們都可以rotation來使其符合性質
### Search
* 要證明BR tree search 的複雜鍍在O(logn)，首先一定要知道RB tree的高度為何，可以透過證明來證實**最大的高度不會大於2(log(n+1))**

證明:在不包括nil點有n個node的情況下，最大樹高不會大於2log(n+1)
前提:
1. 假設函數b(x)代表在節點x到nil路上會經過多少black node(包括x跟nil)
2. 假設在x下面的node數量一定至少有
$$2^{b(x)}+1$$
由上述兩個前提繼續推導
$$\begin{aligned}
n&\geq2^{b(root)}+1 \\
&\geq 2^{height/2}+1 (紅黑數性質) \\ \\
Height&\leq 2\log_{2}(n-1)
\end{aligned}$$
* 結論為BR tree search的複雜度為log(n)
### Insert and Delete
* 目前先不用知道，之後想詳細了解去課楓葉本第13章有詳細說明或是上網找資料
# Reference
[Tree traversal order](https://www.shubo.io/iterative-binary-tree-traversal/#google_vignette)
