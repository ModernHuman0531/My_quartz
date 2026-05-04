---
created: 2025-08-03T14:22
updated: 2026-05-04T21:00
title:
---
2026-04-29 23:51

Status:

Tags:
目錄(ctrl+p):
# HW 2
## Problem 1: PPO with clipped objective

## Problem 4
### (a)
第一小題主要是在實做DDPG算法的實現
* Actor
* Critic:輸入為state跟action
	* 對於簡單的問題(例如Pendulum-v1)，網路架構不需要額外提煉state的特徵，一開始輸入直接將state_dim+action_dim就好了
	* 對於較難的問題，我們可以先讓state經過一個linear_layer+hidden_layer提出特徵，再用`torch.cat`與action結合
<div align="center">
	<img src="critic_network_architecture.svg" width="70%">
</div>

### (b)
* 第一次跑得結果最多到4000出頭，遠遠沒達到要求的5000，該如何在500ksteps中訓練出至少在20次評估中平均成績在5000以上。當無法在規定時間內到達只分數可能有兩個原因，第一個是critic network學習Q value學太慢了，此時要調高lr_c，第二個是當critic network剛開始估計的Q值不穩定時，如果此時actor的lr也很大的話，因為actor是跟著Q值更新方向，這會導致一旦Q值辜的不太準確時，actor會跑很遠。判斷基準可能是reward在相近的episode差距較大，可能是actor更新過頭了。

### (c)
要實做DDPG algorithm加上CDG(clipped  double Q)，因為只用一個critic來估算Q值的話很容易高估Q值，原因是
* $\text{target Q}=r+\gamma Q_{target}(s^{\prime},\pi(s^{\prime}))$
* actor會朝著Q值的方向進行更新，錯誤的高估會不斷的被放大
而CDQ用兩個獨立的Critic，計算target Q時取兩個的最小值：
$$
target_Q = r + γ · min(Q1_target(s', π(s')+ε), Q2_target(s', π(s')+ε))
$$
取min便能壓制高估，使得訓練更加穩定，分數高了快2000以上
## Bug (a)
* `memory_sample()`回傳的是`list of transition`，但在`update_parameters()`裡一開始直接取用`batch.state`，這裡需要的是一個`transition`而非list，因此要用`Transition(*zip(*batch))`將list of Transition成Transition of list
* episides是一場實驗，而steps是代表實驗的每一歩
* 

# Reference
[PPO clipped 簡介](https://zhuanlan.zhihu.com/p/28223597805)
[DDPG算法實做參考](https://zhuanlan.zhihu.com/p/615999880)
[TD3 算法原理](https://zhuanlan.zhihu.com/p/86297106)