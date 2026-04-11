---
title: 連接 Threads
aliases: ['連接 Threads']
created: 2025-11-16 14:14:24
modified: 2026-04-11 18:50:19
published: 2025-11-16 14:14:24
tags: ['export-to-obsidian', 'gtd/todo', 'public', 'writing/lab']
draft: False
description: 背景：Social media post sync 需求 兩種實現方案 1. 盜版 API 2. 正版 API 正版 API via https//github.com/tirthpatell/threads-go 註冊開發者，居然需要註冊手機號，而且用哪個手機號都發不出短信 ip 被 meta 送中了，meta/facebook 系的 ip 規則十分嚴格，甚至可以說嚴格到變態。而且最致命的是無解...
---

背景：Social media post sync 需求

## 兩種實現方案

1. 盜版 API
2. 正版 API

### 正版 API

<iframe src='https://github.com/tirthpatell/threads-go' style='height:40vh;width:100%' class='iframe-radius' allow='fullscreen'></iframe>
<center>via: <a href='https://github.com/tirthpatell/threads-go' target='_blank' class='external-link'>https://github.com/tirthpatell/threads-go</a></center>

[註冊開發者](https://developers.facebook.com/async/registration/dialog/?src=default )，居然需要註冊手機號，而且用哪個手機號都發不出短信

> ip 被 meta 送中了，meta/facebook 系的 ip 規則十分嚴格，甚至可以說嚴格到變態。而且最致命的是無解
> https://www.v2ex.com/t/1154689

暫時無解了，我操

## 參考

- https://developers.facebook.com/docs/development/create-an-app/
- https://www.reddit.com/r/Instagram/comments/hm2e1a/error_on_instagram_try_again_later/?tl=zh-hans

Source via: https://note.bgzo.cc/weekly/20251116-connect-meta-api-using-golang