---
created: 2025-08-03T14:22
updated: 2026-02-26T22:55
title:
---
2025-09-30 18:33

Status:

Tags:[[Linear regression]], [[Homework 1|Homework 1]]

目錄:
# Bias and Variance
* 在linear regression裡我們有根據不同的model用loss function算出他們各自的error(training data跟testing data都有)，而error主要來自於兩個部份**Bias(平均與最佳點差距)** 跟**Variance(點的分佈)**
![[testing_error.png]]
## Estimator of Bias and Variance
* 我們不知道最佳函數`f*`的位置在哪，只能由training data來算出最佳參數`f`，我們想知道`f*`與`f`的差距差多少，因此要用estimator來估計
* 假設變數X，他的平均(mean)為𝜇，變異數(Variance)為𝜎2
### Estimator of mean
* 取N個點(x1,x2,...,xn)做平均，會發現其平均不會等於𝜇，但如果對平均找期望值則會等於𝜇，代表你取N個數取平均的值會散落在𝜇都周圍
$$\begin{aligned}
m&=\frac{1}{N}\sum_{i=1}^nx_{i} \neq \mu \\
E[m]&=E\left[ \frac{1}{N}\sum_{i=1}^nx_{i} \right]=\frac{1}{N}\sum_{i=1}^nE[x_{i}]=\mu
\end{aligned}$$
* 而散佈在𝜇周圍的稠密程度則計算平均的varinace，發現與N有關，sample的點越多，越集中於𝜇
$$Var[m]=\frac{\sigma^2}{N}$$
### Estimator of variance
* 這個則是用於估計與母體間的稠密程度，發現當N越大越靠近本來(X)的variance。
$$\begin{aligned}
s^2&=\frac{1}{N}\sum_{i=1}^N(x_{i}-m)^2 \\
s^2&=\frac{N-1}{N}\sigma^2
\end{aligned}$$
![[Bias&Variance.png]]
## Bias & Variance
* 當使用同一個model但你的training data不一樣時會有不一樣的參數，較複雜的model參數的可能性也比較多因此分佈的較廣(Variance大)，較簡單的model比較不會受到輸入/雜訊的影響，因此分佈較集中(Variance小)
![[variance.png]]
* Bias則是用不同training data train出來的函數去做平均，這是會發現較複雜的model雖然分佈較廣但取平均後會更靠近目標函數(small bias)，相反的較簡單的model取平均離目標函數差距較大(large bias)
![[Bias.png]]
* 藉由上面的比較我們可以知道，較複雜的model有著**large variance & low bias**的特性(overfitting)，較簡單的model則有著**low variance & large bias**(underfitting)的特性，這個現象我們稱為**bias and variance tradeoff**。
![[BiasVsVariance.png]]
### Classify bias error or variance error
* 那我們要如辨認究竟是bias error還是variance error呢？
	* 當連training data都沒有辦法很好的fit時，代表training data error 很大，也就是目標函數跟本部在function set裡此時就是underfitting(**bias error**)
	* 當我們在training data上表現的很好，但在testing data上表現得很糟糕時，此時代表funtion過份的fit training data，此時為overfitting(**variance error**)
* 解決bias error
	* 增加feature
	* 選用更複雜的model
* 解決variance error
	* Regularizatioon(正規化)
	* More data
## How to select model
* 以下是在選擇model時不該做的事
![[model_selection.png]]
* 當我們有3個model時，train完後拿testing data去測試他，選error最低的那個當成最終的model，不能這麼做的原因是，選error最低的那個model會導致**無法正確的反應在真實的testing data上的效果**，因為我們是根據我們的testing data去選model，這可能導致這個model在我們的testing data表現的很好，但在實際的testing data上卻不如預期
* 我們會用cross validation來解決這個問題
### Cross validation
* 我們將原本的training data拆分成training data跟validation data，training data一樣是在train model的，但validation data是用來選model的，這樣我們自己的testing model的結果才能反應真正testing data的結果。
* 要注意選好model就不要再因為testing data 的結果再去改變model的選擇
* 小技巧，在**選好model後**如果擔心data不夠，則可以將training data跟validation data合併再train一次。
![[cross_validation.png]]
### N-cross validation
* 這是比cross validation在更進階的方法，舉例來說將training data分成3份，每model都train三次，每次都選不同的set當validation set選那個平均error最小的當我們的model。
![[N-cross_validation.png]]
# Reference