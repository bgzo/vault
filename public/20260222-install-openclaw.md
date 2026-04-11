---
title: Openclaw 踩坑
aliases: ['Openclaw 踩坑']
created: 2026-02-22 01:23:54
modified: 2026-04-11 18:50:18
published: 2026-02-22 01:23:54
tags: ['llm', 'openclaw', 'public', 'writing/lab']
draft: False
description: 我對 OpenClaw 帶給我的驚喜，恰如一開始讀他的提示詞那樣驚豔： You're not a chatbot. You're becoming someone 我完全被這句話震住了。 無法使用 openclaw devices list 修改 ~/.openclaw/devices/pending.json，從 "silent" false 到 "silent" true via https/...
---

我對 OpenClaw 帶給我的驚喜，恰如一開始讀他的提示詞那樣驚豔：

> You're not a chatbot. You're becoming someone

我完全被這句話震住了。

## 無法使用 `openclaw devices list`

```shell
[openclaw] Failed to start CLI: Error: gateway closed (1008): pairing required
```

修改 `~/.openclaw/devices/pending.json`，從 `"silent": false` 到 `"silent": true`

via: https://github.com/openclaw/openclaw/issues/4531

## Telegram 沒有反應

找到 Service 文件位置

```shell
systemctl --user show -p FragmentPath openclaw-gateway.service
```

編輯文件加入代理設置

```shell
Environment="http_proxy=http://127.0.0.1:7890"
Environment="https_proxy=http://127.0.0.1:7890"
Environment="all_proxy=socks5://127.0.0.1:7890"
```

重啓服務

```shell
systemctl --user daemon-reload
systemctl --user restart openclaw-gateway
```

## DS 上下文太小

```shell
⚠️ Agent failed before reply: Model context window too small (4096 tokens). Minimum is 16000.

Logs: openclaw logs --follow
```

OpenClaw 這個 Agent 的**最低要求是 16k**，OpenClaw 的 Agent 通常會自動拼接：

- system prompt（很長）
- agent persona / policy
- 歷史對話
- 工具說明
- planning / scratchpad
- 你剛發的消息

使用思考模型，配置裏面改一下：

```json
"providers": {
  "deepseek": {
	"baseUrl": "https://api.deepseek.com/v1",
	"apiKey": "sk-xxx",
	"api": "openai-completions",
	"models": [
		{
		"id": "deepseek-chat",
		"name": "DeepSeek Chat",
		"reasoning": false,
		"input": [
		  "text"
		],
		"cost": {
		  "input": 0,
		  "output": 0,
		  "cacheRead": 0,
		  "cacheWrite": 0
		},
		"contextWindow": 16000,
		"maxTokens": 4096
		},
		{
		  "id": "deepseek-reasoner",
		  "name": "DeepSeek Reasoner",
		  "reasoning": false,
		  "input": [
			"text"
		  ],
		  "cost": {
			"input": 0,
			"output": 0,
			"cacheRead": 0,
			"cacheWrite": 0
		  },
		  "contextWindow": 200000,
		  "maxTokens": 8192
		}
	]
  }
}
```

## 換模型

因爲我有 Copilot 訂閱，平時一直閒置不用，而且運行 onboard 的時候看到有這個選項，但是找不到相關文檔，所以無奈只能再次通過 onboard 配置這個模型，總的來說有兩種方法：

1. GitHub Copilot (GitHub device login)
2. Proxy，通過 Vscode 假設 RESTFul 節點給 OpenClaw 調用；
	1. https://marketplace.visualstudio.com/items?itemName=lewiswigmore.open-wire

我是通過第二種方法，不確定未來 Copilot 會不會封我的號，我直接入了 4o 模型，因爲 Copilot 的模型非常多，並且只能選擇一樣，未來還不能在機器人內切換，所以就選了免費的 4o，說實話，也不心疼燒 Token。爲了未來切換模型方便，我把可切換的模型放在下面：

```shell
github-copilot/claude-haiku-4.5
github-copilot/claude-opus-4.5
github-copilot/claude-opus-4.6
github-copilot/claude-sonnet-4
github-copilot/claude-sonnet-4.5
github-copilot/claude-sonnet-4.6
github-copilot/gemini-2.5-pro
github-copilot/gemini-3-flash-preview
github-copilot/gemini-3-pro-preview
github-copilot/gemini-3.1-pro-preview
github-copilot/gpt-4.1
github-copilot/gpt-4o
github-copilot/gpt-5
github-copilot/gpt-5-mini
github-copilot/gpt-5.1
github-copilot/gpt-5.1-codex
github-copilot/gpt-5.1-codex-max
github-copilot/gpt-5.1-codex-mini
github-copilot/gpt-5.2
github-copilot/gpt-5.2-codex
github-copilot/grok-code-fast-1
```

## This group is not allowed.

1. 檢查配置是否寫對了
2. 把機器人移除重新加一遍

```json
{
  "channels": {
    "telegram": {
      "enabled": true,
      "dmPolicy": "pairing",
      "botToken": "xxx:xxx",
      "groupPolicy": "allowlist",
      "groupAllowFrom": [
	      // 允許羣組裏的這些人使用
	      "xxx1",
	      "xxx2"
	  ],
      "groups": {
	      // 羣組id
	      "-xxx": {}
      },
      "streaming": "partial",
      "proxy": "http://127.0.0.1:10800"
    }
  }
}
```

## 遠程開啓 Web

先遠程啓動 web 頁面

```shell
openclaw dashboard
```

然後記住端口地址，SSH 穿透

```shell
ssh -L 18789:127.0.0.1:18789 bgzo@192.168.31.20
```

## 感想

1. 隨便聊了兩句就花了 100 萬 Token，上下文喂的太多了，看了下其他模型也有這種問題，千問尤爲如此。
	1. https://www.v2ex.com/t/1152698
	2. https://www.v2ex.com/t/1171348
	3. https://www.v2ex.com/t/1179391

## 參考

1. https://zhuanlan.zhihu.com/p/2002485126714644013
2. https://club.fnnas.com/forum.php?mod=viewthread&tid=56132
3. https://zhuanlan.zhihu.com/p/2005987429828534912
4. https://www.reddit.com/r/vscode/comments/1rb8cox/i_wanted_my_openclaw_instance_to_use_copilots/
5. https://www.reddit.com/r/GithubCopilot/comments/1r6zwuv/openclaw_github_copilot/

## More

1. https://www.reddit.com/r/ArtificialSentience/comments/1qvcefb/do_not_use_openclaw/
2. https://www.reddit.com/r/google_antigravity/comments/1qykskz/account_banned_for_using_open_claw/

Source via: https://note.bgzo.cc/weekly/20260222-install-openclaw