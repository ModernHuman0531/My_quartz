2025-04-17 21:41

Status:

Tags

# Special syntax:
## Constructor
* Both **Class** and **Struct** have constructor.
* Recommend syntax:
```C++
class Node{
	private:
		int value;
		Node* next;
	public:
		Node(int _value):value{_value}, next{nullptr}{}
}
struct Node{
	int value;
	Node* next;
	Node(int _value):value{_value}, next{nullptr}{}
}
```
## Count_if function and lambda function

## pair
* Must include ``<utility>`` library to use pair.
* Declaration: 
```c++
pair<int, string> p1(1, "Book1");
or
pair<int, string> p2 = =make_pair(1, "Book1");
```

# Reference