---
aliases: ['如何用 Calibre 轉化爲 PDF']
created: 2023-04-12 10:06:04
draft: False
modified: 2025-11-14 06:39:41
title: 如何用 Calibre 轉化爲 PDF
tags: ['writing/how-to']
description: 簡單的講，直接在操作欄選擇轉換書籍，然後選擇 PDF 即可，但是導出書籍的格式不一，最好還是有一些約定好的配置，兼顧閱讀和打印，也可以避免版權問題。 需要準備的字體 https//source.typekit.com/source-han-serif/cn/ https//github.com/be5invis/Sarasa-Gothic https//github.com/laishulu/Sa...
---

簡單的講，直接在操作欄選擇轉換書籍，然後選擇 PDF 即可，但是導出書籍的格式不一，最好還是有一些約定好的配置，兼顧閱讀和打印，也可以避免版權問題。

## 需要準備的字體

- https://source.typekit.com/source-han-serif/cn/
- https://github.com/be5invis/Sarasa-Gothic
- https://github.com/laishulu/Sarasa-Term-SC-Nerd

善用 Brew：

```shell
brew install --cask font-noto-serif-cjk
brew install --cask font-source-han-serif-vf
brew install --cask font-sarasa-gothic
brew tap laishulu/homebrew
brew install font-sarasa-nerd
brew install --cask font-genryumin
```

## 配置

- 轉換書籍 -> 輸出格式 PDF
- 界面外觀 -> 字體 -> 最小行高 -> 180%
- 頁面設置
    * 輸出配置文件 -> 默認配置文件
    * 輸入配置文件 -> 默認配置文件
* PDF 輸出
    * 紙張大小 -> A4
    * 襯線字體（正文） -> 思源宋體（Noto Serif CJK SC / Source Han Serif SC VF）/ 源流明體（GenRyuMin2 TC）[^why-song-font]
    * 非襯線字體（標題/普通 UI） -> 更紗黑體（Sarasa Gothic SC）
    * 等寬字體（代碼/表格/CLI） -> 更紗黑體 Mono SC（Sarasa Mono SC）
    * 默認字體大小 -> 16 px
    * 等寬字體大小 -> 12 px

[^why-song-font]: 在實際轉換的過程中，一些字體其實會印象文字的排版，具體原理不清楚，在轉換某本 EQUB 的時候，使用思源宋體在一些段落中就無法正常劃線，複製下來文字順序也是亂的，嘗試 Pandoc 之後。覺得 pandoc 的排版太難弄了，最後換了個源流明體就好多了。這方面還沒有一個定論 #gtd/todo

## 參考

- source-han-serif
- genryu-font
- Sarasa-Gothic
- LxgwWenKai
- https://lishouzhong.com/article/note/uncategoried/Calibre%20%E7%9B%B8%E5%85%B3/
- [calibre有替代品嗎 (bgm.tv)](https://bgm.tv/group/topic/373701) #calibre
- [藉助 Calibre 處理電子書的流程和技巧 - 少數派 (sspai.com)](https://sspai.com/post/57005)
- [Use advanced book creation options in Pages - Apple Support](https://support.apple.com/en-us/HT202066)
- [Export InDesign documents to an EPUB format](https://helpx.adobe.com/indesign/using/export-content-epub-cc.html)
- https://commandnotfound.cn/linux/1/519/mutool-%E547D%E4EE4
- https://github.com/qpdf/qpdf
- https://www.v2ex.com/t/913812
- https://ghostscript.com/releases/index.html

Source via: https://note.bgzo.cc/weekly/convert-to-pdf-with-calibre