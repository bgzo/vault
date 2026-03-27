---
title: 如何在 Obsidian 中增加按鈕
aliases: ['如何在 Obsidian 中增加按鈕']
created: 2026-02-01 14:42:45
modified: 2026-02-01 15:50:27
comments: True
draft: False
tags: ['writing/how-to']
type: how-to
description: 電腦有鍵盤，可以綁定快捷鍵，可以很方便地插入模版，但是手機端不行，手機端的操作主要是「點擊」，所以這個操作場景是針對手機端的： 在頁面上渲染一個按鈕，每次點擊它就可以自動地按既定模板創建一片文章。 方案有： 1. ==Buttons + Templater== 2. QuickAdd（更偏命令） 對於方案 1，下載安裝 Buttons 和 Templater，並用下面的案例測試下自己當前的 Vau...
---


電腦有鍵盤，可以綁定快捷鍵，可以很方便地插入模版，但是手機端不行，手機端的操作主要是「點擊」，所以這個操作場景是針對手機端的：

> 在頁面上渲染一個按鈕，每次點擊它就可以自動地按既定模板創建一片文章。

方案有：

1. ==Buttons + Templater==
2. QuickAdd（更偏命令）

對於方案 1，下載安裝 [Buttons](https://github.com/shabegom/buttons) 和 Templater，並用下面的案例測試下自己當前的 Vault 是否工作正常：

```button
name Add Current Time
type append text
action Current time: <% tp.date.now("HH:mm:ss") %>
templater true
```

正常情況會插入當前時間，如：`Current time: 14:49:53`，如果出現了其他東西，打開命令臺看下報錯，可能是本地什麼文件衝突了。

我們假設你已經提前在某個文件夾定義了 Templater 的模板文件，接着我們需要在某個文件夾下面創建一篇文章，假如我想新增一條隨筆，放在週記裏，按鈕可以這樣寫：

```button
name New Writing V1
action
<%*
const templatePath = "templaters/writing.md";
const folder = "/weekly";
const filename = tp.date.now("YYYYMMDD");
const notePath = `${folder}/${filename}`;

const existedFile = app.vault.getAbstractFileByPath(notePath);
if (existedFile) {
  // 已存在：直接打開
  await app.workspace.getLeaf(true).openFile(existedFile);
} else {
  // 不存在：用模板創建
  const templateFile = tp.file.find_tfile(templatePath);
  const newFile = await tp.file.create_new(
    templateFile,
    notePath,
    false
  );
  // 創建完順手打開
  await app.workspace.getLeaf(true).openFile(newFile);
}
%>
templater open true
```

這個按鈕又一個 BUG：判斷存在邏輯失效，原因是實際創建的文件根目錄不是當前知識庫，而是我全局設置的 `/pages` 文件夾，即最終創建的文件都在 pages/weekly 下面，我理想的位置是根目錄 /weekly。

目前沒有特別好的方案，只能增加一段移動文件的邏輯進去，即先隨便創建一個文件，然後移動到這個目錄中去，最終版本如下：

```button
name New writing V2
action
<%*
const templatePath = "templaters/writing.md";
const targetFolder = "weekly";
const filename = tp.date.now("YYYYMMDD");
const targetPath = `${targetFolder}/${filename}.md`;

// 如果目標文件已存在：直接打開，結束
const existedFile = app.vault.getAbstractFileByPath(targetPath);
if (existedFile) {
  await app.workspace.getLeaf(true).openFile(existedFile);
  return;
}

// 確保模板存在
const templateFile = tp.file.find_tfile(templatePath);
if (!templateFile) {
  new Notice(`Template not found: ${templatePath}`);
  return;
}

// 先創建（在哪都行）
const newFile = await tp.file.create_new(templateFile, filename, false);

// 再移動到目標目錄
try {
  await tp.file.move(`${targetFolder}/${filename}`, newFile);
} catch (err) {
  new Notice("Failed to move file to weekly folder");
  return;
}

// 打開新文件
const finalFile = app.vault.getAbstractFileByPath(targetPath);
if (finalFile) {
  await app.workspace.getLeaf(true).openFile(finalFile);
}
%>
templater open true

```

## References

Templater 和 Button 還有更多用戶，比如 Button 其實可以替代 slash 命令，比如下面的按鈕：

```button
name 打開模板選擇框
type command
action Templater: Open Insert Template modal
```

- https://buttonslovesyou.com/usage/templater
- https://forum.obsidian.md/t/trying-to-create-a-button-that-runs-a-specific-templater-template/49472/5
- https://forum.obsidian.md/t/buttons-showcase/18044/2
- https://medium.com/@ConstructByDee/i-added-buttons-to-obsidian-and-i-love-it-d3625cc58879
- https://forum.obsidian.md/t/my-home-base-tutorial/108759

Source via: https://note.bgzo.cc/weekly/using-button-on-obsidian