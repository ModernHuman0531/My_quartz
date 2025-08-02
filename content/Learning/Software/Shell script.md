2024-11-21 15:44

Status:

Tags:[[Shell]]

# Shell script
## Variable
* `foo=bar`, there can't not have space between `=`, since `foo = bar`, it will call the foo function and set `=` and `bar` as variable(Space in shell is  to split arguments.)
* Use `$<variable_name>` to refer the value of variable.
* In the echo, we can use `""` or  `''` to represent string, but when we want to substitute variable's value we must use `""`
```shell
foo=cookie
>>> echo "I like to eat $foo"
I like to eat cookie
>>> echo 'I like to eat $foo'
I like to eat $foo
```
* If i want the variable the variable store the result of the command, we first use `(command)` to let the command been execute then access the value by `$`, for instance `path=$(pwd)`.
## Function
### Self-define function:
* Function in shell can take parameters, but using another variables to refer the parameters.
```shell
function myfunction(){
	echo "my function $1 $2"
}
```

| Syntax  | Description                                                |
| ------- | ---------------------------------------------------------- |
| `$0`    | The name of the script.                                    |
| `$1-$9` | First to Ninth arguments we input                          |
| `$@`    | All the arguments we input                                 |
| `$#`    | Numbers of arguments we input                              |
| `$?`    | Return value of previous command                           |
| `!!`    | The previous command we input. Usually used with `sudo !!` |
| `$_`    | Last argument of the previous command                      |

### if 
* Syntax:
```shell
#!/bin/zsh
if [[`condition`]];then
	#do something
elif [[`condition`]];then
	#do something
else
	#do something
fi

```
## while 
* Syntax:
```shell
#!/bin/zsh
while [[`condition`]]; do
	#do something
done
```
* Example(count number):
```shell
!/bin/zsh
i=1
while [[$i != 5]];do
	echo "i = $i"
	i=$(($i + 1))
done
```
### for 
* Syntax 1:(C-like code)
```shell
#!/bin/zsh
sum=0
num=5
for(i=1;i<$num;++i);do
	sum=$(($sum_$i))
done
echo "sum=$sum"
```
## And & Or
### And
* Syntax:`<expression1>|<expression2>`
* If the first expression is true or function correctly, then execute the second expression.
* In shell, when successfully execute the function, it will return 0, else return 1.
```shell
true & echo "hi"
#hi

false & echo "hi"
#
echo "hi" & echo "my friend"
#hi
#my friend
```
### Or
* Syntax:`<expression1> || <expression2>`
* If the first expression is false, then execute the second expression.
```shell
false || echo "Oops"
#Oops

true || echo "Oops"
#

echo "hi" || echo "Oops"
#hi
```
## `Globbing`
* When writing shell, we often use similar kinds of parameters, shell offer a convenient way by using `*`, `?` and `{}`. 
* Wildcards: When selecting the file all have some common words we can use `*` and `?`, noted that `*` is select all the file have that common word, but `?` only allow selecting the common word with `1` differences, if want selecting with two difference, then using `??`
* Curly braces: When creating or moving the file have common sub-string in series of command, we can use `{}` to expand the command.  
```shell
!#/bin/zsh
# Create files foo1, foo2 ... foo10
touch foo{1..10}
# Remove foo1, foo2, foo10
#Method1
rm foo*
#Method2
#Remove foo1 to foo9
rm foo?
#Remove foo10
rm foo??
```
### Shebang
* `#!` is called shebang, compiler will identify the symbol and take the after code as command and execute it. 
## Finding files
* We can use `find` command to find the file we want. We can even specify the file from it's `size`,`type`,`name`,`time`,`path` etc.
```shell
# Find all the dictionary names src
find . -name src -type d
#find all the path have test and in it have python files.
find . '*/path/*.py' -type f
#find all the file yesterday modify
find . -mtime 1 -type f
#find all the file that size is between 500k to 10M and named tar.gz
find . -size +500k -size -10M -name "*.tar.gz"
```
* After finding the file, we can also take some action to those files by using `-exec`
```shell
#remove all the file named .tmp
find . -name '*.tmp' -exec rm {} \;
#find all the png file and turn into jpg
find . -name '*.png' -exec convert {} {}.jpg \;
```
## Find the code
* We can use command `grep` to find the content of file(code) that have specific keywords.
* Syntax:`grep <keyword> <file1> <file2>...`

## `Xargs Command`
* Read the standard input, take space or change line to be a new argument, and regard those arguments as the parameters of the command.(The default command is `echo`)
```shell
xargs
arg1 arg2
arg3
#arg1 arg2 arg3
```
* If we don't want the space to separate the argument, we can assign the separate symbol by our self by using `-d "<symbol>"`  
```shell
xargo -d '\n'
# Assign the saperate argument in input by `\n` 
arg1 arg2
arg3
#arg1 arg2
#arg3
```
## tar command
* `tar` command have multiple applications, we can use it to pack all into new files and named it, zip or unzip the files.Doing these function by some command behind `tar`

| Command          | function |
| ---------------- | -------- |
| `-c`             |          |
| `-t`             |          |
| `-z`             |          |
| `-f <file name>` |          |
| `-x`             |          |
# Reference:
[self-defines function](https://shengyu7697.github.io/shell-script-function/)
[grep reference](https://blog.gtwang.org/linux/linux-grep-command-tutorial-examples/)
[find reference](https://blog.gtwang.org/linux/unix-linux-find-command-examples/)