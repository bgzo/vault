---
title: 用 GitHub issue 寫博客很好，但我要放棄了
aliases: ['用 GitHub issue 寫博客很好，但我要放棄了']
created: 2025-12-06 11:15:36
modified: 2026-04-11 18:50:20
published: 2025-12-06 11:15:36
tags: ['public', 'writing/lab']
draft: False
description: 這曾經是一個比火熱的寫作方式，至少在 2020 年是如此，我也是聽、看 laike9m 和 yihong618 的項目慢慢摸索的，它有很多優點，比如至少解決了如下的問題： 1. 文章託管：所有文件放在 GitHub，他的穩定性至少要比你電腦的壽命要長； 2. 圖片引用：所有本地寫過博客的人一定頭疼過如何上傳圖片，這方面不贅述了； 3. SEO 索引：GitHub issue 自帶 SEO 索引，會...
---

這曾經是一個比火熱的寫作方式，至少在 2020 年是如此，我也是聽、看 laike9m 和 yihong618 的項目慢慢摸索的，它有很多優點，比如至少解決了如下的問題：

1. 文章託管：所有文件放在 GitHub，他的穩定性至少要比你電腦的壽命要長；
2. 圖片引用：所有本地寫過博客的人一定頭疼過如何上傳圖片，這方面不贅述了；
3. SEO 索引：GitHub issue 自帶 SEO 索引，會被瀏覽器抓取；
4. 評論功能：你不需要折騰、嵌入評論插件，完全可以用 GitHub 自帶的那一套；

好處應該還有很多，比如全文搜索和標籤管理，這裏就不贅述了，讓我講講爲什麼我要放棄它吧。

## 「寫作不流暢」

如果你要寫一篇文章，你的第一步應該是什麼？是不是像我一樣打開 Obsidian、Logseq、或者蘋果備忘錄？甚至打開一個記事本就直接開始寫了？

寫到這裏，答案應該明瞭了，總之，不可能是打開 GitHub，然後點擊 Issue，再點擊 Create，然後再寫，真要結合國內的網絡情況，想寫的東西早就忘記了。所以過去的幾年裏，我都是本地寫好了，然後檢查一遍，最後上傳到 GitHub Issue 裏面。

這當然是一個不錯的主意，但仍然有問題：如果有一天你發現文章有些地方寫的有紕漏，然後直接在 issue 裏面改了，然後就發佈了，那你本地的文章怎麼辦？是不是還得改一遍？文章的一致性非常難保證。

反覆的編輯和校對會把所有表達的慾望耗盡，最後什麼也寫不出來。

## 「污染 GitHub 工作流」

首先，issue 的誕生就不是用來寫博客的，寫博客只是 issue 的一種用法，用於追蹤定位問題，換種嚴肅的說法就是，這本來就是一種邪修的路子，早晚會出問題。

比如我想看自己創建過的 issue，我們可以去 https://github.com/issues/created, 但因爲你拿 issue 做博客了，所以這裏默認全都是你還處於打開狀態的博客，你當然可以通過 `-repo:xxx/blog` 這個搜索參數來過濾你的統計結果，但這總不如默認提供來的直觀、方便。

然後，還會有更多不可預料的副作用，比如官方有一個跨項目的 issue 聯動功能，就是如果你在項目 A 的 issue 裏面引用了項目 B 的 issue，雙方的 issue 時間線裏面就會出現一個雙向鏈接 [^double-link]，這對解決過定位共性問題有幫助，但如果不是爲了解決問題，這個功能就有點「濫用」的味道。

[^double-link]: https://docs.github.com/en/issues/tracking-your-work-with-issues/learning-about-issues/about-issues#about-integration-with-github

試想，如果我把一個熱門的項目全都重定向到我的博客，我當然可以獲得海量的流量，但我離封號也不遠了 😊 如果裁決人是你，「要不要封」這件事情一定也很明瞭。

總之，你沒有選擇，只要 GitHub 做更多相關的集成操作，那麼對你來說就是更多的負擔。

## 還有更好的方式嗎？

想說的話說完了，這就是我的博客 https://blog.bgzo.cc 停更快一年的主要原因。至於未來在哪，很難說，因爲 GitHub 已經實現了近乎博客需要的所有功能了，如果要放棄它，你不得不重新實現一遍我在開頭說的那些功能。

Sounds hard really.

別忘了我們的初衷，只是想寫點能被保管時間久點的東西，或是愉悅自己，或是愉悅他人，而不是克隆一個成熟的科技輪子。

## 後話：談談項目的實現細節和我博客的後路

閒話終於寫完了，可以寫點代碼相關的東西了🥰

首先我想說實現整個項目很蠻有趣的，我在 GitHub issue 上寫博客，然後通過每日的 CI 定時的拉取數據到倉庫博客目錄，然後自動關聯來源 issue，這樣甚至可以無縫接入 https://utteranc.es/, 完美地把自己的 issue 內容和評論，用 Github Pages 展現出來。

這對 4 年前，或者 5 年前的自己來說還挺酷的，那個時候還沒有 AI ，因此完全是看着別人的項目代碼，然後摸石頭過河。

### 20220104 第一版發佈

https://github.com/bGZo/blog/commit/428035c7167ce2899e4db9fb5d1d006d60829cc3

