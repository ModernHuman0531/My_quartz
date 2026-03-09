---
created: 2025-08-03T14:22
updated: 2025-10-06T20:06
title:
---
2025-09-30 20:56

Status:

Tags:
目錄:
# Homework 3
## 事前準備
###  用makefile來跑指令架設python虛擬環境
* 在makefile裡每一行都是獨立的子shell，所以如果分成兩行寫的指令，第一行造成的效果不會延續到第二行指令
* makefile語法細節
	* `.`：等同於source，目的是在當前shell執行腳本，不開新的子shell
	* 安靜模式:`@echo "Creating venv"`，前面的`@`代表讓make不輸出指令本身，指輸出結果
* 學習怎麼在vscode裡跑.ipynb檔，要讓.ipynb檔抓到你創建虛擬環境的kernel
	* 要先下載ipykernel
	* 跑`python -m ipykernel install --user --name=myproject --display-name "Python (myproject)"`
		* `--name=myproject`: 內部名稱
		* `--display-name "Python (myproject)"`: Vscode裡顯示名稱
## 開始訓練
* 目標: 這個任務是要做 **城市層級的每日病例數預測**，使用歷史病例資料與日期、季節、血清型組成等特徵，預測未來 **7 天的平均病例數**(不包括今天)
* 重要函數
	* `_choose_model_date` 是要從.csv檔裡看"report date", "onset date", "confirm date"，優先順序為"report date"-> "onset date"->"confirm date"，如果該藍沒有數據才換下一個，是為了之後要用到的date作為基準
	* `build_design_matrix():(處理資料跟輸入特徵)
```python
"""
1. 數據聚合:
   分組維度:df.groupby(["res_city","date"],as_index=false):按照城市+日期分組
   聚合函數:.agg(cases=("cases","sum"),imported=("imported","sum"))，將res_city+date相同的cases相加到新的column "sum"裡
   
"""
    daily = (
        df.groupby(["res_city", "date"], as_index=False)
          .agg(cases=("cases", "sum"), imported=("imported", "sum"))
    )
"""
1. 要實做roll7_mean,roll14_mean,roll7_sum,roll14_sum
	* 將(res_city)上面變數相同的數據各自分成一個dataframe，利用groupby function
	* 用['case']選定'case' column再用.apply，使用我們自己定義的函數_roll_past（s,w），取得過去case數的和
	* _roll_past有兩個輸入，s跟w，w是回朔日期，因此要用lambda function給一個輸入s
	* 使用.reset_index(level=0,drop=True)，是為了將groupby的group第一個column刪掉，避免索引對齊問題，level=0：移除第0層索引(即res_city層)，drop=true:不將移除的索引作為新欄位保留
使用前：
res_city  original_index
台北市    0                 NaN
         1                 NaN
         2                 5.2
         3                 4.8
高雄市    100               NaN
         101               3.1
         102               2.9
但我們要index來找到case，如果結果如上式，我們就不能用original index找到我們要的cases
使用reset_index後：
original_index
0         NaN
1         NaN  
2         5.2
3         4.8
100       NaN
101       3.1
102       2.9
	* .mean():是平均的函數，會幫你紀錄滑動窗口過去的和並幫你算平均
	* .sum():是算滑動窗口過去的和 
"""
    feat["roll7_mean"]  = feat.groupby("res_city")["cases"].apply(lambda s:_roll_past(s,7).mean()).reset_index(level=0,drop=True)
    feat["roll14_mean"] = feat.groupby("res_city")["cases"].apply(lambda s:_roll_past(s,14).mean()).reset_index(level=0,drop=True)
    feat["roll7_sum"]   = feat.groupby("res_city")["cases"].apply(lambda s:_roll_past(s,7).sum()).reset_index(level=0,drop=True)
    feat["roll14_sum"]  = feat.groupby("res_city")["cases"].apply(lambda s:_roll_back(s,14).sum()).reset_index(level=0,drop=True)
