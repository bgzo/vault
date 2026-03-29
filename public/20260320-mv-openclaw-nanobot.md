---
title: NanoBot 踩坑
aliases: ['NanoBot 踩坑']
created: 2026-03-20 22:38:33
modified: 2026-03-28 18:14:59
comments: True
draft: False
tags: ['llm', 'nanobot', 'writing/lab']
description: 之前有使用 Openclaw 踩坑 的經歷，用起來也還可以，但有幾點問題： 1. 啓動慢； 2. 配置複雜； 3. 性能； Openclaw 的代碼十幾萬行是出了名的臭，大家都知道，所以爆火之後就接二連三出來了很多語言的平替版本，有： NonoBot (Python) PicoClaw (Golang) ZeroClaw (Rust) 考慮到我的模型是 CopilotPro，並且不想走彎路，所以最...
---


之前有使用 Openclaw 踩坑 的經歷，用起來也還可以，但有幾點問題：

1. 啓動慢；
2. 配置複雜；
3. 性能；

Openclaw 的代碼十幾萬行是出了名的臭，大家都知道，所以爆火之後就接二連三出來了很多語言的平替版本，有：

- NonoBot (Python)
- PicoClaw (Golang)
- ZeroClaw (Rust)

考慮到我的模型是 CopilotPro，並且不想走彎路，所以最終選擇更加完善的 https://github.com/HKUDS/nanobot

整個備份過程沒有任何阻礙，甚至比 OpenClaw 順多了。

## 禁用 OpenClaw 啓用 NanoBot

首先，就是備份文件

```shell
mv ~/.openclaw ~/.openclaw-backup-$(date +%Y%m%d)
```

然後，停用 OpenClaw 進程

```shell
ps aux | grep openclaw
kill -9 1432
systemctl --user stop openclaw-gateway
systemctl --user disable openclaw-gateway
```

考慮未來可能還會重新用 OpenClaw，所以跳過卸載，到這裏爲止。

接下來安裝 NanoBot

```shell
uv tool install nanobot-ai
nanobot --version
nanobot onboard
```

然後，進行 CopilotPro 的授權

```shell
nanobot provider login github-copilot
```

接着，編輯如下內容到 `~/.nanobot/config.json`：

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "token": "TelegramBotToken",// ← 這裏改成 "token"（不是 botToken）
      "allowFrom": ["TG用戶、羣組ID"]// ← 完全一樣（不帶 @）
    }
  },
  "agents": {
    "defaults": {
      "model": "github-copilot/gpt-5-mini"
    }
  }
}
```

直接開始測試

```shell
nanobot gateway
```

沒問題就增加一個後臺守護進程到 `~/.config/systemd/user/nanobot-gateway.service`

```shell
[Unit]
Description=Nanobot Gateway
After=network.target

[Service]
Type=simple
ExecStart=%h/.local/bin/nanobot gateway
Restart=always
RestartSec=10
NoNewPrivileges=yes
ProtectSystem=strict
ReadWritePaths=%h

[Install]
WantedBy=default.target
```

接着啓動配置：

```shell
systemctl --user daemon-reload
systemctl --user enable --now nanobot-gateway
```

接下來就可以正常使用了。

##

Source via: https://note.bgzo.cc/weekly/20260320-mv-openclaw-nanobot