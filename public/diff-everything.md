---
draft: False
aliases: ['Diff-everything', 'How to diff everything']
created: 2025-07-01 21:04:56
modified: 2025-07-16 20:27:10
title: How to diff everything
tags: ['writing/how-to']
description: Text Online offline-diff-viewer via https//diffviewer.vercel.app/v2 via https//www.diffchecker.com/ Directories 比較兩個目錄的文件區別, 不 Care 內容 比較兩個目錄的文件區別, Care 內容 Photos Meta Video meta -u Git 比對 着色 using co...
---


## Text

### Online

#### offline-diff-viewer

<iframe src='https://diffviewer.vercel.app/v2' style='height:40vh;width:100%' class='iframe-radius' allow='fullscreen'></iframe>
<center>via: <a href='https://diffviewer.vercel.app/v2' target='_blank' class='external-link'>https://diffviewer.vercel.app/v2</a></center>

<iframe src='https://www.diffchecker.com/' style='height:40vh;width:100%' class='iframe-radius' allow='fullscreen'></iframe>
<center>via: <a href='https://www.diffchecker.com/' target='_blank' class='external-link'>https://www.diffchecker.com/</a></center>

## Directories

比較兩個目錄的文件區別, 不 Care 內容

```shell
diff -rq dir1 dir2
```

比較兩個目錄的文件區別, Care 內容

```shell
diff -r dir1 dir2
```

## Photos Meta

## Video meta

```shell
diff -u --color <(mediainfo --fullscan wbgm08.mp4) <(mediainfo --fullscan default.mp4)
```

- `-u`
	- Git 比對

```shell
sudo apt install colordiff
diff -u <(mediainfo --fullscan old.mp4) <(mediainfo --fullscan new.mp4) | colordiff
colordiff <(mediainfo --fullscan old.mp4) <(mediainfo --fullscan new.mp4)
```

- 着色 using [colordiff](https://www.colordiff.org/) on [Github](https://github.com/daveewart/colordiff)
	- It's a **wrapper** around `diff` that produces the same output as diff, except that it augments the output using colored syntax highlighting to increase readability

```bash
alias diff=colordiff
```

Source via: https://note.bgzo.cc/weekly/diff-everything