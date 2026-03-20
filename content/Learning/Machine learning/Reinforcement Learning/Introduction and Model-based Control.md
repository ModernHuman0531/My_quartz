---
created: 2025-08-03T14:22
updated: 2026-03-20T14:57
title:
---
2026-03-14 13:35

Status:

Tags:
目錄(ctrl+p):
# Introduction and Model-based Control
## Introduction to RL
### Overview
我們可以用簡單一句話來描述強化學習(Reinforcement Learning):
**Learn** to take a **sequence of actions** to achieve specific **goal** in an unknown environment.
* Learn: 代表我們事先不知道環境如何活動的
* Sequence of actions:表示含環境多次互動嘗試不同決定與學習
* Goal:例如得到最高的reward
我們如何與環境互動的方式如下圖所示:
![[actions.png]]
> Trajectory(軌跡)：代表狀態(S), 動作(a)，到下一個狀態所得到的獎賞(r)，所組成的一連串過程

在agent與環境互動時，會作用一連串的actions，並觀察到一連串的狀態變化states，與獲得到新狀態的rewards。

通常，一個RL算法由包含兩個要素：
1. Model：描述環境如何跟agent產生互動
	包含**transition model**(描述各個state是如何變化的)與**Reward model**(描述狀態轉移時到新state會得到的reward)
2.  Policy(策略)：用$\pi$來表示，描述狀態(s)與動作(a)間的關係，分為兩種：
	1. Determistic Policy：代表在狀態s下只會採取一固定的動作(a)$$\pi(s)=a$$
	2. Stochastic Policy：代表在狀態(s)下，他會給出**每個可能動作的機率分佈**$$\pi(a|s)=P(A_{t}=a|S_{t}=s)$$
	而policy如何在RL裡持續被優化(觀察目前狀態s -> 根據policy來決定action -> 得到環境給的reward後跳成下一個狀態 -> 學習並更新policy已達到Goal)，會在[[Policy Gradient]]裡說明推導過程
而目前的RL演算法會根據是否有model分成兩種：
* Model-based：
	* 特點：會建立一個對環境的理解，學習環境的動態模型，並利用模型來規劃與思考，例如再做下一個動作前先模擬一遍做動作的後果，再決定要不要做。
	* 學習動態模型代表學會：
		* Transition model:$P(s_{t+1}|s_{t},a)$
		* Reward model:$R(a_{t}|s_{t})$
	* 演算法：Dyna-Q, AlphaZero, MBPO
* Model-free：
	* 特點：不常是預測環境會如何變化，而是採用試錯法來讓agent知道在什麼state下做什麼action所得到的reward最好。
	* 演算法：Q-learning, PPO

## Markov Decision Process
---
建構環境的方法有很多種，其中最基礎且重要的方法則是**Markov Decision Process(MDP)**。
### Markov chain
Markov chain代表一系列的狀態轉移，而箭頭上的數字則代表狀態轉移的機率
<img src="markov_chain.png" width="50%" height ="auto">
而為何叫markov chain的原因試因為他滿足Markov property，也就是**下一個state只會受當前state的影響**。
> Markov Property
> A state $s_{t}$ is Markov if and only if $$P(s_{t+1}|s_{t})=P)(s_{t+1}|s_{1},\dots,s_{t})$$

> Markov Chain
> Markov chain is (S,P) is specified by:
> 1. State space S: a (finite) set of possible states.
> 2. Transition Matrix T: $P=[P_{ss^\prime}]$ with elements $P_{ss^\prime}=P(s_{t+1}=s^\prime|s_{t}=s)$

P是一個$|S|\times|S|$的矩陣$$P=
\left[
\begin{array}{ccc}
    P_{11} & P_{12} & ... & P_{1n} \\
    P_{21} & P_{22} & ... & P_{2n} \\
    \vdots & \vdots & \ddots & \vdots \\
    P_{n1} & P_{n2} & ... & P_{nn}
\end{array}
\right]$$
而P矩陣有兩個性質：
1. 所有的值大於等於0，因為每個值都代表機率
2. 每一行的值相加等於1，因為把每一種可能的狀態機率相加結果應該要是1
### Markov Reward Process
---
在markov chain的基礎下，如果我們有要達到的goal，就要引入reward function(每一個state都有對應的reward)，而我們將這個定義為Markov Reward Process:

