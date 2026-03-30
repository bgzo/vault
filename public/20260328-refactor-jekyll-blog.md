---
title: 重構 Jekyll 博客
aliases: ['重構 Jekyll 博客']
created: 2026-03-28 13:57:04
modified: 2026-03-30 22:09:20
comments: True
draft: False
tags: ['blog', 'callout', 'jekyll', 'rss', 'writing/lab']
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

| 比較                | `site.posts`          | 自定義 collection                       |     |
| ----------------- | --------------------- | ------------------------------------ | --- |
| 來源目錄              | 只能是 `_posts`          | `_<name>/` 任意命名                      |     |
| 文件名要求             | 必須 `YYYY-MM-DD-title` | 無限制                                  |     |
| 內置 `date` 解析      | 自動從文件名提取              | 需自己在 front matter 寫 `date`/`created` |     |
| `output: true` 默認 | 是                     | 顯式配置                                 |     |

考慮了一下，果斷選擇方案 2。

因此，我們需要自定義一套 `_articles` 集合，增加配置：

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

## 重新輸出 RSS

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

如果你的網站裏面存在 Jekyll 的模板內容，最終輸出可能會亂掉，所以需要在配置裏面新增一行配置：

```diff
defaults: # 批量爲文檔注入默認 front matter，避免每篇文章重複聲明
  - scope: # 定義該組默認值的作用範圍
      path: "" # 路徑爲空字符串，表示匹配網站內所有路徑
      type: articles # 僅對 "articles" 集合中的文檔生效
    values: # 以下爲要注入的默認 front matter 字段
      layout: post # 默認使用 "post" 佈局模板（對應 _layouts/post.html）
+     render_with_liquid: false # 禁止對文章內容進行 Liquid 渲染，避免代碼塊中的模板語法被執行
```

當然，還有一種辦法是修改文章，在代碼塊上下加入：

```ruby
{% raw %}
{% endraw %}
```

> [!NOTE]
> 做的過程有個小插曲，如果第一次構建可以跳過下面部分

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

## Jekyll 支持 Obsidian 的語法糖：Youtube、Twitter 嵌入

```markdown
![](https://x.com/Enter_Apps/status/1768669206826926292)
![](https://twitter.com/Enter_Apps/status/1768669206826926292)
![](https://www.youtube.com/watch?v=p485kUNpPvE)
```

增加以下邏輯：

```html
<!-- Replace Obsidian-style ![]( URL ) with proper embeds for Twitter/X and YouTube -->
<script>
  (function () {
    var YT_RE =
      /(?:youtube\.com\/watch\?(?:.*&)?v=|youtu\.be\/)([a-zA-Z0-9_-]{11})/;
    var YT_SHORT_RE = /youtube\.com\/shorts\/([a-zA-Z0-9_-]{11})/;
    var TW_RE = /(?:twitter\.com|x\.com)\/\w+\/status\/(\d+)/;

    function replaceImg(img, embed) {
      var parent = img.parentNode;
      // kramdown wraps standalone ![]() in <p>; unwrap it so block elements are valid
      if (parent && parent.tagName === "P" && parent.childNodes.length === 1) {
        parent.parentNode.replaceChild(embed, parent);
      } else {
        parent.replaceChild(embed, img);
      }
    }

    function makeYouTubeEmbed(videoId) {
      var wrapper = document.createElement("div");
      wrapper.className = "embed-youtube";
      var iframe = document.createElement("iframe");
      iframe.src = "https://www.youtube.com/embed/" + videoId;
      iframe.title = "YouTube video player";
      iframe.frameBorder = "0";
      iframe.allow =
        "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share";
      iframe.allowFullscreen = true;
      iframe.setAttribute("loading", "lazy");
      wrapper.appendChild(iframe);
      return wrapper;
    }

    function makeTwitterEmbed(tweetUrl) {
      var blockquote = document.createElement("blockquote");
      blockquote.className = "twitter-tweet";
      var a = document.createElement("a");
      a.href = tweetUrl;
      a.textContent = tweetUrl;
      blockquote.appendChild(a);
      return blockquote;
    }

    var imgs = Array.from(document.querySelectorAll("article img"));
    var hasTweet = false;

    imgs.forEach(function (img) {
      var src = img.getAttribute("src") || "";

      var ytMatch = src.match(YT_RE) || src.match(YT_SHORT_RE);
      if (ytMatch) {
        replaceImg(img, makeYouTubeEmbed(ytMatch[1]));
        return;
      }

      var twMatch = src.match(TW_RE);
      if (twMatch) {
        // Twitter's widgets.js only accepts twitter.com URLs, so normalise x.com → twitter.com
        var tweetUrl = src.replace(/^(https?:\/\/)x\.com\//, "$1twitter.com/");
        replaceImg(img, makeTwitterEmbed(tweetUrl));
        hasTweet = true;
        return;
      }
    });
    if (hasTweet) {
      var s = document.createElement("script");
      s.src = "https://platform.twitter.com/widgets.js";
      s.async = true;
      s.charset = "utf-8";
      document.head.appendChild(s);
    }
  })();
</script>
```

