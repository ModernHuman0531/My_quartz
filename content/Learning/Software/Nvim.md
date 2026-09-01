---
created: 2025-08-03T14:22
updated: 2026-07-20T14:09
title:
---
1  2026-06-29 21:17

Status:

Tags:[[Vim]]
目錄(ctrl+p):
# Nvim
This note is for the Neovim setup configuration(including setup file and plugin.)
Use vim-plug to manage plugin.

使用init.lua來下載與匯入plugin還有其他的設定檔。
## init.lua 撰寫邏輯
### 下載vim plug

### 宣告plugin

### Plugin 載入


## 其他設定檔

### 
### Mappings 
在neovim裡面要設定按鍵語法是用`vim.keymap.set()`函數，他的基本語法結構是：
```lua
vim.keymap.set('{模式}', '{你按下的鍵}', '{觸發的功能}', { 額外參數 })
```
這四個位置分別代表：
1. 模式(Mode)
	 指定這個快捷鍵在哪個模式才有效：
	* 'n': Normal mode
	* 'i': insert mode
	* {'v','n'}:多個mode用大括號包住
2. 你按下的按鍵
	- 在鍵盤上敲擊的組合
	* `<Leader>`: Vim著名的前綴鍵(預設通常是space鍵)
	* `<C-a>`:代表ctrl+a
	* `<A-k>`:代表Alt+k
	* `<S-Tab>`:代表shift+Tab
	* `<CR>`:代表Return
3. 觸發的功能
	這可以是一串 **Vim 原生指令**，也可以是一個 **Lua 函式（Function）**。
	* ***字串形式（原生指令）**：`':w<CR>'`（等同於手動輸入 `:w` 並按 Enter 存檔）。
	- **函式形式（呼叫 Lua）**：`function() print("Hello") end` 或是呼叫套件的 API。
4. 額外參數
	- `silent = true`: 觸發快捷鍵時，下方命令列不會顯示提示訊息（保持畫面乾淨）。
	- `noremap = true`: 非遞迴映射（防止按鍵連續觸發造成死循環，`vim.keymap.set` 預設就已經是 `true` 了）。
	- `desc = "說明文字"`: **這非常重要！** 寫了說明文字後，你的 `which-key.nvim` 套件才能在跳出提示選單時，顯示這個快捷鍵是做什麼用的。
特殊設定：我們將space 鍵設成`<Leader>`，需要先將空白鍵的預設功能廢除，因此將`<Space>-><Nop>`

### 指令對應表

