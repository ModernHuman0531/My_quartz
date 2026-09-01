---
created: 2025-08-03T14:22
updated: 2026-07-20T18:22
title:
---
2026-06-20 12:33

Status:

Tags:[[Nvim]],[[Kitty terminal emulator]],[[rofi]],[[Waybar]]
目錄(ctrl+p):
# Hyprland
我是參考下面的repo來作為hyprland的範例，因為我覺得一開始全都要自己設定實在是太難了，不如我先有其他人設定檔來參考，先摸熟並修改內容後等之後在做出自己的設定檔。
## 參考repo
因為我本身已經有在用kde 桌面，但那個repo是設定給還沒有任何桌面的人使用，因此需要修改`Install.sh`檔案。

他的shell會改變我原本就有的檔案例如：`~/.zshrc`, `~/.config/kitty`等都改名成`.bak`（不是刪除）
1. Can't type chinese
2. SUPER+ALT+H can't work.(resize problem)
3. nvim proble
## 自己寫設定檔
作法：先建立一個folder，然後建立連結從我們自己的設定檔folder連結到自己電腦裡的`~/.config` 資料夾裡。
相關指令：(以kitty為例)
* 建立連結：`ln -sf ~/Dunkun_config/kitty ~/.config/kitty`
* 查看連結：`ls -l ~/.config/kitty`
	* 如果成功連結，輸出特徵會有：
		* 最前方第一個字母會是`l`
		* 結尾路徑會 路徑A->路徑B，代表當軟體讀取路徑A時，底層會自動改讀取路徑B
* 斷開連結：`unlink ~/.config/kitty`
### 切換輸入法
在kde裡內建Fcitx5自動幫我在背景啟動跟切換輸入法，但在hyprland裡這些自動化的功能都要自己設定。當Hyprland啟動時，輸入法並沒有被呼叫，因此自然無法切換中英文。
要讓Fcitx5在Hyprland裡運作，需要補上以下動作：
#### 步驟一：讓輸入法開機時自動啟動
在`core/execs.conf`檔案中加上這行：
```Toml
# When power on, auto start Fcitx5
# -d means execute in background
exec-once = fcitx5 -d --replace
```
#### 步驟二：設定環境變數(讓軟體認識輸入法)
打開`user/env.conf`，加入以下環境變數：
```Toml
# 設定輸入法環境變數
env = QT_IM_MODULE, fcitx
env = XMODIFIERS, @im=fcitx
env = SDL_IM_MODULE, fcitx
env = GLFW_IM_MODULE, ibus
```
## 螢幕
### 方法一(嚴重延遲問題)
我想在有外接螢幕時只用外接螢幕，而沒有外接螢幕實在切換到內建螢幕。
在`user/monitors.conf`加上兩個螢幕的定義
```conf
# Auto-generated Config

# Workspace Mapping

# Can change between build-in monitor and External monitor

# 1. If no ecternal monitor, use build-in monitor
monitor = eDP-1, 1920x1080@144.42, 0x0, 1.5

#2. Once plug-in external monitor, only use it and set to 2k-144Hz
monitor = HDMI-A-1, 2560x1440@144, 0x0, 1

```
把在monitors.conf裡定義的註解掉，螢幕的控制全權交給下面的script來控制。
 在寫一個腳本讓他偵測現在是否有連結外接螢幕：
 ```zsh
 #!/usr/bin/env zsh
 # 定義筆電內建螢幕跟外接螢幕
 $INTERNAL="eDP-1"
 $EXTERNAL="HDMI-A-1"
 
 # 確認是否有外接螢幕(用hyprctl monitors all 列出所有monitor然後用grep -q找關鍵字)
 if hyprctl monitors all | grep -q "$EXTERNAL"; then
	 # 偵測到外接螢幕：啟用外接，關閉內建
	 hyprctl keyword monitor "$EXTERNAL, 2560x1440@144, 0x0, 1"
	 hyprctl keyword monitor "$INTERNAL, disable"
else
	# 沒有外接螢幕就用內建螢幕
	hyprctl keyword monitor "$INTERNAL, 1920x1080@144.42, 0x0, 1.5" 
fi
 ```
 然後在execs.conf裡啟動這個腳本：
 ```conf
 # 1. 剛進入hyprland後先執行一次，決定要使用哪一個螢幕
 exec-once = ~/.config/hypr/scripts/switch_monitor.sh
 
 # 2. 監聽螢幕插拔事件(當螢幕狀態改變時，自動重新執行腳本)
 exec-once = socat "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCESIGNATURE/.socket2.sock" - | stdbuf -pL grep '^monitor' | while read -r line; do ~/.config/hypr/scripts/switch_monitor.sh; done
 ```
 我們可以將第二個指令拆分成四個步驟：
