---
created: 2025-08-03T14:22
updated: 2025-10-03T13:05
title:
---
2025-09-30 20:56

Status:

Tags:
目錄:
# Homework 3
## 事前準備
###  用makefile來跑指令架設python虛擬環境
* 在makefile裡每一行都是獨立的子shell，所以如果分成兩行寫的指令，第一行造成的效果不會延續到第二行指令
* makefile語法細節
	* `.`：等同於source，目的是在當前shell執行腳本，不開新的子shell
	* 安靜模式:`@echo "Creating venv"`，前面的`@`代表讓make不輸出指令本身，指輸出結果
* 學習怎麼在vscode裡跑.ipynb檔，要讓.ipynb檔抓到你創建虛擬環境的kernel
	* 要先下載ipykernel
	* 跑`python -m ipykernel install --user --name=myproject --display-name "Python (myproject)"`
		* `--name=myproject`: 內部名稱
		* `--display-name "Python (myproject)"`: Vscode裡顯示名稱
## 開始訓練
* 目標: 這個任務是要做 **城市層級的每日病例數預測**，使用歷史病例資料與日期、季節、血清型組成等特徵，預測未來 **7 天的平均病例數**(不包括今天)

# Reference
[python venv虛擬環境](https://dev.to/codemee/python-xu-ni-huan-jing-venv-nbg)
[pd.dataframe介紹](https://www.learncodewithmike.com/2020/11/python-pandas-dataframe-tutorial.html)