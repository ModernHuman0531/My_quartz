---
created: 2025-08-03T14:22
updated: 2026-05-25T22:07
title:
---
2026-05-18 12:18

Status:

Tags:
目錄(ctrl+p):
# HW3
這個作業基本上都是在講SAC algorithm的應用與原理

## Problem 2
### (a)
在sac裡，我們希望policy 的分佈能越接近Q function的分佈越好，而透過regularized MDP推導出的soft policy iteration確實可以讓optimal policy 正比於$\frac{\exp(Q^{\pi_{k}}_{\Omega})}{Z}$，而當我們想要讓$\pi(a|s)$盡可能接近令一個目標分佈$P(a|s) \propto \exp(Q(s,a))$時，在機器學習裡最常來衡量兩個機率分佈之間距離的指標是KL divergence.
KL divergence公式：
$$
D_{KL}(P||Q)=\sum_{i}P(i)\log(\frac{P(i)}{Q(i)})
$$
將KL divergence帶入式子當中時會得到新的loss function:
$$
\begin{aligned}
L_{\pi}(\theta)&=E_{s\sim D}[D_{KL}(\pi_{\theta}({\cdot|s}||\frac{\exp(Q_{{\phi}}(s,\cdot))}{Z_{\bar{\phi}}(s)})] \\
&=E_{s\sim D}[\sum_{a \in A}\pi_{\theta}(a|s)\log \frac{\pi_{\theta}(a|s)Z_{\bar{\phi}}(s)}{\exp Q_{\bar{\phi}}(s,a)}] \\
&= E_{s\sim D, a\sim\pi_{\theta}}[\log\pi_{\theta}(a|s)-Q_{\bar{\phi}}(s,a)+\log Z_{\bar{\phi}(s)}]\\
&= E_{s\sim D, a\sim\pi_{\theta}}[\log\pi_{\theta}(a|s)-Q_{\bar{\phi}}(s,a)]
\end{aligned}
$$
Actor NN 的輸出為$\mu$跟variance, 而目標函數變成：
$$
\min_{\theta}E_{a\sim\pi_{\theta}}[\log\pi_{\theta}(a|s)-Q_{\bar{\phi}}(s,a)]
$$
而處理這個函數不能直接做policy gradient而是要藉由Reparameterization trick建立一個獨立於$\theta$ 抽取action a的方式，需要做這種方法的原因如下：

**微積分視角（為什麼不能只對裡面微分）**： 如果你學過微積分的微導公式，當我們要對一個期望值求導：$\nabla_\phi \mathbb{E}_{a \sim \pi_\phi} [f(a)]$ 根據微積分，它**絕對不等於** $\mathbb{E}_{a \sim \pi_\phi} [\nabla_\phi f(a)]$。 因為當 $\phi$ 改變時，分佈 $\pi_\phi$ 的形狀改變了，這會導致某些動作被抽到的**機率變大或變小**。只對裡面的 $f(a)$ 微分，完全忽略了「分佈形狀改變所帶來的影響」。

在 SAC 中，我們的 $f(a)$ 就是 $Q(s, a)$，而 $Q(s, a)$ 是一個**由神經網路維護、完全可微分的函數**！如果我們用舊的 Policy Gradient 方法，就白白浪費了「我們可以直接對 $Q$ 值算動作梯度（$\nabla_a Q(s,a)$）」的這個優勢。 所以，如果我們能用一個**可微分的確定性函數**把動作寫出來（也就是重參數化 $a = f_\phi(\epsilon, s)$），那上面的期望值導數就可以直接把微分符號丟進期望值裡面了： $$\nabla_\phi \mathbb{E}_{\epsilon \sim \mathcal{N}} [Q(s, f_\phi(\epsilon, s))] = \mathbb{E}_{\epsilon \sim \mathcal{N}} [\nabla_\phi Q(s, f_\phi(\epsilon, s))]$$ 這樣一來，利用連鎖律，梯度是不是就能順利地透過 $\nabla_a Q \cdot \nabla_\phi f_\phi$ 一路暢通無阻地傳回 Actor 網路的參數 $\phi$ 了

如果把抽樣過程「拆開」，讓隨機性由一個**與 $\phi$ 完全無關**的獨立標準高斯分佈 $\epsilon \sim \mathcal{N}(0, I)$ 來提供，然後透過一個確定性的公式把 $\epsilon$ 轉換成動作：

$$a = f_\phi(\epsilon, s) = \mu_\phi(s) + \sigma_\phi(s) \odot \epsilon$$

這樣做的話，取期望值的對象變成了 $\mathbb{E}_{\epsilon \sim \mathcal{N}(0,I)}$。此時，參數 $\phi$ 被移到了期望值符號的**裡面**了，可以直接對目標函數做偏微分，而藉由Reparameterization所得到的新的目鰾函數為(把目標函數裡的 $a$ 全部替換成 $f_\phi(\epsilon, s)$)：
$$
L_{\pi}(\theta)=\mathbb{E}_{s\sim D, \epsilon \sim G}[\log\pi_{\theta}f_{\theta((\epsilon;s)|s)}-Q_{\bar{\phi}}(s,f_{\theta}(\epsilon;s))]
$$
發現$\theta$真的在期望值裡面了！！！

### 實做細節
1. 何時要用detach
	所以規則很簡單：**哪個 network 是這個 loss 的「主角」，就讓它的輸出保留 gradient；其他人的輸出一律 detach。**
2. 
# Reference
[Original SAC paper](https://arxiv.org/pdf/1801.01290)
[Soft Actor-critic 算法講解](https://zhuanlan.zhihu.com/p/70360272)
[KL divergence解釋](https://hackmd.io/@kk6333/Byp2LxHes)
[Reparameterization trick](https://www.zhihu.com/question/529196847/answer/2452737394)
