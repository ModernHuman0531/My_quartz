2024-11-07 23:42

Status:

Tags: [[SQL]]

# Create the table
## Select statement
* Select statement is to create a **new table**, either from scratch(build the table from zero) or projecting the table(use already existed table to create a new table)
* Select statement always end up with a comma-separated list follow by the column descriptions.
* Column description have the expression of the column and optionally have name of that column after as.
	* **select [expression] as [name];** , which create one row table.
* If we want to bind the row table together, we can use **union** statement to replace comma.
* Noted that select statement only shows the statement on screen, if we want to store the table we should use *create statement** to give that table **name**
	*  **create table [name] as [select statement] 
* Example:
```sql
create table parents as 
	select "delano" as parent, "herbert" as child union 
	select "abrahan" , "barack" union 
	select "abrahan" , "clinton" union 
	select "fillmore" , "abrahan" union 
	select "fillmore" , "delano" union 
	select "fillmore" , "grover" union 
	select "eisenhower" , "filmore";
```
![[Screenshot from 2024-11-08 00-07-36.png]]
## Where statement
* If select statement is create table from zero, then where statement is to create the table from already existed table.
* Can imagine where statement as a filter, we can give some condition about the existed table and then will output the result we want.
* Syntax:
	*  **select [columns] from [existed table] where [condition] **
* Example:
```sql
select child from parents where parent = 'filmore' #graph1
select parent from parents where parent > child #graph2
```
![[graph1.png]] 
![[graph2.png]]
## Arithmetic
* We can use name of the column to achieve the row's value.
```sql
create table lift as # graph4
	select 101 as chair, 2 as single, 2 as couple union 
	select 102          , 0         , 3           union 
	select 103          , 4         , 1;
# Arithmetic
create chair, single*1 + couple * 2 as total from lift #graph4
```
![[graph3.png]]
![[graph4.png]]
* If we want to show the result of the table, we can use **`select * from [table's name]`**
# Reference