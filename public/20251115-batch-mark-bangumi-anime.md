---
title: 如何批量標記 bangumi 往季新番
aliases: ['如何批量標記 bangumi 往季新番', '如何批量標記往季新番']
created: 2025-11-15 12:34:34
modified: 2026-04-11 18:50:21
published: 2025-11-15 12:34:34
tags: ['bangumi', 'public', 'writing/how-to']
draft: False
description: 本篇指南屬於 https//pypi.org/project/bangumi_recovery/ 操作備忘 使用場景 你可能是一個多年的追番達人，突然某一天發現了 https//bangumi.tv/ 這樣一個網站，你很希望擁有自己的一套收藏夾，但是可能會有如下問題： 1. 手動點格子耗時且容易出錯； 2. 代理或網絡不穩定會整個過程有點坐牢； 當然，你也有可能是豆瓣難民，遷移來這裏，你同樣面臨如...
---

本篇指南屬於 https://pypi.org/project/bangumi_recovery/ 操作備忘

## 使用場景

你可能是一個多年的追番達人，突然某一天發現了 https://bangumi.tv/ 這樣一個網站，你很希望擁有自己的一套收藏夾，但是可能會有如下問題：

1. 手動點格子耗時且容易出錯；
2. 代理或網絡不穩定會整個過程有點坐牢；

當然，你也有可能是豆瓣難民，遷移來這裏，你同樣面臨如上問題。

## 前置準備

使用本工具你需要一些前置知識，如：

1. 會使用命令行工具（bash/zsh）
2. 已安裝 Python 3.11+ 環境並能使用 pipx 或 venv
3. 在 Bangumi `next` [頁面](https://next.bgm.tv/demo/access-token) 獲取要目標賬號的 `access_token`
4. 在 zsh shell 中設置代理與 token：

```bash
export BGM_ACCESS_TOKEN="xxx"
export http_proxy="http://127.0.0.1:1080"
export https_proxy="http://127.0.0.1:1080"
export no_proxy="localhost,127.0.0.1,::1"
```

## 開始

```bash
pipx install bangumi_recovery
bgm-click-server
```

本地瀏覽器打開運行的項目，效果圖如下：

![](https://raw.githack.com/bGZo/assets/dev/2025/202508021025451.png)

## Related

- 如何遷移 bangumi 賬號
- 如何刪除清空 bangumi 時間線

Source via: https://note.bgzo.cc/weekly/20251115-batch-mark-bangumi-anime