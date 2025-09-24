---
created: 2025-08-03T14:22
updated: 2025-09-20T16:20
title:
---
2025-09-03 22:38

Status:

Tags:
目錄:
- [[#什麼是Machine Learning|什麼是Machine Learning]]
	- [[#什麼是Machine Learning#如何找到目標的function呢|如何找到目標的function呢]]
- [[#Machine Learning Road Map|Machine Learning Road Map]]
	- [[#Machine Learning Road Map#Supervised Learning|Supervised Learning]]
		- [[#Supervised Learning#Regression|Regression]]
		- [[#Supervised Learning#Classification|Classification]]
		- [[#Supervised Learning#Deep learning|Deep learning]]
		- [[#Supervised Learning#Structured learning|Structured learning]]
	- [[#Machine Learning Road Map#Semi-supervised learning|Semi-supervised learning]]
	- [[#Machine Learning Road Map#Transfer learning|Transfer learning]]
	- [[#Machine Learning Road Map#Unsupervised learning|Unsupervised learning]]
	- [[#Machine Learning Road Map#Reinforcement learning|Reinforcement learning]]
- [[#Dataset Splitting and Data leakage|Dataset Splitting and Data leakage]]
	- [[#Dataset Splitting and Data leakage#Data leakage|Data leakage]]

# Introduction to ML
學習重點

* ML 種類(supervised, unsupervised...)跟這些種類的定義跟範例
* Data Splitting and Data leakage(HW1 content)

## 什麼是Machine Learning

* 以觀念來說，ML是要讓機器有自主學習的能力而不是手刻一堆if 條件讓機器一個個找對應。
* 在實做上是找出一個**function**讓我們入一個data跑出我們想要的輸出，舉例來說，我們想讓machine能辨認出我們給的動物圖片是什麼動物，那我們的目標就是找到一function當我們給一個貓的圖片時他會回覆說這是一隻貓。
### 如何找到目標的function呢

* 要找到符合我們預想的data的話需要3個東西
	* A set of functions(函數集) 也就是所謂的model(模型): 要將輸入套進的函數
	* Training data: 告訴函數正確的輸入對應輸出應該怎麼樣 
	* Goodness of function: 用來判斷函數的好壞
* 舉例來說我們是要做動物圖片判斷的machine, 我們有兩個functions 來當function set 分別是f1 f2，而training data則是一堆動物圖片標著對應的名稱，而在這個case 的good of function則是依據將圖片帶入funtion的結果來判斷，準確率較高的function就是較好的function，接著設計一個演算法挑出最好的function並用test data來檢測效果
![[ML_frame.png]]
## Machine Learning Road Map
* scenario是學習的情境
* task是要解決的問題
* method是解決問題所使用的方法
![[Road_map.png]]
### Supervised Learning
* 定義是你的training data都是一個pair(input and label)而你function的輸出一定是**label**
* 除非很難收集到有label的data不然我們都會傾向用supervised learning
#### Regression
* 目標函數的輸出是一個**scalar(數值)**
* 以預測pm2.5來舉例你預期的輸出是明天的pm2.5而你所需要的input data可能是今天跟昨天的data，而你的training data可能是幾個月前的pm2.5數據。
![[Regression.png]]
#### Classification
* 分為**Binary Classification**跟**Multi-class Classfication**
* Binary Classification的輸出是yes/no，而Multi-classification的輸出是從你給的選項中選出一個當答案。
#### Deep learning
* 當我們所想要的輸出無法被簡單的linear model實現時，此時就要用deep learning -> (function 特別複雜)來實現。
* 舉例來說，動物圖片辨識無法用linear model 來實現因此需要用到deep learning model
#### Structured learning
* 輸出不是一個數值或是你給定的選項而是一個更複雜的輸出
![[Structured_learning.png]]
### Semi-supervised learning
* 當training data 只有一小部份有label而另外一大部分沒label。
### Transfer learning
* 當training data 只有一小部份有label而另外一大部分的跟我們要訓練的東西無關的data(可以是labeled or not labeled)
![[Transfer_learning.png]]
### Unsupervised learning
* 當你的training data都沒有label 時他要怎麼學習。
* 舉例來說，如果你想要讓machine 知道某個詞是什麼意思，你會給他看大量的文章讓他自行推導出那個詞的意思。
### Reinforcement learning
* 比起Supervised learning會告訴你對應輸出的label(正確答案)，在RL不會告訴你正確答案只會說這個input的分數好壞(用reward function來判定)
## Dataset Splitting and Data leakage
* 我們會將所有的data分成三個部份，分別是
	* Training data: 用來訓練model的data
	* Validation data: 用來檢視現在的hyper-parameter調出的model的效果，如果不好，不換模型僅hyper-paramter
	* Test data: 用來與其他model做比較的data
	* tip: Validation data 是用來與自己model做比較調出最好的參數的data，test data則是與其他model做比較的data
* 通常分割比例會是70/15/15 
### Data leakage
* Data leakage發生在訓練model時獲取到不該在訓練時拿到的data，這會使model的效果看起異常的好但在實際應用時效果卻差強人意
* 避免方法: 做好Data splitting
# Reference
[Reference video](https://www.youtube.com/watch?v=CXgbekl66jc)
[Data set 介紹](https://ithelp.ithome.com.tw/articles/10240556)
[Data leakage](https://vocus.cc/article/6720a06ffd89780001f49fd7)