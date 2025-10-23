---
created: 2025-08-03T14:22
updated: 2025-10-20T21:43
title:
---
2025-09-30 10:58

Status:

Tags:
目錄:
# Classification
* 我們是否可以用Regression的方法來實做classification問題呢？像是假設class 1為1，class 2為2，依此類推
結論是不行的，假設真的用regression來做classification，結果大於1為class 1小於1為class 2，用MSE來作為loss function，產生兩個問題
1. 當那些出來很正確的數值例如100，之類的代表很明顯是class 1，但在算loss function時會被當成誤差很大因此要修正(too correct seemed as error)
2. 若用class 1為1, class 2為2, class 3為3...這種方法，代表class 1與class 2比較相近，class 2與class 3比較相近，class 1跟class 3相差較遠，如果實際情況並分這樣，則可能造成很大誤差
![[Classificatin_as _regression.png]]
* 另外一種做法(Recall model 決定三步驟)
1. Function(model):x作為input
$$\begin{aligned}
f(x)&=\begin{cases}
g(x)\geq0.5,output=class1 \\ 
g(x)<0.5,output=class2
\end{cases}
\end{aligned}$$
2. Goodness of model(Loss function):
$$L(f)=\sum_{n} \delta(f(\hat{x})\neq \hat{y})$$
3. Find best function：用[[Kernel methods]]裡的SVM
## Probabilistic Generative model
* Two boxes questions
我們嘗試用two boxes問題來帶出機率與分類的關係。
假設現在有兩個箱子B1跟B2，B1有4藍1綠，B2有2藍3綠，抽中藍色時他是B1的機率為
$$P(B_{1}|Blue)=\frac{P(B_{1})P(Blue|B_{1})}{P(B_{1})P(Blue|B_{1})+P(B_{2})P(Blue|B_{2})}$$
這同樣可以應用在分類上，像是抽到的x屬於C1的機率為:
$$P(class_{1}|x)=\frac{P(class_{1})P(x|class_{1})}{P(class_{1})P(x|class_{1})+P(class_{2})P(x|class_{2})}$$
這種方法只要我們能從trainging data裡得出
$$P(class_{1}),P(class_{2}),P(x|class_{1}),P(x|class_{2})$$
就能知道x屬於class 1的機率為何，而
$$P(class_{1})P(x|class_{1})+P(class_{2})P(x|class_{2})$$
稱為Generative model。

