---
title: 導出 V2ex 的收藏主題
aliases: ['導出 V2ex 的收藏主題']
created: 2025-12-14 20:13:07
modified: 2026-04-11 18:50:19
published: 2025-12-14 20:13:07
tags: ['export-to-obsidian', 'public', 'writing/lab']
draft: False
description: 基於幾點原因有這方面的需求： 1. 覆盤；寫自己的週報用，總結看看最近一週摸魚的結果； 2. 備份：V2 是個人站點，賬號有被封禁的可能，並且沒有導出數據的功能，你的數據可能永遠消失； 實現 儘管 V2 過去已經開放過一版 API，但是缺少個人的部分，因此具體實現上還需要結合傳統的 Cookie 網頁，解析收藏列表，然後纔可以通過 API 調用獲得主題詳情。還是希望未來有一天能有相關的接口，具體官...
---

基於幾點原因有這方面的需求：

1. 覆盤；寫自己的週報用，總結看看最近一週摸魚的結果；
2. 備份：V2 是個人站點，賬號有被封禁的可能，並且沒有導出數據的功能，你的數據可能永遠消失；

## 實現

儘管 V2 過去已經開放過一版 API，但是缺少個人的部分，因此具體實現上還需要結合傳統的 Cookie 網頁，解析收藏列表，然後纔可以通過 API 調用獲得主題詳情。還是希望未來有一天能有相關的接口，具體官方支持情況請見： https://www.v2ex.com/t/1035675, 暫時沒有希望。

解析網頁實現如下：

https://github.com/bGZo/playground/blob/abe661baec193a32a6fc64e1ce8b8e36ee9ddbd7/src/v2ex/mytopic.py#L32

獲取主題具體信息如下：

https://github.com/bGZo/playground/blob/abe661baec193a32a6fc64e1ce8b8e36ee9ddbd7/src/v2ex/topic.py#L14

## 使用

基於上述實現緣由，除了傳統 Cookie，還需要啓用個人 AccessToken，去設置裏面找一下，然後聲明環境變量，即可導出個人的收藏主題：

```shell
pipx install export_to_obsidian
export V2EX_COOKIE='xxx'
export V2EX_ACCESS_TOKEN="xxx"
eto v2ex -o ./v2ex
```

## 反饋

項目比較個人，如果有一些通用性的意見，歡迎提 ISSUE

Source via: https://note.bgzo.cc/weekly/20251214-export-v2ex-collection