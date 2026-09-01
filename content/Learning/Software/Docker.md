---
created: 2025-08-03T14:22
updated: 2026-08-07T15:02
title:
---
2026-02-03 00:25

Status:

Tags:
目錄(ctrl+p):
# Docker
As example, i will build a docker that can run ROS2, Gazebo, rviz etc. and can use **SLAM** and **Navigation** to reach the destination .
Also need ML tool for training the RL model for local planner.

## GPU 在HOST端準備
1. 確認nvidia driver正常
	```zsh
	nvidia-smi
	```
2. 安裝docker
	```zsh
	sudo pacman -S docker docker-compose
	sudo systemctl enable --now docker
	sudo usermod -aG docker $USER
	```
3. 安裝NVIDIA Container Toolkit
	```zsh
	yay -S nvidia-container-toolkit
	sudo nvidia-ctk runtime configure --runtime=docker
	sudo systemctl restart docker
	```
4. 驗證GPU能進容器
```zsh
docker run --rm --gpus all nvidia/cuda:12.4.1-base-ubuntu22.04 nvidia-smi
```
### 在dockerfile需要做的設定

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
	3. **`freeglut3-dev`**：提供建立 OpenGL 視窗的工具箱，輔助圖形介面的生成。
### 建構邏輯
用[[ROS Navigation Robot Simulation purpose]]這個專案來作為解釋設計
#### 多階段建構
一開始會從官網用他們的image作為基準`FROM <IMAGE>`語法，而我們在FROM後在用AS來作為命名，進行多階段建構，主要功能是給目前建構階段取一個名字，方面後階段複製檔案，縮小最終映像檔檔案。

#### zsh & zsh plugin installation
在容器建立的過程中為 `/root` 使用者**自動化安裝與配置一套美觀且高效的 Zsh 終端機環境**（包含 Oh My Zsh 框架、兩款極實用的插件，以及 Spaceship 主題）。
1. 安裝oh-my-zsh
	```Dockerfile
	RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	```
	* `curl fsSL ...`:從Github下載Oh my Zsh 的官方安裝腳本(install.sh)
	* `--unattended`:預設的安裝腳本會在最後詢問是否把shell切換成zsh，並啟動zsh提示，這會卡住Docker建構流程。加上--unattended讓它在非互動模式下自動完成安裝，不等待使用者輸入
2. 下載plugins跟Theme
	```Dockerfile
	RUN git clone https://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    git clone https://github.com/spaceship-prompt/spaceship-prompt.git /root/.oh-my-zsh/custom/themes/spaceship-prompt --depth=1
	```
	* 利用&&將三個git clone串連在一起，分別將擴充元件下載到Oh My Zsh 的自訂目錄下(`/root/.oh-my-zsh/custom`)下：
	* - **`zsh-autosuggestions`**：自動補全外掛。會根據你過往輸入過的歷史指令，在輸入時自動出現灰色建議，按下右方向鍵 `→` 即可快速補全。
	- **`zsh-syntax-highlighting`**：語法高亮外掛。如果指令打對會顯示綠色，打錯（或不存在）會顯示紅色，方便即時檢查。
	- **`spaceship-prompt`**：Spaceship 主題。一款功能非常強大且精美的提示字元主題，支援顯示 Git 狀態、Node/Python/Docker 環境版本等資訊。
	    - `--depth=1`：只拉取最新一次的 Commit 歷史，以節省下載時間與 Image 體積。
3. 建立軟連結
	```Dockerfile
	RUN ln -s /root/.oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme /root/.oh-my-zsh/custom/themes/spaceship.zsh-theme
	```
	* `ln -s <來源> <目標>`：建立連結
	* 原因：因為Oh My Zsh 預設只會在`/root/.oh-my-zsh/custom/themes`根目錄尋找.zsh-theme主題檔。但Spaceship的儲存庫結構是把檔名放在子資料夾內，因此需要建立一個軟連結到上層，Oh My Zsh才能順利讀取到`ZSH-THEME="spaceship"`
4. 用sed去替換裡面文字
	*  在用`install.sh`安裝Oh My Zsh時，他就會自動在`/root/`下產生一個標準的.zshrc範本檔，因此我們只要用sed去替換裡面的設即可
	1. 切換主題至Spaceship
		* `sed -i 's/ZSH_THEME="robbyrussell/ZSH_THEME="spaceship"' /root/.zshrc`
		* `sed -i`: sed是Linux上的串流文字編譯器，-i代表直接修改檔案內容，而不是只把結果印在螢幕上
		* `s/舊字串/新字串/`：s代表替換
			* 舊字串:`ZSH_THEME=""robbyrussell`
			* 新字串：`ZSH_THEME=spaceship`
		* `/root/.zshrc`：要被修改的目標檔案
	2. 啟用自動補全與語法高亮外掛
		* `sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' /root/.zshrc`
#### 下載其他packages
通常會用以下指令來下載packages:
```Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
	<package1 name> \
	<package2 name> \
	&& rm -rf /lib/apt/lists/*
```
* -y: 代表對所有安裝都說yes
* --no-install-recommends:代表只安裝「必要的依賴套件（Depends）」，不安裝「推薦套件（Recommends）」
###  Install gazebo in docker for ros humble
參考官方網站，gazebo classic 11已經在2025停止維護了，而在我使用的ros jazzy最適合的gazebo版本是gazebo fortess(參考這個[網站](https://gazebosim.org/docs/latest/ros_installation/))，不確定目前Turtlebot3 apt是否與Fortess相依與否，因此改用官方`humble-devel branch source build`(參考[Gazebo Migration](https://gazebosim.org/docs/latest/migrating_gazebo_classic_ros2_packages/))。
但在官方文件跟在docker裡實做有以下差別：

|        | 下載地點                     | 原因                                                                                          |
| ------ | ------------------------ | ------------------------------------------------------------------------------------------- |
| 官方<br> | `~/turtlebot3_ws/src`    | 這是直接下載在家目錄，適用於個人電腦實裝                                                                        |
| docker | `/opt/turtlebot3_ws/src` | 下載在根目錄下的的`/opt`資料夾，在 Linux 中，`/opt` 通常是用來放「額外安裝的第三方軟體/套件」（例如 ROS 預設也是裝在 `/opt/ros/humble`）。 |
#### 困惑點：在dockerfile建構時選擇切換容器的shell至zsh時間點
* 在dockerfile建構時，繼續用`setup.bash`進行編譯
* 在進去docker後，預設打開zsh
於設定使用者環境指定zsh
 
 ## Compose.yaml
通常會命名為`docker-compose.yml`或是`compose.yaml`
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
* Clean specific image
```zsh
docker rmi <IMAGE-NAME>
```
# Reference
[Docker使用者權限](https://blog.wu-boy.com/2019/10/three-ways-to-setup-docker-user-and-group/)
[ENTRYPOINT vs. CMD](https://shiun.me/blog/dockerfile-cmd-vs-entrypoint/)
[gazebo - ros version installation](https://gazebosim.org/docs/latest/ros_installation/)