![[two_classes.png]]
* 仍以寶可夢分類做為例子，training data有79個水系寶可夢，現在有一個寶可夢當作輸入，計算可能是水系寶可夢的機率，而輸入是寶可夢的feature，像是Defense跟SP defense為例。
假設水系寶可夢的特徵分佈是一個 **Gaussian Distribution**，得到這個分佈後將新的點帶入可以得知這個分佈便可以知道這個分佈sample出這個點的機率為何。
![[Classification_feature.png]]
* **Gaussian Distribution**是由兩個變數來定整個分佈的Σ(變異數)跟μ(平均)，不同變異數跟不同平均行程的高斯分佈會不同
公式:
$$f_{\mu,\sum}(x)=\frac{1}{(2\pi)^{D/2}} \frac{1}{|\sum|^{1/2}}\exp{-\frac{1}{2}(x-\mu)^T\sum^{-1}(x-\mu)}$$
假設所有的點都是從Gaussian distribution裡sample出來的，那要如何回推出Gaussian distribution呢
* Maximum Likelihood
其實不論是哪種Gaussian distribution(不同Σ(變異數)跟μ(平均))都有可產生那79個training data。
但不同的Gaussian distribution產生那79個training data的機率不同，而我們要找的是**產生79個training data機率最高的Gaussian distribution**。
* 高斯函數sample 出79 training data的機率可能性(likelihood)為
$$L\left( \mu,\sum \right)=f_{\mu,\sum}(x_{1})f_{\mu,\sum}(x_{2})..f_{\mu,\sum}(x_{79})$$
![[Maximum_likelihood.png]]
假設𝜇∗, Σ∗會讓likelihood變成最大
$$\begin{aligned}
\mu^*,\sum^{*}&=arg Max_{\mu,\sum}L\left( \mu,\sum \right) \\
\mu^{*}&=\frac{1}{79}\sum_{n=1}^{79}x_{n} \\
\sum^*&=\frac{1}{79}\sum_{n=1}^{79} (x_{n}-\mu^{*})(x_{n}-\mu^{*})^T
\end{aligned}$$
![[Maxiam_likelihood_esample.png]]
我們透過找到class 1跟class 2的Gaussian distribution function(得到你在class 1 sample p跟class 2 sample p的機率)，帶入機率公式，可以得到結論
$$\begin{aligned}
P(class_{1}|x)&=\frac{P(class_{1})P(x|class_{1})}{P(class_{1})P(x|class_{1})+P(class_{2})P(x|class_{2})} \\ \\
P(class_{1}|x)&=\begin{cases}
\geq 0.5,屬於class_{1} \\ \\
<0.5屬於class_{2}
\end{cases}
\end{aligned}$$
但其實這個分類方法在著個case並沒有很好，在只考慮defense跟SP defense情況時，準確率只有47％，就算將7個特徵全部考慮進來，準確律也只有54％，跟瞎猜差不多。
![[result1.png]]
* 但常見的model會讓兩個Gaussian distribution**共用相同的的covariance**，因此我們可以改寫loss function，假設training data 1-79是class 1,80-140是class 2，loss function會等於
$$L\left( \mu^1,\mu^2,\sum \right)=L_{\mu_{1},\sum}(x_{1})\dots L_{\mu_{1},\sum}(x_{79})L_{\mu_{2},\sum}(x_{80})\dots L_{\mu_{2},\sum}(x_{{140}})$$
而共用的covariance是兩個分別class的加權平均(根據training data的數量)
$$\sum=\frac{79}{140}\sum^1+\frac{61}{140}\sum^2$$
換成共用covariance後分隔兩個class的界線變成一條直線！！！，且正確率大幅提高從54％到73％。
* 回頭來看training model的三個step
1. Function set：Probability Generative model
$$P(class_{1}|x)=\frac{P(class_{1})P(x|class_{1})}{P(class_{1})P(x|class_{1})+P(class_{2})P(x|class_{2})}$$
2. Goodness of function:用Maximum likelihood來決定參數Σ(變異數)跟μ(平均)看哪種參數產生我們給的training data機率最高
3. Pick the best function：
$$\mu=\frac{1}{N}\sum_{i=1}^Nx^N,\sum=\frac{1}{N}\sum_{i=1}^N(x_{i}-\mu)^T(x_{i}-\mu)$$
### Connection between Probability Generartive Model to Logistic Regression
簡單整理一下model可以發現
$$\begin{aligned}
P(C_{1}|x)&=\frac{P(C_{1})P(x|C_{1})}{P(C_{1})P(x|C_{1})+P(C_{2})P(x|C_{2})} \\
&=\frac{1}{1+\frac{P(C_{2})P(x|C_{2})}{P(C_{1})P(x|C_{1})}} \\
&=\frac{1}{1+\exp(-z)} \\
&=\sigma(z) \ (Sigmoid\ function)\\ \\
where\ z&=\ln\frac{P(C_{1})P(x|C_{1})}{P(C_{2})P(x|C_{2})}
\end{aligned}$$
![[Sigmoid_function.png]]
* 整理一下z:
![[LR_proof1.png]]
![[LR_proof2.png]]
![[LR_proof3.png]]
還可以更加簡化，因為我們的**兩個Gaussian distribution共用一個covariance**

$$\begin{aligned}
z&=((\mu^1)^T-(\mu^2)^T)\sum^{-1}x-\frac{1}{2}(\mu^1)^T\sum^{-1}(\mu^1)+\frac{1}{2}\mu_{2}^T\left( \sum \right)^{-1}\mu^2+\ln N_{1}
/N_{2} \\
&=wx+b \\
P(C_{1}|x)&=\sigma(wx+b) \ (Logistic \ \mathrm{Re}gression!!!)

\end{aligned} 

