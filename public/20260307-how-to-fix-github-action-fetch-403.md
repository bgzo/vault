---
title: 如何繞過拉取 403
aliases: ['GitHub Action 拉取 403', '如何繞過拉取 403']
created: 2026-03-07 22:13:26
modified: 2026-03-29 09:28:26
comments: True
draft: False
tags: ['cloudflare/worker', 'github/action', 'writing/how-to']
description: 因爲很多服務器屏蔽了 GitHub Action 的請求，所以更好的辦法是換 Cloudflare Worker 套一層，樣例如下： Source via https//note.bgzo.cc/weekly/20260307-how-to-fix-github-action-fetch-403
---

因爲很多服務器屏蔽了 GitHub Action 的請求，所以更好的辦法是換 Cloudflare Worker 套一層，樣例如下：

```js
export default {
  async fetch(request) {
    const target = "https://baidu.com";

    const resp = await fetch(target, {
      headers: {
        "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120 Safari/537.36",
        "Accept": "application/rss+xml,application/xml,text/xml",
      },
    });

    return new Response(await resp.text(), {
      headers: {
        "Content-Type": "application/rss+xml; charset=utf-8",
        "Access-Control-Allow-Origin": "*",
      },
    });
  },
};
```

Source via: https://note.bgzo.cc/weekly/20260307-how-to-fix-github-action-fetch-403