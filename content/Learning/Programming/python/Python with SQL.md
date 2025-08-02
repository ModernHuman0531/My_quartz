2024-11-12 12:22

Status:

Tags:[[python]], [[SQL]]

# Python with SQL
* We can use the built-in package in python to interact python with SQL.
* Example:
```python
# Import a package allowing us to 
import sqlite3

# Create a sql object and connect it with database(n.db)
db = sqlite.Connection("n.db")
# Use execute() to execute sql code, start and end up with "".
db.execute("create table nums as select 2 union select 3;")
# Can make a space (?), to let python insert number.
db.execute("insert into (?),(?),(?),(?);", range(4,7))
# fetchall() is convert the result of table into tuple
print(db.execute("select * from nums").fetchall())
#Commit() is to store the data in n.db(database)
db.commit()
```
# Reference