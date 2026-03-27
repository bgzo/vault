---
title: 蒸汽機後時代的人們
aliases: ['蒸汽機後時代的人們']
created: 2026-02-22 15:54:03
modified: 2026-03-08 23:02:20
comments: True
draft: False
tags: ['llm', 'translate', 'writing/lab']
description: 現在最像歷史上什麼時候呢？ 蒸汽機發明之後的英國，人們以爲生產力的提升可以解放人類，釋放出來更多的空閒時間，但實際上不是這樣的，就像人們以爲 AI 出來不會幹活了，是這樣嗎？ 沒有失業就不錯了，但這只是暫時的。 2025 年 LLM 爲了打消自己的焦慮，這個假期折騰了一下過去一年比較熱門的技術，切入點就是 Copilot 的配置，我從一個 TW 賣客的那裏學到了基礎的配置 https//githu...
---


現在最像歷史上什麼時候呢？

蒸汽機發明之後的英國，人們以爲生產力的提升可以解放人類，釋放出來更多的空閒時間，但實際上不是這樣的，就像人們以爲 AI 出來不會幹活了，是這樣嗎？

沒有失業就不錯了，但這只是暫時的。

## 2025 年 LLM

爲了打消自己的焦慮，這個假期折騰了一下過去一年比較熱門的技術，切入點就是 Copilot 的配置，我從一個 TW 賣客的那裏學到了基礎的配置

- https://github.com/doggy8088/github-copilot-configs

然後我發現網上關於這部分的資料很少，問 ChatGPT 完全沒有用，他甚至都沒有去搜索網頁，完全的胡說八道，我很失望，然後去問 Grok，發現一個非常好玩的模式 `Gork 4.20(4 Agent)`，四個代理獨立工作，給出一份覆蓋範圍更廣的答案。

配置的過程比較曲折：我先把裏面感覺有用點的文件全都靠過來，發現有些 Tools 還是無法找到，然後我把 VSCode 從 Stable 版本升級到了 Insider，有些工具還是找不到（如：`Unknown tool 'add_issue_comment'/'terminalCommand'`），猜測是迭代過程中直接直接棄用了，網上也找不到，最後直接刪掉了。

一些 Agent 和 prompt 裏面其實還包含了 MCP 的一些配置，如 時間和 GitHub 的相關 MCP 服務後，再多也沒管，多說一句，這部分開發的人還蠻多、蠻成熟、蠻讓我意外的。

升級 Insider 後，配置是獨立的，本地 cp 一份配置到 insider 重新加載一遍就可以，之後重新看到了上下文窗口大小，一開始問了一個問題，直接佔用 50%，我靠，一下就焦慮了，發現不同項目的上下文不應該公用，這也讓我想起來國內有說自己上下文支持 1M 真的是不得了的事情，然後經過不斷優化，最終上下文來到了：

```shell
Context Window
44.3K / 160K tokens • 28%
System
System Instructions 0.6%
Tool Definitions 1.7%
Reserved Output 25.2%
```

`Reserved Output` 是 Copilot 預留空間，不太能優化，最終折騰的結果是：

- https://github.com/bGZo/playground

但還沒完，Obsidian 還沒配置，哈哈哈。

除此之外，還發現了 TW 翻譯的一些必大陸要好的專業名詞，包括：

- Bit：字元
- Byte：字元組

---

- Transaction：交易
- Transactional：交易式

一瞬間感覺自己大學真是起到了幫倒忙的作用。

Source via: https://note.bgzo.cc/weekly/20260222-llm-feeling