---
created: 2025-08-03T14:22
updated: 2025-11-18T12:54
title:
---
2025-11-17 19:19

Status:

Tags:
目錄:
# Midterm 2
範圍：
- **Kernel methods (SVM/SVR):** core concepts and intuition.
    
- **Dimensionality reduction (PCA):** purpose, basic idea, and standard preprocessing (centering/when to standardize).
    
- **Clustering:** **K-means** one iteration (assignment → update) and practical considerations (initialization, scaling).
    
- **Neural Networks (MLP):** forward/backward via chain rule, parameter counting, and correct **head × loss** pairing.
    
- **CNNs:** output size formula usage, parameter counting, and a small hand-computed convolution.
    
- **Sequence models (RNN/LSTM/GRU):** basic structures and stabilization ideas at a conceptual level.
## Kernel methods
一、模型基礎與分類
*  參數模型 vs. 非參數模型
	* **參數模型**（如線性迴歸、邏輯迴歸）具有固定的參數數量，與數據大小無關，它們假設了特定的函數形式，訓練通常較快，但靈活性有限
	* **非參數模型**（如核方法、k-NN、決策樹）的參數數量隨著數據量增長，這類模型對函數形式沒有強烈的假設，因此更靈活，能夠捕捉複雜的非線性模式
二、核方法與對偶表示 (Kernel Trick & Dual Representation)
 * **對偶形式 (Dual Form)：** 模型不是由權重向量 w 定義，而是透過訓練樣本和權重 αi​ 來表達的。這種形式的優勢在於，它僅使用樣本之間的點積來進行計算
 * **格拉姆矩陣 (Gram Matrix)：** 這是訓練樣本之間所有成對點積構成的矩陣。在核方法中，它被廣義化為核函數矩陣 K(xi​,xj​)，模型的訓練僅依賴於此矩陣
 * **核技巧 (Kernel Trick) 的直覺：** 核心是**隱式地**將數據映射到一個更高維的特徵空間。這樣可以處理非線性的決策邊界（例如圓形或螺旋形結構）
 * **技巧的實踐：** 使用核函數 K(x,x′)=⟨ϕ(x),ϕ(x′)⟩ 來取代顯式的特徵映射 ϕ(x)。這允許我們在特徵空間中計算內積，而無需實際構建高維 ϕ(x)，從而提高計算效率
 * **有效核的標準：** 一個函數要作為有效的核，必須滿足**正半定 (Positive Semi-Definite, PSD)** 的性質。這保證了該核確實對應於某個（可能無限維）特徵空間中的內積
 * **常見核函數的直覺**
	 * **線性核 (Linear Kernel)：** 等同於在輸入空間中進行標準內積，不提供非線性映射
	 * **多項式核 (Polynomial Kernel)：** 增加了非線性特徵交互，可以用於表示曲線和光滑的非線性邊界
	 * **RBF (高斯) 核：** 提供無限維的映射。它通過度量相似性來工作，點越接近，值越高；它也是 SVM 中最受歡迎的核
* **可擴展性問題：** 由於核矩陣的大小為 n×n，對於大型數據集，存儲和計算成本很高，這是核方法的局限性
三、支援向量機 (SVM)
* **最大邊界分類器：** SVM 的目標是找到一個能最大化幾何邊界（Margin）的超平面。最大化邊界等價於最小化權重向量的範數 ∥w∥
* **支援向量 (Support Vectors)：** 只有那些最靠近超平面的點（邊界最小的點）才被稱為支援向量。這些支援向量是唯一決定最終超平面 w 和 b 的點

四、迴歸與概率模型 (SVR, KLR, GPR)
* **支援向量迴歸 (SVR)：**
	* 目標是預測連續輸出
	* 核心思想是擬合一個**盡可能平坦**的函數（最小化 ∥w∥），同時允許一個容忍度 ϵ
	* ϵ **容忍度**允許模型忽略落在 ±ϵ 範圍內的小錯誤
	* VR 使用 ϵ-不敏感損失函數，該損失在 0 附近是平坦的
* **核邏輯迴歸 (KLR)：**
	* 通過使用核技巧，將邏輯迴歸擴展到處理非線性數據
	* LR 輸出的不是硬分類標籤，而是**類別概率**
	* 它使用邏輯（交叉熵）損失函數。與 SVM 的鉸鏈損失不同，KLR 保留了概率解釋