做的時候發現，只有 x.com 的鏈接無法嵌入，這才發現注入的腳本還是老域名 twitter.com，沒有換成新域名，這可太好笑了。

增加如下邏輯，從 x.com ，重新換回 twitter.com

```js
var twMatch = src.match(TW_RE);
if (twMatch) {
	// Twitter's widgets.js only accepts twitter.com URLs, so normalise x.com → twitter.com
	var tweetUrl = src.replace(/^(https?:\/\/)x\.com\//, "$1twitter.com/");
	replaceImg(img, makeTwitterEmbed(tweetUrl));
	hasTweet = true;
	return;
}
```

然後就可以正常的嵌入 Youtube 和 X 的鏈接了。

![](https://x.com/imbGZo/status/1986569052161253708)

![](https://www.youtube.com/watch?v=IHENIg8Se7M)

## Jekyll 支持 Callout

因爲 Jekyll + kramdown 天然不支持這些擴展語法，因此唯一的思路就是在渲染頁面之前捕獲這些元素，然後進行 HTML 內容渲染。

因此，我們增加一個組件：

```html
<!-- Transform GFM-style callouts: > [!NOTE], > [!TIP], > [!WARNING], > [!IMPORTANT], > [!CAUTION] -->
<script>
  (function () {
    var TYPES = {
      NOTE: "Note",
      TIP: "Tip",
      WARNING: "Warning",
      IMPORTANT: "Important",
      CAUTION: "Caution",
    };

    // ── SVG icon paths ────────────────────────────────────────────────────────
    // Each value is the `d` attribute of a single <path> on a 24×24 viewBox.
    // Leave a string empty to show no icon for that type.
    var SVG_PATHS = {
      NOTE: "M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8Zm8-6.5a6.5 6.5 0 1 0 0 13 6.5 6.5 0 0 0 0-13ZM6.5 7.75A.75.75 0 0 1 7.25 7h1a.75.75 0 0 1 .75.75v2.75h.25a.75.75 0 0 1 0 1.5h-2a.75.75 0 0 1 0-1.5h.25v-2h-.25a.75.75 0 0 1-.75-.75ZM8 6a1 1 0 1 1 0-2 1 1 0 0 1 0 2Z",
      TIP: "M8 1.5c-2.363 0-4 1.69-4 3.75 0 .984.424 1.625.984 2.304l.214.253c.223.264.47.556.673.848.284.411.537.896.621 1.49a.75.75 0 0 1-1.484.211c-.04-.282-.163-.547-.37-.847a8.456 8.456 0 0 0-.542-.68c-.084-.1-.173-.205-.268-.32C3.201 7.75 2.5 6.766 2.5 5.25 2.5 2.31 4.863 0 8 0s5.5 2.31 5.5 5.25c0 1.516-.701 2.5-1.328 3.259-.095.115-.184.22-.268.319-.207.245-.383.453-.541.681-.208.3-.33.565-.37.847a.751.751 0 0 1-1.485-.212c.084-.593.337-1.078.621-1.489.203-.292.45-.584.673-.848.075-.088.147-.173.213-.253.561-.679.985-1.32.985-2.304 0-2.06-1.637-3.75-4-3.75ZM5.75 12h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1 0-1.5ZM6 15.25a.75.75 0 0 1 .75-.75h2.5a.75.75 0 0 1 0 1.5h-2.5a.75.75 0 0 1-.75-.75Z",
      WARNING:
        "M6.457 1.047c.659-1.234 2.427-1.234 3.086 0l6.082 11.378A1.75 1.75 0 0 1 14.082 15H1.918a1.75 1.75 0 0 1-1.543-2.575Zm1.763.707a.25.25 0 0 0-.44 0L1.698 13.132a.25.25 0 0 0 .22.368h12.164a.25.25 0 0 0 .22-.368Zm.53 3.996v2.5a.75.75 0 0 1-1.5 0v-2.5a.75.75 0 0 1 1.5 0ZM9 11a1 1 0 1 1-2 0 1 1 0 0 1 2 0Z",
      IMPORTANT:
        "M0 1.75C0 .784.784 0 1.75 0h12.5C15.216 0 16 .784 16 1.75v9.5A1.75 1.75 0 0 1 14.25 13H8.06l-2.573 2.573A1.458 1.458 0 0 1 3 14.543V13H1.75A1.75 1.75 0 0 1 0 11.25Zm1.75-.25a.25.25 0 0 0-.25.25v9.5c0 .138.112.25.25.25h2a.75.75 0 0 1 .75.75v2.19l2.72-2.72a.749.749 0 0 1 .53-.22h6.5a.25.25 0 0 0 .25-.25v-9.5a.25.25 0 0 0-.25-.25Zm7 2.25v2.5a.75.75 0 0 1-1.5 0v-2.5a.75.75 0 0 1 1.5 0ZM9 9a1 1 0 1 1-2 0 1 1 0 0 1 2 0Z",
      CAUTION:
        "M4.47.22A.749.749 0 0 1 5 0h6c.199 0 .389.079.53.22l4.25 4.25c.141.14.22.331.22.53v6a.749.749 0 0 1-.22.53l-4.25 4.25A.749.749 0 0 1 11 16H5a.749.749 0 0 1-.53-.22L.22 11.53A.749.749 0 0 1 0 11V5c0-.199.079-.389.22-.53Zm.84 1.28L1.5 5.31v5.38l3.81 3.81h5.38l3.81-3.81V5.31L10.69 1.5ZM8 4a.75.75 0 0 1 .75.75v3.5a.75.75 0 0 1-1.5 0v-3.5A.75.75 0 0 1 8 4Zm0 8a1 1 0 1 1 0-2 1 1 0 0 1 0 2Z",
    };
    // ─────────────────────────────────────────────────────────────────────────

    var SVG_NS = "http://www.w3.org/2000/svg";
    var RE = /^\[!(NOTE|TIP|WARNING|IMPORTANT|CAUTION)\]\[ \t]*/i;

    function makeIcon(type) {
      var d = SVG_PATHS[type];
      var svg = document.createElementNS(SVG_NS, "svg");
      svg.setAttribute("viewBox", "0 0 16 16");
      svg.setAttribute("fill", "currentColor");
      svg.setAttribute("aria-hidden", "true");
      if (d) {
        var path = document.createElementNS(SVG_NS, "path");
        path.setAttribute("d", d);
        svg.appendChild(path);
      }
      return svg;
    }

    document
      .querySelectorAll("article blockquote:not([class])")
      .forEach(function (bq) {
        var firstP = bq.querySelector("p:first-child");
        if (!firstP) return;

        var firstText = firstP.firstChild;
        if (!firstText || firstText.nodeType !== 3 /* TEXT_NODE */) return;

        var m = firstText.nodeValue.match(RE);
        if (!m) return;

        var type = m[1].toUpperCase();

        // Strip the "[!TYPE] " prefix from the opening text node
        firstText.nodeValue = firstText.nodeValue.slice(m[0].length);

        // If the text node is now empty, remove it and any following hard-wrap <br>
        if (firstText.nodeValue === "") {
          var next = firstText.nextSibling;
          firstP.removeChild(firstText);
          if (next && next.nodeName === "BR") firstP.removeChild(next);
        }

        // If the first <p> is now empty, discard it entirely
        if (
          firstP.childNodes.length === 0 ||
          firstP.textContent.trim() === ""
        ) {
          bq.removeChild(firstP);
        }

        // Build the callout title element
        var titleEl = document.createElement("p");
        titleEl.className = "callout-title";
        titleEl.setAttribute("aria-label", TYPES[type]);

        var iconSpan = document.createElement("span");
        iconSpan.className = "callout-icon";
        iconSpan.appendChild(makeIcon(type));

        var labelSpan = document.createElement("span");
        labelSpan.textContent = TYPES[type];

        titleEl.appendChild(iconSpan);
        titleEl.appendChild(document.createTextNode("\u00a0"));
        titleEl.appendChild(labelSpan);

        bq.insertBefore(titleEl, bq.firstChild);
        bq.classList.add("callout", "callout-" + type.toLowerCase());
      });
  })();
</script>
```

需要說明下，樣式和顏色的靈感來自 [GitHub](https://github.com/orgs/community/discussions/16925) 。支持種類也是直接照搬 GitHub。具體如下：

> [!NOTE]
> Highlights information that users should take into account, even when skimming.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]
> Crucial information necessary for users to succeed.

> [!WARNING]
> Critical content demanding immediate user attention due to potential risks.

> [!CAUTION]
> Negative potential consequences of an action.

相關 CSS 我就不貼在這裏了，感興趣的朋友可以直接照搬本博客的 部分 CSS。

Source via: https://note.bgzo.cc/weekly/20260328-refactor-jekyll-blog