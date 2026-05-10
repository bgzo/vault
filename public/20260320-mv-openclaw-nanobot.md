---
title: Nanobot 踩坑
aliases: ['Nanobot 踩坑']
created: 2026-03-20 22:38:33
modified: 2026-04-11 18:50:18
published: 2026-03-20 22:38:33
tags: ['copilot', 'llm', 'nanobot', 'public', 'writing/lab']
draft: False
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

## 從源碼安裝

最近 3 月底爆出 LietLLM 被供應鏈投毒，然後 Nanobot 在最新版本 `v0.1.4.post6`，迅速把這個依賴切割掉了，出現最大的一個問題是，Copilot 用不了了，幸好幾天過後有人修了：

- https://github.com/HKUDS/nanobot/pull/2668

皆知目前還沒有發佈最新版本，所以只能自己編譯了，無奈，卸載之前自己的 nanobot-ai

```shell
un tool uninstall nanobot-ai
rm -f ~/.local/bin/nanobot

pipx uninstall nanobot-ai
```


總之，確保自己本地已經沒有安裝過的 nanobot-ai 的包了，然後：

```shell
git clone https://github.com/HKUDS/nanobot.git
cd nanobot
pipx install .
```


爲了以防萬一可以已經修改個版本號，然後安裝之後自己驗證下，保證是自己安裝的版本

```shell
~/workspaces/trending > nanobot --version
🐈 nanobot v0.1.4.post7
```

DONE

## 技術債

- 管理工具 https://hatch.pypa.io
- GitHub OAuth 爲什麼在新版本中失效？
- 爲什麼 GitHub Token 無法訪問 Copilot？
	- https://github.com/orgs/community/discussions/156263

Source via: https://note.bgzo.cc/weekly/20260320-mv-openclaw-nanobot