* **高斯過程迴歸 (GPR)：**
	* GPR 是一種**概率迴歸模型**，它能夠提供不確定性估計
	* **核心思想：** 它不是定義參數 w 的分佈，而是**定義整個函數** f(x) **上的分佈**
	* 任何有限集合的函數值都遵循多元高斯分佈
	* **協方差函數** K(x,x′) **(核)：** 定義了兩個輸入點 x 和 x′ “同步移動”的程度，從而決定了函數的平滑度
	* **預測：** GPR 的預測是訓練輸出值的加權平均。它同時提供**均值預測**和**方差預測**（即不確定性）
### quiz
1. What is the purpose of the kernel trick in SVMs? To transform non-linear data into a higher dimensional space without explicitly the mapping
2. What statement best describes the RBF kernel? It measures similarity between points using an exponential function of their distance
3. In SVMs, what does the margin represent? The distance between the decision boundary and the cloest data points (support vectors)
4. Why is soft-margin SVM used instead of hard-margin SVM? To handle noisy or non-separable data by allowing some misclassifications.

## Dimensionality reduction(PCA)
降維技術的目標 (Purpose)
降維的主要目標是解決高維數據帶來的實際問題並優化學習過程
* **解決維度詛咒 (The Curse of Dimensionality) 與數據稀疏性：**
	* 隨著特徵數量的增長，空間會呈指數級增長
	* 數據變得稀疏（sparsity），導致模式難以學習
	* 在高維空間中，距離變得不可靠，最近點和最遠點的距離開始相似（「距離集中」現象），使得相似性度量和聚類不穩定
	* 為了維持相同的空間覆蓋率，所需的樣本數量呈指數級增長
* **實際操作與模型優化：**
	* 解決實際問題帶來的困擾，例如訓練速度變慢、模型不穩定、對噪聲或相關性數據過度擬合（overfitting），以及特徵難以解釋
	* **數據壓縮 (Data compression)**：減少記憶體佔用（lower memory footprint）並提高計算效率
	* **訊號淨化 (Cleaner signals)**：減少隨機的波動（random wiggles），穩定模型訓練
	* **優化下游任務 (Better pipelines)**：加速後續任務，有時甚至能帶來更好的泛化能力
* **PCA 的特定目的：**
	* PCA 是一種快速、通用且**不使用標籤**的降維方法，用於**壓縮數據**、**去噪**以及製作 **2D/3D 可視化視圖**
	* 在高維數據稀疏且嘈雜，且許多特徵（features）具有冗餘性的情況下，PCA 將它們轉化為少數幾個能解釋大部分變化的「主控滑塊」（master sliders）
	* **可視化 (Visualization)**：將數據映射到 2D/3D 空間中，以便進行探索和模式發現
基本概念 (Basic Idea)
降維方法可以分為特徵選擇（Feature selection，保留子集）和**特徵提取（Feature extraction，重新表達於新空間** 兩大類；PCA屬於後者
* **PCA 的核心原理：**
	* PCA 是一種**線性 (Linear)** 且**無監督 (Unsupervised)** 的特徵提取方法
	* 它的基本概念是找到數據中**變異性最大 (most variation)** 的方向
	* 可以想像成「陰影擴散」（shadow spread）：在數據雲中畫一條線，找出能投射出最寬陰影（即變異性最大）的線
	* PCA 選擇第一條變異性最大的線，然後選擇與第一條線垂直（正交）且變異性次之的線，依此類推
	* 保留前幾個方向，即可得到新的緊湊座標
* **數學目標與實現**:
	* PCA 的目標是找到能最大化投影後數據方差的方向（Goal: find the direction with the widest spread）
	* 其數學解法是找出**協方差矩陣 (**Σ**) 的頂部特徵向量**（top eigenvectors），這些特徵向量即為主方向（principal directions）
	* **奇異值分解 (SVD)** 是實現 PCA 的穩定且乾淨的方法
		* SVD 的 V 矩陣的列即為有序的主方向
		* SVD 的對角線 S 包含奇異值，表示重要性或「能量」
標準預處理 (Standard Preprocessing)
在應用 PCA 之前，數據必須經過特定的預處理步驟，以確保結果的有效性和穩定性
* **居中處理 (Centering)：**
	* 在 PCA 的數學運算中，數據需要是**居中 (Centered data)** 的，這意味著需要減去特徵的平均值
	* 這一步是標準化流程中的一部分
