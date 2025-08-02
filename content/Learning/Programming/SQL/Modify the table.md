2024-11-12 11:56

Status:

Tags:[[SQL]]

# Modify the table
## Create an empty table
* `create table [table name] (n unique, default note)`,**unique** is for different content of column, **default** is when we don't input, it'll have default value.
* Above command will create a empty table.
## Delete table
* `drop table if exists [table name]`, delete the table if the table name already exists.
## Insert row in table
* Assume the table only have two columns.
* Insert into one column
	*  `insert into [table name](specify column) values (value);`
* Insert into two columns.
	* `insert into [table name] values (value1, value2);`
## Modify the value in the rows
`update [table name] set [expression] where [condition]`
```sql
create table prime (n unique, prime default 1);
insert into prime (2,1), (3,1);
insert into prime(n) values(4),(5),(6),(7);
update prime(n) set prime = 0 where n>2 and n%2=0;
```
![[Screenshot_20241112_122011.png]]
# Reference