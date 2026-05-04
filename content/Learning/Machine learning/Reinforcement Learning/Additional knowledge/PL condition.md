---
created: 2025-08-03T14:22
updated: 2026-03-22T15:17
title:
---
2026-03-21 15:58

Status:

Tags:
目錄(ctrl+p):
# PL condition
在一般的優化中，我們通常要求目標函數要具有強凸性(Strongly Convexity)才能保證快速收斂到唯一的極小值。但現實中(尤其是在神經網路或強化學習)，函數往往不是凸的。而PL Condition的意義是：即使函數不凸、甚至有無窮多個全域最小值，只要滿足PL，Gradient descent依然能衝像最優解。

## PL condition的定義與意義
PL 的直覺意義：梯度必須需要夠抖！！！
PL condition的數學表示形式為：
$$
\begin{aligned}
\frac{1}{2}||\nabla f(\theta)||^2\geq\mu(f(\theta)-f^*)
\end{aligned}
$$
可以理解成對函數f的性能保證：
* 左邊的$||\nabla f(\theta)||^2$：代表目前的梯度
* 右邊的$f(\theta)-f^*$：代表現在離最優解還有多遠
* 而$\mu$為固定值，因此上式又被稱作uniform PL condition
PL 的核心意義：只要還沒到最優點，那麼你腳下的坡度就絕對不能太緩（左邊也必須大於 0）。它保證了「只要有差距，就有梯度」，不會讓你卡在半山腰的平原上

在強化學習上，我們優化的目標是$J(\theta)=E[V^{\pi}(s)]$，不是V滿足PL而是$J(\theta)$(有些也可能有$V(\theta)$)滿足PL(這代表當我沿著參數$\theta$的梯度方向走時，我的進步速度會跟我離$J^*$的距離成正比)。

而在[https://arxiv.org/abs/2005.06392]這篇paper的lemma 8所要證明的東西是，他的函式滿足non-uniform PL condition，也就是說他的$\mu$不是常數而是取決於policy的變數，因此才說是non-uniform。
這篇論文的貢獻是大家以前擔心Policy Gradient會卡在局部最優，因為$J(\theta)$並非凸的，但這篇論文證明了對於softmax policy，雖然$J(\theta)$不是凸函數，但他在整個空間中滿足『non-uniform PL condition』，這意味著：
* 好消息：沒有壞的局部最小值。只要一直走，最後一定得到最優解
* 壞消息：因為他是non-uniform的，所以$\pi_{\theta}$會變得太獨斷(像是當某個動作趨近時)，PL係數會變得極小，導致得花很久時間才能更新下一步
**Mei et al. (2020)** 的這項研究，本質上是在為所有做強化學習（RL）的工程師提供一個「數學診斷報告」。它解釋了為什麼你用 Policy Gradient (PG) 訓練機器人時，常常會看到 Reward 曲線像心電圖死掉一樣平，然後突然在某個瞬間噴發。

我們可以把 **Policy Gradient 的收斂速度** 與 **Non-uniform PL 係數** 的關係拆解為以下三個現象：
 
 ---
1.為什麼會走得很慢？（平原期 Plateau）
在 Lemma 8 中，收斂速度取決於一個「阻礙因子」：
$$
\text{速度}∝\min_{s}(\frac{d^\pi(s)}{d^*(s)})^2\min_{s}(\pi_{\theta}(a^*|s))^2
$$
* **分佈不匹配：** 如果你的機器人（例如你研究的足式機器人）還在原地打轉，根本沒走到目標區域，那麼 $d^\pi$ 離 $d^*$ 極遠。這會讓 PL 係數趨近於 0，導致梯度「看起來」消失了
* **Softmax 飽和：** 如果$\theta$讓機器人太快「誤以為」往左走是對的（即便往右才是最優），那麼往右的 $\pi_{\theta}(a^*)$ 會變得極小。這會讓 PL 係數萎縮，即使現在離目標還很遠，PG 步長也會變得微乎其微。
* Distribution Mismatch Coefficient($||\frac{d^{\pi^\theta}_{\mu}}{d^{\pi^*}_{\rho}}||_{\infty}$)：
	* $\rho$：這是環境整體的初始狀態分佈，他代表我們衡量表現的基準。當我們要優化$V^*(\rho)-V^\pi(\rho)$，我們是在看，如果機器人從 ρ 分佈開始出發，目前的策略跟最優策略差多少 。
	* $\mu$：這通常是我們在分析或更新時所採用的**參考分佈**，它出現在分母的狀態佔據度（State Occupancy Measure）$d^{\pi^\theta}_{\mu}$中。它決定了你的演算法「看過」哪些地方。這是**探索（Exploration）**。代表你實際拿來訓練的數據涵蓋了哪些狀態。
		* 分子$d^{\pi^*}_{\rho}$:最優策略$\pi^*$從目標分佈$\rho$出發會經過哪些路徑
		* 分母$d^{\pi^\theta}_{\mu}$:目前的策略 πθ​ 從參考分佈 μ 出發實際走過哪些路徑
2.什麼它「保證」會收斂
* **沒有死胡同：** J(θ) 的地形雖然有很多平原，但**沒有局部極小值（Local Minima）**
* 只要你給它無限的時間，或者是你的機器人「運氣好」撞到了正確的狀態與動作，PL 係數就會回升，帶領你脫離平原
3.如何處理non-uniform 所造成的收斂緩慢
這篇論文最精采的後半部（關於 **Entropy Regularization** 或 **Log-barrier**）解釋了現代演算法（如 PPO, SAC）為何強大：
* **人工補償：** 加上正則化後，數學上相當於在 PL 係數的底部加了一塊墊片，強迫$\pi_{\theta}(a)\geqϵ_{0}$
* **變更性質：** 這樣就把 **Non-uniform PL** 硬生生地修正成了 **Uniform PL**。
* **結果：** 收斂速度從像烏龜爬的 O(1/t) 直接進化成**指數級收斂（Exponential convergence）**。這就是為什麼同樣的問題，純 PG 可能要跑一百萬步，而 PPO 只要十萬步。
# Reference
[PL condition](https://www.stat.cmu.edu/~siva/teaching/725/lec13.pdf)
[non-uniform PL-condition](https://arxiv.org/abs/2005.06392)