"""
2. 在要train之前，要將資料從dataframe轉為numpy，因為機器學習模型是要吃數值陣列而非dataframe
3. 將meta_column跟input feature分開，meta_columns=["date","res_city","cases","fwd7_mean"]，這些不能做為輸入input feature的原因是
    * date已經被拆解成更詳細的特徵，像是year,month,weekdays
	* res_city: 已透過one-hot encoding (`city_台北`, `city_高雄` 等) 轉換為數值特徵
	* cases:這是data leakage 要預測未來7天不能直接用當天數據，因為還沒過完今天我們不該知道今天有多少案例
	* fwd7_mean:是要預測的結果而非特徵
"""
```
* train_val split的部份，原本的training data是包含1998-2021的所有數據，現在要將這些數據分成2類，分別為training data跟validation data
* Dataset and dataloaders的目的是:
	* `yb`是真正的輸出，其維度是1D tensor(batch,size)，而`y_pred`是預測出來的輸出，其維度是2D tensor(batch_size,1)，這個如果直接丟進MSE裡算loss會導致broadcasting的問題，因此要先將`yb`轉成2D tensor，利用
	```python
	y = y.reshape(-1, 1) if y.ndim == 1 else y
	```
	* X是輸入的特徵矩陣，要求輸入矩陣大小有幾行，用`len(self.X)`
	* 當告訴我們要第幾個index，如果是testing data要回傳特徵矩陣，如果是training/validation data要回傳特徵矩陣跟數值

* Model part:
	* 線性模型: 一個最簡單的線性model
		* 利用pytorch.nn的model創建一個linear model：`self.linear=nn.Linear(input_dim,output_dim)`
		* `foward()`是決定數據如何流過模型的(輸入X(特徵)->線性模型->輸出預測值)
	```python
	class Regressor(nn.Module):
    # build ur model here
    def __init__(self,input_dim: int):
        super().__init__()
        self.linear=nn.Linear(input_dim,1)

    def forward(self, x):
        return self.linear(x)
	```
	* 試試看在線性model加regularizatoin
	* 多項式模型: 測試看看二次方程跟三次方程的效果(暫時不採用，因為線性已經讓結果overfitting了)
	* MLP(多層感知器):input layer->hidden layer->output layer[2017李宏毅 Brief Introduction of Deep Learning]，用nn.sequential包成一個個的block，按照說序排列，上一層的輸出要等於下一層的輸入，且不用字定義foward函數
* Training part:
	* predict():
		* 把數據轉到設備上: GPU擅長進行矩陣運算，因此套模型之前先轉到GPU上，一次處理整個batch的數據
		* 用模型進行預測，預測出來的結果torch.Tensor類型，而我們輸出要是numpy
		* 把結果轉成numpy跟轉回cpu: 轉回CPU是因為GPU記憶體有限，計算完後就將結果轉到CPU上(記憶體較多)，如果不轉回CPU會導致GPU out of memory，因此要先轉到cpu在將ouptut type轉成numpy=>`yb.cpu().numpy()`
		* 收集所有預測結果，out現在是一個array每個元素都是一個numpy array，對應每個batch的輸出結果，現在要將結果合併成一個大的numpy array，要用np.concatenate()合併
	```python
	# 3個batches，總共1400個樣本
	out = [
	    array of shape (512, 1),
	    array of shape (512, 1), 
	    array of shape (376, 1)
	]
	
	# 合併後
	result = np.concatenate(out, axis=0)  # shape: (1400, 1)
	```
	* train_loop():要選擇損失函數(Loss function)跟優化器(Optimizer)
		* Regression最適用的Loss function是MSE(Mean Square error)
		* Optimizer是用來調整learning rate的方法，現在最泛用的optimizer是Adam
		* 上述兩個pytorch都有內建
			* `class torch.nn.MSELoss(size_average=None, reduce=None, reduction='mean')`:全部都有default value 
			* `class torch.optim.Adam(params, lr=0.001, betas=(0.9, 0.999), eps=1e-08, weight_decay=0, amsgrad=False, *, foreach=None, maximize=False, capturable=False, differentiable=False, fused=None, decoupled_weight_decay=False)`:model 的parameter是必要輸入，但lr(learning rate)跟weight_decay可以按照自己需要調整，且只要model是繼承自nn.module就可以直接就由`model.parameters()`取得parameter
		* 訓練過程步驟
			1. 數據移動置設備上
			2. 清零梯度:在training loop裡，每次都要清除上一個batch所累積的梯度，而我們在宣告optimizer時，一定要傳的參數便是model的參數，因此不管在用optimizer優化參數或是清零梯度都會同步到model上。
			3. 前項傳播:將input帶入model得到理論的output
			4. 計算損失:計算預測值與真實值得差別，在regression裡通常適用MSE
			5. 反向傳播: 計算每個參數的梯度(gradient)，從loss function對每個參數做偏微得到梯度。
			6. 更新參數: 用優化器根據反向傳播的結果調整參數
			7. 紀錄損失: 把這個batch的損失加到列表中，用於計算平均損失(是指一個epoches的損失嗎)，我們會先將算完的一個batch的loss存進一個list裡，等跑完整個epoch再進算平均loss，注意傳進list的是loss.item()而非loss，因為loss裡包含批度計算圖等我們用不到的東西而loss.item()只保留值
		* 驗證過程步驟(validation set process)
			1. 數據移動
			2. 前項傳播
			3. 計算損失
			4. 紀錄損失
			* validation sets裡不能更新參數因此不會計算gradient，因此也沒有清零梯度，反向傳播跟更新參數
		* Epoches vs. batch
			* Epoches是代表要跑training dataset幾次
			* batch則是跑一次training dataset不能一次跑完，要分好幾次跑，而每一次跑得就是一個batch的量
* Main loop part:
	1. 建立dataset物件，我們可以從`temporal_holdout()`的回傳值`X_train, y_train, X_valid, y_valid`，利用class DengueDataset來分別建立**training dataset**跟 **validation dataset**
	2. 建立dataloader物件:
		* 把dataset打包成dataloader
		* 設定合適的參數(**batch_size**,shuffle,num_workers等)
		* 訓練集要shuffle，驗證集不用
		* 建立兩個dataloader: `train_loader`跟`valid_loader`
	3. 參數設定考慮
		* 批次大小:使用`args.batch_size`
		* 工作進程: 使用`args.num_workers`(notebook中自動設為為0)
		* 記憶體優化: `pin_memory=True`
# Reference
[python venv虛擬環境](https://dev.to/codemee/python-xu-ni-huan-jing-venv-nbg)
[pd.dataframe介紹](https://www.learncodewithmike.com/2020/11/python-pandas-dataframe-tutorial.html)
[Regression model in python](https://pyecontech.com/2019/12/28/python_regression/)
[Panda groupby用法](https://zhuanlan.zhihu.com/p/101284491)
[Polynomial regression](https://www.geeksforgeeks.org/machine-learning/python-implementation-of-polynomial-regression/)
[Pytorch 官方網站](https://docs.pytorch.org/docs/stable/generated/torch.nn.Linear.html)
[Pytorch gradient usage](https://docs.pytorch.org/tutorials/recipes/recipes/zeroing_out_gradients.html)
[Why need dataloader](https://ithelp.ithome.com.tw/articles/10277163)
[MLP介紹](https://chih-sheng-huang821.medium.com/%E6%A9%9F%E5%99%A8%E5%AD%B8%E7%BF%92-%E7%A5%9E%E7%B6%93%E7%B6%B2%E8%B7%AF-%E5%A4%9A%E5%B1%A4%E6%84%9F%E7%9F%A5%E6%A9%9F-multilayer-perceptron-mlp-%E5%90%AB%E8%A9%B3%E7%B4%B0%E6%8E%A8%E5%B0%8E-ee4f3d5d1b41)
[pytorch container](https://ithelp.ithome.com.tw/articles/10300573)