> Markov Reward Process(MRP)
> An MRP (S, P, R, $\gamma$) is specified by 
> Environment Dynamic:
> 1. State Space
> 2. Transition Matrix $P=[P_{ss^\prime}]$ with $P_{ss^\prime}=P(s_{t+1}=s^\prime|s_{t}=s)$
> 
> Task:
> 3. Reward function $R_{s}=\mathbb{E}[r_{t+1}|s_{t}=s]$(In state s. the expectation reward of current state)
> 4. Discount factor $\gamma \in [0, 1]$

Markov Reward Process代表一個狀態轉移的系統，且每一個狀態都有相對應的即時reward，並且轉移的過程滿足markov property.

接下來我們要定義兩個函數來衡量reward跟在這個state有多好。第一個是Return function，代表follow一個固定的trajectory，從現在這個時間點t開始，未來所有的reward總和。第二個是Value function，代表現在在這個state考慮所有可能的trajectory我return value的期望值有多大，越大表示我在這個state我能獲得的reward越多這個state越好。

> **Return $G_{t}(\tau)$**: Cumalative discounted reward of a trajectory $\tau$ from t and onward$$G_{t}=r_{t+1}+\gamma r_{t+2}+\gamma ^2 r_{t+3}+...=\sum_{k=0}^\infty \gamma^k r_{t+k+1}$$
> Value function **V(s)**: Expected return if we start from a state s
> $$
\begin{aligned}
V(s) &=\mathbb{E}[G_{t}(\tau)|s_{t}=s] \\
&= \mathbb{E}[r_{t+1}+\gamma r_{t+2}+\gamma ^2 r_{t+3}+...|s_{t}=s]
\end{aligned}
$$

Reward的計算非常容易且直觀，但我們該如何計算Value function呢，不然我們無法衡量現在這個state究竟好不好？

因為V(s)是所有可能的$\tau$算出的reward的期望值，所以理論上只要抽樣夠多的$\tau$，則他們$G_{t}(\tau)$的平均便是V(s)，這是暴力解。

另一種方法則是利用Recurssion(Dynamic Programming):
$$
\begin{aligned}
V(s) &=\mathbb{E}[G_{t}|s_{t}=s] \\
&= \mathbb{E}[r_{t+1}+\gamma r_{t+2}+\gamma ^2 r_{t+3}+...|s_{t}=s] \\
&= \mathbb{E}[r_{t+1}+\gamma G_{t+1}|s_{t}=s] \\
&= \mathbb{E}[r_{t+1}|s_{t}=s]+ \gamma \mathbb{E}[G_{t+1}|s_{t}=s] \\
&= R_{s} + \gamma \sum_{s^\prime} P(s^\prime|s_{t}=s) \mathbb{E}[G_{t+1}|s_t=s, s_{t+1}=s^\prime] \\
&= R_{s} + \gamma \sum_{s^\prime} P(s^\prime|s_{t}=s) \mathbb{E}[G_{t+1}|s_{t+1}=s^\prime] \\
&= R_{s} + \gamma \sum_{s^\prime} P_{ss^\prime} V(s^\prime)
\end{aligned}
$$
1. 第3到第4個等式是利用期望值的linear operation特性拆分而成
2. 第四到第五個等式則是利用**Law of Iterated Expectation(LIE)** 相等的。由於$G_{t+1}$完全取決於我們的$s_{t+1}$上，因此我們考慮所有可能的$s_{t+1}$並計算期望值。
由此我們可以推導出MRP所用的Bellman Expectation Equation:
> **Bellman Expectation Equation** for MRP
>$$
V(s)=R_{s}+\sum_{s^\prime}P_{ss^\prime}V(s^\prime)
$$

Bellman Expectation Equation寫成矩陣形式為：
$$
V=R+ \gamma PV \\
=> 
\left[
\begin{array}{ccc}
    V(s_1) \\
    V(s_2) \\
    \vdots \\
    V(s_n) 
\end{array}
\right] =
\left[
\begin{array}{ccc}
    R_1 \\
    R_2 \\
    \vdots \\
    R_n 
\end{array}
\right] + \gamma
\left[
\begin{array}{ccc}
    P_{11} & P_{12} & ... & P_{1n} \\
    P_{21} & P_{22} & ... & P_{2n} \\
    \vdots & \vdots & \ddots & \vdots \\
    P_{n1} & P_{n2} & ... & P_{nn}
\end{array}
\right]
\left[
\begin{array}{ccc}
    V(s_1) \\
    V(s_2) \\
    \vdots \\
    V(s_n) 
\end{array}
\right]
$$
因為$V=R+\gamma PV$，經由推導可得$(I-\gamma P)V=R$，而$V=(I-\gamma P)^{-1}R$便可得到V。
但就由反矩陣得到的解複雜度為$O(n^3)$十分沒有效率，因此需要方法來代替， 之後會介紹代替方法。