1. `socat "UNIX-CONNECT:... - ` 
	1. `socat`是一個網路/資料傳輸工具。可以把了個不同資料通道連結在一起。
	2. `UNIX-CONNECT...`指向的是Hyprland的`.socket2.sock`。這是hyprland專門用來廣播事件的IPC窗口
	3. `-` 代表標準輸出
	4. - **白話解釋**：Hyprland 內部發生任何事（例如：視窗切換、工作區改變、螢幕插拔），都會發送訊息到這個 Socket。這行指令就像是**把一個聽診器貼在 Hyprland 的心臟上**，把所有即時事件全部「導流」出來印在畫面上。
2. `stdbuf -oL`
	1. **`stdbuf`** 是用來控制輸入輸出「緩衝區（Buffer）」的指令
	2. **`-oL`**（Line-buffered）意思是「只要滿一行，就立刻傳下去」。
	3. **白話解釋**：在 Linux 的管線（Pipe）傳輸中，系統為了效率，通常會等資料累積到一定大小（例如 4KB）才一次傳給下一個指令。這會導致嚴重的**延遲**（你拔掉 HDMI，可能要等好幾分鐘系統才收到訊號）。加上 `stdbuf -oL` 可以強迫系統「只要有新的一行訊息，就給我秒傳」，確保切換螢幕是即時（Real-time）的。
3. `grep '^monitor` 
	1. **`grep`** 是抓取關鍵字的工具。
	2. **`'^monitor'`** 是一個正規表示式，意思是「抓取開頭是 `monitor` 的那一行」。
	3. **白話解釋**：Hyprland 每秒鐘可能都會傳出幾十條訊息（像是滑鼠移動、視窗聚焦等）。但我們只關心螢幕插拔。當外接螢幕接上或斷開時，Hyprland 會噴出 `monitoradded>>...` 或 `monitorremoved>>...` 的訊息。這段 `grep` 就是一個**過濾網**，把其他無關的雜訊全部丟掉，只留下開頭是 `monitor` 的通知。
4. `while read -r line; do ... ; done`
	1. **`while read -r line`**：這是一個 Shell 迴圈，只要前面過濾出來的 `monitor` 訊息傳進來一行，它就會捕捉到。
	2. **`~/.config/hypr/scripts/switch_monitor.sh`**：一旦捕捉到任何一行，就執行一次你的切換腳本。
	3. **白話解釋**：這是一個**無窮迴圈的監聽器**。
		- 插上 HDMI $\rightarrow$ 產生 `monitoradded` $\rightarrow$ 被 `grep` 抓到 $\rightarrow$ 觸發腳本 $\rightarrow$ 關內建、開外接。
		- 拔掉 HDMI $\rightarrow$ 產生 `monitorremoved` $\rightarrow$ 被 `grep` 抓到 $\rightarrow$ 觸發腳本 $\rightarrow$ 開內建。
這表示不是 script 本身有 bug，而是 **你把唯一還在輸出的 monitor 關掉了，Hyprland 沒有來得及重新啟用 eDP-1**。
為什麼會這樣？
流程目前是：

```
插 HDMI
↓
script
↓
disable eDP-1
↓
只剩 HDMI
```
然後拔 HDMI：
```
HDMI 消失
↓
唯一 active monitor 消失
↓
Hyprland 已經沒有任何輸出
↓
socket event/script 可能根本來不及執行或無法恢復畫面
```
所以就黑屏了。

### 方法二：使用kanshi package
放棄使用腳本直接控制，轉而使用kanshi來定義workspace，disable一個螢幕風險還是太大了，因此轉而定義內建與外接螢幕各自workspace的位置，內建螢幕就擔任workspace 1其他的workspace都放在外接螢幕，當HDMI線拔掉時workspace也會自動跑回內建螢幕裡。

