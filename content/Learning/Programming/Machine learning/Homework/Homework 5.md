---
created: 2025-08-03T14:22
updated: 2025-12-03T18:21
title:
---
2025-12-01 20:38

Status:

Tags:
目錄:
# HW5
問題：
1. 什麼時候要將data轉成torch，什麼時候保留為numpy就好了
只是單純儲存數據時，仍要做後續處理，就先存成numpy，唯有要在model裡使用時才要轉成tensor
2. torch.Tensor.view用法
 PyTorch 中用於**改變張量形狀**的重要方法
 ```
 # 常見於 CNN 到全連接層的轉換
batch_size = 32
features = torch.randn(32, 128, 7, 7)  # CNN 特徵圖

# 展平除了 batch 維度之外的所有維度
flattened = features.view(batch_size, -1)  # (32, 128*7*7) = (32, 6272)

# 或者完全展平
completely_flat = features.view(-1)  # (32*128*7*7,)
 ```
3. 4種優化方法：BN(Batch Normalization), Residual blocks, Dropout, Pooling 應該怎麼用在模型上
* Batch Normalization(BN) 使用準則：放在 Linear/Conv 後，但 Activation 前。因為 BN 的目的是 **讓資料分布穩定（平均=0、std=1）**。如果先 ReLU → 負值變0 → 資料分布不自然 → BN 難處理
	* 使用`self.bn1=nn.BatchNorm1d(feature_size)`
* Dropout使用原則：**放在 Activation 後面（ReLU 後面）**  放在主要線性層之後最有效。因為 CNN 特徵是空間結構，一次打掉某些 channel 或 pixel 容易破壞特徵。CNN 通常只在 **最後的全連接層** 使用 Dropout，dropout 的解釋為：在訓練過程的向前傳播中，讓每個神經元以一定機率dropout_rate處於不激活得狀態以減少過擬合
	* `self.drop1=nn.Dropout(p=dropout_rate)`
* Residual block 最早是 ResNet 的概念：讓輸入 x **直接加回** 卷積後的輸出 F(x)，  
讓模型學習「殘差」而不是整個 mapping：
y= F(x) + x，這可以避免深層網路的 gradient 消失。
```
Conv → BN → ReLU → Conv → BN → Residual Add → ReLU
```
* Pooling 的主要功能：max pooling => 取最強特徵，縮小特徵圖
```
Conv → BN → ReLU → MaxPool
```
3. nn.Identity:`nn.Identity()` 是 PyTorch 中的一个**恒等映射（Identity Mapping**模块，它的作用是**原样返回输入** ，不做任何变换。
4. 對於NN，為什麼輸出層不用 BatchNorm 和 Dropout？
	1. **BatchNorm 在輸出層的問題**
		- **改變輸出分佈**：BatchNorm會強制輸出標準化，但我們希望輸出層保持原始的邏輯值
		- **影響機率解釋**：對於分類問題，我們需要原始的logits去計算CrossEntropyLoss
		- **測試時不穩定**：BatchNorm在測試時使用全域統計，可能導致預測不一致
	2.   **Dropout 在輸出層的問題**
		- **預測不確定性**：即使在eval模式下，也可能影響預測的穩定性
		- **信息丟失**：最後一層的每個神經元都對應一個類別，隨機置零會丟失重要信息
		- **沒有正則化必要**：輸出層通常參數相對較少，過擬合風險較低
## Models

### CNN
* `[Conv(3*3,32)]` 是代表：
	* kernel size = `3*3`
	* Output channels=32
	* Input channels= 你當前 feature map 的 channel（例如 MNIST 是 grayscale：1）
`nn.Conv2d(in_channels, out_channels, kernel_size,padding=1)`：3×3 的 kernel 會減少圖片大小（28 → 26），加 padding=1 可以保持 size 不變（28 → 28）
* Residual block實做與流程圖
	* **Residual Block 的核心**是 `x + F(x)`，這要求：
		* x and f(x)要有相同的形狀
		* 因此要在flatten之前就做residual block
```
         x
         │
         │───────┐
         ▼       │
      Conv3×3    │
         ▼       │
         BN      │
         ▼       │
        ReLU     │
         ▼       │
      Conv3×3    │
         ▼       │
         BN      │
         ▼       │
      F(x)       │
         │       │
         └── + ──┘  ← Add
             │
            ReLU
             │
             y

```

* 何時要做shortcut：if stride != 1 or in_channels != out_channels
	* stride!=1：當步長>1，特州圖尺寸縮小
	* in_channels!=out_channels：輸入輸出通道不相等
	* 使用`nn.Conv2d(in_channels, out_channels, kernel_size=1, stride=stride, bias=False)` 來調整通道數從in_channels到out_channels

## Train process
1. `_, predicted=torch.max(outputs,1) # Choose the class with highest probability` 
2. `correct_predictions+=(predicted==labels).sum().item()` ，sum是加總所有的True，.item()是將tensor轉成整數

# Reference
[Pytorch documentation](https://docs.pytorch.org/docs/stable/generated/torch.nn.MaxPool2d.html)