當然剩下的博客框架久隨便選了，但是我已經用過了 hugo、hexo 和非常多在線工具，對 GitHub 自帶的 jekyll 還不熟悉，所以自從看了這位老哥的博客，我就動手開始模仿了起來：

<iframe src='https://dzhavat.github.io' style='height:40vh;width:100%' class='iframe-radius' allow='fullscreen'></iframe>
<center>via: <a href='https://dzhavat.github.io' target='_blank' class='external-link'>https://dzhavat.github.io</a></center>

這是我模仿的結果：

![](https://raw.githack.com/bGZo/assets/dev/2025/202507022230006.png)

### 內容獲取

設計有幾點約定：

1. 用標籤來進行 issue 分類，比如我的 `post`、`threads`、`thoughts`、`letters` 等等，沒有分類的標籤不會出現在博客裏面；
2. 自定義標題需要寫在文內，常規的路由名字會用 issue 標題加中線符號進行組合；

剩下的就是用 PyGithub 獲取 issue 列表和內容，拼湊出 jekyll 需要的格式了，核心代碼有：

```python
def output_label_articles(_repo, _name, _label):
    issues = _repo.get_issues(
                labels=[_repo.get_label( _label )],
                creator=_name,
                state='open')
```

### 自動化 CI 更新倉庫

上面我們把腳本確定好，然後在 `.github` 內部創建好 yaml 文件，主要是制定運行日期，比如東八區 0 點，就是對應的 UTC+0 的 16 點， 核心代碼有：

```yaml
on:
  workflow_dispatch:
  push:
    branches: [ main ]
  schedule:
    - cron:  '0 16 * * *'
```

CI 的思路也簡單粗暴：先刪掉當前的緩存文章，再執行一遍腳本即可，如：

```python
- name: Delete All Old Post
  run: |
  rm -rf _posts/
- name: Sync issue to repository
  run: |
  python3 utils/sync.py -t ${{ secrets.G_T }} -p bGZo/blog posts thoughts letters
- name: Proof article
  run: |
  python3 utils/proof.py
- name: Convert Text to Traditional Chinese
  run: |
  python3 utils/stconverter.py _posts -t
```

除了 CI，還能通過 GitHub 自己提供的 `ISSUE_TEMPLATE` 來簡化 issue 的創建過程；

### 博客評論:giscus

因爲 https://utteranc.es/ 天然就是用 issue 來做評論存儲的，所以我們只需要在腳本構建中，加入博文和 issue 的綁定關係，並且嵌入如下代碼，即可生效：

```html
<script src="https://utteranc.es/client.js"
  repo="bgzo/blog"
  theme="preferred-color-scheme"
  issue-number="{{ page.number }}"
  crossorigin="anonymous"
  async>
</script>
```

當然還有幾種選擇，如：

- utterances
- gitalk: not support name matching;
	- https://github.com/gitalk/gitalk.github.io/blob/master/index.html
	- https://github.com/gitalk/gitalk/issues/1

20230304

### 博客美化

沒啥用，但是確實自認爲美化了好幾版，就當看個樂呵吧。

#### 20230128 字體換了好幾波

最開始喜歡用微軟雅黑，但是雅黑不是襯線字體，後面就換成了 lxgw-wenkai-webfont，但楷體不符合中國人的閱讀習慣，最終還是換回了宋體（[Noto Serif Simplified Chinese - Google Fonts](https://fonts.google.com/noto/specimen/Noto+Serif+SC/about)）。

#### 20230131 自動替換半角符號

因爲之前敲代碼的關係，標點符號全部設置的是半角，這讓中文排版最終糊成一坨，所以最好在發佈的時候替換爲全角符號。

- [x] `,` 替換
- [x] `.` 替換
- [x] 結尾空格替換
- [x] 腳註替換
- [x] | 替換
- [x] 鏈接轉義

#### 20230228 增加黑暗模式

抽空修整並優化了下博客的兩個小功能（夜間模式和評論功能），夜間模式着重優化下圖片遮罩，防止圖片在夜晚環境過亮（Brightness of img is too dazzling in dark mode），當然一開始沒想到加這些功能只需要幾行代碼😂，我果然還是很厲害的👍（欠下的技術債 -1）；

via:

- [Dark Mode: Reduce image brightness & contrast · Issue #618 · WordPress/twentytwentyone · GitHub](https://github.com/WordPress/twentytwentyone/issues/618)
- https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme

### 還可以優化的點：

- [ ] 增加博客說明
	- 最好支持鍵盤快捷鍵的支持，比如：
		- https://player.fm with `?`
		- https://github.com with `?`
- [ ] 鏈接預覽，支持社交媒體的預覽
	- [ ] Telegram
	- [ ] Twitter
- [ ] 分頁顯示

## 未來

前面兩節已經寫清楚了，未來不會再在 issue 裏面寫博客了，但這裏應該也不會閒着，我會從上游 (https://github.com/bGZo/vault) 把我一些折騰的文章拉取過來。然後再在這裏進行展示。

當然，這個分支我會保留，感興趣的人可以來這個分支抄抄作業：

而且如果你不在意我開頭說的兩個我認爲缺點的話，GitHub issue 寫博客還是最好使的，不僅僅是背靠巨硬，你懂的。

Source via: https://note.bgzo.cc/weekly/20251206-archive-blog-written-by-github-issue