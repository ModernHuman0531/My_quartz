2024-11-11 22:32

Status:

Tags:[[SQL]]

# Aggregation
### Aggregation function
* filter function like **where** refer a value in a single row in a time.
* Aggregation function in the column can compute a group of value in rows.
* Aggregation function:
	*  `max([column])`: Refer the maximum of that column
	* `min([column])`: Refer the minimum of that column
	* `count(*)`: Count the number of the data base
* Example:
```sql
create table animals as 
	 select "dog" as kind, 4 as legs, 20 as weight union 
	 select "cat" as kind, 4 as legs, 10 as weight union 
	 select "ferret" as kind, 4 as legs, 10 as weight union 
	 select "parrot" as kind, 2 as legs, 6 as weight union 
	 select "pengun" as kind, 2 as legs, 10 as weight union 
	 select "t-rex" , 2 , 12000;# graph1

select max(legs), min(kind), count(*) from animals #graph2

select max(weight), kind from animals #graph3
```
![[Screenshot_20241111_233010.png]]
![[Screenshot_20241111_232328.png]]
![[Screenshot_20241111_232801.png]]
### Group
* Can group the same property of the row into the group by using **group by** and **having** statement.
* Syntax:`select [columns] from [table] group by [expression] having [expression];`
* The amount of the group is the number of unique value in that expressions.
* Having filter the sets of the group that are aggregated,.(Add the condition to the property of the group).
* The **aggregation expression** will do it's function to each group.
* Example:
```sql
select weight/legs, count(*) from animal group by weight/legs #graph4

select weight/legs, count(*) from animals group by weight/legs having count(*) > 1;# Graph 5
# Group the table with the value of weight/legs, and the amount in the group must bigger than 1.

```
![[Screenshot_20241112_002612.png]]
![[Screenshot_20241112_002801.png]]
# Reference