---
而MRP的第四個要素$\gamma$(Discount factor)。需要他的原因，就數學上而言，我們要確保reward會收斂，而在實際上的意義則是我們較不在乎離我們太遠的未來的reward。

$\gamma$的選擇：

* Continuing environment(Trajectory never end): 固定的$\gamma$<1
* Episodic environment(flimited trajectory):$\gamma$<1

### Markov Decision Process
在Markov Reward Process 的基礎上，加上各種可能的actions可能對transition matrix造成的影響變可以定義Markov Decision Process。
> Trajectory $\tau$ : $s_{0},r_{0},a_{1},\dots$

> **Markov Decision Process**
> An MDP (S,A,P,R,$\gamma$) is specified by:
> Environment Dynamics:
> 1. State Space S
> 2. Action A
> 3. Transition Matrix $P=[P_{ss^\prime}^a]$ with $P_{ss^\prime}^a=P(s_{t+1}=s^\prime|s_{t}=s, a_t=a)$
>
>Tasks:
>4.Reward
>5.Discount factor $\gamma \in [0,1]$

 * MDP是一個由狀態、動作、轉移矩陣跟獎勵所構成的決策過程
有了state跟action後我們變可以定義什麼是Policy(策略)：

> (Randomizded) Policy: A policy is a **conditional distribution**
 >over possible actions given state s, i.e. for any $s \in S$, $a \in A$
 >$$\pi(a|s):=P(a_t=a|s_t=s)$$
 >Moreover, $\Pi$ denotes the class of all the possible randomized policies.
 
![[policy.png]]
 
 ### MDP跟MRP間的關係
 對於一個MDP，如果我們固定一個policy $\pi(a|s)$，則
 $$P_{ss^\prime}^\pi = \sum_{a \in A} \pi(a|s) P_{ss^\prime}^a$$
 > 在固定policy之下由s->s'的機率 ＝ 對於所有可能的action a：在state s選擇action a的機率 * 選擇action a 可以從s->s'的機率
 
 $$R_{s}^{\pi}=\sum_{{a \in A}}\pi(a|s)R_{s}^a$$
 > 在固定的policy下，以s作為起點的reward = 對所有可能的action a:在state s選擇action a的機率 * 在state s選額action a的reward
 
 當policy固定時$\pi(a|s)$時，代表a已經不是一個獨立變數，而是被s所決定的隨機變數，因此從MDP降階成$\pi$ induced MRP $(S, P^\pi, R^\pi, \gamma)$。

多了actions後，我們便可以定義MDP的return 跟 Value function
>  在MRP裡沒有所謂的policy全部都是狀態轉移，但在MDP裡我們追求最好的policy，因此不同的policy會不同的value function，而用value function的大小來決定policy 的好壞。

> **Return $G_{t}(\tau)$** is the cumulative discounted reward over a single trajectory from t onward
> $$G_{t}(\tau)=r_{t+1}+\tau r_{t+2}+\tau^2r_{t+3}\dots=\sum_{k\geq_{0}}\gamma^kr(s_{t+k+1}, a_{{t+k+1}})$$
> **Value function $V^{\pi}(s)$**: Expected return under a policy $\pi$ (can be random) from a state s $$V^\pi(s)=\mathbb{E}_{\tau}[G_{t}(\tau)|s_{t}=s;\pi]$$

$V^{\pi}(s)$ 在三方面具有隨機性(Randomness)：
1. State transtition
2. Reward
3. Policy

## Model-Based Evaluation and Control
我們該如何評價一個policy的好壞呢，我們首先要定義好壞的標準是什麼？

首先我們先引入一個新的定義來評價在state s時做action a(之後還是依照policy $\pi$ )對整體reward的期望值大小，將這個函數稱為**Action-value function**
> **Action-value function** $Q^{\pi}(s,a)$ is the expected return under policy $\pi$ from a state s and action a.
> $$
Q^\pi(s, a)= \mathbb{E}[G_t|s_t=s, a_t=a;\pi]
 $$

