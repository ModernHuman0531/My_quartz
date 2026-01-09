---
created: 2025-08-03T14:22
updated: 2026-01-08T18:01
title:
---
2025-09-27 15:12

Status:

Tags:

目錄:
# Github.io website
## 步驟
1. 環境準備
	* 先fork repo
	* 建立自己的github repo (ModernHuman0531.github.io)
	* 建立dockerfile and Makefile，讓我們能輸入一個指令啟動本地伺服器
2. 在本地的開發與預覽
	* 啟動環境
	* 修改配置(`_config.yml`)：這是網站的大腦。需要修改title(網站標題)、author(作者資訊)以及`url`(設為github pages的網址)
3. 佈署至Github Pages
	* Github actions
		* 推送我的程式碼到github
		* Github actions啟動一個虛擬環境(像docker一樣)
		* 在虛擬環境編譯好HTML
		* 將編譯好的靜態檔案佈署到`gh-pages`分支
## Dockerfile setting

## Makefile setting
* `docker build -t jekyll:latest`
	* build在同個資料夾下的dockerfile成image 並將他命名為 `jekyll:latest`
* `run:
	  docker run --rm -it \
		  --net=host \
		  --name jekyll \
		  --ulimit nofile=1024:524288 \
		  --mount type=bind,source=$(shell pwd), target=/site \
		  jekyll:latest`
	* `--rm`
		* container停止後自動刪除
	* `-it`
		* 互動式terminal，可以看到Jekyll log
	* `--net=host`
		* container直接用宿主網路
		* 所以`localhost:4000`在container跑＝本機可以直接打開
	* `--name` 
		* container名稱固定叫jekyll，方便docker exec
	* `--ulimit nofile=1024:524288`
		* 提高檔案描述上限
	* `--mount type=bind,source=$(shell pwd),target=/site
		* 在本機裡改markdown, container jekyll會立刻看到`
* `claen: docker rmi jekyll:latest`
	* 刪掉image
* `attach: -docker exec -it jekyll /bin/bash`
	* `-`:是為了即使container沒在跑也不要報錯
# Reference
[clone repo](https://github.com/mmistakes/minimal-mistakes)
[學長的範例](https://github.com/zebra314/zebra314.github.io)
[yt video](https://www.youtube.com/watch?v=Pof342wGt78)