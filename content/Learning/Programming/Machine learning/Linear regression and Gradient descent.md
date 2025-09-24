---
created: 2025-08-03T14:22
updated: 2025-09-21T23:40
title:
---
2025-09-10 12:56

Status:

Tags:
# Linear regression and Gradient descent
老師投影片重點
### **1. 線性回歸基礎**
- 線性模型方程式：h(x) = θ₀ + θ₁x₁ + ... + θₙxₙ
- 設計矩陣 X 和參數向量 θ
- 預測值計算：Xθ
- 問題: 
	1. why x0=1
	2. 線性模型的缺點
### **2. 成本函數 (Cost Function)**
- 均方誤差 (MSE)：J(θ) = (1/2m)∑(hθ(x⁽ⁱ⁾) - y⁽ⁱ⁾)²
- 矩陣形式：J(θ) = (1/2)(Xθ - y)ᵀ(Xθ - y)
### **3. 正規方程式 (Normal Equation)**
- 解析解：θ = (XᵀX)⁻¹Xᵀy
- 矩陣不可逆問題和解決方案
- 問題
	- 矩陣推導的詳細過程
	- theta是線性模型的參數，要找到使cost function最小的theta
	- Gradient是啥
	- optimizer是啥(2021年有)
### **4. 梯度下降基礎**
- 更新規則：θ := θ - α∇J(θ)，希望能降到最小值
- 學習率 α 的影響
- LMS 更新規則
- 問題:
	- 為啥要用gradient, 背後原理是啥
	- LMS update rule 在convex函數只會落到absolute minimum，因為沒有local minimum
### **5. 梯度下降變體**
在不是convex function 時要如何避免落到local minimum
- Batch Gradient Descent
	- Batch vs epoch
	- Batch size trade-off
- Stochastic Gradient Descent (SGD)
- Mini-batch Gradient Descent

