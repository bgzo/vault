---
title: Twitter 數據導出
aliases: ['Twitter 數據導出']
created: 2026-02-14 18:39:04
modified: 2026-02-16 11:05:18
published: 2026-02-14 18:39:04
tags: ['writing/lab', 'twitter', 'export-to-obsidian', 'public']
draft: False
description: 本文爲 黑曜石導入計劃 的一部分，理由自不必多說。 我們來看看怎麼做？ 1. 官方存檔； 2. API 爬取； 官方存檔 官方從 Twitter 就一直有這個功能，支持下載自己的全部推文，還有賬號的一些其他數據，如果裏面的 README 文件所述不假，那麼這個存檔文件可能會超過 50GB。Of course, 一切都需要在你賬號沒有被徹底封禁之前請求，封掉就什麼都沒有了😊。 這也是一個偷懶的方法，...
---

> 本文爲 黑曜石導入計劃 的一部分，理由自不必多說。

我們來看看怎麼做？

1. 官方存檔；
2. API 爬取；

## 官方存檔

官方從 Twitter 就一直有這個功能，支持下載自己的全部推文，還有賬號的一些其他數據，如果裏面的 README 文件所述不假，那麼這個存檔文件可能會超過 50GB。Of course, 一切都需要在你賬號沒有被徹底封禁之前請求，封掉就什麼都沒有了😊。

這也是一個偷懶的方法，我在 懷念逝去的 Twitter 中寫過，Elon 取消了之前 Twitter 免費的 API，然後加入了更加嚴格的反爬限制，所以如果賬號裏面有幾千上萬的內容，最好還是先通過官方存檔一份。

當然官方也不是萬能的，尤其 Elon 收購 Twitter 之後大量裁員導致很多功能其實無人維護，我想，一個想到打造爲西方微信的軟件公司，團隊規模卻只有 30 個人，這太瘋狂了，不過我認爲他在學習 Telegram，但我還是覺得他們要比 TG 小氣得多，草臺得多，比如他的導出功能，其實是不包含書籤的。

![](https://x.com/imbGZo/status/2022682295115878412?s=20)

所以啊，你的書籤怎麼辦？只能自己用 API 慢慢爬了。但這不是這章的重點，先來看看哪幾個存檔文件有用：

- `data/like.js`: 喜歡的推文；
- `data/tweets.js`：發過的推文；

暫時就這兩個有用，唯一的遺憾是，like.js 裏面的推文沒有用戶名，沒有辦法做進一步的歸類，比較操蛋。

## 官方 API

## 開始做

### 重新整理了 Template

- 加入了 vibe 模板
- 加入了 env 文件
	- https://stackoverflow.com/questions/19331497/set-environment-variables-from-file-of-key-value-pairs
- 加入了.vscode debug 文件
	- https://github.com/golang/vscode-go/wiki/debugging

### 用 UV 還是 Poetry？

- UV 也能打包： https://hellowac.github.io/uv-zh-cn/guides/publish/
- https://zhuanlan.zhihu.com/p/663735038

### 跑一遍測試居然如此簡單

```shell
uv run ruff format --check .
uv run ruff check .
uv run pytest -q
```

Source via: https://note.bgzo.cc/weekly/20260214-twitter-archives-export-into-obsidian