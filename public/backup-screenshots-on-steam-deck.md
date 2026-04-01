---
comments: True
draft: False
aliases: ['如何在 Steam Deck 上備份截圖']
created: 2025-12-08 22:18:09
modified: 2025-12-08 23:31:04
tags: ['writing/how-to']
title: 如何在 Steam Deck 上備份截圖
description: Steam 本地當然提供了截圖的管理功能，還有畫廊，還有 Steam 雲上傳，全程無縫，但是有個問題，我有上千張截圖，你讓我一個一個上傳？簡直在開玩笑，好吧。 藉助之前的折騰： 在 Steam Deck 上開啓用戶級別的 SMB，我們有了一個隨便怎麼折騰都不會掛掉的 SMB 服務，可以隨時用 Mac 等設備連上 Steam，管理 Steam 的文件。 這樣的背景下，我們的管理截圖的需求就變成了如何...
---

Steam 本地當然提供了截圖的管理功能，還有畫廊，還有 Steam 雲上傳，全程無縫，但是有個問題，我有上千張截圖，你讓我一個一個上傳？簡直在開玩笑，好吧。

藉助之前的折騰： 在 Steam Deck 上開啓用戶級別的 SMB，我們有了一個隨便怎麼折騰都不會掛掉的 SMB 服務，可以隨時用 Mac 等設備連上 Steam，管理 Steam 的文件。

這樣的背景下，我們的管理截圖的需求就變成了如何快速定位截圖的位置，我們可以用軟連接達到這一點，因爲用戶目錄一般都是在緩存裏存着，所以最好創建一個用戶目錄級別的軟連接：

```shell
ln -s /home/deck/.local/share/Steam/userdata /home/deck/userdata
```

因爲我有三個 steam 賬戶，所以對我而言，需要創建三個截圖目錄，具體命令如下：

```shell
ln -s /home/deck/.local/share/Steam/userdata/12467603290/760/remote /home/deck/Pictures/bgzous
ln -s /home/deck/.local/share/Steam/userdata/131140098148/760/remote /home/deck/Pictures/bgzocn
ln -s /home/deck/.local/share/Steam/userdata/141420650290/760/remote /home/deck/Pictures/bgzotr
```

這樣，下次直接訪問 `Pictures` 就可以直達自己賬戶下游戲的目錄，如果需要備份，直接拖出來就是，或者使用 `rclone`，都很好。

我是直接拖到 Onedrive 備份的，這裏就不贅述了，感興趣的人自行研究。

順便貼一下，本地錄製的目錄在

`~/.local/share/Steam/userdata/<你的Steam ID>/gamerecordings/`， 但都是 steam 內部格式，需要在桌面端圖庫界面進行導出之後才能在 Videos 目錄下找到。

Source via: https://note.bgzo.cc/weekly/backup-screenshots-on-steam-deck