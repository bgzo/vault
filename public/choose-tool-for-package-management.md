---
draft: False
aliases: ['How to choose package management', 'Package-management']
created: 2025-04-06 15:30:19
modified: 2025-07-16 20:44:21
title: How to choose package management
tags: ['writing/how-to']
description: 跨平臺 | | Windows | Debian | return-archlinux | MacOS | Mark | | --------------------------- | :-----: | :----: | :-----------: | :---: | ------------------------------- | | winget | ✅ | ❌ | ❌ | ❌ | | |...
---


## 跨平臺

|                             | Windows | Debian | return-archlinux | MacOS | Mark                            |
| --------------------------- | :-----: | :----: | :-----------: | :---: | ------------------------------- |
| winget                      |    ✅    |   ❌    |       ❌       |   ❌   |                                 |
| scoop      |    ✅    |   ❌    |       ❌       |   ❌   |                                 |
| apt                         |    ❌    |   ✅    |       ❌       |   ❌   | 系統核心組件、穩定性要求高的軟件                |
| homebrew |    ❌    |   ✅    |       ✅       |   ✅   | 快速獲取穩定環境的軟件或新版本、開發工具、個人開發環境     |
| aur                         |    ❌    |   ❌    |       ✅       |   ❌   | 適合追求最新軟件、需要高度定製的用戶，或者喜歡滾動更新的環境。 |

## Windows

### Winget

### Scoop

## debian

### 系統自帶 APT 原理

1. .deb 二進制包：
    1. 軟件和依賴都打包成 .deb 文件，包含安裝路徑、依賴信息、腳本等。
2. 中央倉庫
    1. 官方倉庫由 Ubuntu/Debian 官方維護，經過嚴格測試和簽名驗證。
3. 系統級安裝
    1. 安裝位置固定，通常在 /usr/bin、/etc 等系統路徑，和系統核心組件共處。
4. 依賴和版本衝突處理複雜
    1. 系統級更新會導致依賴衝突或升級問題，包衝突可能影響整個系統穩定性。

## Archlinux

### Pacman

專門處理 .pkg.tar.zst 格式的**已編譯包**，不支持直接安裝源碼。

1. 讀取官方倉庫元數據（如 core, extra, community）。
2. 下載軟件的二進制包。
3. 自動處理依賴關係。
4. 解壓到系統路徑（/usr/bin, /etc, /lib 等）。

#### AUR 的原理

> [!note]
> AUR 和 pacman 的本質區別
>
> AUR 不是包管理器，是一個**社區託管的源碼包倉庫**，提供了構建軟件的“說明書”——PKGBUILD。

| **項目** | **pacman**                      | **AUR**                         |
| ------ | ------------------------------- | ------------------------------- |
| 類型     | **包管理器（Package Manager）**       | **用戶維護的源代碼倉庫（Repository）**      |
| 管理對象   | 已構建好的 .pkg.tar.zst 二進制包         | **源碼 + 構建腳本（PKGBUILD）**         |
| 安裝方式   | 直接下載並安裝二進制包                     | 克隆源碼倉庫，執行構建腳本，再安裝               |
| 更新機制   | 統一由官方倉庫控制                       | 完全由社區用戶貢獻和維護                    |
| 工具命令   | pacman -S, pacman -R, pacman -U | 需配合 AUR helper（如 yay, paru）     |
| 速度     | 極快（下載即裝）                        | 相對較慢（clone -> build -> install） |

1. **PKGBUILD 文件**
    1. 每個包由一個名爲 PKGBUILD 的腳本文件定義，說明如何下載源碼、編譯和安裝。
2. **用戶編譯源碼**
    1. 使用 makepkg 命令讀取 PKGBUILD，從源碼編譯生成 .pkg.tar.zst 二進制包。
3. **輔以 AUR Helper**
    1. 如 yay, paru 等工具提供自動解析依賴、編譯安裝、更新等操作。
4. **系統級安裝**
    1. 最終通過 pacman 安裝，和系統包共存，不像 Homebrew 那樣自成體系。

## Macos

### Homebrew

