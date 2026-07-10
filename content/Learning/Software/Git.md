---
created: 2025-08-03T14:22
updated: 2026-06-07T16:47
title:
---
2026-06-07 15:49

Status:

Tags:
目錄(ctrl+p):
# Git

## 協作github流程
會開多個branch，所以大概會有pull下來所有目前有的branch，建立、合併branch的指令。
### 同步最新的遠端狀態
先確保本地的main分支是最新的，並獲取所有branch的最新狀態
```zsh
git checkout main
git pull origin main
git fetch origin
```

### 建立一個整合測試用的分支
建議不要在main裡跑兩個merge。可以先建立一個暫時的分支，把兩個branches合併在一起，最後在合併至main branch裡。
```zsh
git checkout -b integration
```

### 合併分支
假設隊友的兩個`algo-a` and `algo-b`
1. 合併第一個分支
```zsh
git merge origin/algo-a
```

2. 合併第二個分支
```zsh
git merge origin/algo-b
```

3. 處理衝突
動到相同的檔案，先進去檔案裡解決衝突，然後：
```zsh
git add <衝突的檔案>
git commit -m "Merge info"
```
4. 合併進Main branch
```zsh
git checkout main
git merge intergration
git push origin main
```
### 刪除已合併的分支
```zsh
git push origin --delete <deleted-branch>
```
* Delete the local branch
```zsh
git branch -d <deleted-branch>
```
# Reference