* **何時需要標準化/縮放 (Standardize/Scale)：**
	* 標準化的建議步驟是「**先標準化，再 SVD**」
	* 當特徵的**單位不同 (units differ)** 時，必須進行縮放 (scale) 或標準化
* **實施管線 (Pipeline) 與警告：**
	* 標準的流程是：**居中（+如有需要則縮放）→ 進行一次 SVD → 根據 k 值進行切片** (Vk​)
	* **避免數據洩漏 (Avoid leakage)**：居中、縮放和 PCA 的擬合（Fit）過程**只能在訓練集 (train only) 上進行**。然後將訓練集上計算出的平均值和縮放比例應用（reuse）到驗證集和測試集上
	* **注意離群值 (Beware outliers)**：方差（Variance）對離群值非常敏感。少數極端點可能會導致主成分（PCs）的方向產生偏差（steer PCs）
PCA 的整個過程，就像是將一堆雜亂無章的物資（高維特徵）堆積在倉庫中，通過旋轉貨架（找到主方向）並將所有物資壓平投影到少數幾個最主要的通道上。這樣做既能壓縮空間（降維），又能減少裝卸時的混亂（去噪），使得我們能透過幾個關鍵的維度了解物資的整體結構。

### quiz
## Clustering
K-Means 是一種**基於質心**（Centroid-Based）的聚類演算法，屬於非監督式學習（Unsupervised learning），其目標是在沒有標籤的情況下發現資料中的結構。K-Means 的形式目標是找到一組劃分 {C1​,…,CK​} 來**最小化群集內部的平方誤差和（SSE）**，也就是最大化群集內部的相似度或最小化群集內部的離散度（within-cluster dispersion

一、 K-Means 的單次迭代：分配 (Assignment) 與更新 (Update)
K-Means 演算法在核心上包含五個步驟，其中步驟 3 和 4 構成了重複的迭代循環
* **分配 (Assign) 步驟 (步驟 3)**
	* 在這個步驟中，每個資料點會被分配到距離其最近的群集中心
* **更新 (Update) 步驟(步驟 4)**
	* 群集中心會根據其被分配的資料點重新計算或更新
* **重複迭代**
	* 演算法會重複進行分配和更新步驟（步驟 5），直到群集中心點的變化小於設定的容忍度（tolerance），或是群集標籤停止改變為止
二、 實務考量：特徵縮放（Scaling Features）
對於所有基於距離的聚類方法（K-Means 屬於距離型方法），特徵縮放是至關重要的預處理步驟
* **必要性**：在進行基於距離的聚類之前，應該**始終標準化特徵**（standardize features）。也可以選擇性地進行白化（whiten）
* **常見陷阱**：如果特徵未經縮放，則會導致**未縮放的特徵主導了距離的計算**（Unscaled features dominate distances）。因此，必須先進行縮放
* **距離選擇**：在特徵經過縮放之後，**歐幾里德距離（Euclidean distance）**適合用於已縮放的數值特徵，並傾向於產生球形（spherical）的群集
三、 實務考量：初始化（Initialization）

初始化群集中心點（Init centers）是 K-Means 演算法的第二步,由於隨機初始化可能導致結果不佳，因此選擇一個好的初始化策略至關重要
* **K-Means++ 策略**：
	* **K-Means++** 是一種常見且推薦的初始化方法
	* 與僅隨機選擇初始質心不同，K-Means++ 會**策略性地選擇分佈良好的初始質心**（Strategically selects well-spread initial centroids
* **實踐建議**：
	* 在 K-Means 的快速檢查清單中，建議使用 `k-means++` 進行初始化
	* 為了減輕對初始化的敏感性，通常建議使用**多重起始點**（multiple seeds），例如運行 10 到 20 次重新啟動（restarts）
總括而言，K-Means 的實務步驟建議是：**縮放**（Scale）→ 選擇 K → **k-means++** → **多重起始點** → 驗證（Validate，例如使用 Silhouette 或視覺圖表）
### quiz

## Neural Networks(MLP)
一、 鏈式法則的前向與後向傳播 (Forward/Backward via Chain Rule)
* **回傳 (Backpropagation) 的基礎概念：**
	* 回傳是一種在計算圖上**應用鏈式法則**的過程
	* 這是高效訓練多層感知器 (MLP) 的方法
	* 其主要目標是在**一次反向傳播**中計算所有參數的梯度
	* 訓練神經網絡的循環包括：前向傳播（計算損失）和回傳（計算梯度）
