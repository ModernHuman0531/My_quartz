2024-11-11 18:43

Status:

Tags:[[SQL]]

# Joining graphs
### Joining different two graph
* Two tables **a** and **b** are joined by a **comma** to yield all possible combination of a row from a and a row from b.`select * from [table1], [table2]`
* Use **where** statement to pick the row we want.
* Syntax:`select [columns] from [table1], [table2], where[condition]
* Example:
```sql
CREATE TABLE dogs AS
  SELECT "abraham" AS name, "long" AS fur UNION
  SELECT "barack"         , "short"       UNION
  SELECT "clinton"        , "long"        UNION
  SELECT "delano"         , "long"        UNION
  SELECT "eisenhower"     , "short"       UNION
  SELECT "fillmore"       , "curly"       UNION
  SELECT "grover"         , "short"       UNION
  SELECT "herbert"        , "curly";
CREATE TABLE parents AS
  SELECT "abraham" AS parent, "barack" AS child UNION
  SELECT "abraham"          , "clinton"         UNION
  SELECT "delano"           , "herbert"         UNION
  SELECT "fillmore"         , "abraham"         UNION
  SELECT "fillmore"         , "delano"          UNION
  SELECT "fillmore"         , "grover"          UNION
  SELECT "eisenhower"       , "fillmore";
>>> 
>>> select parent from parents, dogs
		where child = name and fur = curve; 
```
![[Screenshot_20241111_191821.png]]
### When joining the two same graph
* When refer two same table, we have to give two table **alias** 
* Use point to achieve alias's element.
* Example:(Find the dogs have same parent)
```sql
create table sibiling as
	select a.child as first, b.child as second
		from parents as a, parents as b #<- This part
		where a.parent = b.parent and a.child < b.child
```
![[Screenshot_20241111_192700.png]]


# Reference