而$V^{\pi}(s)$跟$Q^{\pi}(s,a)$可以相互表示，也可以各自寫為遞迴式，而這四種表示法我們稱為Bellman Expectation Equations:
![[V-Q.png]]
> **Bellman Expectation Equation**:
> 
> * V written in Q:
> $$
 V^{\pi}(s) = \sum_{a \in A}\pi(a|s)Q^{\pi}(s,a)
 $$
 > * Q written in V:
 > $$
 Q^{\pi}(s,a) = R_{s}^a+\sum_{s^{\prime} \in S}P_{ss^{\prime}}^aV^{\pi}(s^{\prime}) 
  $$
  > * V written in V:
  > $$
   V^\pi(s)=\sum_{a \in A} \pi(a|s) \Bigr[R_{s}^a + \gamma \sum_{s^\prime \in S} P_{ss^\prime}^a V^\pi(s^\prime) \Bigr]
   $$
   > * Q written in Q:
   > $$
  Q^\pi(s, a)=R_{s}^a + \gamma \sum_{s^\prime \in S} P_{ss^\prime}^a \Bigr[\sum_{a^\prime \in A} \pi(a^\prime|s^\prime)Q^\pi(s^\prime, a^\prime) \Bigr]
  $$

因為$V^{\pi}$可以寫成自己的遞迴式，因此只要我們給定一個policy $\pi$，便可以找出$V^{\pi}$，此即為policy evaluation.
這裡有兩種policy evaluation的方法：
1. Non-Iterative policy evaluation(Matrix form)
$$
\begin{aligned}
V^{\pi}&=R^{\pi}_{s}+\gamma P^{\pi}V^{\pi} \\
V^{\pi}&=(I-\gamma P^{\pi})^{-1}R^{\pi}_{s}
\end{aligned}
$$
2. Iteration policy evaluation:
> **Iterative MDP Policy Evaluation (IPE)**
> For a fixed policy $\pi$:
> 1. Initialize $V^{\pi}_{0}(s)=0$ for all state s
> 2. For k=1,2,$\dots$
> $$
  V^\pi_{k}(s)=\sum_{a \in A} \pi(a|s) \Bigr[R_{s}^a + \gamma \sum_{s^\prime \in S} P_{ss^\prime}^a V^\pi_{k-1}(s^\prime) \Bigr] \text{, for all s}
 $$

這代表帶入$V^{\pi}_{0}$可以得到$V^{\pi}_{1}$，帶入$V^{\pi}_{1}$可以得到$V^{\pi}_{2}$，直到收斂至一個數即為$V^{\pi}$。

---
但我們要如何保證迭代一定會收斂至$V^{\pi}$呢？
考慮一個Matrix vector space $V_0^\pi(s), V_1^\pi(s), ..., V_k^\pi(s) \in \mathbb{R}^{|S|}$，我們可以透過兩步驟來證明IPE一定會converge to $V^{\pi}(s)$

1. Proof that IPE is a contraction operator.
2. Under any contraction operator, all point converge to a fixed point.

定義IPΕ Operator:
> **IPE operator (also called Bellman expectation backup operator)**
> $$
 T^\pi(V):=R^\pi+ \gamma P^\pi V
 $$

而contraction operator的定義是給定一個函數T，測量兩個點u,v，如果經過T
處理後兩個點的距離比處理前小的話，T便是contraction operator。
我們使用$L_\infty$-norm來衡量兩個函數間的距離：
$$
||V-V^\prime||_\infty := max_{s \in S} |V(s) - V(s^\prime)|
$$
proof that **IPE is contraction operator**:
$$
\begin{aligned}
\begin{aligned}
||T^\pi(V) - T^\pi(V^\prime)||_\infty &= ||(R^\pi+ \gamma P^\pi V) - (R^\pi+ \gamma P^\pi V^\prime)||_\infty \\
&= \gamma ||P^\pi(V-V^\prime)||_\infty \\
&\leq \gamma ||V-V^\prime||_\infty
\end{aligned}
\end{aligned}
$$
> 第二至第三行不等式成立是因為$P^{\pi}$每個entry都$\leq 1$ 
> 

我們稱$T^{\pi}$為$\gamma$-contraction operator ($\gamma \leq 1$)

 至於**Under any contraction operator, all point converge to a fixed point.** 可藉由Banach Fixed-Point Theorem 得證：
 > **Banach Fixed-Point Theorem:** For any non-empty complete metric space V, if T: V->V is a $\gamma$-contraction operator with ($\gamma \leq 1$) , then T has a unique fixed point.
  >

Summary:
在IPE裡，不論是哪一個起始點$V^{\pi}_{0}$，$V^{\pi}_{k}$都會收斂至$V^{\pi}$，代表我們現在已經可以有基準可以來衡量policy了，就是透過$V^{\pi}$。

