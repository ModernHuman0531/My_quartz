2025-02-26 20:33

Status:

Tags:

# State space and search problem
A search problem contains the following elements.
* State space: All the possible state in the given situation
* A series of actions: The action we can do depending on out current state
* Transition model: After we take the action, what will the state become
* An action of cost: What we need to cost when we choose to do specific action
* A start state: Initial state we are given
* A goal state: The final state we want to achieve
For example:
![[pacman1.png]]
Purpose: Eat all dots.

# State space size
# State space graph versus Search tree
# Uniformed search
**PESUDO code** for uniformed search:
```python
function Tree-search(problem, frontier) return  solution or failure
	frontier
```
## Depth-First Search(**DFS**)

## Breadth-First Search(**BFS**)

## Uniform-Cost Search(**UCS**)
# Reference
[bfs and dfs basic](https://oi-wiki.org/graph/dfs/)