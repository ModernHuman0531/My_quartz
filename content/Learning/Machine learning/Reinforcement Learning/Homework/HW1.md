---
created: 2025-08-03T14:22
updated: 2026-04-11T15:37
title:
---
2026-04-02 14:30

Status:

Tags:
目錄(ctrl+p):
# HW1

## Problem 4
### Problem(a)
This problem is  "CartPole-v1" problem.
#### Debug
* 要觀察訓練停滯時，可能是gradient非常小到導致，因此要看model的gradient的話可以用
```python
for name, param in model.named_parameters():
	if param.grad is not None:
		print(f"{name}: grad mean = {param.grad.mean().item():.6f}")
```
* 在這個問題裡面每步固定的reward是+1，所以一個episode的return只取決於你這個episode的length多長。因為所有的return 都是正的，這代表policy gradient告訴actor說『每個動作都是好的，都要增加機率』，只是增加的程度不同，導致actor永遠無法學到『哪些動作是相對差的應該要減少機率』，所以梯度方向都一樣導致卡死，因此要對Return做正規劃(Normalization) `returns = (returns - mean) / (std)` 後return 會被轉化為有正有負的數值
* 所有進入 loss 的東西 → 一律 tensor
### Problem(c)
* Return ≈ Q
* Q ≈ Advantage + V
* 當僅僅是是用數值來更新時是可以做正規劃(Normalize)的，但當需要與其他計算誤差時就不能正規劃，例如當我們用Retunrs來作為value的estimator算MSE時，就不能將Retunrns正規劃！！！

Question:
* 何時要做normalization，做分佈比較時(MSE)是不是不要用比較好？
* 何時要用detach？為何可以在loss時做比例縮放(像是`0.5*value_loss+policy_loss`)
解決方法：
 1. 增加神經網路的維度(例如將128 -> 64變成 256 -> 128)
 2. detach的時機是：當我們只是要那個值作為數值而非要帶回去更新神經網路的我們都要detach他，例如做GAE時我們只是要advnatage作為數值而非要讓他更新神經網路，因此要detach他
 3. 在做scaling loss 時，我們要先畫出policy loss 跟 value loss的曲線，看他們收斂的值為多少，兩個收斂的值應該要差不多，如果差很多才要用scaling 來平衡他們
 4. 為何兩個loss會差那麼多，因為當我們normalize advantage 時，advantage的值會在0左右擺蕩，因此policy loss會在0左右擺蕩，但value loss就是當純的數值，因此兩個會差很多，此時就要用3.的方法更新他們
 5. 在用p5來做policy gradient時，我們是用advanatege (A=Q-V)來計算出target value(target_value = Advantage + value)與value NN做MSE來更新神經網路，因為$V^{\pi}(s)=E_{a\in A}[Q^{\pi}(s,a)]$，但我只取一個trajectory，因此可以用Q來近似V。
 6. 在實做時要記得做gradient clipping避免一次壞的gradient造成無可挽回的後果，要寫在backward()之後optimizer.step()之前。
 7. loss計算時用mean取代sum會比較好，因為每個episode長度不固定會導致更新大小劇烈晃動造成不穩定，而用mean是代表單步的平均貢獻，對於梯度方向不會影響，只會影響大小而已


# Reference
1. [Gradient Clipping](https://zhuanlan.zhihu.com/p/557949443)
