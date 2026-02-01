---
created: 2025-08-03T14:22
updated: 2026-02-01T15:49
title:
---
2025-10-20 16:01

Status:

Tags:
目錄:
# Twitch-emoji-detector
這個想法是受 [[https://github.com/jasonli5/clash-royale-emote-detector]]這個repo的啟發，簡單來說他是用webcam藉由mediapipe去捕捉人的表情與手勢，去訓練一個classification model(他是用random forest)去辨識現在我們做的表情對應到哪個皇室戰爭表情貼圖(哪個class)。
我覺得蠻有趣的，之前就看過別人怎麼玩mediapipe，且這學期剛好在修機器學習概論，剛
好可以結合實做看看。

## Fixed bug or Improve point
### Python 版本問題
* 目前的mediapipe並不支援Python 3.14.2只能使用的版本在3.8-3.10之間，我是用requirements.txt下載所有的packages在虛擬環境venv裡，但venv不能指定python的版本，會與本機同步
* 解決方法：研究用pyproject.toml+Poetry來解決以上問題[[toml + Poetry]]
### Mediapipe 延遲問題
* 在opencv上開鏡頭都很正常沒有延遲，但用mediapipe後畫面會明顯延遲
* 解決方法：
	* GPU加速
	* 降解析度
### 想讓圖顯示的時間變長一點
* 原本想法讓引入`time`模組，在`cv.imshow`之後直接加一個`time.sleep(0.5)` ，但其實畫面還是只顯示一幀，還讓畫面更新慢了0.5秒。
* 解法：利用time stamp與durations來維持面呈現，紀錄每一幀開始時間為`current_time`，當每次按按鈕時紀錄該幀時間為`start_time`，當`current_time-start_time<durations`時，一直將在這個區間的frame上`cv.puttext`。

## Mediapipe
### 點位物件(landmarks index)
* Pose landmarks indices
<img src="pose_landmarks_index.png" width="40%"  align="center">
當存取`results.pose_landmarks[idx]`時得到的是一個具有三個屬性的Landmarks Object
1.  `.x`:歸一化後的水平座標(0.0到1.0)
2. `.y`：歸一化後的垂直座標(0.0到1.0)
3. `.z`：深度(Landmark附近深度)
在畫圖時要轉換成像素座標，公式為
$$
\begin{align}
p_{x}&=int(x*W_{image}) \\
p_{y}&=int(y*H_{{image}})
\end{align}
$$
   
* Hand landmarks indicies
<img src="finger_landmarks.png">
* Face landmarks indicies

###  繪製點位函數
是用`mp.solutions.drawing.utils.draw_landmarks`函式來繪製點位，我是使用Holistic模型，需要針對臉、手跟姿勢分開呼叫這個函數，因為它們的點位連接方式不同
1. `draw_landmarks`核心參數：主要有5個輸入
	1. `image` :我的opencv影響(必須要是BGR格式，因為opencv顯示是用BGR)
	2. `landmark_list`：偵測到的點位物件。例如`results.face_landmraks`或是`results.left_hand_landmarks`
	3. `connections`：點與點之間的連線規則。這告訴程式哪些點該連在一起(例如手指的順序)
	4. `landmark_drawing_spec`: 點的樣式(顏色、粗細、半徑)
	5. `connection_drawing_spec`:線的樣式(顏色、粗細)
2. Holistic model的具體寫法
	1. 繪製臉部
		* Landmark List:`results.face_landmarks`
		* Connections:`mp.solutions.holistic.FACEMESH_TESSELATION`(細密的網格)、`mp.solutions.holistic.FACEMESH_CONTOURS`(外輪廓、眼睛、嘴唇)
	2. 繪製手部
		* Landmark List: `results.left_hand_landmarks`跟`results.right_hand_landmarks`
		* Connections:`mp.solutions.holistic.HAND_CONNECTIONS`
	3. 繪製姿勢
		* Landmark List: `results.pose_landmarks`
		* Connections: `mp.solutions.holistic.POSE_CONNECTIONS
3. 自定義樣式(DrawingSpec)
	如果覺得預設的綠色線條太丑或太粗，可以使用`mp.solutions.drawing_utils.DrawingSpec`來調整：
	* 參數：`color=(B,G,R)`,`thickness=2(default)`,`circle_radius`=2(default)`
	* 範例：例如建立一個紅色的給臉部，白色給手部等
4. 根據我的目標圖片我選擇了幾樣landmarks特徵來標示與作為training data
	* pose:
	* hand:
	* face:

## Data preprocessing
- [x] 將選取的landmark data從object 攤平成array ✅ 2026-01-28
- [x] 將全部的trainging data 收集完後分成training data跟test data ✅ 2026-01-29
* 在取用holistic model  的結果作為訓練的input時，不能直接用絕對座標，因為就算對做沒有變，只要我們一起身，動作辨識會整個不準確，因此才要用相對座標。
* 而當畫面沒有偵測到部位像是只有偵測到左手沒有右手時，要用與原本偵測到的特徵等長等0向量來替代，因為當送進模型時你的輸入都要等長不然會報錯，而可以用0向量來代替的原因是，因為是用相對座標，通常不會有一個手勢手上所有的點都集中在一個點，我們也可以在多加一個特徵來判斷左手或右手有沒有出現。
* 捨棄掉深度座標，這是要看你要辨識的圖片是否有深度動作，如果沒有捨棄掉z可以大幅降低特徵數量，讓模型訓練速度加快
 
 ## Random forest model
 ### rf 參數選擇
 ```python
 from sklearn.ensemble import RandomForestClassifier
 rf_model = RandomForestClassifier(
	n_estimators=100, # 森林中數的數量
	max_depth=15, # 數的最大深度
	min_samples_split=5, # 分裂節點所需的最小樣本數
	min_samples_leaf=2, # 葉子節點所需的小樣本數
	mas_featueres='sqrt', # 尋找最佳分裂時所考慮的特徵數
	random_state=42,# 確保結果可復現
	n_jobs=-1 # 使用cpu核心進行訓練
 )
 ```
 * 參數選擇原因詳解
 * `n_estimators=100`
	- **原因：** 這代表你的森林裡有 100 棵樹。通常 100 是一個平衡點。樹越多，模型越穩定，但**儲存空間會變大，推論速度會變慢**。
	- **針對你的需求：** 因為你要做的是實時（Real-time）辨識，不建議設到 500 或 1000，否則 WebCam 可能會感到卡頓。
* `max_depth=15`
	- **原因：** 限制樹的深度。
	- **針對你的需求：** 你的特徵是相對簡單的座標。如果 `max_depth` 設為 `None`（無限深），模型會記住你錄製資料時的每一個細微抖動。限制在 10-20 之間，可以強迫模型學會更具「通用性」的規則。
*  `min_samples_split=5` 與 `min_samples_leaf=2`
	- **原因：** 這些是「剪枝（Pruning）」參數。
	- **針對你的需求：** 座標數據中會有很多相近的數值，這兩個參數能防止模型為了區分非常接近的點位而產生過於複雜的判斷邏輯，有效提升模型對不同使用者的適應力。
* `max_features='sqrt'`
	- **原因：** 每一棵樹只看 sqrt(121)≈11 個特徵。
	- **針對你的需求：** 這能增加樹與樹之間的「多樣性」。有些樹可能專注看手，有些專注看臉。最後投票出來的結果會比所有樹都看全部特徵來得精準。
### 訓練、使用與儲存模型
在訓練階段，將收集到的訓練data分成training data 跟test data，然後放入rf model來訓練，並用accurracy_score和classification_report來看模型預測的準確率。

當模型訓練好後，便要應用在實時的鏡頭，但如果直接用`predict.predict`直接輸出機率最高的分類的話，有可能每一個機率都很低他只是從幾個低的率挑一個最高的輸出，會很不準，所以我們用`model.predict_proba`輸出最高機率與其種類，可以設定一個值，當機率小於該值時，將種類設為沒有辨識到圖案。

`model.predict_proba`的輸出是一個二維陣列，因為在所有`sklearn`裡的模型他們的`predict`函數都被設計成批量處理，也就是如果一次丟了10幀的資料他會同時回傳10組機率，如果只傳一幀他還是會是一個2為矩陣
舉例來說，假設模型學會3個動作

| index | label | Probability |
| ----- | ----- | ----------- |
| 0     | frown | 0.9         |
| 1     | happy | 0.1         |
| 2     | sad   | 0           |
 ```python
 # Take the current frame's probability distribution
 probabilty = model.predict_proba[0]
 # Choose the max probability
 max_proba = np.max(probability) # 0.9
 # Get the max probability's index
 max_proba_idx = np.argmax(probability) # 0
 # Connect the idx with label
 max_prob_label = self.pose_labels[max_proba_idx] # frown
 ```

至於儲存與取用model，我利用`joblib` package來幫忙

## Collect training data
要好好考慮該如何設計這段程式！！！

參考別人的repo，似乎可以用不同按鍵來代表不同的功能，例如按1代表收集表情1的數據、按t代表將收集好的數據放進模型訓練等等，旦目前先寫一個程式來測試多個按鈕效果，參考這一篇[文章](https://blog.csdn.net/Jin1Yang/article/details/125206681)，

 讓程式自動存取data(例如過五秒後，讓程式自動擷取一個特定的動作固定的frame數作為trainging data)

將收集好的array取的方式，最推薦的是用`.npz`來儲存，因為
* 高效儲存數值資料
* 與scikit-learn完美整合
* 可以同時儲存特徵(X)與標籤(y)
* 載入速度快，節省記憶體
* [np.savez跟np.load用法](https://numpy.org/doc/2.2/reference/generated/numpy.load.html)

## Display the results

## 實做流程
- [x] 建立虛擬環境 ✅ 2026-01-27
- [x] Mediapipe, choose features ✅ 2026-01-27
- [x] Build the holistic part into class object ✅ 2026-01-29
- [x] collect the trainging data ✅ 2026-02-01
- [x] put data into ML model to train the model ✅ 2026-02-01
- [x] user interface ✅ 2026-02-01


# Reference
**[clash-royale-emote-detector](https://github.com/jasonli5/clash-royale-emote-detector)**[](https://github.com/jasonli5/clash-royale-emote-detector)
[Mediapipe 手勢+臉部標誌](https://steam.oxxostudio.tw/category/python/ai/ai-mediapipe-holistic.html)
[Mediapipe holistic repo](https://github.com/google-ai-edge/mediapipe/blob/master/docs/solutions/holistic.md)
[丁神圖奇表情符號網站](https://twitchemotes.com/channels/66548548)
[Pose, Hand, Face landmarks indicies](https://medium.com/@hotakoma/mediapipe-landmark-face-hand-pose-sequence-number-list-view-778364d6c414)
[Opencv manual](https://docs.opencv.org/4.x/dc/da5/tutorial_py_drawing_functions.html)
[Random forest parameters](https://ithelp.ithome.com.tw/articles/10359301)、[Random forest official manual](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html)
[Classification report](https://www.cnblogs.com/178mz/p/8558435.html)
