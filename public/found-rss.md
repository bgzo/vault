---
draft: False
title: How to found rss
aliases: How to found rss
created: 2025-06-12 22:28:05
modified: 2025-06-12 22:28:31
type: how-to
tags: ['writing/how-to']
description: Some websites will include element whose type is application/atom+xml or application/rss+xml. They would include RSS link. And following are some address they mostly used: Source via: https://note.bgz...
---

Some websites will include element whose type is `application/atom+xml` or `application/rss+xml`. They would include RSS link.

```xml
<link rel="alternate" type="application/atom+xml" title="${source.title}" href="${source.url}">
```

And following are some address they mostly used:

```xml
./feed
./rss.xml
./feed.xml
./atom.xml
./rss/index.xml
./index.xml
./rss
./rss/rss
./rss/rss.xml
<!-- Z-Blog via: https://bbs.zblogcn.com/thread-3527.html-->
./feed.asp?user=userID
./feed.asp?tags=TagID
<!-- Youtube -->
https://www.youtube.com/feeds/videos.xml?channel_id=<channel_id>
https://www.youtube.com/feeds/videos.xml?playlist_id=<playlist_id>
```

Source via: https://note.bgzo.cc/weekly/found-rss