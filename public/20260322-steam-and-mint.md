---
title: Steam 和 Mint
aliases: ['Steam 和 Mint']
created: 2026-03-22 19:23:43
modified: 2026-04-11 18:50:18
published: 2026-03-22 19:23:43
tags: ['mint', 'public', 'steam', 'writing/lab']
draft: False
description: 翻看書籤，看到了前半個月在 Mint 服務器上安裝 Steam 的經歷，想起來幾個操蛋的事情： Steam 開啓之後會自動進行更新，然後從更新到顯示這部分時間，是什麼都沒有的，沒有標籤欄圖標，後臺進程沒有真正啓動，所以如果你的網絡環境不行，實際效果就是：點和沒點沒區別。 很苦惱啊，怎麼都打不開，難道說 Steam 依賴跟其他亂八七糟的軟件衝突了？Steam 又沒有提供 AppImage 的包，怎麼...
---

翻看書籤，看到了前半個月在 Mint 服務器上安裝 Steam 的經歷，想起來幾個操蛋的事情：

Steam 開啓之後會自動進行更新，然後從更新到顯示這部分時間，是什麼都沒有的，沒有標籤欄圖標，後臺進程沒有真正啓動，所以如果你的網絡環境不行，實際效果就是：點和沒點沒區別。

很苦惱啊，怎麼都打不開，難道說 Steam 依賴跟其他亂八七糟的軟件衝突了？Steam 又沒有提供 AppImage 的包，怎麼辦呢？ 我去問 LLM

在經過了一大堆實驗，包括但不限於：

1. 檢測自己的硬件，驅動；
2. 檢測 Steam 依賴的包是否安裝；
3. 安裝 Flatpak 的 Steam；
4. 菜單的 Steam 圖標啓動命令替換；

然後某個時刻，我發現 Steam 打開登陸界面了，我想這破問題終於解決了，然後掃碼進去下了一個遊戲，測試了一下，可以正常遊玩，然後我就重啓了一下機器（因爲折騰的東西比較多）。

當我再次嘗試啓動的時候，發現他又沒反應了，我徹底崩潰了，用 flatpak 命令啓動之後

```shell
flatpak run com.valvesoftware.Steam
```

發現之前的數據都沒了，當時我的狀態簡直要崩潰了，我之前下載的遊戲和兼容層呢？

冷靜了一會兒，在自己的本地目錄排查了一下：

```shell
$ find ~ -type d -name steamapps 2>/dev/null

/home/bgzo/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps
/home/bgzo/.local/share/Steam/steamapps
```

這才發現端倪，原來之前的啓動的 Steam 是一開始的那個，而不是後來用 flatpak 裝的這個。

最後，拷貝了下之前的目錄，問題成功解決，以後就用 flatpak 的包了

```shell
rsync -av --progress ~/.local/share/Steam/steamapps/ ~/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/
```

一切正常運行
---
title: Steam 和 Mint
aliases:
  - Steam 和 Mint
created: 2026-03-22T19:23:43
modified: 2026-04-11T18:50:18
published: 2026-03-22T19:23:43
tags:
  - mint
  - public
  - steam
  - writing/lab
---

翻看書籤，看到了前半個月在 Mint 服務器上安裝 Steam 的經歷，想起來幾個操蛋的事情：

Steam 開啓之後會自動進行更新，然後從更新到顯示這部分時間，是什麼都沒有的，沒有標籤欄圖標，後臺進程沒有真正啓動，所以如果你的網絡環境不行，實際效果就是：點和沒點沒區別。

很苦惱啊，怎麼都打不開，難道說 Steam 依賴跟其他亂八七糟的軟件衝突了？Steam 又沒有提供 AppImage 的包，怎麼辦呢？ 我去問 LLM

在經過了一大堆實驗，包括但不限於：

1. 檢測自己的硬件，驅動；
2. 檢測 Steam 依賴的包是否安裝；
3. 安裝 Flatpak 的 Steam；
4. 菜單的 Steam 圖標啓動命令替換；

然後某個時刻，我發現 Steam 打開登陸界面了，我想這破問題終於解決了，然後掃碼進去下了一個遊戲，測試了一下，可以正常遊玩，然後我就重啓了一下機器（因爲折騰的東西比較多）。

當我再次嘗試啓動的時候，發現他又沒反應了，我徹底崩潰了，用 flatpak 命令啓動之後

```shell
flatpak run com.valvesoftware.Steam
```

發現之前的數據都沒了，當時我的狀態簡直要崩潰了，我之前下載的遊戲和兼容層呢？

冷靜了一會兒，在自己的本地目錄排查了一下：

```shell
$ find ~ -type d -name steamapps 2>/dev/null

/home/bgzo/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps
/home/bgzo/.local/share/Steam/steamapps
```

這才發現端倪，原來之前的啓動的 Steam 是一開始的那個，而不是後來用 flatpak 裝的這個。

最後，拷貝了下之前的目錄，問題成功解決，以後就用 flatpak 的包了

```shell
rsync -av --progress ~/.local/share/Steam/steamapps/ ~/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/
```

一切正常運行

Source via: https://note.bgzo.cc/weekly/20260322-steam-and-mint