* **梯度流動機制：**
	* 梯度流動的方向是**從右到左**，即從損失函數流向輸入層
	* 在計算圖的每個節點，梯度計算遵循的局部規則是：**局部梯度** × **上游梯度** → **下游梯度**
	* 這個局部規則只需要每個節點的簡單導數（例如，ReLU 的導數是 0 或 1)
	* 自動微分庫會自動建立計算圖並應用此鏈式法則
* **梯度流動失敗模式與修復：**
	* **梯度消失 (Vanishing gradients)：** 發生在激活函數的導數 ∣ϕ′(z1​)∣ 非常小的時候。這可能由於 Sigmoid/Tanh 飽和，或 ReLU 位於負值區域
	* 症狀是**早期層次（靠近輸入層）難以學習**
	* **深度疊加效應 (Depth compounding)：** 深度網絡會乘以更多的雅可比矩陣，從而放大梯度消失或爆炸的效應
	* 修復方法包括在隱藏層使用 **ReLU 家族**的激活函數，並添加**標準化 (Normalization)** 或**殘差連接 (Residuals)**
二、 參數計數 (Parameter Counting)
* **MLP 的組成：**
	* 神經網絡（NN）是一種參數化函數 fθ(x)，透過組合**線性變換**和**非線性激活**來構建
	* **非線性激活是必要的**：如果堆疊線性層而沒有非線性，結果僅等同於一個單一的線性映射
	* MLP 通過添加隱藏層和非線性，實現非線性決策邊界和更豐富的特徵
* **單層參數計算（含偏置 Bias）：**
	* 對於一個線性層，參數數量（含偏置）的公式為： Param=din​⋅dout​+d,其中 d 通常指輸出維度 dout​ 的偏置項）
* **非線性層的參數：**
	* 非線性函數（如 ReLU 等）會**保持形狀不變**
	* 非線性函數的**參數數量為 0**
* **參數計數範例：**
	* 考慮一個範例 MLP：Linear(784→256)→ReLU→Linear(256→10)
	* 第一層 Linear(784→256) 的參數數量是 784⋅256+256(全連結的)
	* ReLU 的參數數量是0
	* 第二層 Linear(256→10) 的參數數量是 256⋅10+10
 三、 正確的 Head × Loss 配對 (Correct Head × Loss Pairing)
 * **配對核心原則：**
	 * 在訓練神經網絡時，必須正確選擇**輸出層 Head** ↔ **損失函數 Loss** ↔ **標籤 Labels** 的組合
* **Logits 的使用：**
	* 應將**原始 Logits** 饋入損失函數
	* **不要**在計算這些損失之前應用 Softmax 或 Sigmoid
	* 這是因為 Cross-Entropy (CE) 和 Binary Cross-Entropy (BCE) 的 "WithLogits" 版本已經內建了 Softmax/Sigmoid 處理
* **常見的任務配對：**
	* **迴歸任務 (Regression)：**
		* Head：**線性層**（通常沒有激活函數/Identity）
		* Loss：**MSE** 或 **Huber 損失**
		* 當異常值 (outliers) 頻繁出現時，**應優先選擇 Huber 損失**。Huber 損失在誤差接近零時表現為二次方，而在錯誤很大時增長速度較慢
	* **多類別分類 (Multiclass, 單標籤)：**
		* Head：輸出 C 個 Logits（C 為類別數）
		* Loss：**CrossEntropyLoss**
		* 標籤格式：損失函數期望標籤是 B 維的**類別索引 (Long 整數)**，而不是 One-Hot 編碼
	* **二元分類 (Binary, 單標籤)：**
		* Head：輸出 **1 個 Logit**
		* Loss：**BCEWithLogitsLoss**
		* 標籤格式：目標值 {0,1}
	* **多標籤分類 (Multilabel, 多 0/1)：**
		* Head：輸出 C 個 Logits
		* Loss：**BCEWithLogitsLoss** (每個類別使用一次)
### quiz

## CNNs(RNN/LSTM/GRU) (注意計算題)
一、 輸出尺寸公式及應用 (Output Size Formula Usage)
卷積層的輸出尺寸計算涉及輸入、核心（Kernel）、步幅（Stride）和填充（Padding）
* **輸入和核心定義**：
	* 輸入：H×W×Cin​（高度 × 寬度 × 輸入通道數）
	* 核心：kh​×kw​（核心高度 × 核心寬度）
