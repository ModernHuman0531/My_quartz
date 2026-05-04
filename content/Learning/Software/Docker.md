---
created: 2025-08-03T14:22
updated: 2026-04-22T10:18
title:
---
2026-02-03 00:25

Status:

Tags:
目錄(ctrl+p):
# Docker
As example, i will build a docker that can run ROS1, Gazebo, rviz etc. and can use **SLAM** and **Navigation** to reach the destination .
Also need ML tool for training the RL model for local planner.

## Dockerfile
Design the Dockerfile.
### 要如何知道每一個項目的dependencies
以在docker裡要視覺化作為例子(像是在[[Learning/Machine learning/Reinforcement Learning/Final project|Final project]]裡要用的sumo或是模擬機器人要用的rviz跟gazebo)，這裡以SUMO所需要的工具為例：
1. 編譯工具：這些套件將sumo的c++原始碼轉為電腦可執行的檔案
	1. `build-essential`:包含編譯c++的編譯器跟基礎函式庫
	2. `cmake`:負責自動偵測系統環境並生成正確的編譯路徑
2. 資料解析與地圖處理：SUMO需要讀取各類地圖格式，這些套件讓他具備處理空間資料的能力
	1. `libxerces-c-dev`:SUMO 的路網、車流、設定檔全是 **XML 格式**，這個套件專門負責解析這些 XML 。
	2. `libgdal-dev`:用於讀取地理空間數據（例如高度圖或衛星影像）。
	3. `libproj-dev`:負責**座標轉換**。它能將地球表面的經緯度座標轉換為 SUMO 模擬器中的 2D 平面座標（公尺）
3. 圖形介面 (GUI) 核心:若少了這些，編譯器會自動放棄產生圖形介面
	1. `libfox-1.6-dev`:GUI的核心。SUMO-GUI的視窗、按鈕跟選單都是基於FOX Toolkit構件的。沒有他就無法產生`sumo-gui執行檔
	2. **`libgl1-mesa-dev` & `libglu1-mesa-dev`**：提供 **OpenGL** 支援。這讓電腦能利用顯示卡（或 CPU 模擬）來渲染 3D 畫面，呈現車輛與路網路徑。
	3. **`freeglut3-dev`**：提供建立 OpenGL 視窗的工具箱，輔助圖形介面的生成。`

## Makefile
Design the Makefile to run Dockerfile.
1. Docker 預設是用root身份來啟動，但當要儲存或修改檔案時卻是以本機使用者的身份來企圖修改root的檔案因此會被拒絕，因此我們要設定來要求docker不要以root身份來啟動這個容器，請改用與宿主機目前使用者完全相同的UID 跟GID來執行容器內進程
## Useful command line in docker
## For existed docker images and containers
* List all the images
```zsh
docker image ls
```
* List all the container
```zsh
docker container ls
```
* Find the total space that docker occupy
```zsh
docker system df
```
## For cleaning the space
* Cleaning the cache when building the images
```zsh
docker builder prune -a
```
* Cleaning the unuse images
```zsh
docker image prune -a
```


# Reference
[Docker使用者權限](https://blog.wu-boy.com/2019/10/three-ways-to-setup-docker-user-and-group/)