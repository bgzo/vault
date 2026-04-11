---
title: 如何修復 Steam Deck OLED 開機卡 Logo
aliases: ['How to fix steam deck stuck on logo when startup', '如何修復 Steam Deck OLED 開機卡 Logo']
created: 2025-11-30 14:01:38
modified: 2026-04-11 18:50:21
published: 2025-11-30 14:01:38
tags: ['public', 'writing/how-to']
draft: False
description: 先寫下自己怎麼搞壞的吧，我自己準備了一塊 Windows 的啓動盤，然後進 Windows，進去更新了 Windows，打好了驅動，但是發現藍牙無論如何都無法識別。Reddit 當然有一些方法，但 OLED 和 LED 的版本還不一樣，還沒有辦法通用，所以暫時無解。 折騰完，我看着挺完美，就直接放過去了，下個星期準備玩的時候才發現連 Steam 主系統都進不去了，非常震驚，是沒想到裝個 Windo...
---

先寫下自己怎麼搞壞的吧，我自己準備了一塊 Windows 的啓動盤，然後進 Windows，進去更新了 Windows，打好了驅動，但是發現藍牙無論如何都無法識別。Reddit 當然有一些方法，但 OLED 和 LED 的版本還不一樣，還沒有辦法通用，所以暫時無解。

折騰完，我看着挺完美，就直接放過去了，下個星期準備玩的時候才發現連 Steam 主系統都進不去了，非常震驚，是沒想到裝個 Windows 然後會把我的主系統都搞壞掉。

能怎麼辦呢，我收集了網上的資料，大致看了下：

1. 重置 CMOS；
2. 做一個 Linux 恢復鏡像，然後從 U 盤進入恢復系統；
3. 回滾系統；

最後我用第三種方法恢復了，第一種方法最坑，可能只適用 LCD 的機型，反正我試過之後，連 BIOS 都進不去了。

<iframe src="https://www.youtube.com/embed/Lqf8MT3xn8g" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
<center>via: <a href='https://www.youtube.com/watch?v=Lqf8MT3xn8g' target='_blank' class='external-link'>https://www.youtube.com/watch?v=Lqf8MT3xn8g</a></center>

第二種方法也很蠢，比較折騰，而且不知道我的數據能不能被完美的保留下來，我還存着非常多截圖在用戶目錄呢，不能就這麼丟了。

然後嘗試第三種方法成功了，具體步驟如下：

1. quick access + 電源鍵

2. 選擇下面的 B 版本系統，執行回滾

然後坐和等待，全程大概 20 分鐘，系統就恢復好了；

<iframe src="https://www.youtube.com/embed/FBIYKla2z_Y" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
<center>via: <a href='https://www.youtube.com/watch?v=FBIYKla2z_Y' target='_blank' class='external-link'>https://www.youtube.com/watch?v=FBIYKla2z_Y</a></center>

如果上述步驟無法解決你的問題，你可能只能通過方法 2 了，具體步驟可能需要查看官網的指南，如下： https://help.steampowered.com/zh-cn/faqs/view/1B71-EDF2-EB6D-2BB3

Source via: https://note.bgzo.cc/weekly/20251130-fix-steam-deck-stuck-on-logo-when-startup