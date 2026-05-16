---
title: 修復 Venera 點擊導出無反應，章節顯示問題
aliases: ['修復 Venera 點擊導出無反應，章節顯示問題']
created: 2026-05-16 10:47:28
modified: 2026-05-16 15:41:31
published: 2026-05-10 07:05:43
tags: ['flutter', 'public', 'venera', 'writing/lab']
draft: False
description: 上次修復 Venera 無法在 iOS/iPad OS 上保存圖片 的問題，很可能是 iOS 的一個 BUG，因爲這周升級 iOS 26.5 之後，這個奇怪的問題就消失了。 除了這個問題，上次修復還有一個遺留問題是 iOS 會自動處理超長文件名，導致如： 最終會被 iOS 系統直接截斷爲： 很奇怪啊，之前一直沒有發現這個問題，檢測文件是否存在的時候用的原始原標題，而不是截斷後的，最終導致保存邏輯非...
---

上次修復 Venera 無法在 iOS/iPad OS 上保存圖片 的問題，很可能是 iOS 的一個 BUG，因爲這周升級 iOS 26.5 之後，這個奇怪的問題就消失了。

![](https://pub-89c11651a8434f18a530bd6f93e399da.r2.dev/2026/20260505230857427.webp)

除了這個問題，上次修復還有一個遺留問題是 iOS 會自動處理超長文件名，導致如：

```shell
與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png
```

最終會被 iOS 系統直接截斷爲：

```shell
與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう.png
```

很奇怪啊，之前一直沒有發現這個問題，檢測文件是否存在的時候用的原始原標題，而不是截斷後的，最終導致保存邏輯非常奇怪；

定位相關的調用 `saveFile` 的地方爲：

```dart
  void saveCurrentImage() async {
    var result = await selectImageToData();
    if (result == null) {
      return;
    }
    if (!mounted) return;
    var (imageIndex, data) = result;
    var fileType = detectFileType(data);
    // Save file name: ComicName_EP{chapter}_P{page}.{ext} to avoid conflict.
    // The chapter index of different group is continuous, so we use chapter number is enough.
    var filename =
        "${context.reader.widget.name}_EP${context.reader.chapter}_P${imageIndex + 1}${fileType.ext}";
    saveFile(data: data, filename: filename);
  }
```

首先這裏就有兩個問題：

1. 文件名字沒有經過清洗，非法文件名會帶來很多問題，比如上述的文件超長，特殊字符比如 `/` 會導致文件不存在的報錯，如下：

```shell
flutter: PathNotFoundException: Cannot open file, path = '/Users/bgzo/Library/Containers/io.github.haukuen.venera/Data/Library/Caches/io.github.haukuen.venera/侯爵嫡男好色物語 ～異世界後宮英雄戰記～[AL/GEN] 侯爵嫡男好色物語 ～異世界ハーレム英雄戰記～_EP1_P13.png' (OS Error: No such file or directory, errno = 2)
flutter: #0      _checkForErrorResponse (dart:io/common.dart:58:9)
flutter: #1      _File.open.<anonymous closure> (dart:io/file_impl.dart:438:7)
flutter: #2      _rootRunUnary (dart:async/zone_root.dart:48:47)
flutter: #3      _CustomZone.runUnary (dart:async/zone.dart:733:19)
flutter: <asynchronous suspension>
flutter: #4      _File.writeAsBytes.<anonymous closure> (dart:io/file_impl.dart:728:34)
flutter: <asynchronous suspension>
flutter: #5      saveFile (package:venera/utils/io.dart:359:7)
flutter: <asynchronous suspension>
```

2. EP 的章節顯示的是 chapter 的 ID，這個 ID 只對 Venera 有效，實際不是漫畫章節

## 清洗文件名

一開始想着還得自己清洗文件名，粗糙的寫了一個：

```dart
String sanitizeSaveFilename(String fileName, {int maxLength = 50}) {
  final extension = p.extension(fileName);
  final hasExtension = extension.isNotEmpty && extension.length < fileName.length;
  final reservedLength = hasExtension ? extension.length : 0;
  final nameLength = maxLength - reservedLength;
  if (nameLength <= 0) {
    throw Exception('Invalid File Name: Max length is less than extension length.');
  }
  final sanitizedBaseName = sanitizeFileName(
    hasExtension ? p.basenameWithoutExtension(fileName) : fileName,
    maxLength: nameLength,
  );
  return hasExtension ? '$sanitizedBaseName$extension' : sanitizedBaseName;
}
```

但細看代碼才發現它原本就有，只是這裏導出沒有調用而已...

```dart
/// Sanitize the file name. Remove invalid characters and trim the file name.
String sanitizeFileName(String fileName, {String? dir, int? maxLength}) {
  while (fileName.endsWith('.')) {
    fileName = fileName.substring(0, fileName.length - 1);
  }
  var length = maxLength ?? 255;
  if (dir != null) {
    if (!dir.endsWith('/') && !dir.endsWith('\\')) {
      dir = "$dir/";
    }
    length -= dir.length;
  }
  final invalidChars = RegExp(r'[<>:"/\\|?*]');
  final sanitizedFileName = fileName.replaceAll(invalidChars, ' ');
  var trimmedFileName = sanitizedFileName.trim();
  if (trimmedFileName.isEmpty) {
    throw Exception('Invalid File Name: Empty length.');
  }
  if (length <= 0) {
    throw Exception('Invalid File Name: Max length is less than 0.');
  }
  if (trimmedFileName.length > length) {
    trimmedFileName = trimmedFileName.substring(0, length);
  }
  return trimmedFileName;
}
```

那第一個問題就秒殺了，直接調用一下即可，考慮到 Linux、Mac、Android、Widnwos，最終考慮把文件名字限制爲 50 個字符。

## 章節顯示

這塊也是一開始想複雜了，因爲它 chapterId 涉及章節定位、歷史顯示的問題，如果一次遷移到 chapterTitle 的話，對歷史改動可能不太兼容，源之間做的也不是特別兼容，所以問題比較多。

然後看了一下其他地方的處理邏輯，我發現它其實已經做了一部分工作，比如:

```dart
// 已有邏輯1
final epName = context.reader.widget.chapters?.titles.elementAtOrNull(
    context.reader.chapter - 1,
);
// 已有邏輯2
var epName = context.reader.widget.chapters?.titles.elementAtOrNull(
  context.reader.chapter - 1,
) ?? "E${context.reader.chapter}";
```

我這才發現它上方顯示的標題是正確的，然而下方顯示的 EP，以及導出的文件文字的 EP 是錯誤的

![](https://github.com/user-attachments/assets/59f879bc-b4ee-4bd5-8879-c6858c790c82)

那這個改動就更簡單了，直接提取這部分爲公共邏輯即可正確展示：

```dart
String? get chapterTitle =>
    widget.chapters?.titles.elementAtOrNull(chapter - 1);

String get chapterDisplayName => chapterTitle ?? 'E$chapter';
```

直接抽象兩個變量，前者是源自己的標題，如果不存在，那麼 Display 自動會退爲 chapter ID，這樣的改動就合理多了。最終修復如下：

![](https://github.com/user-attachments/assets/9c29fb48-98ad-4e15-9f5c-bfd768bf49b0)

好多了，提 PR： https://github.com/haukuen/venera/pull/53

Source via: https://note.bgzo.cc/weekly/20260516-fix-venera-export-name