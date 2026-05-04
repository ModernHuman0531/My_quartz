---
created: 2025-08-03T14:22
updated: 2026-04-24T16:00
title:
---
2026-03-30 21:44

Status:

Tags:[[Docker]]
目錄(ctrl+p):
# Final project
Use SUMO as the platform to do the traffic signal control.(Dockerfile perfered.)
## Docker settings
在docker裡要訓練RL模型，如果一直開著視覺化顯示會導致訓練效率低下，因此我會開兩個run的指令，一個是有視覺化的，一個是沒視覺化的，在通常訓練時用沒視覺化的指令，再看結果或是除錯時在用有視覺化的
### Setting for visualization
1. 在run 指令要開視覺化要設定一下，首先是要允許 Docker 容器把視窗畫面畫在你的螢幕上
```zsh
xhost +local:docker 
```
* xhost: 這是linux用來控制X server 存取權限工具
* + :增加權限
* local:代表權限授權對象是「這台電腦本地端的連線」
2. 還要建立一條實體的通訊管道，讓docker內部的圖形訊號能傳遞到主機
```zsh
X11_MOUNT = -v /tmp/.X11-unix:/tmp/.X11-unix
```
3. 強制停用共享記憶優化，以避免在docker顯示視覺化時產生黑畫面導致雖然有成功視覺化但螢幕無法顯示
```shell
QT_X11_NO_MITSHM=1
```
用`.env` file來控制不同作業系統的設定
## Main problem
- **安全違反風險（Safety Violations）**：現有的深度強化學習（DRL）模型通常將安全需求（如行人清空時間 PCI）視為獎勵函數中的「軟懲罰」（Soft Penalties） 。這種做法無法在現實世界中保證「零違規」，這對於公共安全是不可接受的 。
- **運算開銷過大**：傳統處理動作約束的方法多依賴「動作投影」（Action Projection）與二次規劃（QP） 。然而，QP 在處理擁有數百種相位組合的高維度交通網絡時，運算成本極高且擴展性差 。
- **低接受率與訓練不穩定**：在使用接受-拒絕法（AR）時，訓練初期的策略容易產生無效動作，導致接受率過低 。若代理人無法收集足夠的「安全經驗」，會導致訓練不穩定或失敗 。
- **複雜的時空動態**：捕捉行人的時空模式比單純計算車輛數量更困難，代理人必須在不造成車流死結的前提下優先考慮行人 。

## Main methods
### 1. 核心數學框架：ACRL 與 AR 方法

為了確保交通信號在任何情況下都不會違反安全規範（如行人清空時間），本專案捨棄了傳統的「軟獎勵懲罰」，轉而採用硬性的**動作約束強化學習（ACRL）** 。
- **接受-拒絕法 (Acceptance-Rejection Method, AR)**： 這是本專案的技術基石，源自 Hung 等人 (2025) 的研究 。
    - **運作機制**：將策略網絡（Policy Network）視為「建議分佈（Proposal Distribution）」。當網絡產生一個動作 at​ 時，會先通過一個驗證器（Oracle） 。
    - **動作篩選**：如果$a_{t}$屬於可行動作集 C($s_{t}$​)（符合安全限制），則執行該動作；若不屬於，則拒絕並重新採樣 。
    - **優勢**：相比於需要解二次規劃（QP）的投影法，AR 方法在大規模路網（高維度動作空間）中運算速度更快、擴展性更好 。
- **增強型二目標 MDP (Augmented MDP)**： 為了解決訓練初期因為隨機探索導致「接受率過低」的問題 ：
    - 系統會建構一個增強的獎勵機制，針對被拒絕的無效動作給予**懲罰訊號** 。
    - 這能有效引導策略網絡主動向「可行區域」靠攏，縮短訓練時間並提升穩定性 。
### 2. 交通與行人感知技術
為了精確定義什麼是「可行動作」，系統必須深入理解路口的即時狀態。
- **動態可行動作集導出 (DFASD)**： 採用 Nam 等人 (2026) 提出的演算法，根據感測器回傳的行人存在資訊，動態計算出當下合法的信號相位組合 。
- **行人特徵提取器 (Pedestrian Feature Extractor, PFE)**： 利用 Zhang 等人 (2026) 的技術，處理行蹤飄忽且具時空規律的行人數據，將其轉換為模型可理解的多模態狀態空間 S 。
### 3. 優化與學習機制
在實作上，專案採用了 **Actor-Critic 框架** 搭配 **廣義優勢估計（GAE）** ：
- **環境建模**：將狀態 s 定義為局部交通資訊（如排隊長度、車輛密度），動作 a 為號誌相位，獎勵 r 則是負的總等待時間 。
- **適應性 GAE 參數 (λ)**： 考慮到交通流量在尖峰與離峰時段有極大的變異性（High Variance） ：
    - 系統不使用固定的 λ，而是根據觀察到的 **時空差分誤差（TD-error）** 動態調整 λ 
    - 這能在交通狀況劇烈變化時，有效平衡優勢估計的偏差與變異數，確保學習過程不會崩潰 。
### 4. 實作流程簡述

1. **觀察 (Observe)**：透過 PFE 提取車流與行人狀態 st​ 。
2. **提案 (Propose)**：策略網絡輸出候選動作 。
3. **驗證 (Verify)**：透過 DFASD 定義的 C(st​) 進行 AR 篩選 。
4. **執行與更新 (Act & Update)**：執行安全動作，獲得獎勵（或懲罰），並根據動態 λ 的 GAE 更新模型 。
## Base case
### Build the environment(Simple intersection)
1.  Define nodes : One lane each direction first(simple_intersection.node.xml)
```xml
<node>

<\node>
```
2. Define edges(How to connect nodes: simple_intersection.edg.xml)
```xml

```
3. Define the connection of each edge (Because we restrict it to be only can go straight: simple_intersection.con.xml)
4. Use netconvert command to build net.xml file
	1. Add configure to let it generate sidewalk based on the edge: `--sidewalks.guess true`
	2. Add configure to let it generate the crossing between the edges: `--crossings.guess true
```zsh
netconvert -n single_intersection.nod.xml
		   -e single_intersection.edg.xml
		   -x single_intersection.con.xml
		   -o single_intersection.net.xml
		   --crossings.guess true
		   --sidewalks.guess true
```
5. Create vehicles and pedestrians flow
	* Define our own vtype of cars, and use flow to generate cars flow
	* Use the default pedestrian vtype, and use personFlow to generate pedestrian flow
```xml

```

tip:要先定義sidewalks在edge files裡面，否則在connections裡定義crossing時會無法生成
# Reference
[SUMO simulation docker](https://sumo.dlr.de/docs/Tutorials/Containerized_SUMO.html)
[Docker run command](https://hackmd.io/@joshhu/H1467RoUt)
[Reference repo](https://github.com/LucasAlegre/sumo-rl)
[Create sumo network reference](https://www.youtube.com/watch?v=eXW4D32ePpE)
[官方文件介紹各類.xml檔案該如何定義](https://sumo.dlr.de/docs/Networks/PlainXML.html)
[SUMO基礎用法簡介](https://hsuanchih-wang.medium.com/sumo-%E4%BD%BF%E7%94%A8%E6%95%99%E5%AD%B8-3-3-%E9%96%8B%E5%A7%8B%E6%A8%A1%E6%93%AC%E5%90%A7-89a3cfced6d7)
[SUMO abstract vehicles default parameters](https://sumo.dlr.de/docs/Vehicle_Type_Parameter_Defaults.html)