* **公式所需參數**
	* 步幅 s (stride)：濾波器每次移動跳過的像素數
	* 填充 p (padding)：在邊界周圍添加的零值
	* 輸出通道數 C′：等於 Cout​
* **輸出尺寸計算公式**
	* 輸出高度 H′：⌊(H+2p−kh​)/s⌋+1
	* 輸出寬度 W′：⌊(W+2p−kw​)/s⌋+1
* **應用實例**
	* **“Same” 示例：** 當核心大小 k=3、填充 p=1、步幅 s=1 時，輸出尺寸 H 和 W 將保持不變
	* **“Valid” 示例：** 當填充 p=0 時，輸出特徵圖的尺寸會比輸入小
	* **降採樣：** 當步幅 s>1 時，會對圖像進行降採樣，導致 H′ 和 W′ 縮小。例如，對於 32×32×3 的輸入，若使用 s=2，輸出尺寸將是 16×16×64
* **填充的作用：** 填充的目的是保留邊緣信息，並有效擴大輸入尺寸
二、 參數計數 (Parameter Counting)
卷積層通過權重共享來大幅減少需要優化的參數數量，使其比全連接層（FC）更有效率
* **全連接層（FC）的局限性**
	* 將全連接層應用於圖像時，鏈接數量會過多
	* 以 1000×1000 的圖像為例，一個隱藏節點就需要 100 萬個鏈接。如果該層有 100 萬個神經元，則參數總數將達到 10^12
* **卷積層的優勢**：
	* 卷積神經網絡（CNN）的核心是**局部連接**（Local connectivity）和**權重共享**（Weight sharing）
	* 這使得 CNN 能捕捉空間相關性（局部依賴關係），並大幅削減參數數量
	* 在卷積層中，每組權重都受到約束而保持相同。用於隱藏層的這組權重集被稱為**濾波器（filter）**
	* 在一個簡化示例中，如果只給每個隱藏節點輸入 3 個像素值，且權重相同，則需要優化的參數只有 3 個不同的權重（加上 1 個偏差，共 4 個）
* **卷積層參數計算公式**
	* 參數數量 = kh​×kw​×Cin​×Cout​（加上偏差）
* **參數計數示例**：
	* 對於一個輸入為 32×32×3 的層，若輸出為 32×32×64 (使用 k=3,p=1,s=1)，則其參數數量為 3×3×3×64=1,728
三、 小型手動計算卷積的直覺 (Small Hand-Computed Convolution Intuition)
* **局部感受野操作（Local Receptive Field Operation）**
	* 卷積操作的核心是使用一個小的**感受野**（receptive field），例如 3×3×C（其中 C 是輸入圖像的通道數），僅觀察輸入中的局部像素
	* 神經元**不需要看到整個圖像**，因為許多需要提取的模式（如邊緣或紋理）都比整個圖像小得多
	* 這種設計利用了**空間相關性是局部性**（locality of spatial dependencies）的特性
* **濾波器權重共享和滑動（Shared Filter Weights and Sliding）**
	* 卷積層使用一組**共享的濾波器權重**。這組權重對於隱藏層中的所有節點來說是相同的
	* 這些共享的濾波器權重會**滑過整個圖像**。在每一步中，濾波器會與其當前的局部感受野中的像素進行點乘和求和運算，加上一個偏差（bias），產生輸出特徵圖（feature maps）中的一個數值
	* 通過這種機制，濾波器能夠學習例如**邊緣、紋理或部件**等局部模式
	* 種權重共享機制大幅削減了需要優化的參數數量，使其遠比全連接層（FC）高效
* **計算的數值化與結果**
	* 卷積層的計算涉及輸入尺寸 (H×W×Cin​)、核心尺寸 (kh​×kw​)、步幅 (s) 和填充 (p)
	* 透過手動計算，我們可以觀察到如何應用步幅（Stride）來實現降採樣（downsamples），以及填充（Padding）如何幫助保留邊緣信息
	* 卷積層的輸出尺寸 H′ 和 W′ 可以通過以下公式計算：H′=⌊(H+2p−kh​)/s⌋+1 和 W′=⌊(W+2p−kw​)/s⌋+1
	總結來說，手動計算卷積就是將一個小的權重矩陣（濾波器）在輸入數據上按步幅滑動，並在每個位置進行乘法和加法操作，從而一步一步地生成輸出特徵圖。這對於理解卷積的**轉譯等變性**（Translation equivariance，即平移輸入會導致特徵圖也平移）也非常有幫助
