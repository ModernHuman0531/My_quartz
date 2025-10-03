---
created: 2025-08-03T14:22
updated: 2025-09-30T13:15
title:
---
2025-09-27 11:35

Status:

Tags:[[Linear regression]]

目錄:
# Gradient descent
* 之前在linear regression章節講過gradient descent的應用，這章節是來學習背後原理與如何加速gradient descent使其更快的到最優解
* 回顧:我們是為了找出參數的最佳解使得
$$\theta^*=argminL(\theta)$$找出最小的參數使得loss fuunction最小，假設我們現在有兩個參數，gradient的變化是
$$\begin{aligned}
\nabla L(\theta)&=\left[ \begin{array}{cc}
\frac{\partial L(\theta)}{(\partial \theta_{1})} \\
\frac{\partial L(\theta)}{(\partial \theta_{2})} \\
\end{array} \right] \\ \\
\left[ \begin{array}{cc}
\theta^1_{1} \\
 \theta^1_{2}\\
\end{array} \right]&=\left[ \begin{array}{cc}
\theta^0_{1} \\
\theta^0_{2} \\
\end{array} \right]-\eta \nabla L(\theta ^0)
\end{aligned}$$
注意到gradient變化的方向跟實際參數移動的方向正好相反，是因為為了要走到最低點，當我們發現在走上坡時應該往左走，在下坡時應該往右才能到最低點。
* 為了走到最低點，我們每次要走得步伐很重要，而控制步伐的除了gradient的值外還有**Learning rate**，如果步伐太小，要走到最優點的速度太慢，步伐太大則可能會跳過最優點達到更大的值，永遠到不了最小值，因此Learning rate的調整十分重要，因此我們有種方法來調整Learning rate
![[Learning_rate0.png]]
## Tip 1. Turning learning rate(學習率調整方式)
* Learning rate不應該一直保持著同一個值，應該隨著epoches的次數而調整
	* 一開始離終點很遠，應該跨大步，因此Learning rate應該較高
	* 快到終點時應該跨小步，因此Learning rate 應該較小
	* 每一個參數的Learning rate應該也要不同
### Adaptive Learning rate
Adaptive Learning rate就是會隨著epoches次數而調整Learning rate的方法。
$$\begin{aligned}
\eta^t&=\frac{\eta}{\sqrt{ t+1 }} \\
g^t&=\frac{\partial L(\theta^t)}{\partial w} \\
\sigma^t&=\sqrt{ \frac{1}{t+1}\sum_{i=1}^n(g^i)^2 }
\end{aligned}$$
* Vanilla gradient descent: 
$$w^{t+1} \leftarrow w^t-\eta^tg^t$$
* Adagrad method:
$$\begin{aligned}
w^{t+1} &\leftarrow w^t-\left( \frac{\eta^t}{\sigma^t} \right)g^t \\
w^{t+1} &\leftarrow w^t-\frac{\eta}{\sqrt{ \sum_{i=0}^n(g^i)^2}}g^t