1. **Formula 配方**
    1. 每個軟件都有一個稱爲 **formula** 的 Ruby 腳本，描述瞭如何安裝這個軟件（包括下載地址、依賴、編譯參數等）。
    2. 舉例：brew install neovim 會查找 Neovim 的 formula，決定用源碼編譯還是下載預編譯包。
2. **安裝路徑**
    1. 默認安裝在 /home/linuxbrew/.linuxbrew（或 macOS 上的 /usr/local/Cellar），**不影響系統自帶的包和依賴**。
    2. 使用軟鏈接將軟件鏈接到可執行路徑，如 /home/linuxbrew/.linuxbrew/bin。
3. **依賴管理**
    1. Homebrew 會爲每個軟件管理獨立的依賴，**避免全局污染**，適合構建隔離的開發環境。
4. **Binary Bottles**
    1. 通常直接從預編譯的二進制包（bottle）安裝，無需源碼編譯。
    2. 當然也支持從源碼編譯（用 --build-from-source）。

## 總結 #llm/chatgpt

|                | APT                                                           | ~Homebrew-brew                                                       | AUR                                               |
| -------------- | ------------------------------------------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------- |
| 軟件包數量和社區活躍度    | **APT** 倉庫中的軟件通常是經過嚴格測試的穩定版本，但更新較慢，有時可能滯後於官方版本。               | 軟件包數量雖然多，但整體遠不及 AUR，尤其是一些小衆或定製軟件可能找不到。<br>                              | 擁有極其龐大的軟件包數量和社區支持，幾乎任何軟件都能在 AUR 找到，而且更新速度非常快。<br> |
| 軟件包多樣性和覆蓋度     |                                                               | 主要維護穩定版，開發版或實驗性版本較少。                                                    | 涵蓋範圍極廣，既有穩定版、開發版、甚至是測試版或實驗性軟件。                    |
| 定製化            |                                                               | 雖然可以修改 formula，但定製過程不如 AUR 靈活，且複雜度更高                                    | 用戶可以直接修改 PKGBUILD 文件，自定義編譯參數，輕鬆打造符合自己需求的軟件包。      |
| 滾動更新           |                                                               | 雖然更新快，但不如 AUR 那麼前沿                                                      | 滾動更新模式，用戶總能使用到最新版本的軟件。                            |
| 依賴管理           |                                                               | 依賴管理較嚴格，依賴鏈由 Homebrew 維護                                                | 依賴管理非常靈活，可以從源碼編譯，完全控制依賴版本。                        |
| 安裝方式           |                                                               | 主要提供二進制包，源碼編譯不是默認選項。                                                    | 用戶可以選擇從源碼編譯安裝，也可以直接安裝二進制包。源碼編譯更靈活。                |
| 獨立於系統          | APT 直接影響系統庫和組件，容易引發系統依賴問題。                                    | Homebrew 安裝在 /home/linuxbrew 或 /usr/local 下，不影響系統自帶的軟件，避免因系統升級或包衝突導致問題。 |                                                   |
| 軟件版本管理         | APT 主要通過 apt install package=version 來安裝指定版本，但不如 Homebrew 直觀。 | Homebrew 支持多版本軟件共存和切換，比如通過 brew link/unlink 選擇不同版本。                     |                                                   |
| 跨平臺一致性         | APT 僅限於 Debian 繫系統（Ubuntu、Debian 等）                           | Homebrew 提供一致的體驗，可以在 macOS 和 Linux 之間無縫切換。                               |                                                   |
| 更容易安裝非官方或第三方軟件 | APT 需要手動添加 PPA 源或編譯安裝，步驟較繁瑣。                                  | Homebrew 支持**自定義 formula**（配方），允許輕鬆安裝 GitHub 上的開源項目或個人開發的軟件包。           |                                                   |
| 簡潔和統一的命令管理     | APT 的命令雖然功能強大，但語法有時較複雜，比如 apt-get 和 apt 的區別容易讓人混淆。            | Homebrew 的命令非常直觀，如 brew install、brew upgrade、brew uninstall，操作簡單。       |                                                   |

Source via: https://note.bgzo.cc/weekly/choose-tool-for-package-management