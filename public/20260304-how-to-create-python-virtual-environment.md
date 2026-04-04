---
title: Python 創建虛擬環境
aliases: ['Python 創建虛擬環境']
created: 2026-03-04 22:24:48
modified: 2026-03-04 22:39:40
published: 2026-03-04 22:24:48
tags: ['llm/note', 'python', 'venv', 'llm/gpt-53-codex', 'writing/how-to', 'public']
draft: False
description: "從零到一的 Python 虛擬環境，包含創建步驟、工作原理、常見坑和最佳實踐。"
---

虛擬環境是一個**項目級別的獨立 Python 運行空間**。它會爲當前項目準備一套獨立的：

- Python 解釋器入口（可執行文件）
- 第三方包安裝目錄（`site-packages`）
- `pip` 等工具

不同項目可以擁有不同版本的依賴，互不干擾。

## 爲什麼

- 依賴隔離：項目 A 用 `Django 4.x`，項目 B 用 `Django 5.x`，不會衝突。
- 可復現：通過 `requirements.txt` 或 `pyproject.toml`，別人能在自己的機器上還原同樣環境。
- 降低污染：不把包安裝到系統全局 Python，避免把電腦環境搞亂。
- 便於排障：當環境壞了，刪除重建 `.venv` 往往比修修補補更快。

## 作用原理

虛擬環境並不是“複製了一整套 Python”，而是建立一個本地目錄（常見名爲 `.venv`），裏面包含必要結構。

當你激活虛擬環境時，主要發生兩件事：

- 臨時修改 `PATH`：讓終端優先使用 `.venv` 裏的 `python` 和 `pip`。
- （通常）修改提示符：在命令行前顯示 `(.venv)`，提醒你正在該環境中。

因此你執行 `pip install xxx` 時，包會被安裝進 `.venv` 對應目錄，而不是系統全局目錄。

## 最佳實踐

### 檢查 Python

```bash
python3 --version
```

如果你電腦上 `python` 就是 Python 3，也可以用：

```bash
python --version
```

### 進入項目目錄並創建虛擬環境

```bash
cd your-project
python3 -m venv .venv
```

說明：

- `-m venv`：調用 Python 內置虛擬環境模塊。
- `.venv`：虛擬環境目錄名（推薦這個名字，主流工具識別友好）。

### 激活虛擬環境

macOS / Linux:

```bash
source .venv/bin/activate
```

Windows PowerShell:

```powershell
.venv\Scripts\Activate.ps1
```

Windows CMD:

```bat
.venv\Scripts\activate.bat
```

激活成功後，終端通常會出現 `(.venv)` 前綴。

### 驗證當前解釋器路徑

macOS / Linux:

```bash
which python
which pip
```

Windows:

```powershell
where python
where pip
```

輸出應指向項目內 `.venv` 目錄。

### 安裝依賴

```bash
python -m pip install requests
```

推薦寫法是 `python -m pip`，可以明確“當前解釋器對應的 pip”，降低裝錯環境的概率。

### 導出依賴（可選）

```bash
pip freeze > requirements.txt
```

別人拿到項目後可執行：

```bash
pip install -r requirements.txt
```

### 退出虛擬環境

```bash
deactivate
```

## 注意

- 不要把 `.venv/` 提交到 Git。
- 每個項目單獨一個虛擬環境，不要多個項目共享同一個環境。
- 解釋器版本要固定：例如用 `python3.11 -m venv .venv`。
- 激活失敗時先確認 shell 類型和激活腳本是否對應。
- Windows PowerShell 若報執行策略錯誤，可先執行：

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

- 優先用 `python -m pip install -U pip` 升級 pip，避免 `pip` 指向錯誤解釋器。
- 環境異常時，最穩妥方案常常是刪除 `.venv` 後重建。

## 推薦的最小工作流

每次新項目建議固定爲：

1. `python3 -m venv .venv`
2. `source .venv/bin/activate`（或 Windows 對應命令）
3. `python -m pip install -U pip`
4. 安裝項目依賴
5. `pip freeze > requirements.txt`
6. 在 `.gitignore` 中加入 `.venv/`

## 補充：和 Conda、Poetry 的關係

- `venv`：Python 官方內置，輕量、通用、學習成本最低。
- Conda：更偏數據科學生態，能管理非 Python 依賴。
- Poetry：在依賴管理與打包發佈流程上更完整。

如果你是 Python 初學者，先把 `venv` 用熟，再按項目需求選擇更高級工具。

---

如果你只記一件事：**任何 Python 項目開始前，先建 `.venv` 再安裝依賴**，否則就會遇到如下提醒：

```shell
If you wish to install a non-Debian-packaged Python package,
create a virtual environment using python3 -m venv path/to/venv.
Then use path/to/venv/bin/python and path/to/venv/bin/pip. Make
sure you have python3-full installed.

If you wish to install a non-Debian packaged Python application,
it may be easiest to use pipx install xyz, which will manage a
virtual environment for you. Make sure you have pipx installed.

See /usr/share/doc/python3.12/README.venv for more information.

note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
hint: See PEP 668 for the detailed specification.
```

在 Pycharm 中，開啓虛擬環境這件事情更加簡單：`Settings > Project: > Python Interpreter > Add Interpreter > Select Virtualenv`, via: https://www.jetbrains.com/help/pycharm/creating-virtual-environment.html#python_create_virtual_env

Source via: https://note.bgzo.cc/weekly/20260304-how-to-create-python-virtual-environment