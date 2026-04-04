---
title: 如何禁用 Firefox 自動更新
aliases: ['如何禁用 Firefox 自動更新']
created: 2026-03-22 14:12:07
modified: 2026-03-22 14:20:42
published: 2026-03-22 14:12:07
tags: ['firefox', 'macos', 'update', 'writing/how-to', 'public']
draft: False
description: MacOS 加入如下配置 重啓 Firefox，然後就能在關於中，就能看到： 你的組織禁用了更新 Source via https//note.bgzo.cc/weekly/20260322-how-to-ban-firefox-update-on-mac
---

## MacOS

```shell
cd "/Applications/Firefox Developer Edition.app/Contents/Resources/"
sudo mkdir distribution
cd distribution
sudo vim policies.json
```

加入如下配置

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