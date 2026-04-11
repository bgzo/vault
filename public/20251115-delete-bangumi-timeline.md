---
title: 如何刪除清空 bangumi 時間線
aliases: ['如何刪除清空 bangumi 時間線']
created: 2025-11-15 12:24:32
modified: 2026-04-11 18:50:21
published: 2025-11-15 12:24:32
tags: ['bangumi', 'public', 'writing/how-to']
draft: False
description: 本篇指南屬於 https//pypi.org/project/bangumi_recovery/ 操作備忘 使用場景 你可能基於如下場景想要刪除自己的活動記錄/時間線： 1. 賬號被他人查看，想刪除敏感活動記錄。 2. 更換賬號或重置狀態前清理歷史。 3. 定期清理時間線以維護隱私。 前置準備 使用本工具你需要一些前置知識，如： 1. 會使用命令行工具（bash/zsh） 2. 已安裝 Pytho...
---

本篇指南屬於 https://pypi.org/project/bangumi_recovery/ 操作備忘

## 使用場景

你可能基於如下場景想要刪除自己的活動記錄/時間線：

1. 賬號被他人查看，想刪除敏感活動記錄。
2. 更換賬號或重置狀態前清理歷史。
3. 定期清理時間線以維護隱私。

## 前置準備

使用本工具你需要一些前置知識，如：

1. 會使用命令行工具（bash/zsh）
2. 已安裝 Python 3.11+ 環境並能使用 pipx 或 venv
3. 獲取當前登錄用戶的 Cookie，使用 `F12` 控制檯獲取
4. 在 zsh shell 中設置代理與 token：

```bash
export BGM_ACCESS_COOKIE="xxx"
export http_proxy="http://127.0.0.1:1080"
export https_proxy="http://127.0.0.1:1080"
export no_proxy="localhost,127.0.0.1,::1"
```

> [!warning]
> 跟之前兩篇不一樣的是，本需求因爲沒有官方 API 支持，只能利用已登陸的用戶 Cookie 進行操作

## 運行項目

```shell
pipx install bangumi_recovery
bgm-timeline-delete bool
```

## Related

- 如何遷移 bangumi 賬號
- 如何批量標記 Bangumi 往季新番

Source via: https://note.bgzo.cc/weekly/20251115-delete-bangumi-timeline