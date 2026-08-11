---
title: 如何禁用 Firefox 自動更新
aliases: 如何禁用 Firefox 自動更新
created: 2026-03-22 14:12:07
modified: 2026-06-19 17:14:46
published: 2026-03-22 14:12:07
tags: ['firefox', 'macos', 'public', 'update', 'writing/how-to']
draft: False
description: 核心思路是在 Firefox 所在目錄增加一個策略文件 distribution/policies.json，位置根據你的安裝目錄確定，比如 Mac 就是： Windows Scoop 就是： 內容爲： 重啓 Firefox，然後就能在關於中，就能看到： 你的組織禁用了更新 Source via https//note.bgzo.cc/weekly/20260322-how-to-ban-fire...
---

核心思路是在 Firefox 所在目錄增加一個策略文件 `distribution/policies.json`，位置根據你的安裝目錄確定，比如 Mac 就是：

```shell
"/Applications/Firefox Developer Edition.app/Contents/Resources/"
```

Windows Scoop 就是：

```shell
D:\Users\bgzo\scoop\apps\firefox-nightly-zh-cn\current
```

內容爲：

```json
{
  "policies": {
    "DisableAppUpdate": true
  }
}
```

重啓 Firefox，然後就能在關於中，就能看到：

> 你的組織禁用了更新

Source via: https://note.bgzo.cc/weekly/20260322-how-to-ban-firefox-update-on-mac