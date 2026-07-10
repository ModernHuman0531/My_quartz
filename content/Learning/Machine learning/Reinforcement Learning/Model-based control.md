---
created: 2025-08-03T14:22
updated: 2026-05-28T16:36
title:
---
2026-05-27 15:07

Status:

Tags:
目錄(ctrl+p):
# Model-based control
相比於不需要模型的傳統演算法(Model-free RL like PPO, SAC, DDPG等)，Model-based RL的最大優點在於多了一個『World Model(世界模型)』來扮演模擬器。

但不同於之前在MUJOCO裡訓練PPO(Model-free RL)時，對PPO算法本身來說，MUJOCO是一個無法窺探內部規則的黑盒子，在PPO的視角裡，在state $s_{t}$做一個動作a後，會回傳reward, $s_{t+1}$, done等資訊，但不知道他是如何產出這些的。也就是說，PPO無法再不和環境(MUJOCO)互動的情況下自主去預測下一步，如果PPO想要知道下一步發生了什麼，必須實際傳動作給MUJOCO運行一次，MUJOCO計算完後才會告知PPO結果。

而Model-based RL(例如Dreamer algorithm)的目標是，在自己的神經網路裡複製出一個世界模型，讓我們不用實際丟動作給MUJOCO也可以預測下一步是什麼(reward, next state .etc)，也就是說Dreamer與真實世界(或是MUJOCO)互動過幾次後，使用自己的神經網路訓練出一個白盒子，藉由這個白盒子我們便能不與真實環境互動也能預測下一個狀態(但不一定百分百準確)

訓練流程比較：
* Model-free RL trainig process
```txt
┌───────────┐ 動作 a_t ┌───────────────────────────────────┐ │ PPO/SAC ├───────────────>│ 外部環境 (MuJoCo 模擬器 / 真實世界) │ │ Policy │<───────────────┤ 扮演黑盒子的角色 │ └───────────┘ 觀測 o, 獎勵 r └───────────────────────────────────┘ ▲ │ └─────────── 每一輪訓練都必須依賴這裡回傳的資料 ┘
```
* Model-based RL training process(Use Dreamer for example)
Dreamer 只在初期或定期從環境收集少量資料，其餘 90% 以上的策略提升，都是在右側那個World model完成的。
```txt
**Model-based 具有線上適應能力（Online Adaptation）**： 如果我們把一個 Model-based 演算法丟到真實世界，當它發現「現實的重力」或「地面摩擦力」跟原本想的不一樣時，它會**立刻在線更新它的「世界模型」神經網路**，讓大腦快速適應新的物理法則。而 Model-free 演算法（PPO）在面對環境改變時，通常需要大動干戈地重新收集海量資料來重練整個策略。
```

## Latent State-Transition Models
Issue: 

## Parametric vs non-parametric models

## TD-MPC
TD-MPC的發表正式為了解決vanilla MPC的兩大痛點誕生的：
* **模型不精準（Model Error）**：在複雜環境（如像素影像或高維度關節）中，極難訓練出完美的物理轉移模型。
* **視線短淺（Short Horizon）**：MPC 為了運算速度只能規劃很短的窗口（如 $H=5$ 步），看不到長遠未來的獎勵（例如走迷宮時，出口在 100 步外，短窗口規劃完全失效）
## 一、 TD-MPC 的核心原理解析

TD-MPC 提出了一個名為 **TOLD (Task-Oriented Latent Dynamics)** 的世界模型。它不再像傳統模型那樣去預測複雜的「下一幀畫面」或「所有真實物理狀態」，而是**只預測與當前任務獎勵相關的特徵**。

其大腦由以下 5 個成對的神經網路聯合組成，且完全使用 **Temporal Difference (TD) 誤差** 來進行端到端的聯合訓練：

1. **Representation (Encoder)**: $z_t = h_\theta(o_t)$ （將原始觀測壓縮進隱空間）
2. **Latent Dynamics**: $z_{t+1} = d_\theta(z_t, a_t)$ （在隱空間中做純向量的狀態轉移預測）
3. **Reward Predictor**: $\hat{r}_t = R_\theta(z_t, a_t)$ （預測即時獎勵）
4. **Value Function (Q)**: $\hat{q}_t = Q_\theta(z_t, a_t)$ （利用 TD-learning 估計長期價值）
5. **Policy (Actor)**: $a_t \sim \pi_\theta(z_t)$ （學習一個輔助策略，用來加速 MPC 採樣）
## 二、 TD-MPC 相比 vanilla MPC 的 5 大增強功能 (Enhancements)