$$
* 在Generative function我們要先找到
$$N_{1},N_{2},\mu^1,\mu^2,\sum$$
才能找到w,b，但這就繞了一圈，那為何不直接找w跟b呢？這就是Logistic regression的精神。
## Logistic Regression
Logistic regression適用二元分類。
照著training model的三大步驟來說明Logistic regression的內容。
### Step 1.Function set
我們的目標是要找到
$$P_{w,b}(C_{1}|x)=\begin{cases}
\geq 0.5,output\ is \ C_{1} \\ \\
<0.5,output\ is\ C_{2}
\end{cases}$$
$$\begin{aligned}
P_{w,b}(C_{1}|x)&=\sigma(z) \\
&=\sigma (wx+b),\sigma \ is \ sigmoid\ function
\end{aligned}$$
x是所有的特徵，透過sigmoid function將輸出轉為機率。
![[Logistic_part1.png]]
### Step 2.Goodness of function
假設有一組共n筆trainging data: x1->c1,x2->c1, x3->c2,...,xn->c1，假設這組training data是由一個機率函數生成出來的
$$f_{w,b}(x)=P_{w,b}(c_{1}|x)$$
我們可以計算出生成這個training data的機率(可能性)為
$$\begin{aligned}
L(w,b)&=f_{w,b}(x_{1})f_{w,b}(x_{2})(1-f_{w,b}(x_{3}))\dots f_{w,b}(x_{n})
\end{aligned}$$
而我們要找的目標是要讓這個可能性最大化，也就是要找到能讓這個機率最大化的w,b。
$$\begin{aligned}
argMax_{w,b}L(w,b)&=argMax_{w,b}\ln(L(w,b)) \\
&=argMin_{w,b}-\ln(L(w,b))
\end{aligned}$$
上式皆等效，因此我們把目標轉換至找到w,b使-ln(L(w,b))最小化，假設**c1->1,c2->0**，將L(w,b)展開後:
$$\begin{aligned}
-\ln(L(w,b))&=-(\ln f_{w,b}(x_{1})+\ln f_{w,b}(x_{2})+\ln(1-f_{w,b}(x_{3}))+\dots+f_{w,b}(x_{n})) \\ \\
&=-\sum_{n}(\hat{y}\ln f_{w,b}(x_{n})+(1-\hat{y})\ln (1-f_{w,b}(x_{n})))\\
&Cross\ entropy\ of\ two\ Bernoulli's\ distribution 
\end{aligned}$$
我們發現我們要minimize的function恰好是**目標結果(y)跟預測結果(f_w,b(x))做cross entropy**，其意義是檢測兩個機率分佈的相似程度，越靠近0越相似，這也解釋了為何我們要minimize這個函數。
Cross entropy:
$$\begin{aligned}
C(f_{w,b}(x_{n}),\hat{y}_{n})=-\sum_{n}(\hat{y}_{n}\ln f_{w,b}(x_{n})+(1-\hat{y}_{n})\ln(1-f_{w,b}(x_{n})))
\end{aligned}$$

