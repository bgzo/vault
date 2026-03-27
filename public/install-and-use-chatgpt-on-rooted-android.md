---
comments: True
draft: False
aliases: ['How to install and use chatgpt on rooted android', 'What problem you could meet when using chatgpt on a rooted android']
created: 2025-06-12 23:41:37
modified: 2025-12-11 22:18:58
tags: ['writing/how-to']
title: How to install and use chatgpt on rooted android
type: how-to
description: 總的來說，在 ROOT 的手機上使用 chatGPT，你可能會遇到的幾個問題： 1. Devices's date and time are set properly 1. 2. PlayIntegrity Preauth PlayIntegrity verification failed 1. 3. Unusual Activity Coming from your system 1. 第一個可...
---


總的來說，在 ROOT 的手機上使用 chatGPT，你可能會遇到的幾個問題：

1. Devices's date and time are set properly
	1. ![](https://raw.githack.com/bGZo/assets/dev/2025/1749868182517.png)
2. PlayIntegrity: Preauth PlayIntegrity verification failed
	1. ![](https://raw.githack.com/bGZo/assets/dev/2025/1749826001219.jpg)
3. Unusual Activity Coming from your system
	1. ![](https://raw.githack.com/bGZo/assets/dev/2025/1749826400677.png)

第一個可能是手機的 Play 版本比較低，我在嘗試更新過後可以正常使用。

第二個和第三個其實是一個問題，就是 Play Integerity 不完成，Google 驗證過不去導致的。所以問題變成了如何修補 Play Integerity。先來下載這個 App 檢查下自己的環境：`Play Integrity API Checker`，看看這幾個指標：

- MEETS_DEVICE_INTEGRITY：系統沒被改動/解鎖（或成功僞裝）
- MEETS_BASIC_INTEGRITY：沒被當成模擬器 / 惡意環境
- MEETS_STRONG_INTEGRITY： 設備 + 系統 + 密鑰鏈全部原生純淨（**root / 自制 ROM 永遠=NO**）

顯然一個 ROOT 過後的手機不可能滿足上面三個條件，因此需要第三方模塊來隱藏，分別是：

1. Integrity Box v16, https://github.com/MeowDump/Integrity-Box
2. Play Integrity Fork v14, https://github.com/osm0sis/PlayIntegrityFork
3. Tricky Store, https://github.com/5ec1cff/TrickyStore

三個項目依次安裝，然後在模塊內運行，重啓手機，上面三個就能全綠了。

Source via: https://note.bgzo.cc/weekly/install-and-use-chatgpt-on-rooted-android