| **快捷鍵**           | **模式** | **觸發功能 / 指令**                                                                                       | **說明**                            |
| ----------------- | ------ | --------------------------------------------------------------------------------------------------- | --------------------------------- |
| `<Space>`         | N/V/X  | `<Nop>`                                                                                             | 停用空白鍵預設功能，將其設為 `Leader` 鍵         |
| `Shift + l`       | N      | `:bnext`                                                                                            | 切換到**右邊**下一個分頁                    |
| `Shift + h`       | N      | `:bprevious`                                                                                        | 切換到**左邊**上一個分頁                    |
| `<leader> q`      | N      | `:BufferClose`                                                                                      | 關閉當前分頁                            |
| `<leader> Q`      | N      | `:BufferClose!`                                                                                     | **強制關閉**當前分頁（不存檔）                 |
| `<leader> U`      | N      | `:bufdo bd`                                                                                         | **關閉所有**分頁標籤                      |
| `<leader> vs`     | N      | `:vsplit` + `:bnext`                                                                                | **垂直分割視窗**，並在右邊打開下一個分頁            |
| `Alt + Shift + h` | N      | `:BufferMovePrevious`                                                                               | 將目前分頁標籤**往左移**一格                  |
| `Alt + Shift + l` | N      | `:BufferMoveNext`                                                                                   | 將目前分頁標籤**往右移**一格                  |
| `Alt + 1` ~ `9`   | N      | `:BufferGoto 1~9`                                                                                   | 直接跳轉到第 1 到第 9 個分頁                 |
| `Alt + 0`         | N      | `:BufferLast`                                                                                       | 直接跳轉到**最後一個**分頁                   |
| `Alt + p`         | N      | `:BufferPin`                                                                                        | **釘選**當前分頁（防止被意外關閉）               |
| **快捷鍵**           | **模式** | **觸發功能 / 指令**                                                                                       | **說明**                            |
| `Ctrl + h`        | N      | `<C-w>h`                                                                                            | 游標跳到**左邊**視窗（可用於從編輯窗跳去樹狀圖）        |
| `Ctrl + j`        | N      | `<C-w>j`                                                                                            | 游標跳到**下面**視窗                      |
| `Ctrl + k`        | N      | `<C-w>k`                                                                                            | 游標跳到**上面**視窗                      |
| `Ctrl + l`        | N      | `<C-w>l`                                                                                            | 游標跳到**右邊**視窗（可用於從樹狀圖跳回編輯窗）        |
| `F5`              | N      | `:resize +2`                                                                                        | 將目前水平分割視窗**調高** 2 單位              |
| `F6`              | N      | `:resize -2`                                                                                        | 將目前水平分割視窗**調矮** 2 單位              |
| `F7`              | N      | `:vertical resize +2`                                                                               | 將目前垂直分割視窗**調寬** 2 單位              |
| `F8`              | N      | `:vertical resize -2`                                                                               | 將目前垂直分割視窗**調窄** 2 單位              |
| **快捷鍵**           | **模式** | **觸發功能 / 指令**                                                                                       | **說明**                            |
| `<leader> f`      | N      | `fzf-lua.files()`                                                                                   | 模糊搜尋**目前工作目錄 (CWD)** 的檔案          |
| `<leader> Fc`     | N      | 搜尋 `~/.config`                                                                                      | 模糊搜尋 **`.config` 設定檔資料夾**         |
| `<leader> Fh`     | N      | 搜尋 `~/`                                                                                             | 模糊搜尋**家目錄 (Home)**                |
| `<leader> Fl`     | N      | 搜尋 `~/.local/src`                                                                                   | 模糊搜尋 `~/.local/src` 資料夾           |
| `<leader> Ff`     | N      | 搜尋 `..`                                                                                             | 模糊搜尋**上一層目錄**                     |
| `<leader> Fr`     | N      | `fzf-lua.resume()`                                                                                  | 恢復（打開）上一次的搜尋結果                    |
| `<leader> g`      | N      | `fzf-lua.grep()`                                                                                    | 在專案全域進行**關鍵字搜尋 (Grep)**           |
| `<leader> G`      | N      | `fzf-lua.grep_cword()`                                                                              | 直接抓取**游標所在的單字**進行全專案搜尋            |
| **快捷鍵**           | **模式** | **觸發功能 / 指令**                                                                                       | **說明**                            |
| `<leader> w`      | N      | `:w`                                                                                                | 快速存檔（比原生少敲一個鍵）                    |
| `<leader> d`      | N      | `:w`                                                                                                | 另存新檔（後方自動帶一空格，方便直接打新名字）           |
| `<leader> s`      | N      | `:%s//g<Left><Left>`                                                                                | **全域字串取代**（游標會自動停在舊單字輸入區）         |
| `<leader> t`      | N      | `:NvimTreeToggle`                                                                                   | 開啟或關閉左側**樹狀空間（檔案瀏覽器）**            |
| `<leader> p`      | N      | `switch_theme`                                                                                      | 輪流切換不同主題配色（Catppuccin, Gruvbox 等） |
| `<leader> P`      | N      | `:PlugInstall`                                                                                      | 觸發 `vim-plug` 進行套件下載與安裝           |
| `<leader> z`      | N      | `FTerm.open()`                                                                                      | 開啟浮動終端機                           |
| `<Esc>`           | T      | `FTerm.close()`                                                                                     | 在終端機中按 Esc 關閉視窗，但**保持背景會話不中斷**    |
| `<leader> x`      | N      | `!chmod +x %`                                                                                       | 將當前寫好的腳本檔案**直接加上執行權限**            |
| `<leader> mv`     | N      | `:!mv %`                                                                                            | 快速移動（重新命名）當前檔案                    |
| `<leader> R`      | N      | `:so %`                                                                                             | **重新載入 Neovim 設定檔**（讓剛修改的設定立刻生效）  |
| `<leader> u`      | N      | `!xdg-open "<cWORD>"`                                                                               | **一鍵點擊網址**：用瀏覽器打開游標所在的網址          |
| `<leader> i`      | V      | `=gv`                                                                                               | 對選取範圍**自動排版縮排**，且保持選取狀態           |
| `<leader> W`      | N      | `:set wrap!`                                                                                        | 切換長文字是否自動折行 (Wrap/NoWrap)         |
| `<leader> l`      | N      | `:Twilight`                                                                                         | 開啟/關閉 Twilight 專注模式（周圍代碼變暗）       |
| **快捷鍵**           | **模式** | **功能 / 作用說明**                                                                                       |                                   |
| `<leader> csa`    | N      | 呼叫 `decisive` 套件，將當前密密麻麻的 **CSV 檔案自動對齊成精美表格**                                                       |                                   |
| `<leader> csA`    | N      | 清除 CSV 檔案的表格對齊，還原成原始逗號分隔格式                                                                          |                                   |
| `[c`              | N      | 在對齊的 CSV 表格中，將游標跳到**前一個欄位** (Column)                                                                |                                   |
| `]c`              | N      | 在對齊的 CSV 表格中，將游標跳到**下一個欄位** (Column)                                                                |                                   |
| `<leader> H`      | N      | 一鍵彈出/關閉系統監控面板（`htop`）                                                                               |                                   |
| `<leader> ma`     | N      | **自動編譯黑魔法**：自動將工作目錄 LCD 到當前檔案夾，並在背景執行 `sudo make uninstall && sudo make clean install`（改 C 語言專案超好用） |                                   |
| `<leader> nn`     | N      | **行號模式切換**：一鍵切換「純絕對行號」與「相對行號」（方便計算 `10j` 這種大跳躍）                                                     |                                   |

# Reference
[Refernece setup video](https://www.youtube.com/watch?v=zkOEdhfwXok)
[Vim plug readme file](https://github.com/junegunn/vim-plug)
[Neovim plugin 大全](https://github.com/rockerBOO/awesome-neovim)
[Nvim-cmp 自動補全插件](https://www.youtube.com/watch?v=gK31IVy0Gp0)