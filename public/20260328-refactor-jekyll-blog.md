---
title: 重構 Jekyll 博客
aliases: ['重構 Jekyll 博客']
created: 2026-03-28 13:57:04
modified: 2026-03-28 18:13:12
comments: True
draft: False
tags: ['blog', 'jekyll', 'rss', 'writing/lab']
description: 因爲種種原因，我需要統一： https//note.bgzo.cc https//blog.bgzo.cc https//bgzo.cc 這幾個網站的定位，考慮到自己的 blog.bgzo.cc 已經存在很長一段時間了，並且已被 V2EX 收錄，最終考慮依然將自己的大部分文章放在這裏，note.bgzo.cc 專注零碎的思考，bgzo.cc 只是個人探索的項目。 Jekyll 兼容自定義類型的 M...
---


因爲種種原因，我需要統一：

- https://note.bgzo.cc
- https://blog.bgzo.cc
- https://bgzo.cc

這幾個網站的定位，考慮到自己的 `blog.bgzo.cc` 已經存在很長一段時間了，並且已被 V2EX 收錄，最終考慮依然將自己的大部分文章放在這裏，`note.bgzo.cc` 專注零碎的思考，`bgzo.cc` 只是個人探索的項目。

## Jekyll 兼容自定義類型的 Markdown 文件

一般情況下，jekyll 天然支持的 markdown 內容格式爲：

```yaml
layout: post
title: XXX
updated: 2026-03-28
```

並且要求文件名類似 `YEAR-MONTH-DAY-title.MARKUP` 格式，例如 `2026-03-27-my-post.md`。但我日常用 Obsidian 書寫不用這些書寫，文件名都是隨機起的，priority 也不一樣，我用的是：

```yaml
title: xxx
aliases:
  - xxx
created: 2026-03-28T13:57:04
modified: 2026-03-28T16:52:30
comments: true
draft: true
tags:
  - writing/lab
```

默認情況下，我的這些文章不會進入變量 `site.posts`，因此爲了使 Jekyll 強行兼容後者，因此有兩種改動：

1. 下游同步腳本增加額外處理，批量重命名文件爲 Jekyll 標準命名；
2. 保持現有文件名，不再用官方的 `_posts`，重新寫一套配置，重新寫首頁的模板；

> [!TIP]
> 關於爲什麼第二方案必須重新定義一套規則，因爲 `site.posts` 在 Jekyll 裏面是**硬編碼**，不可配置的。比如不按人家的命名規則走， `site.posts` 永遠爲空。

| `site.posts`      | 自定義 collection        |                                      |
| ----------------- | --------------------- | ------------------------------------ |
| 來源目錄              | 只能是 `_posts`          | `_<name>/` 任意命名                      |
| 文件名要求             | 必須 `YYYY-MM-DD-title` | 無限制                                  |
| 內置 `date` 解析      | 自動從文件名提取              | 需自己在 front matter 寫 `date`/`created` |
| `output: true` 默認 | 是                     | 顯式配置                                 |

所以，自定義一套 `_articles` 集合，增加配置：

```yml
collections: # 定義 Jekyll 集合，用於將同類內容分組管理
  posts: # 名爲 "posts" 的集合（對應 _posts/ 目錄下的文件）
    output: false # 不爲該集合的文檔生成獨立頁面，僅作爲數據源使用
  articles: # 名爲 "articles" 的集合，用於實際對外發布的文章
    output: true # 爲該集合的每篇文檔生成獨立的 HTML 輸出頁面
    permalink: /:title.html # 輸出頁面的 URL 格式：以文章標題命名，擴展名爲 .html
```

截止目前，首頁函數已經可以解析，但是進去沒有聲明 layout，會導致無 CSS，需要再增加如下配置，隱式補全：

```yml
defaults: # 批量爲文檔注入默認 front matter，避免每篇文章重複聲明
  - scope: # 定義該組默認值的作用範圍
      path: "" # 路徑爲空字符串，表示匹配網站內所有路徑
      type: articles # 僅對 "articles" 集合中的文檔生效
    values: # 以下爲要注入的默認 front matter 字段
      layout: post # 默認使用 "post" 佈局模板（對應 _layouts/post.html）
```

