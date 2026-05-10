---
title: 探索現有社交媒體 CLI 對導入 Obsidian 的可能性
aliases: ['探索現有社交媒體 CLI 對導入 Obsidian 的可能性']
created: 2026-03-21 20:12:10
modified: 2026-04-11 18:50:18
published: 2026-03-21 20:12:10
tags: ['ai/slop', 'public', 'twitter', 'writing/lab', 'xiaohongshu']
draft: False
description: 最近 X 的時間線頻繁春賢一個創作者： @jackwener，他有 5 個比較有代表性的作品： bilibili-cli twitter-cli discord-cli tg-cli xiaohongshu-cli 這些全都是客戶端級別的工具，面向 CLI 用戶，CLI 用戶是哪部份人呢？ AI。 當然也不盡然，吸引我的是這些平臺的 CLI 並不好做，我正好最近在全量導出自己的數據到 Obsidi...
---

最近 X 的時間線頻繁春賢一個創作者： [@jackwener](https://github.com/jackwener)，他有 5 個比較有代表性的作品：

- [bilibili-cli](https://github.com/jackwener/bilibili-cli)
- [twitter-cli](https://github.com/jackwener/twitter-cli)
- [discord-cli](https://github.com/jackwener/discord-cli)
- [tg-cli](https://github.com/jackwener/tg-cli)
- [xiaohongshu-cli](https://github.com/jackwener/xiaohongshu-cli)

這些全都是客戶端級別的工具，面向 CLI 用戶，CLI 用戶是哪部份人呢？

AI。

當然也不盡然，吸引我的是這些平臺的 CLI 並不好做，我正好最近在全量導出自己的數據到 Obsidian，最近就想想要不試試現有的輪子。

先說結論，**不行**，因爲幾個問題：

1. Python 項目不再維護，全面轉向 Node JS 的 Playwright https://github.com/jackwener/opencli ，並且很多命令失效；
2. 牆內社交媒體封控嚴重，在試用小紅書的時候，所有設備被強制下線，就算自己的網頁瀏覽，也會出現如 `驗證過於頻繁，請稍後重試` 等消息提醒；
3. CLI 的設計，註定無法與同步程序匹配；

## Python 轉 Typescript

語言其實不是問題，但是這代表兩種完全不同的工作方式，原來 PY 其實是對可見 API 的模擬，而新的 Open CLI 其實是第三方輔助對原生 APP 的操控，比如通過 Chrome 插件、系統無障礙權限（MacOS）[^wechat-send-msg] 等等。

問題是什麼呢？

1. 跨平臺
2. 複雜度

## 平臺封控

其實無論模擬 API 還是上輔助工具，都有一定的封號風險。

尤其自 AI 無止境蒸餾互聯網之後，每個平臺都趨於保守，都在封堵自己數據泄漏的問題，比如，知乎關閉過無登陸瀏覽，Reddit、Twitter 等 API 開始收費。

就像我之前使用 XHS，被全平臺踢下線之後，我就再也不敢用這些第三方工具了，自己的數據最重要。

## CLI 的設計

因爲自己 XHS 被強制下線了，再次登陸網頁端還是被無限驗證碼騷擾，所以用 Twitter 距離：

首先，登陸問題，CLI 直接從本地的緩存中讀取 Cookie 數據，這個操作敏感不說，在一些服務器環境非常不友好，我 SSH 連接服務器之後，連瀏覽器都不想打開，何談從瀏覽器獲取 Cookie ？逆天的是他還不支持輸入自己從瀏覽器獲得的 Cookie。

接着，持續獲取數據的能力，我的需求很簡單：一個收藏夾的分頁接口就行，twiiter 命令行是怎麼做的呢？

```shell
~ > twitter likes --help
Usage: twitter likes [OPTIONS] SCREEN_NAME
  Show tweets liked by a user. SCREEN_NAME is the @handle (without @).
  NOTE: Twitter/X made all likes private since June 2024. You can only view
  your own likes. Querying another user's likes will return empty results.

Options:
  -n, --max INTEGER  Max number of tweets to fetch.
  --json             Output as JSON.
  --yaml             Output as YAML.
  -o, --output TEXT  Save tweets to JSON file.
  --filter           Enable score-based filtering.
  --full-text        Show full tweet text in table output.
  --help             Show this message and exit.
```


能輸出簡單的 JSON 格式非常好，但是分頁的參數在哪裏？

沒有！

這意味着我得等他一次性爬 10000，然後我再去判斷是否應該導出？顯而易見，每次都要從頭爬到 Twitter 的 API 拒絕工作，肯定不現實，聽着就容易翻車封號，所以我看不出來用他的價值。

正如這些項目中寫的，這些工具都是給 AI SLOP 做的，Human 和其他項目就少參合了。

## 後話

漸漸地，我有一種危機感：數據的獲取難度會被這些 AI SLOP 捲上天，這些商業公司爲了防止自己的成本被這些機器人爬到難以支付的地步，會無止盡的擡價，或是門檻。最終有一天，我再也無法輕易取回我的數據了。

現階段似乎陷入了一種無論如何都解不開的狀態，想象一下，你身處一個公園中，可以自由地散步、欣賞風景，或者聚在廣場上，聽聽人們的討論。

突然有一天，有個人帶了條狗來到廣場，東嗅西嗅，甚至這些狗還要學你說話，人們發笑，慢慢地，牽狗的人也多了起來，不得不說，看一隻狗在那胡言亂語也挺有意思的。

但是突然有一天，一條野狗出現了，你不知道他是誰家的，但他依然能自說自話，接着不久，它甚至開始穿上我們的衣服，出現在我們面前，如果不認真分辨，根本不知道他是條狗。

現在，整座廣場都是這些似人似狗的東西，你想去廣場聽聽討論，你擠在熙熙攘攘的廣場上，認真聽了一下午，才發現這些聲音都參合着一些狗叫，你很疲憊，想去看看落日，才發現落日照耀下的這篇公園的基礎設施，早就被這羣東西毀的一團糟。

你想，狗可惡嗎？不對啊，狗狗多可愛啊，多忠誠啊，能有什麼壞心思呢？

但我不想跟狗聊天，不想成爲狗飼料，更不想成爲狗屎。

Source via: https://note.bgzo.cc/weekly/20260321-explore-opencli-and-others-cli-for-social-media