### 1. 任務導向的隱空間規劃 (Planning in Task-Oriented Latent Space)

- **Vanilla MPC**：在真實的狀態空間（State space）或透過解碼器還原的像素空間（Pixel reconstruction）進行規劃。
- **TD-MPC 增強**：完全在低維度的隱空間（Latent Space）中進行 Rollout 規劃。更重要的是，它採用 **無解碼器（Decoder-free）** 設計，模型的目標函數只預測 Reward、Value 與狀態一致性（Consistency Loss），這使得模型會主動忽略環境中與任務無關的背景雜訊。
### 2. 基於時序差分學得的末端價值函數 (Terminal Value Function Bootstrapping)

- **Vanilla MPC**：在有限窗口 $H$ 的結尾，通常不加獎勵、或只能給予一個粗糙的啟發式估計（Heuristic Cost）。這導致它缺乏長遠目光。
- **TD-MPC 增強**：在隱空間 Rollout 的最後一步 $z_H$，引入了透過 **TD 學習（Temporal Difference）** 訓練出來的 $Q_\theta(z_H, a_H)$ 函數作為結尾獎勵（Terminal Value）。這使得即使 MPC 只規劃 5 步，它也能透過 $Q$ 函數「看見」無窮遠處的長期總收益（類似於 Model-free 的好處）。
### 3. 利用學得策略引導採樣 (Policy-Guided Sampling / MPPI Initialization)

- **Vanilla MPC**：在尋找最佳軌跡時，通常使用隨機射擊（Random Shooting）或從純高斯分佈中盲目採樣動作序列（如標準 CEM 或 MPPI）。
- **TD-MPC 增強**：TD-MPC 在內部蒸餾出了一個策略網路 $\pi_\theta(z)$。在執行 MPPI 軌跡優化時，它會**將這個策略網路輸出的動作作為採樣的均值先驗（Prior Mean）**。這大幅減少了盲目搜尋的開銷，讓 AI 在高維度連續動作空間中（例如 38 維的 Dog 機器人任務）依舊能精準找到最優軌跡。
### 4. 潛在狀態一致性正則化 (Latent State Consistency Regularization)

- **Vanilla MPC**：如果模型有誤差，多步預測後的狀態會嚴重失真（Compounding error）。
- **TD-MPC 增強**：在訓練世界模型時，論文加入了規約項：要求「從 $o_t$ 透過編碼器得到的真實隱狀態 $z_t$」，必須與「從 $z_0$ 透過 Dynamics model 預測 $t$ 步得到的 $\hat{z}_t$」保持高度一致：
    $$\mathcal{L}_{\text{sim}} \sim ||h_\theta(o_t) - d_\theta(z_{t-1}, a_{t-1})||_2^2$$
    這項正則化確保了模型在長時間軸的虛擬規劃中，隱狀態轉移不會發散（Drift）。
### 5. 結合 Model-Based 與 Model-Free 的多目標聯合訓練 (Joint TD Learning)

- **Vanilla MPC**：系統的動力學模型（System Identification）與上層的控制器是完全切開、獨立優化的。
- **TD-MPC 增強**：它將**模型學習（Model Learning）與價值估計（Value Estimation）綁定在同一個目標函數中**。透過最大化同一個時序差分回報（TD Return），讓模型的參數優化直接為「精準控制」和「價值極大化」服務，達成了端到端（End-to-End）的極高樣本效率。
# Reference
[MBRL 簡介](https://zhuanlan.zhihu.com/p/527093209)
[MBRL blog](https://bair.berkeley.edu/blog/2019/12/12/mbpo/)
[Dreamer model 詳細解說](https://zhuanlan.zhihu.com/p/617887001)
[model predictive control (MPC)簡介](https://zhuanlan.zhihu.com/p/99409532)
[TD-MPC](https://zhuanlan.zhihu.com/p/500039489)
[TD-MPC2](https://zhuanlan.zhihu.com/p/676110237)