### Finding optimal policy
先給出最佳policy在value function跟action-value function的定義：
> **Optimal State-Value function**:
> $$
 V^{*}=\max_{\pi \in \Pi}V^{\pi}(s)
 $$
 依照最佳policy在state s 所能得到的expected return 

> Optimal Action-Value function
> $$
 Q^{*}(s,a)=\max_{\pi \in \Pi}Q^{\pi}(s,a)
 $$
 在state s走了action a後，之後都依照最佳policy所能得到的expected return.

那我們該如何*定義policy的好壞*呢，什麼叫policy $\pi$比policy $\pi^{\prime}$好，由以下定義：
> **Optimal Policy**: For **all state** s, optimal polcy $\pi^*$ should perform best
> 
> **Partial ordering of Policies**
> $$\pi \geq \pi^{\prime}, \text{if } V^{\pi}(s)\geq V^{\pi^\prime}(s)\text{, for all } s\in S$$
> **Optimal Policy**: A policy $\pi^*$ is said to be optimal policy if is better than or equal to all other policies, i.e.
> $$\pi^*\geq\pi \text{, for all }\pi \in \Pi$$
> 重點：在MDP 裡optimal policy $\pi^*$ 永遠存在(之後會詳細說明) 

但不是所有的polciy都可以透過比較value function的大小來決定好壞，舉例來說
<img src="Policy_compare.png" height="40%" width="60%">
分析兩個不同的起點，我可以得到
$$
\begin{aligned}
V^{\pi_{1}}(s)>V^{\pi_{2}}(s) \\
V^{\pi_{1}}(s^{\prime})>V^{\pi_{2}}(s^{\prime}) 
\end{aligned}
$$
因此單純通過value function來衡量policy好壞不太容易。

--- 
Ｏptimal policy確實存在，但我該*如何找到optimal policy*呢？
當我能計算出每一個state的最佳action-value function $Q^*(s,a)$，便能依此找到最優策略
$$\pi^*(a|s)=arg\max_{a\in A}Q^*(s,a)$$
也就是每一個狀態s，能確定最佳動作a（即最大化$Q^*(s,a)$的動作），便能找到optimal policy。
也就是說，只要能計算$Q^*(s,a)$，就等同於找到**optimal policy**。
接下來便是要討論該如何計算$Q^*(s,a)$。

定義：
> **Bellman Optimal Equation**:
> * $V^*$ written in $Q^*$:
> $$V^*(s)=\max_{a\in A}Q^*(s,a)$$
> *  $Q^*$ written in $V^*$:
> $$Q^*(s,a)=R_{s}^a+\gamma\sum_{s^{\prime}\in S}P_{ss^\prime}^aV^*(s)$$
> *  $V^*$ written in $V^*$:
> $$V^*(s)=\max_a \Bigr[R_{s}^a + \gamma \sum_{s^\prime \in S} P_{ss^\prime}^a V^*(s^\prime) \Bigr]$$
> *  $Q^*$ written in $Q^*$:
> $$Q^*(s,a)=R_{s}^a+\gamma\sum_{s^{\prime}\in S}P_{ss^{\prime}}^a(\max_{a\in A}Q^*(s^{\prime},a))$$

Bellman Optimal Equation因為有一個非線性的operator(取最大值max)，因此無法像Bellman Expectation Equation一樣用線性代數得解，但因為是遞迴式(即自己可以用自己來表示)，因此可以用**iterative**方法求解：
1. Value Iteration
2. Policy Iteration

### Value Iteration
剛剛就由推導，我們已經得知Bellman Optimal Equation:
$$
V^*(s)=\max_{a\in A} \Bigr[R_{s}^a + \gamma \sum_{s^\prime \in S} P_{ss^\prime}^a V^*(s^\prime) \Bigr]
$$
由此我們便可以來定義Bellman Optimality Operator：
> **Bellman Optimality Operator**
> $$T^*(V)=\max_{a\in A}\Bigr[R+\gamma P^aV\Bigr]$$
> 這個在等一下證明Value Iteration會收斂至一個點時很重要！！！

藉由上面兩個等式我們便可以來定義Value Iteration:
> **Value Iteration:**
> step 1. Initialize k=0, $V_{0}=0$ for all state s
> step2. Repeat until convergenve:
> 	For each state s, update by
> 		$V_{k+1} \leftarrow \max_{a\in A}\Bigr[ R_{s}^a+\gamma \sum_{s^{\prime}\in S}V_{k}(s^{\prime})\Bigr ]$
> 	Equivanlently :$V_{k+1}\leftarrow T^*(V_{k})$