## 音訊問題
可以使用`pavucontrol`查看是否有背景音訊音訊，當我們從kde轉到hyprland時，kde的音訊後端沒有把硬體控制權乾淨地釋放出來，導致hyprland的PipeWire去存取硬體時直接撞牆，表面上雖然顯示，但底層的音訊通道其實已經斷掉了(所以不管是Youtube還是ncspot都發不出聲音)。
步驟1：強制重起用戶級systemd音訊服務
既然系統卡住了，直接強迫初始化，把卡住的硬體接口釋放掉。請在終端機中執行這行大絕招(這會同時重起核心、Pluse接口與路由管理器)：
```zsh
systemctl --user restart pipewire pipewire-pulse wireplumber
```

## 文件開啟
### pdf
1. 我們是以okular作為基礎打開文件，而okular依賴須確保以下指令：
```zsh
sudo pacman -Ss qt5-wayland qt6-wayland
```
2. 在`hypr/core/env.conf`這個變數檔案裡面加入以下環境變數
```Toml
# 🎨 修正 Qt 程式（如 Okular）在 Hyprland 下的渲染與外觀 env = QT_QPA_PLATFORM, wayland;xcb # 優先使用 Wayland，失敗才退回 X11 env = QT_AUTO_SCREEN_SCALE_FACTOR, 1 # 自動處理螢幕縮放 env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1 # 停用 Qt 自帶的視窗邊框（交由 Hyprland 處理）
```
### Word
推薦使用WPS office 來打開

## 想要的功能
- [x] 用Waybar來做上面的功能欄(可以添加wifi選擇欄功能 (https://github.com/LifeOfATitan/orbit)) ✅ 2026-07-07
- [x] Waybar切換windows時動畫 ✅ 2026-07-08
```txt
[現在] ➔ 使用 Waybar（穩定的頂部狀態列）+ 你的 Hyprland 核心 ↓ (用一兩週，熟悉快捷鍵、習慣平鋪邏輯、確保音量/網路工具都裝好) [進階] ➔ 保持 Waybar 不動，下載 AGS 來「單獨做右邊的控制中心/儀表板」 ↓ (體驗 AGS 的排錯流程，如果 AGS 崩潰了，至少頂部狀態列還在，不影響工作) [終極] ➔ 把 Waybar 停用，將頂部狀態列也寫進 AGS，達成全機 AGS 一體化
```
- [x] 下載WPS office，讓我們可以直接編輯word檔 ✅ 2026-07-08
	- Hyprland 的應用程式啟動器搜尋：OnlyOffice
- [x] 換掉現有hyprlock.conf，找網路上是否有參考的packages[參考repo](https://github.com/xCaptaiN09/pixie-sddm) ✅ 2026-07-08
`sudo systemctl enable sddm.service`

- [x] 加一個widget在旁邊顯示撥放的專輯或是影片封面使用[eww](https://elkowar.github.io/eww/)，寫完記得要測試換wallpaper可不可以用，如果不行要重作 ✅ 2026-07-18
- [x] fastfetch更改內容(https://github.com/itsfoss/text-script-files/tree/master/config/fastfetch) ✅ 2026-07-09
- [x] 用rofi做出換桌布的功能 ✅ 2026-07-18
- [ ] 了解rofi換桌布的shell是怎麼寫的，有些邏輯不懂(尤其是縮圖部份
- [x] nvim添加自動補全插件([hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)) ✅ 2026-07-20
- [x] 優化eww music displayer(可以參考我在網路上找到的酷[repo](https://github.com/abod8639/eww-music-widget)) ✅ 2026-07-20
- [x] 在waybar上添加新的功能 ✅ 2026-07-20
- [ ] 修理hyprlock issue(完全法克一直發生)

## Media playing info
可以使用`playerctl metadata` 來顯示出目前這在播訪的詳細資料，包括作家、歌曲名稱等。
## Bug fixed

### Screen locked issue
不一定是hyprlock的問題，有可能他找不到hyprlock在哪裡

### 音訊在重開機時會斷掉
原因：PipeWire重啟了兩次，一次是在systemmd裡啟動，一次是在hyprland裡的autostart又寫了啟動一次。
如何檢查pipewire是否正常
* `pgrep -af pipewire`應該只有:`pipewire`跟`pipewire-pluse`
* `pgrep -af wireplumber`應該只有一個
解決方法：既然systemmd已經會自行啟動pipewire，就沒必要在hyprland再起動一次了，因此把`exec-once = pipewire & pipewire-pulse & wireplumber`註解掉，然後直接登出hyprland或是重啟user service利用`systemctl --user restart pipewire pipewire-pulse wireplumber`指令 

# Reference
[Reference Repo](https://github.com/hayyaoe/zenities/)