### **6. 優化問題**
- Local minima vs Global minimum
- 凸函數特性
- 避免局部最小值的方法
### **7. 進階優化器**
- Momentum
- Adam
- RMSProp
### **8. 機率解釋**
- 高斯噪聲假設
- 最大似然估計 (MLE)
- 與最小二乘法的關係
### **9. 局部加權回歸 (LWR)**(只要了解概念就好了)
- 非參數方法
- 權重函數
- 帶寬參數 τ
# Linear regression
## Linear model example
* 我們以預測寶可夢進化後的cp值(scalar)當作例子，我們現在有1. 現在的cp值2.現在的重量3. 現在的高度4. 現在的屬性 ，都可以作為linear regression的輸入 
![[Linear_regression_example.png]]
### Step 1. Choose model
* 在這邊我們選擇的是**Linear model**: $$y=b+\sum w_{i}x_{i}$$，(wi,b)屬於參數，而xi是屬於feature，即我們認定可能會影響輸出的因素，我在這裡***猜測**會影響未來cp值的只有現在的cp值，因此我的function set是$$y=wx_{cp}+b$$
* 由於`w`跟`b`的數值都沒有限制，因此有無限種可能，(w,b)可能是(10.0,9.0),(-12.0,90.0)...，那我們該如何衡量我們選的(w,b)是好是壞呢？
### Step 2. Goodness of function
* 衡量參數好壞的步驟
	* 假設我們收集10份data，裡面包含**已經確定**的10組進化與進化後的cp 值，分別為:$$(x_{1},\hat{y}_{1}),\dots,(x_{10},\hat{y}_{10})$$
	* 然後以**1. training data** 和 **2. function set 裡的function**作為輸入來定義一個function叫做**Loss function**來幫助我們判斷參數好壞(在linear model裡不同function的差別在於`(w,b)`，因此很常用`(w,b)`來代替`(f)`的表示
	* Loss function的定義:
	$$\\\begin{aligned}

L(f)=\sum^{10}_{n=1} (\hat{y}-f(x^{n}_{cp}))^2 \\ L(w,b)=\sum^{10}_{n=1} (\hat{y}-(wx^{n}_{cp}+b))^2\end{aligned}  $$
###  Step3. Select the best function
* 已經有loss function後，最佳function就是要找出最好的參數使得loss function的值最小化，以數學是來表示是:$$\begin{aligned} f^{*}=argminL(f) \\ (w^{*},b^{*})=argminL(w,b)\end{aligned}$$
* 要求得最小值有兩種方法，第一種是用數值解(Normal equation)，第二種是用偏微分(gradient descent)
#### Method 1. Normal equation
#### Method 2. Gradient descent(perfered)
* 先假設loss function只有一個參數`w`作為範例，根據gradient descent步驟:
	* 先隨便選一個`w`稱之為`w0`
	* 計算$$\frac{\partial L}{\partial w}|_{w=w_{0}}$$，`w`更新的方向藉由上式判斷，當斜率為負代表現在正在走下坡，要往x軸**正向**繼續前進才能到達最低點，反之，當斜率為正時代表我們現在在走上坡，此時應該往**x軸負向**前進
	* 更新公式(**LMS update rule**):$$w^{*}=w_{0}-\eta\frac{\partial L}{\partial w}|_{w=w_{0}}$$，η被稱為**Learning rate**，`η`與`w`對`L`的偏微共同決定`w`更新的速率
![[Gradient0.png]]
* 但我們根據下圖會發現，當你的loss function同時具備local minimum跟global minimum時，如果十分不幸的先遇到local minimunm，會導致`w`對`L`的偏微為0，使得`w`不再更新，但幸好在linear regression不會遇到這種情況，因為他的loss function只有global minimun
![[Gradient1.png]]
* 現在回到有兩個參數`(w,b)`的情況，其實跟只有一個參數的情況同理
	* 首先任意選取一組(w0,b0)
	* 更新w0,b0:$$\begin{aligned} w_{1}\leftarrow w_{0}-\end{aligned}\frac{\partial L}{\partial w}|_{w=w_{0},b=b_{0}}, b_{}{1}\leftarrow b_{0}-\frac{\partial L}{\partial b}|_{w=w_{0},b=b_{0}} \\ $$ $$\begin{aligned} w_{2}\leftarrow w_{1}-\end{aligned}\frac{\partial L}{\partial w}|_{w=w_{1},b=b_{1}}, b_{}{2}\leftarrow b_{1}-\frac{\partial L}{\partial b}|_{w=w_{1},b=b_{1}} \\ $$
### Different model's result
* 我們以線性，2階，3階，4階，5階model的表現來比較如下表

| model                                                                               | best function                                              | training average error | testig average error |
| ----------------------------------------------------------------------------------- | ---------------------------------------------------------- | ---------------------- | -------------------- |
| $$y=b+wx_{cp}$$                                                                     | $$b=-188.4, w=2.7$$                                        | `31.9`                 | `35.0`               |
| $$y=b+w_{1}x_{cp}+w_{2}(x_{cp})^2$$                                                 | $$b=-10.3, w_{1}=1.0,w_{2}=2.7*10^{-3}$$                   | `15.4`                 | `18.4`               |
| $$y=b+w_{1}x_{cp}+w_{2}(x_{cp})^2+w_{3}(x_{cp})^3$$                                 | $$b=6.4, w_{1}=0.66,w_{2}=4.3*10^{-3},w_{3}=-1.8*10^{-6}$$ | `15.3`                 | `18.1`               |
| $$y=b+w_{1}x_{cp}+w_{2}(x_{cp})^2+w_{3}(x_{cp})^3+x_{4}(x_{cp})^4$$                 |                                                            | `14.9`                 | `28.8`               |
| $$y=b+w_{1}x_{cp}+w_{2}(x_{cp})^2+w_{3}(x_{cp})^3+x_{4}(x_{cp})^4+w_{5}(x_{cp})^5$$ |                                                            | `12.8`                 | `232.1`              |
* 我們可以發現當我們開始提高model的階數，training 跟testing error 都以明顯下降直到4階函數，training 的average error依然有下降但testing average error卻上昇了，這代表迷行過份專注於迎合training data而降低了預測未知數據的能力，這個現象稱為**overfitting**因此最好的model選擇是training error跟testing error都相對低的3階model。
![[Overfitting.png]]
### Redesign the model
![[features.png]]
* 我們之前假設未來cp值只與現在的cp 值有關，但根據我們所收集的數據，似乎不同品種所跟隨的線不同，而且伊布似乎不是非常線性，我們假設新的模型會依據不同的品種有不一樣的`(w,b)`，我們將模型定義為:$$\begin{aligned}y=b_{1}(\delta(x_{s}=Pidgey))+w_{1}x_{cp}(\delta(x_{s}=Pidgey)) \\ +b_{2}(\delta(x_{s}=Weedle))+w_{2}x_{cp}(\delta(x_{s}=Weedle)) \\ +b_{3}(\delta(x_{s}=Caterpie))+w_{3}x_{cp}(\delta(x_{s}=Caterpie)) \\ +b_{4}(\delta(x_{s}=Eevee))+w_{4}x_{cp}(\delta(x_{s}=Eevee))  \end{aligned}$$，使用這個模型後，會使testing error變成`14.3`，trainging error變成`3.8`
* 模型有非常多種定義方式，會影響未來的cp值也可能不只跟現在的cp值有關，可能也跟體重，高度那些有關，可以多嘗試不同種類的搭配像是**1. 增加feature 2. 試試不同種model**等等，但注意不要太過複雜以免發生overfitting
### Regularization
* **Regularization是一種重新定義loss function的方法**，可以減少高次階model的overfitting，我們將新的loss function定義為:$$L=\sum_{n}(\hat{y}-(w_{i}x_{i}+b))^2+\lambda \sum (w_{i})^2$$，多考慮這樣向的原因是我們希望loss function變得平滑一點，因為高階model比較容易受到noise(雜訊)的影響，而加上後面那一項會讓loss function傾向取得較小的`wi`值
* 後面那項與`b`沒關係是因為那是截距與函數的陡峭程度無關
* 而為啥`wi`越小越不會受到雜訊影響是因為:$$y+\sum(w_{i}\Delta x_{i})=b+\sum(w_{i}(x_{i}+\Delta x_{i})$$，當`wi`越小越不會受到`Δxi`的影響。
## Gradient in math
---
# Reference
[Normal equatoin推導](https://medium.com/@gatorsquare/ml-normal-equation-%E6%AD%A3%E8%A6%8F%E6%96%B9%E7%A8%8B%E5%BC%8F-9f1c09de4217)
[Regression](https://www.youtube.com/watch?v=fegAeph9UaA)
[Gradient descent](https://www.youtube.com/watch?v=yKKNr-QKz2Q)
[Latex change line method in obsidian](https://forum-zh.obsidian.md/t/topic/15889)