到這完成首頁、文章的改造。

因爲選擇了方案 2，拋棄了 `site.posts`， 所以社區的 RSS 插件 `jekyll-feed` 會失效，所以生成 RSS 地址需要自己手寫：

```markdown
---
layout: none
---
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
  <generator uri="https://jekyllrb.com/" version="{{ jekyll.version }}">Jekyll</generator>
  <link href="{{ site.url }}/feed.xml" rel="self" type="application/atom+xml"/>
  <link href="{{ site.url }}/" rel="alternate" type="text/html"/>
  <updated>{{ site.time | date_to_xmlschema }}</updated>
  <id>{{ site.url }}/feed.xml</id>
  <title type="html">{{ site.title | xml_escape }}</title>
  <subtitle>{{ site.description | xml_escape }}</subtitle>
  {% if site.author %}
  <author>
    <name>{{ site.author | xml_escape }}</name>
  </author>
  {% endif %}
  {% assign articles = site.articles | sort: "created" | reverse %}
  {% for post in articles limit: 20 %}
  <entry>
    <title type="html">{{ post.title | xml_escape }}</title>
    <link href="{{ post.url | prepend: site.url }}"/>
    <published>{{ post.created | date_to_xmlschema }}</published>
    <updated>{{ post.modified | default: post.created | date_to_xmlschema }}</updated>
    <id>{{ post.url | prepend: site.url }}</id>
    <content type="html" xml:base="{{ post.url | prepend: site.url }}">{{ post.content | xml_escape }}</content>
    {% if post.description %}
    <summary type="html">{{ post.description | xml_escape }}</summary>
    {% endif %}
  </entry>
  {% endfor %}
</feed>
```

之後，RSS Feed 也可以正常輸出了。

## Feed 不兼容

上面加完之後依然有一個問題，我發現收錄我博客的下面兩個網址沒有更新內容（已經超過 12h）

- https://www.qireader.com/subscriptions/p4YmaAWDNp2q6bKl#https://blog.bgzo.cc/feed.xml
- https://www.v2ex.com/xna/s/104

首先，排查了下 RSS 地址，用 https://validator.w3.org/feed/check.cgi 驗證了一下 [^value-error]，沒有問題。

[^value-error]: https://zhangzifan.com/validator-rss-feed.html

然後，翻找了一下 Vercel 過去的快照，找到了之前提供的源：

- 舊的: https://blog-czlfazsnq-bgzos-projects.vercel.app/feed.xml
- 新的: https://blog-f5fmpamy9-bgzos-projects.vercel.app/feed.xml

分析一下，有幾點差異：

1. **[最大可能]** `<link>` 缺少 `rel` 和 `type` 屬性

```diff
- <link href="..." rel="alternate" type="text/html" title="..."/>
+ <link href="..."/>
```

> [!NOTE]
> Atom 規範要求每個 `<entry>` 至少有一個 `rel="alternate"` 的 link。很多 feed 聚合器依賴這個屬性來識別文章鏈接，沒有它就無法找到條目的 URL，導致不更新或不顯示。

2. 內容用 `xml_escape` 而非 CDATA

```diff
- <content ...><![CDATA[<p>...</p>]]></content>
+ <content ...>&lt;p&gt;...&lt;/p&gt;</content>
```

作出如下調整：

```diff
- <link href="{{ post.url | prepend: site.url }}"/>
+ <link href="{{ post.url | prepend: site.url }}" rel="alternate" type="text/html" title="{{ post.title | xml_escape }}"/>

- <content type="html" xml:base="{{ post.url | prepend: site.url }}">{{ post.content | xml_escape }}</content>
+ <content type="html" xml:base="{{ post.url | prepend: site.url }}"><![CDATA[{{ post.content }}]]></content>
```

前後的格式保持一致了，這下再觀察一下

Source via: https://note.bgzo.cc/weekly/20260328-refactor-jekyll-blog