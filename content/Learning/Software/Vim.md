---
created: 2025-08-02T19:28
updated: 2025-08-02T19:32
title: Test
---
2024-11-26 12:08

Status:

Tags:
---
---
# Vim
* The interface of vim is a programming language, since different key have different effect and we can combined those key together and achieve more complex command
## Mode type
* Normal mode: *`esc`*,(Navigating around the file and read the code)
* Insert mode: **`i`** ,(Inserting text)
* Replace mode: **`R`**,(Replacing the text)
* Visual mode: **`v`**, (selecting loads of codes in same time)
* Command-line mode: **`:`**, (Start typing command)
## Command-line
* `:e <file's name>`:Open file for editing
* `:q`:Close the window
* `:w`:save the change
* `:help <topic>`:Open help
	* `help :w`:Open help for :w command.
## Movement
* Basic: `hjkl`, (left,down,up,right)
* Words:`w`(next word), `b`(beginning of word),`e`(end of word)
* Lines:`0`(begin of the line), `^`(first non-blank character), `$`(end of line)
* Screen:`H`(top of screen), `M`(middle of screen), `L`(bottom of screen)
* Scroll:`ctrl-u`(scroll up),`ctrl-d`(scroll down)
* File:`gg`(beginning of file), `G`(end of file)
* Find:`f{character}`(find character on **current line**, and use `,` / `;` navigating for matches.)
* Search:`/<keyword>`(find `<keyword>` in current file), use `n` / `N` navigating for matches.
## Selection
* Visual:`v`
* Visual line:`V`
* Visual block:`ctrl-v`
## Editing
Don't necessarily into insert mode to edit the text.
* `o`/`O`:insert line below/above and go into insert mode.
* `d<motion>`:delete `<motion>`
	* `dw`:delete word
	* `d$`:delete to end of line
	* `d0`:delete to beginning of line
* `c<motion>`:change `<motion`, equal to `d<motion>` + `i`
* `x`:delete character
* `s`:substitute character
* `u`:undo
* `ctrl-u`:redo
* `y`:copy
* `p`:paste
## Modifier
* `i`(inside):
	* `ci(`:change the content `inside` the current pair parentheses.
	* `ci[`:change the content `inside` the current pair square brackets
* `a`(around):
	* `da(`:delete the content in the parentheses include parentheses itself.
# Reference
[Missing semester lesson 3 vim ](https://missing-semester-cn.github.io/2020/editors/)
