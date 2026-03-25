---
comments: True
draft: False
aliases: ['如何把你的.git 分離出 OneDrive/iCloud', 'How to separate your git directory from onedrive and icloud']
created: 2025-11-30 10:20:59
modified: 2025-11-30 10:34:14
tags: ['writing/how-to']
title: 如何把你的.git 分離出 OneDrive/iCloud
type: how-to
description: 爲什麼這麼做呢？ 雲同步固然方便，可以讓你在任何設備中隨時開展工作，但這不是網盤發明的目的，也會帶來額外的性能開銷，增加設備發熱和網絡帶寬流量。 一個比較好的解決方案就是，保留你本地的副本，你依然可以在各個設備上開展工作，但是你的 git 目錄需要存在本地的某個目錄，Git 本身給了很好分離支持，如 --git-dir[^git-dir]。 [^git-dir]: https://git-scm....
---


爲什麼這麼做呢？

雲同步固然方便，可以讓你在任何設備中隨時開展工作，但這不是網盤發明的目的，也會帶來額外的性能開銷，增加設備發熱和網絡帶寬流量。

一個比較好的解決方案就是，保留你本地的副本，你依然可以在各個設備上開展工作，但是你的 git 目錄需要存在本地的某個目錄，Git 本身給了很好分離支持，如 `--git-dir`[^git-dir]。

[^git-dir]: https://git-scm.com/docs/git

那麼接下來的問題就是如何把當前正常的 Git 項目中的 `.git` 目錄拆分出去，我們一點點來：

```shell
mkdir ~/workspaces/separate-git-dir/

cd ` ~/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian`
mv /.git ~/workspaces/separate-git-dir/obsidian.git

vim .git
```

將移動後的路徑寫進去，比如

```shell
gitdir: /Users/bgzo/workspaces/separate-git-dir/obsidian.git
```

需要注意冒號後面必須有空格，然後刷新你的編輯器，你的版本控制也就正常了，並且 git 的文件不會被網盤同步。

> 當然仍然有個問題，unix 和 windows 的目錄構造不一樣，就像我示例寫的，unix 當然可以通用，但是到了 windows 就是另外一副模樣了。需要注意

Source via: https://note.bgzo.cc/weekly/separate-your-git-directory-from-onedrive-and-icloud