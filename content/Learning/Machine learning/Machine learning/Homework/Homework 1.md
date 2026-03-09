---
created: 2025-08-03T14:22
updated: 2025-09-06T14:54
title:
---

2025-09-03 22:42

Status:

Tags:

# Homework 1
## 實做原理
1. load_data() 是去讀./MNIST資料夾下所有的 file and folder的名稱，當用isdir()確定讀取的是folder後變進去那個folder裡算裡面到底有幾個.png檔案以便作為分割data的依據，當檢查完一個folder裡有幾個檔案後傳遞該資料夾相對路徑給split_dataset()來進行資料分割。 
    

2. split_dataset()是根據70/15/15的比例來分個data給train/validation/test　data的，用listdir()讀取folder裡所有的.png檔的檔名，將其加上folder路徑便可已得到與程式檔案的相對路經，由於作業規定輸出格式必須”image_path label”，我們必須先從folder digit_0照順序下去搜索，因此在listdir()後就要先sort folders，接著根據比例將輸出內容分別寫入對應.txt file並紀錄各個data的總數 
    

3. check_data_leakage() 則是檢查有沒有資料洩漏的發生，在這個case裡就是train, validation, test data是否有重複，我使用的方法是set，先將對應的.txt用read().splitline()讀取並以一行為單位將其儲存成list，並將其轉成set，之後在以兩個為一組的set，用intersection來檢查內容是否重複，若有重複則將重複的文檔印出在terminal上。
## 特殊語法
* f-string: 
	* 在f"" 之間打的都是字串
	* 如果要用變數則用{}將變數包起來
* os.listdir(path)跟os.path.isdir(path)使用:
	* path 要是**上一層+這一層的名子** 才會有正確的輸出
	* listdir(path)只會尋找path下一層的folder/file不會遞迴尋找所有檔案
## 問題
* isdir()裡的路徑問題
* listdir()尋找是不一定會根據排序查詢
	* 原因: 回傳的檔案和資料夾名稱順序，預設是「檔案系統的原始順序」，不一定會照你在檔案總管看到的排序
	* 解決方法: 在一個開始找folders裡的東西前先sort過一次，他會用ascii code排，這樣就可以從folder0 - folder9了
* 要如何找文檔是否有共同的地方
	* 利用set語法，set的輸入要是一個list，將文檔的內容藉由`file.read.linesplit()`　以一行為單位進行分割並存成set後利用intersection語法來找共通點`set1.intersection(set2)`　其輸出會是一個list存著重複內容，如果len為0則代表沒有重複內容，在這個case裡代表沒有data leakage.
# Reference
[python 讀檔案](https://blog.gtwang.org/programming/python-list-all-files-in-directory/)
https://shengyu7697.github.io/python-read-text-file/
[python 寫入.txt檔](https://shengyu7697.github.io/python-write-text-file/)