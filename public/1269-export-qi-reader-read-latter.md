---
published: 2025-12-06 21:11:11
aliases: ['導出 Qi Reader 的 Read latter']
created: 2025-12-06 21:11:11
modified: 2025-12-07 12:26:16
tags: ['writing/lab', 'export-to-obsidian', 'public']
draft: False
title: 導出 Qi Reader 的 Read latter
description: 上一次寫這個我記得還是給 https//rss.anyant.com/ 寫的，源碼在 https//github.com/bGZo/playground/tree/2022/01/rssant-backup 已經做的比較完善了，當然這種事情不太好，就沒有引流，自然也沒有多少人用，當時第一次抓包，寫的還比較費勁哈哈哈。 官方當然有計劃，但是已經快 2 年了，猜測是有什麼顧慮，因爲我比較急，就不等了，...
---

上一次寫這個我記得還是給 https://rss.anyant.com/ 寫的，源碼在 https://github.com/bGZo/playground/tree/2022/01/rssant-backup

已經做的比較完善了，當然這種事情不太好，就沒有引流，自然也沒有多少人用，當時第一次抓包，寫的還比較費勁哈哈哈。

官方當然有計劃，但是已經快 2 年了，猜測是有什麼顧慮，因爲我比較急，就不等了，Sorry～

<iframe src='https://github.com/oxyry/qireader/issues/116' style='height:40vh;width:100%' class='iframe-radius' allow='fullscreen'></iframe>
<center>via: <a href='https://github.com/oxyry/qireader/issues/116' target='_blank' class='external-link'>https://github.com/oxyry/qireader/issues/116</a></center>

## 抓包分析

```shell
GET https://www.qireader.com/api/streams/tag-xxx?articleOrder=0&count=25&id=tag-xxx&unreadOnly=false&olderThan=1764313764608411573
```

參數猜測分析：

我的稍後閱讀可能就是一個特別的標籤，查看列表本質就是查看我的標籤（查一個標籤表），然後關聯出文章；F12 看看自己的就能知道自己的 Read Latter ID 是多少。

至於文章內容，我發現 Qi Reader 默認情況下不會走網絡請求，什麼包都抓不到，說實話者挺奇怪的，可能最終的請求是在 Node 後端代理的吧，那數據是怎麼傳回前端的呢？爲什麼不會在控制檯顯示呢？

當然還有一個請求全文的接口，這個接口返回文章的內容，只不過都是 HTML 格式，如果要轉換 Markdown，還需要一番功夫。根據響應結構查了一下，用的應該是這個服務： https://github.com/ArchiveBox/readability-extractor

## 備忘

看了下 git 的時間線，上次做導出還是 8 月，已經過去了快 3 個月了，很多項目的規範都忘記了，代碼寫了又改，比一開始浪費時間。

還是沿用 黑曜石導入計劃 中的代碼結構，定義 QiReader Client 對整體請求進行包裝，然後跟其他的網站導出邏輯類似，過程比較順，沒遇到什麼卡殼。當然爲了偷懶，完全沒有做登錄劫持的那一步，太麻煩，直接用 `Cookie` 做的環境變量，用的時候直接 source 一遍環境變量就行，然後進行後續操作。

最終實現效果：

```shell
> pipx upgrade export_to_obsidian
> source .env
> eto qireader -t tag-xxx -o ./clippers/qireader/
```

export_to_obsidian 的版本（0.3.13） 發佈 🎉

Source via: https://note.bgzo.cc/weekly/1269-export-qi-reader-read-latter