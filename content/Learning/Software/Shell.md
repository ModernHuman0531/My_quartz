2024-11-19 12:00

Status:

Tags:

# Shell
## What is Shell
* **Shell** is a **programming language** that use text to input, display output and execute built-in program.
* When we type the executed program in terminal, it will find all the program in the `$PATH`, which will show me all the paths machine shell will search for program.
* Shell command **separated by space**, if we want to bind word together, use `""` 
* We can use `man` to find the manual description of the built-in program. 
```shell
date
西元2024年11月19日 (週二) 12時48分06秒 CST
# echo [argument]
echo "hello world"
hello world
# which[shell program], tell us the path of shell program
```
## Navigating shell
* Tell the shell where the directory we are or to move to other directories
	* `cd .`: Goes to the current directory
	* `cd ..`: Goes to the parent directory
	* `cd ~`: Goes to **home** directory
	* `cd -`: Goes to previous directory
* To see what is in the  directory
	* `ls`: Shows all the `unhidden` (file start with .) files.
	* `ls-a`: Shows all the files include hidden files.
	* `ls -h`:Give us more information of the files, like accessibility or created time.
		* `d` means it is a directory.
		* `r` (Read):means you can read that file.
		* `w`(Write):means you can add or remove that file
		* `x`(Execute):means you can get into this and it's parent's directories.
	 * And it divide into three groups: Owner of file, owner of group and anyone else respectively.
```shell
ls -l
drwxr-xr-x  8 dunkun dunkun 4096 11月 19 12:24 Desktop
drwxr-xr-x  4 dunkun dunkun 4096 11月 14 16:52 Documents
drwxr-xr-x  3 dunkun dunkun 4096 11月 18 21:53 Downloads
drwxr-xr-x  2 dunkun dunkun 4096 11月  8 23:10 Music
drwxr-xr-x 22 dunkun dunkun 4096 10月 14 21:08 oop-python-nycu
drwxr-xr-x  3 dunkun dunkun 4096 11月 11 19:18 Pictures
drwxr-xr-x  2 dunkun dunkun 4096 11月  8 23:10 Public
drwxr-xr-x  2 dunkun dunkun 4096 11月  8 23:10 Templates
drwxr-xr-x  2 dunkun dunkun 4096 11月  8 23:10 Videos
```
* We can change the accessibility by using `chmod` command.
	* In number mode, syntax:`chmod [abc] <filename>`
	* a,b,c stands for the number that represent accessibility of user, group, other.
	* r = 4, w = 2, x = 1, so if we want the user can read, write, execute and group can only read and execute, other can only read, then type `chmod 764 <filename>`
## Connecting program in shell
* The default setting of the input stream is keyboard and output is screen(on terminal), but we can change the input and output style in shell.
* Use `< INPUT_file` as input of the shell, and `> OUTPUT_file` as output of shell.
* We can use `cat` to find out is there really output to the file or not.
* Key note: `>` will rewrite every thing by the output, but `>>` will append the output to the original file.
```shell
echo 920321 > file.txt
cat file.txt
>>> 920321
echo 920531 >> file.txt
cat file.txt
>>> 920321
>>> 920531
echo 8978 > file.txt
cat file.txt
>>> 8978
```
* We can also use pipe `|` to wire two program together.
	* Syntax:`<left-program> | <right-program>`
	* pipe take `<left-program>`'s output as the `<right-program>`'s input.
```shell
ls -l | tail -n1# Take the list -l as the input and choose the last 1's file.
drwxr-xr-x  2 dunkun dunkun 4096 11月  8 23:10 Videos
```
## Root user
* Root user can change most of the file we originally can't change it by using `sudo`.
* But we don't use it very common since we may accidentally break something.
* Common use is to change the content in `/sys`
* We can make an example by changing the brightness of the screen by using:
	` sudo echo 48000 > brightness`, but this will give me an error despite we already use `sudo`, that is because`sudo` is for echo to output 48000, but at the time we want to write 48000 in brightness we are not in the **root user**, so we don't have an access to use it.
* We can use `tee` to help use execute the program with the root user.
	`echo 48000 | sudo tee brightness`
## Search keyword 
* We can use `grep` to find the keyword in the content of file.
* Normal syntax:`grep <keyword> <file-name>`
* Advance usage:`ls/etc | grep network`:means search the file name contain **network**
# Reference