---
comments: True
draft: False
aliases: ['如何遷移 bangumi 賬號']
created: 2025-11-13 07:27:54
modified: 2025-11-15 12:42:39
tags: ['bangumi', 'writing/how-to']
title: 如何遷移 bangumi 賬號
type: how-to
description: 本篇指南屬於 https//pypi.org/project/bangumi_recovery/ 操作備忘 使用場景 你想把一個 Bangumi 賬號的數據（收藏、評分等）遷移到另一個賬號上。傳統上你可能需要： 1. 新建或更換賬號後想複製歷史收藏 2. 陸續把播放/觀看進度遷移到主賬號 3. 合併舊賬號數據到新賬號或做橫向備份 可能會很蛋疼，因爲： 1. 沒有一鍵導入：API 也沒有官方的“導入...
---


本篇指南屬於 https://pypi.org/project/bangumi_recovery/ 操作備忘

## 使用場景

你想把一個 Bangumi 賬號的數據（收藏、評分等）遷移到另一個賬號上。傳統上你可能需要：

1. 新建或更換賬號後想複製歷史收藏
2. 陸續把播放/觀看進度遷移到主賬號
3. 合併舊賬號數據到新賬號或做橫向備份

可能會很蛋疼，因爲：

1. 沒有一鍵導入：API 也沒有官方的“導入”端點
2. 需要多個多個瀏覽器去切換賬號並保證授權
3. 網絡或代理不穩定時，數據抓取與寫入容易失敗
4. 大批量操作會觸發限流，需要節流與重試機制

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

## 開始遷移

```bash
pipx install bangumi_recovery
bgm-clone user_id
```

## Related

- 如何批量標記 Bangumi 往季新番
- 如何刪除清空 bangumi 時間線

Source via: https://note.bgzo.cc/weekly/migrate-account-bangumi-to-another