---
title: 圖牀遷移 Cloudflare R2
aliases: ['圖牀遷移 Cloudflare R2']
created: 2026-04-12 00:55:38
modified: 2026-04-12 22:09:38
tags: ['blog', 'cloudflare', 'public', 'writing/lab']
draft: False
published: 2026-04-12 16:23:58
description: 不得不說 CF 是互聯網界的活菩薩，免費提供的對象存儲量大管飽，對我這種沒人看的小透明足夠了： 存儲：10GB/月免費，每增加 1GB/月收取 0.015 美元 A 類操作：100 萬次操作/月免費，每增加 100 萬次操作收取 4.50 美元 B 類操作：1000 萬次操作/月免費，每增加 100 萬次操作收取 0.36 美元 出口流量費全免 [!TIP] 什麼意思呢？只有訪問次數計入賬單（A ...
---

不得不說 CF 是互聯網界的活菩薩，免費提供的對象存儲量大管飽，對我這種沒人看的小透明足夠了：

- 存儲：10GB/月免費，每增加 1GB/月收取 0.015 美元
- A 類操作：100 萬次操作/月免費，每增加 100 萬次操作收取 4.50 美元
- B 類操作：1000 萬次操作/月免費，每增加 100 萬次操作收取 0.36 美元
- 出口流量費全免

> [!TIP]
> 什麼意思呢？只有訪問次數計入賬單（A 類上傳，B 類訪問），無論多大的文件，流量費全免！

2026 年了，我可能是最後一個知道 Cloudflare R2 的人了吧，PicList + (Cloudflare R2) S3API，可能是博客圈的一套標準答案了。

我之前一直用 GitHub / NPM 存圖片，然後用一些公共的 CDN 做圖牀，其實也算方便，如果 CDN 有一天不能用了，或者我掛逼了，可以直接按規則把前綴改一下，圖片就都回來了。

爲什麼還要大動干戈，轉移到 Cloudflare 呢？

因爲我最近有傳視頻的需求了，之前我的博客很少有圖片，幾乎沒有視頻，我還能考壓縮把他們壓縮到 1M，512KB 內，所以最終 GitHub 倉庫不會很大，還能接受。

但這次我的視頻是 3M，已經不能簡單的壓縮了，上傳 GitHub 容易引起提及暴漲，並且對 GitHub 來說，圖牀其實已經是算違規操作了，按最近全球去微軟，GitHub Copilot 被薅羊毛的趨勢，財大氣粗的微軟可能也不一定靠譜。

沒有辦法，最終選擇看看 CF 吧。

大體遷移流程類似： https://zhuanlan.zhihu.com/p/2003661503337886355

我就不贅述了，我就簡單說遷移前後的一些心得：

## 二次壓縮

因爲最開始上傳 GitHub 用的 PicGo，那時還沒有大小管理的概念，所以上傳的圖片大多比較大，這次遷移，正好可以乘次機會再壓縮一遍：

我的圖片大多是 PNG，可以藉助 https://pngquant.org 工具通過如下命令無損壓縮

```shell
pngquant --force --ext .png *.png
```

就算圖片有其他格式，也可以通過 magick 轉換爲 PNG，執行上述操作

```shell
magick frieren.jpg frieren.png
```

如果效果不理想，那麼只能犧牲品質，進行有損壓縮

```shell
pngquant --force --ext .png --quality=60-80 frieren.png
```

## PicList 管理圖片和上傳圖片配置

我不理解爲什麼這兩個功能分開，因爲部分功能有重複。

但是如果想要用兩個功能（管理和上傳），最簡單的辦法就是 TOKEN 配置的時候配置管理員讀寫 [^manage-func]：

[^manage-func]: 雲端由於需要列出 bucket 列表，所以需要的權限比只上傳圖片更高，需要管理員讀和寫 via https://github.com/Kuingsmile/PicList/issues/473

![](https://private-user-images.githubusercontent.com/96409857/543530856-82f1df17-83b4-49b8-9ec5-36d37b7eac54.png?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NzYwMDI2NTIsIm5iZiI6MTc3NjAwMjM1MiwicGF0aCI6Ii85NjQwOTg1Ny81NDM1MzA4NTYtODJmMWRmMTctODNiNC00OWI4LTllYzUtMzZkMzdiN2VhYzU0LnBuZz9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNjA0MTIlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjYwNDEyVDEzNTkxMlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTFiZDMzYTliYjc0ZmI3ODE0NWQxODQxYjUwOWJhMjJjNzYzMDE4ZjRkMTIzNmQ2ZjlkNjQ1MTFkYTlhOWE0ZjcmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0JnJlc3BvbnNlLWNvbnRlbnQtdHlwZT1pbWFnZSUyRnBuZyJ9.y_8O3NFJ4CmSedqDXJ0d85yC6y-2LTMynfcqn_wC0Lc)

如果僅僅是上傳的話，配置第三個，對象讀寫的權限就完全可以勝任。

最終效果如下：

![](https://pub-89c11651a8434f18a530bd6f93e399da.r2.dev/2026/20260412220459533.webp)

## 自定義域名

我一開始有設置這個 ，但發現好像沒啥必要。

因爲域名也有過期的一天，如果有一天我掛逼了，鏈接最多活 10 年，那麼 10 年後呢？你的圖片還不是一樣全部掛掉了？

那麼怎麼辦呢？

還是用 CF 給的域名吧，活得比我久，也挺好的。

```shell
https://img.bgzo.cc
https://pub-89c11651a8434f18a530bd6f93e399da.r2.dev
```

Source via: https://note.bgzo.cc/weekly/20260412-migrate-img-host-to-cloudflare-r2