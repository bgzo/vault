---
draft: False
ale: How to coding with llm
aliases: ['How to coding with llm']
created: 2024-12-28 02:46:31
modified: 2025-06-30 23:59:32
tags: ['llm', 'writing/how-to']
title: How to coding with llm
type: how-to
description: 啓發於 https//linux.do/t/topic/126077/7 via https//www.youtube.com/watch?v=AV_8czoF3PU Local Server ollama Enable LAN access Restart Module Deepseek by China deepseek-coder-v216b Extension Continue high ...
---

啓發於: https://linux.do/t/topic/126077/7

<iframe src="https://www.youtube.com/embed/AV_8czoF3PU" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
<center>via: <a href='https://www.youtube.com/watch?v=AV_8czoF3PU' target='_blank' class='external-link'>https://www.youtube.com/watch?v=AV_8czoF3PU</a></center>

## Local Server: ollama

```shell
curl -fsSL https://ollama.com/install.sh | sh
```

### Enable LAN access

```shell
sudo vim /etc/systemd/system/ollama.service
```

```shell
[Service]
Environment="PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:/home/bgzo/.sdkman/candidates/java/current/bin:/home/bgzo/.nvm/versions/node/v23.3.0/bin:/home/bgzo/demo/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/bgzo/.local/bin"
Environment="OLLAMA_HOST=0.0.0.0"
```

### Restart

```shell
systemctl daemon-reload
systemctl restart ollama
systemctl status ollama
```

## Module

![](https://x.com/yihong0618/status/1872635893657604391)

### Deepseek by China

- [deepseek-coder-v2:16b](https://ollama.com/library/deepseek-coder-v2:16b)

## Extension

### Continue

high CPU usage cause multi files to build index, via: https://github.com/continuedev/continue/issues/1622, https://github.com/continuedev/continue/issues/866, https://github.com/continuedev/continue/issues/778, https://utgd.net/article/20938

## References

- https://medium.com/@smfraser/how-to-use-a-local-llm-as-a-free-coding-copilot-in-vs-code-6dffc053369d

Source via: https://note.bgzo.cc/weekly/coding-with-llm