### quiz
## Sequence models
一.序列的重要性與任務
序列（Sequences）之所以重要，是因為**資訊的意義取決於順序**（例如：「狗咬人」不等於「人咬狗」），且**時間點承載著資訊**（例如：停頓、持續時間、時近性）
* 常見的序列任務包括：
	* **分類 (Classification)**：例如意圖偵測（判斷是「預訂航班」還是「天氣」）
	* **標註 (Tagging)**：例如對句子中的每個標記（token）進行詞性標註或命名實體識別（POS/NER）
	* **轉導 (Transduction)**：將一個序列映射到另一個序列（例如：語音識別 ASR: audio → text）
	* **預測 (Forecasting)**：預測未來數值（例如：日常銷量、交通流量）
	序列建模需要**隨時間保留上下文**（依賴關係可以是短期的或長期的），並且必須**尊重因果關係**（在訓練/評估時不能偷看未來）
二.循環神經網絡 (Recurrent Neural Networks, RNN)
* **基本結構與運作** RNN 是**逐步處理序列**的模型，它會攜帶一個**隱藏狀態** (ht​)
	* **更新概念**：隱藏狀態會隨時間積累上下文。ht​=f(Wx​ xt​+Wh​ ht−1​+b)
	* RNN 會**重複使用今天的預測結果來進行未來的預測**
	* **優勢**：能夠處理**可變長度的輸入**，無需手動截斷邏輯，並且可以模擬時間依賴性和事件之間的間隔
* **核心限制與穩定化**
	由於簡單的 RNN 只查看前一個步驟的資訊，需要引入記憶和遺忘機制來進行改進
	* **限制**：在較長的時間範圍內會出現**梯度消失/爆炸**問題
	* **概念性解決方案**：梯度消失/爆炸問題導致了 LSTM/GRU 等**門控 RNNs** 的發展，這些模型能更好地保存長期資訊
	* **訓練技巧**：為了解決梯度問題，常用的技巧包括**梯度裁剪** (gradient clipping) 和仔細的初始化
三.長短期記憶網絡 (Long Short-Term Memory, LSTM)
LSTM 的設計是為了解決 RNN 的限制，是門控機制模型的代表
* **結構與概念**
	* **核心**：**單元狀態** (Cell state) 被稱為「**記憶高速公路**」(memory highway)
	* **記憶高速公路**：這是一條專門的路徑，**以最小的修改將資訊向前傳遞**，這允許梯度流經許多步驟，減少了梯度消失的問題
	* **特點**：LSTM 具有**強大的長程記憶能力**，但相較於 GRU，它**更重、更慢**（因為有 3 個門控加上單獨的單元狀態）
* **門控機制 (Three Gates)** LSTM 使用三個直覺上的門控來控制資訊的流動：
	* **輸入門 (Input gate / write)**：決定現在要添加多少新資訊
	* **遺忘門 (Forget gate / keep)**：決定要從記憶中抹去什麼
	* **輸出門 (Output gate / read)**：決定將記憶的哪一部分作為當前的輸出暴露出來
	**心智模型**：可以將其視為一本筆記本，每一步都決定要寫下什麼、保留什麼以及朗讀出什麼
四.門控循環單元 (Gated Recurrent Unit, GRU)
GRU 旨在簡化 LSTM，提供更高效的序列建模
* **結構與概念**
	* **簡化**：GRU 只有**兩個門控**：**更新門** (zt​) 和**重設門**
	* **記憶**：**沒有明確的單獨單元狀態**；**隱藏狀態**本身即充當記憶
* **門控機制**
	* **更新門** (Update gate, zt​)：對應於 LSTM 的遺忘門和輸入門的結合，決定是保留舊資訊還是用新資訊覆蓋
	* • **重設門** (Reset gate)：決定在形成新內容時，要使用多少過去的資訊
* **優勢與劣勢**
	* **優勢 (Pros)**：
		* 參數更少，訓練/推論**速度比 LSTM 更快**
		* 在許多 NLP/語音/時間序列任務中，通常可以達到**相似的準確度**
		* **更容易調整**
	* **劣勢 (Cons)**：
		* 在某些長範圍任務上，其**表達能力可能略遜於調整得當的 LSTM**
		* 由於**沒有輸出門**，對「揭示什麼」的控制較不那麼明確
	* **選擇時機**：當需要速度/延遲較低，或模型佔用空間較小時，適合選擇 GRU。它也是一個強大的起步基線模型
# Reference