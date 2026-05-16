---
title: Kazumi 同步 Bangumi
aliases: ['Kazumi 同步 Bangumi']
created: 2026-04-22 19:55:44
modified: 2026-05-16 23:57:51
published: 2026-05-01 23:57:51
tags: ['bangumi', 'flutter', 'kazumi', 'public', 'writing/lab']
draft: False
description: 距離提 PR，到最終合併進主分支，一共耗時半個月吧，前一個星期把大部分功能修了下，後一個星期則在 反反覆覆進行修改，其實沒有那麼輕鬆。 一開始是想找一個追番軟件去補舊番，我的需求比較簡單： 1. 集成 Bangumi 2. 支持截圖 3. 支持測載 iOS 所以壓根沒得選，只有 animeko 滿足這些條件，實際測試中，在我的 iPad 上表現的也不如 Android/Mac（比較慢），也沒事，我...
---

距離提 PR，[到最終合併進主分支](https://github.com/Predidit/Kazumi/pull/2001)，一共耗時半個月吧，前一個星期把大部分功能修了下，後一個星期則在 [反反覆覆進行修改](https://github.com/bgzo/Kazumi/pull/2)，其實沒有那麼輕鬆。

一開始是想找一個追番軟件去補舊番，我的需求比較簡單：

1. 集成 Bangumi
2. 支持截圖
3. 支持測載 iOS

所以壓根沒得選，只有 [animeko]( https://github.com/open-ani/animeko) 滿足這些條件，實際測試中，在我的 iPad 上表現的也不如 Android/Mac（比較慢），也沒事，我們可以用 Mac 來看，並且 Mac/Windows 支持截圖，對嗎？用了才知道，Mac 上的截圖按鈕有 BUG，死活不成功，點了一點反應都沒有，壓根沒法用，而且這個問題已經一年多了，完全沒有人修。

沒招了，Animeko 完全沒法用啊，退而求其次，把目光轉向 Kazumi。它雖然沒有集成 Bangumi，但截圖功能在手機上是好着的，有一個 [ISSUE](https://github.com/Predidit/Kazumi/issues/912) 也掛了好幾年了，一直沒有人做，因爲我自己寫了一個腳本拉取收藏到 Obsidian，所以在我看來僅僅是收藏同步的話，用 AccessToken 完全是可以做的，只是我自己沒怎麼寫過 Flutter，18 號有了這個想法，打算下個週末進行一波 Vibe Coding。

直到周內我發現 [@melancholyFishAndWater](https://github.com/melancholyFishAndWater ) 已經做過相關工作了，暗自竊喜 😊，想着說不定等等就有人做了，直到第二天起來收到回覆：

> 上面提到的問題看上去都沒有得到有效的解決:D
> https://github.com/Predidit/Kazumi/issues/912

我發現好像這個功能又要無疾而終，臥槽我有點急了，不能老是這樣吧。第二天下班連夜 clone melancholyFishAndWater 的代碼，開始本地調試，連着兩個晚上，做了一些初步的改進：

1. 加快同步速度；
2. 收藏即同步；

匆匆地拿着這個草稿去 [提 PR](https://github.com/Predidit/Kazumi/pull/2001)，雖然總得來說功能實現了，但是代碼還是一坨，哈哈，順帶連學帶練地就開始寫 Dart 了。

---

寫 PR 和改代碼都比較費勁，但好在最終合併了😊，這半個月我可是一部舊番都沒有看，因爲看番哪有寫代碼爽啊～

接下來，我終於能好好用 Kazumi 看幾部老番了。

Source via: https://note.bgzo.cc/weekly/20260422-kazumi-sync-with-bangumi