---
comments: True
draft: False
aliases: ['導出知乎收藏夾']
created: 2025-12-14 20:01:18
modified: 2025-12-14 20:25:57
tags: ['writing/lab']
title: 導出知乎收藏夾
description: 基於幾點原因，建議你定期備份知乎收藏夾： 1. 覆盤：工作日有的時候會看這個網站，會存一些收藏的技術文章； 2. 審查：有些答案會被隱藏，甚至刪除，比如下面收藏夾就有這種情況，頁面顯示有 4 個內容，接口返回的 total 也是 4，但是實際查詢到的內容一個都沒有，怎麼辦，好難猜啊，你懂的； 所以是不是得及時做備份？ 實現 通過網頁抓包如下接口： https//github.com/bGZo/en...
---


基於幾點原因，建議你定期備份知乎收藏夾：

1. 覆盤：工作日有的時候會看這個網站，會存一些收藏的技術文章；
2. 審查：有些答案會被隱藏，甚至刪除，比如下面收藏夾就有這種情況，頁面顯示有 4 個內容，接口返回的 total 也是 4，但是實際查詢到的內容一個都沒有，怎麼辦，好難猜啊，你懂的；

![](https://picx.zhimg.com/100/v2-ceda296948cfd37873cb151e0eeb4953_r.jpg)

所以是不是得及時做備份？

## 實現

通過網頁抓包如下接口： https://github.com/bGZo/env/blob/efd01e2e222f907c5e78c8621981fda2a78a9492/common/bruno/zhihu.com/%E6%94%B6%E8%97%8F%E5%A4%B9.bru

廢話不多說，接口整體比較簡單，常規的分頁參數和結構，具體實現參考：

https://github.com/bGZo/playground/blob/abe661baec193a32a6fc64e1ce8b8e36ee9ddbd7/src/zhihu/collection.py#L13

## 使用

```shell
pipx install export_to_obsidian
export ZHIHU_COOKIE=""
eto zhihu -c xxx -o ./zhihu
```

## 反饋

項目比較個人，如果有一些通用性的意見，歡迎提 ISSUE

Source via: https://note.bgzo.cc/weekly/1270-export-zhihu-collection