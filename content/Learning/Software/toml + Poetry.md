---
created: 2025-08-03T14:22
updated: 2026-03-31T16:44
title:
---
2026-01-24 18:41

Status:

Tags:
目錄:
- [[#pyproject.toml setting|pyproject.toml setting]]
	- [[#pyproject.toml setting#Part 1. Build system setting|Part 1. Build system setting]]
	- [[#pyproject.toml setting#Part 2. 定義專案名詞|Part 2. 定義專案名詞]]
	- [[#pyproject.toml setting#Part 3. 安裝packages|Part 3. 安裝packages]]
- [[#Makefile + poetry|Makefile + poetry]]
	- [[#Makefile + poetry#Step 1. Make sure install pyenv and poetry|Step 1. Make sure install pyenv and poetry]]
	- [[#Makefile + poetry#Step 2. Install python3.10 and assign it as the python version we use in venv|Step 2. Install python3.10 and assign it as the python version we use in venv]]
	- [[#Makefile + poetry#Step 3. Init virtual environment|Step 3. Init virtual environment]]
	- [[#Makefile + poetry#Step 4. Run the environment|Step 4. Run the environment]]
	- [[#Makefile + poetry#Step 5. Delete virtual environment and cache|Step 5. Delete virtual environment and cache]]

# toml + Poetry
Poetry 是一種封裝的工具項目，將建立虛擬環境(`python -m venv .venv`)、激活虛擬環境(`source .venv/bin/activate`)、編輯pyproject文件添加依賴聲明、用pip來安裝依賴(`pip install -e .`)全部的包成一個指令來替代
對於python版本問題的部份，如果單只是用`requierements.txt` +venv來建立虛擬環境的話， 他只會拿本機的python版本無法隨意指定python版本，因此我們會用pyenv來下載更之前的python版本，並用poetry(`poetry env use python3.9`)來指定python版本
## pyproject.toml setting
* 記得gitignore .venv檔案，因為檔案很大不應該要上傳
* `poetry config virtualenvs.in-project true`:將.venv檔案放在專案下
* 無法使用`poetry shell`直接激活虛擬環境的原因，是因為在`~/.zshrc`設定優先級問題，因此直接打`poetry run python <file_name.py>`來跑script在虛擬環境裡
### Part 1. Build system setting
將poetry 當做管理虛擬環境的工具
```toml
[build-system]
requires = ["poetry-core>=1.0.0"]
build-backend = "poetry.core.mansonry.api"
```
### Part 2. 定義專案名詞
```toml
[tool.poetry]
name = "Ding-emotes-detector"
version = "0.1.0"
description = "A program use machine learning to detect user's emote and match with Dingding248 twitch emotes"
readme = "README.md"
package-mode = false
```
### Part 3. 安裝packages
```toml
[tool.poetry.dependencies]
python = ">=3.9 <3.11"
numpy = "^1.21.0"
opencv-python = "^4.9.0"
scikit-learn = "^1.3.0"
mediapipe = "0.10.11"
pandas = "^1.5.0"
```
* 在這邊指定python的版本要介於3.9～3.11之間，但並不會幫你安裝對應版本，只會從本機有的python版本中找到符合條件的，因此如果你本機沒有符合規定的版本的話會報錯
* 通常版本指定會用`^`來寫表示以後面版本的為低標，可以接受只要最前面數字沒變得所有版本
* 但在mediapipe直接指定版本的原因是若不指定一個穩定的版本很容易下載到一個不完整的版本從而導致許多模組的欠缺

## Makefile + poetry
### Step 1. Make sure install pyenv and poetry
```makefile
check-tools:
@which poetry > /dev/null || (echo "Poetry is not installed. Please install Poetry to proceed." && exit 1)
@which pyenv > /dev/null || (echo "pyenv is not installed. Please install pyenv to proceed." && exit 1)
```
* 使用pyenv來下載之前版本的python而不影響本地python的版本，先確認是否有安裝pyenv跟poetry
### Step 2. Install python3.10 and assign it as the python version we use in venv
```makefile
	@pyenv install $(SPECIFIED-PYTHON) --skip-existing && (echo "Install of Python $(SPECIFIED-PYTHON) complete.")
	@pyenv local $(SPECIFIED-PYTHON) && (echo "Set local Python version to $(SPECIFIED-PYTHON).")
	@poetry env use $(SPECIFIED-PYTHON) && (echo "Poetry is now using Python $(SPECIFIED-PYTHON).")
```
* `pyenv install 3.10`:下載python3.10版本
* `pyenv local 3.10`:更改專案目錄的python版本
* `poetry use env 3.10`:指定虛擬環境用python3.10版本
### Step 3. Init virtual environment
```makefile
@poetry install && (echo "Project dependencies installed.)
```
這一行指令做了很多事
1.　讀`pyproject.toml`:確認允許使用哪些python版本
2.　選擇python interpreter: 會確認本機有哪些版本符合要求並使用，如果沒有符合要求的版本則會直接停止不會建環境
3.　建立虛擬環境:本質上其實就是跑`python3.10 -m venv .venv`
4. 讀取poetry.lock:確保所有人的packages版本相同
5. 在虛擬環境跑pip install，下載所有要求的packages
### Step 4. Run the environment
* 似乎是在.zshrc裡有設定，因此原本應該直接跑`poetry shell`就可以直接入虛擬環境的，但用zsh shell的話跑完指令仍會指向本機的python版本，因此只能直接跑script，用`poetry run python <file_name.py>`
### Step 5. Delete virtual environment and cache
因為有用poetry+.venv+python會產生：
```
.venv/                  ← 虛擬環境（最大）
__pycache__/            ← Python cache
*.pyc                   ← 編譯檔
.cache/                 ← 有些套件會用
.poetry-cache (少見)
.mypy_cache/
.pytest_cache/
```

```makefile
clean:
	@echo "Removing virtual environment..."
	@rm -rf .venv

	@echo "Removing Python cache..."
	@find . -type d -name "__pycache__" -exec rm -rf {} +
	@find . -type f -name "*.pyc" -delete

	@echo "Removing tool caches..."
	@rm -rf .pytest_cache .mypy_cache .cache

	@echo "Clean complete."
```
* 如果在之後還有想要添加的packages，先在toml 裡的dependicies加入packages名稱跟版本，先用`poetry lock`來跟poetry lock講說toml有變動，它會掃描 pyproject.toml 並重新產生 lock 檔，並利用`poetry install`下載packages，並用`poetry show <package_name>` 確認是否成功安裝
# Reference
[pyproject.toml introduction](https://www.youtube.com/watch?v=jd1aRE5pJWc)、[pyproject.toml參考(1)](https://www.fooish.com/python/pyproject-toml.html)、[pyproject.toml參考(2)](https://packaging.pythonlang.cn/en/latest/guides/writing-pyproject-toml/)
[Poetry 1](https://blog.kyomind.tw/python-poetry/)、[Poetry 2](https://blog.kyomind.tw/poetry-pyenv-practical-tips/)