而value Iteration具有三個性質：
1. **Convergence**:VI 最終都會收斂到$V^*$不論你一開始的$V_{0}$是什麼，稍後會有詳細說明。
2. **Asymptotics(漸進)**：VI可能要經過無限多次迭代才能到最終解，而一次迭代的複雜度為：$\sum_{s^{\prime}\in S}V_{k}(s^{\prime})$需要花$O(|S|)$，找所有action篩選出max花$O(|A|)$，而上述步驟要對所有的state s做一次需花$O(|S|)$，因此一次迭代的複雜度為$O(|S|^2|A|)$。
3. **Optimal policy**:當我們能求的得$V^*(s)$時，便能用greedy policy來找到optimal policy，對每個state s我們都可以找到對應的action a使得$Q^*(s,a)=R_{s}^a+\gamma P_{ss^{\prime}}^aV^*(s^{\prime})$最大化，即$$\pi^*(s)=arg\max_{a\in A}Q^*(s,a)=arg\max_{a\in A}\left( R_{s}^a+\gamma\sum_{s^{\prime}\in S}P_{ss^{\prime}}^aV^*(s^{\prime}) \right)$$
這種方法所得到的policy即為optimal policy。

接下來先簡單說明value iteration的收斂性質，我們就是用此性質來確定$V^*$是唯一解：
> **Value Iteration Converge on $V^*$**: For any initial $V_{0}$ ,Value Iteration achieve that $V_{k}\rightarrow V^*$ as $k\rightarrow \infty$(in $L_{\infty}$-norm)

此性質可以透過三個步驟來證明：
1. Proof that $T^*$ is a **Contraction Operator**:
$$
\begin{aligned}
\begin{aligned}
||T^*(V)-T^*(\hat{V})||_\infty &=  \max_s |T^*(V(s))-T^*(\hat{V(s)})| \\
&= \max_s |\max_a(R^a_s + \gamma \sum_{s^\prime} P^a_{ss^\prime} V(S^\prime)) - \max_{a^\prime}(R^{a^\prime}_s + \gamma \sum_{s^\prime} P^{a^\prime}_{ss^\prime} V(S^\prime))| \\
&\leq \max_s\max_a|(R^a_s + \gamma \sum_{s^\prime} P^a_{ss^\prime} V(S^\prime)) - (R^{a}_s + \gamma \sum_{s^\prime} P^{a}_{ss^\prime} V(S^\prime))| \\
&\leq \max_s\max_a|\gamma \sum_{s^\prime} P^a_{ss^\prime} (V(s^\prime) - \hat{V}(s^\prime))| \\
&\leq \gamma ||(V-\hat{V})||_\infty
\end{aligned}
\end{aligned}
$$
=> $T^*$ is a $\gamma$-contraction operator.
2. **Under a contraction operator, $V_{k}$ shall converge to the unique fixed point.**
proof:
Since $T^*$ is a $\gamma$-contraction operator in a complete metric space, by **Banach Fixed Point Theorem**, $T^*$ converges to the unique fixed point.
3. **Since $V^*$ is a fixed point, $V_k \rightarrow V^*$ due to uniqueness.**

--- 
我們給一個例子來示範Value Iteration 整個過程在實務上是如何進行的：
<img src="PI_exp.png"  height="20%" weight="20%">
* State Space: 當前的座標(共有9種狀態)
* Action:共有上下左右4個動作
* Reward:
	* 每移動一步，reward=-1
	* 到終點即得到寶箱，reward=0並結束遊戲(Note: 從其他點到終點時仍要花一步，也就是reward=-1)
* $\gamma=1$且$P_{ss^{\prime}}^a=1$
我們對於每個state，都根據Bellman Optimal Equation來得到下一步的value，即
$$
V_{k+1}=\max_{a\in A}\Bigr[ R_{s}^a+\gamma\sum_{s\in S}P_{ss^{\prime}}^aV_{k}(s^{\prime})\Bigr]
$$
	
迭代過程如下：
![[policy_iteration.png]]
* 初始化：對於所有state s的$V_{0}(s)=0$
* 第一次迭代：
	* 1.


### Policy Iteration


## Regularized MDP
# Reference
[Value Iteration 實際例子](https://zhuanlan.zhihu.com/p/33229439)
[學長筆記](https://hackmd.io/@tsen159/RLNote)