### Step 3.Select the best function
* 要在這個cross entropy函數找到能使這個函數到global minimum的w,b，使用**Gradient descent!!!**
分別對w跟b做偏微分找出更新式：
* 對w:
$$\begin{aligned}
-\frac{\partial}{\partial w}\ln L(w,b)&=-\sum_{n}\left( \hat{y}_{n}\frac{\partial}{\partial w} \ln f_{w,b}(x_{n})+(1-\hat{y}_{n}) \frac{\partial}{\partial w}\ln (1-f_{w,b}(x_{n})) \right) \\
\frac{\partial}{\partial w}\ln f_{w,b}(x_{n})&=\frac{\partial}{\partial w}\ln\sigma(z) \\
&=\frac{1}{\sigma(z)} \frac{\partial \sigma(z)}{\partial z}\frac{\partial z}{\partial w},\ \frac{\partial \sigma(z)}{\partial z}=\sigma(z)(1-\sigma(z)) \\
&=(1-\sigma(z))w \\
\frac{\partial}{\partial w}\ln(1-f_{w,b}(x_{n}))&=\frac{1}{1-\sigma(z)}-\sigma(z)(1-\sigma(z))w\\
&=-\sigma(z)w \\
將結論帶回原式得:
-\frac{\partial}{\partial w}\ln L(w,b)&=-\sum_{n}(\hat{y_{n}}(1-\sigma(z))w-(1-\hat{y_{n}})\sigma(z)w) \\
&=\sum_{n} -(\hat{y_{n}}-f_{w,b}(x_{n}))w
\end{aligned}$$
* 對b
$$\begin{aligned}
-\frac{\partial}{\partial b}\ln L(w,b)&=-\sum_{n}\left( \hat{y}_{n}\frac{\partial}{\partial b} \ln f_{w,b}(x_{n})+(1-\hat{y}_{n}) \frac{\partial}{\partial b}\ln (1-f_{w,b}(x_{n})) \right) \\
\frac{\partial}{\partial b}\ln f_{w,b}(x_{n})&=\frac{\partial}{\partial b}\ln\sigma(z) \\
&=\frac{1}{\sigma(z)} \frac{\partial \sigma(z)}{\partial z}\frac{\partial z}{\partial b},\ \frac{\partial \sigma(z)}{\partial z}=\sigma(z)(1-\sigma(z)) \\
&=(1-\sigma(z)) \\
\frac{\partial}{\partial b}\ln(1-f_{w,b}(x_{n}))&=\frac{1}{1-\sigma(z)}-\sigma(z)(1-\sigma(z))\\
&=-\sigma(z) \\
將結論帶回原式得:
-\frac{\partial}{\partial b}\ln L(w,b)&=-\sum_{n}(\hat{y_{n}}(1-\sigma(z))-(1-\hat{y_{n}})\sigma(z)) \\
&=\sum_{n} -(\hat{y_{n}}-f_{w,b}(x_{n}))
\end{aligned}$$
所以我們的更新式為:
$$\begin{aligned}
w^{i+1} &\leftarrow w^i-\eta \sum-(\hat{y_{n}}-f_{w,b}(x_{n}))w \\ \\
b^{i+1} &\leftarrow b^i-\eta \sum-(\hat{y_{n}}-f_{w,b}(x_{n})) \\
\end{aligned}$$
* 為何在Logistic regression不像linear regression一樣用MSE當作loss function呢？
參考下圖，若我們用MSE作為loss function，在計算他的gradient時，當我們目標為0，預測為0時，梯度為0，合理因為預測正確，但當我們預測是1，梯度仍為0，不更新，這就不合理，因為離實際值很遠照理來說要跨大步。
![[Logistic_MSE.png]]
### Discriminative vs. Generative model
* 在大部份情況下，Discriminative(Logistic regression)會表現的比Generative model來得好，因為Generative model有做一些假設(腦補)，例如兩個分佈的covariance相同等等的，除非在訓練資料很少時，腦補會有妙用。
### Multi-class Classification
* 當要分變得種類不只一類是，我們就不能單純用sigmoid function找出屬於C1的機率了，而是要將每一類都有自己不同的w,b將特徵帶入後，用softmax 函數將輸出轉為x屬於class 幾的機率。
* Softmax函數
$$y_{n}=\frac{e^{z_{n}}}{\sum_{i=1}^ne^{z_{i}}}$$
* 然後將輸出與目標輸出做cross entropy找出每個class最佳的w,b。
![[Multi-class1.png]]
![[Multi-class2.png]]
### Limitation of Logistic regression
* Logistic regression 分隔兩個class的超平面是一直線，當遇到同一類剛好在斜對角時，找不到一個好的超平面將其分類正確，當你切一邊時，令一個同類的誤差會特別大。
![[Logistic2.png]]
* 沒有辦法分好的原因可能是特徵沒有那麼好，我們可以透過讓**機器自己轉換特徵**，將特徵轉成容易被直線劃分特徵，藉由將Logistic regression並聯跟串連在一起，得到特徵轉換的效果。
* 如下圖，用z1跟z2將特徵x1,x2轉成x1',x2'，較易被直線分類的特徵後，再用另外一個logistic regression做分類。

![[Logistic4.png]]
![[Logistic3.png]]
![[Logistic5.png]]
* 這種將logistic regression串並聯接在一起，他們可以作為各自的input跟output這種網路，稱為**neuro network**，這個就是[[Deep Learning]]!!!
# Reference