\end{aligned}$$
舉例來說
$$
\begin{aligned}
w^1&=w^0-\frac{\eta^0}{\sigma^0}g^0,\sigma^0=\sqrt{ (g^0)^2 }\\
w^2&=w^1-\frac{\eta^1}{\sigma^1}g^1,\sigma^1=\sqrt{\frac{1}{2}((g^0)^2+(g^1)^2) } \\
w^{t+1}&=w^t-\frac{\eta^t}{\sigma^t}g^t,\sigma^=\sqrt{ \frac{1}{t+1} ((g^0)^2+\dots+(g^t)^2}
\end{aligned}
$$
### Adagrad 的矛盾？
從adagrad的更新式中我們會發現一個奇怪的地方，當gradient越大時，分子化越大，但分母會越小，但照理來說，gradient大時代表我們離最低點還很遠，因此我們要跨大步一點，但分母卻限制了我們，這是為何呢？
有一種說法是分母是總和過往的趨勢，看出是否gradient有突然的變化，但有更好一點的解釋是當我們看一個二次函數，從x0走到最佳點的步伐是
$$\begin{aligned}
BestStep&=|x_{0}+\frac{b}{2a}| \\
&=\frac{|2ax_{0}+b|}{2a}
\end{aligned}$$
![[Learning_rate1.png]]
因此我們判斷Best step與該點的|一次微分值|有關，當離最低點越遠，|一次微分值|越大，最佳步袱越大，但這**僅限與同一個參數相比不可跨參數比較**，如下圖所示a點明顯離最低點比c點還遠，但a點的一次微分值比c點的一次微分值還小，因此我們不能僅以|一次微分值|來作為與最低點距離的判斷標準
![[Learning_rate2.png]]
* 我們重新回到最佳步幅的公式看到除了|一次微分值|外，分母還有一個2a，我們驚訝的發現2a竟然是loss function的二次微分，將其重新考慮進最佳步幅公式會發現
$$BestStep=\frac{|一次微分值|}{二次微分值}$$
用這個公式再去看上圖會發現，a點雖然一次微分值較小，但他二次微分值也小，c點雖然他一次微分值大，但二次微分值也大
* 那上面發現的規律與adagrad的關係呢，重新思考adagrad公式
$$\begin{aligned}
w^{t+1} &\leftarrow w^t-\frac{\eta}{\sqrt{ \sum_{i=0}^n(g^i)^2}}g^t \\ \\
g^t &\rightarrow |一次微分值| \\ \\
\sqrt{ \sum_{i=0}^n(g^i)^2 } &\rightarrow 二次微分？
\end{aligned}$$
為何一次微分的分均根合可以替代二次微分呢，當你取夠多點取平均時，便可以反應二次微分的大小。
![[Learning_rate3.png]]
## Tip 2. Stochastic gradient descent(Make training faster)
* Stochastic gradient descent 跟一般的gradient descent的差別是一般的gradient descent是會先跑過所有的training data然後算Loss function再更新參數，而stochastic gradient descent是只要經過一個training data就去算他的Loss function更新參數
* gradient descent
$$\begin{aligned}
L(\theta)&=\sum_{i}\left( \hat{y}-\left( b+\sum_{i}w_{i}x_{i} \right)^2 \right)\\
\theta^t &\leftarrow \theta^{t-1}-\nabla L(\theta^{t-1})
\end{aligned}$$
* Stochastic gradient descent
$$\begin{aligned}
L(\theta)&=(\hat{y}-(b+w_{i}x_{i}))^2 \\
\theta^t &\leftarrow \theta^{t-1}-\nabla L(\theta^{t-1})
\end{aligned}$$
* Gradient vs stochastic
* Gradient優缺點
	* 穩定的朝向最低點前進
	* 更新速率較慢，尤其是當training data很多時
* Stochastic優缺點
	* 更新速度很快，每個training data都更新一次
	* 當有一個點的Loss function很大導致會突然跨一步很大，超過最低點此時又要回頭
![[Stochastic.png]]
## Tip 3. Feature scaling
* 當feature的差距很大時，如下圖，當w2有小小的波動都會對Loss function產生較大的影響，當我們畫出等高線時便會發現呈現扁橢圓形，在w1跟w2方向上所需要的Learning rate差距很大，因此較難走到最佳解，但在經過scaling後變化發現成圓形，兩個參數所需的Learning rate也大致相同，可以很快的到達最低點
* 當是狹長橢圓行時，參數更新是沿著等高線走但不是往中心走，所以要花更多時間到最低點，但當經過scaling過後，沿著等高線走也會往中心前進，因此更新速率會較快
* 效果可以看[[Homework 2]]的第4題
![[feature_scaling.png]]
* Scaling的方法
	* 每個training data都有n個feature，對每個training data的第i個feature找出他們的mean(平均)跟standard deviation(標準差)，將每個i元素都進行標準化處理
$$x^i_{r} \rightarrow \frac{x^i_{r}-m_{i}}{\sigma_{i}}$$
# Reference
[Adagrad、RMSprop、Momentum and Adam – 特殊的學習率調整方式](https://hackmd.io/@allen108108/H1l4zqtp4)
[]()