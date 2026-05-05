---
title: 同步 venera 進度到 Bangumi
aliases: ['Sync venera data to Bangumi', '同步 venera 進度到 Bangumi']
created: 2026-05-03 09:59:37
modified: 2026-05-06 00:23:56
published: 2026-05-04 09:59:37
tags: ['bangumi', 'flutter', 'gtd/todo', 'public', 'venera', 'writing/lab']
draft: False
description: 其實我一直在 iPad 上用魔改的 venera (漫閱) 看漫畫 ，他其實已經提供了追蹤器跟蹤的功能，只是不太好用（需要手動關聯，總是失敗），加上開發者長時間不修，也不看羣，我感覺已經不再維護。 一致挺喜歡 venera 的，得益於 Flutter 跨平臺，它提供了 ipa，可以在 iPad 上測載看漫畫，體驗上和 Mihon 非常接近，配合上 WebDev 同步，已經是一個不錯的全平臺解決方案...
---

其實我一直在 iPad 上用魔改的 venera (漫閱) 看漫畫 [^man-yue]，他其實已經提供了追蹤器跟蹤的功能，只是不太好用（需要手動關聯，總是失敗），加上開發者長時間不修，也不看羣，我感覺已經不再維護。

[^man-yue]: 一個魔改的 venera，違反 GPL-3.0 協議，直接閉源了，25 年末上架的時候賣 6 塊，我就付費了，現在轉爲訂閱了，永久買斷 15 刀，比較離譜。這個作者手下也有一堆類似的軟件（書閱、雲映等等），只不過大部分已經在國區下架了，外區也是遲早的事情

![](https://pub-89c11651a8434f18a530bd6f93e399da.r2.dev/2026/1777774637105.webp)

一致挺喜歡 venera 的，得益於 Flutter 跨平臺，它提供了 ipa，可以在 iPad 上測載看漫畫，體驗上和 [Mihon](https://github.com/mihonapp/mihon) [^mihon-only-android] 非常接近，配合上 WebDev 同步，已經是一個不錯的全平臺解決方案了。

[^mihon-only-android]: Mihon 只提供了 Android，因爲它就是原生寫的，插件也是用 APK 寫的。如果他要跨平臺需要走 [ Kotlin Multiplatform](https://kotlinlang.org/multiplatform/ ) 那一套。

只是上個月 4 號，非常遺憾，它居然存檔了！雖然已經有人 [接手](https://github.com/haukuen/venera) 了，但還不確定未來在哪裏。

## Why not PR

我其實構想過一個比較好的未來：就是 [ venera-app  ](https://github.com/venera-app ) 可以把後續發展給社區，其實你能看到之前的大部分工作都是 [@wgh136](https://github.com/wgh136) 和 [@ynyxx ]( https://github.com/ynyxx ) 來做的，可能負擔比較重？

然後，漫閱拿去做付費其實不在 GPL 協議違規範圍內，其實他可以開源另一個版本，然後靠 AppStore 繼續盈利，一來遵守維持協議，二來也能保持項目之間協作。前提是 AppStore 可以容忍這種軟件存在，不會被人舉報下架。

在這方面我們和 Apple 還有很長的路要走，

一方面是能方便我這樣的小白，另一方面也能讓 venera 可以走的更遠，現在我想提 PR，也不知道改提給我，而且我用 iOS 魔改的 venera，已經只差臨門一腳的修復了，如果可以，我不太想重複造輪子。

## 解析 Venera 數據

一開始還糾結怎麼打開 venera 導出的格式，直接用 VSCode 打開是一坨亂碼，直到看到 venera 的導出實現：

```dart
// lib/utils/data.dart
Future<File> exportAppData([bool sync = true]) async {
  var time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  var cacheFilePath = FilePath.join(App.cachePath, '$time.venera');
  var cacheFile = File(cacheFilePath);
  var dataPath = App.dataPath;
  if (await cacheFile.exists()) {
    await cacheFile.delete();
  }
  await Isolate.run(() {
    var zipFile = ZipFile.open(cacheFilePath);
    var historyFile = FilePath.join(dataPath, "history.db");
    var localFavoriteFile = FilePath.join(dataPath, "local_favorite.db");
    var appdata = FilePath.join(dataPath, sync ? "syncdata.json" : "appdata.json");
    var cookies = FilePath.join(dataPath, "cookie.db");
    zipFile.addFile("history.db", historyFile);
    zipFile.addFile("local_favorite.db", localFavoriteFile);
    zipFile.addFile("appdata.json", appdata);
    zipFile.addFile("cookie.db", cookies);
    for (var file
        in Directory(FilePath.join(dataPath, "comic_source")).listSync()) {
      if (file is File) {
        zipFile.addFile("comic_source/${file.name}", file.path);
      }
    }
    zipFile.close();
  });
  return cacheFile;
}
```

明朗多了，是一個壓縮包，改名 zip，解壓之後我們可以得到

```shell
❯ tree . -L 3
.
├── appdata.json
├── comic_source # js 漫畫源，忽略
├── cookie.db
├── history.db
└── local_favorite.db

2 directories, 43 files
```

於是我們就能拿到 `local_favorite.db` 內部的數據，用於數據同步。接着我們就能進行數據解析，最終把這些數據全部轉化爲一個刻度的 JSON 包：

```shell
python3 src/parser.py dump 20575-2273.venera --include-rows --pretty -o venera_dump.json
```

## 匹配 Bangumi

一個比較大的問題是 venera 天然不與 bangumi 綁定：

```json
{
  "author": "",
  "cover_path": "https://public.komiic.com/comics/4eba50e2fe4d6752d334e7bb943e1455/cover.jpg",
  "display_order": 72,
  "has_new_update": null,
  "id": "1407",
  "last_check_time": 1777659880559,
  "last_update_time": "2026-1-11",
  "name": "青之驅魔師",
  "tags": "作者:加藤和惠,標籤:校園,標籤:冒險,標籤:魔幻,標籤:魔法,標籤:格鬥",
  "time": "2026-04-08 00:19:02",
  "translated_tags": "",
  "type": 637999886
},
```

所以最大的一個問題其實變成了如何匹配 Bangumi 的數據，存在非常多情況

1. 簡繁體不匹配
2. 符號差異
3. 別名衝突
4. 無關搜索

這些一一解決之後，我的樣本數據基本都跑完了，所以沒有辦法保證未來新增的數據依然有效，但是隻能這樣一點點迭代了。

## 如何使用

1. 從源碼 https://github.com/bgzo/playground/tree/2026/05/venera-parser-bangumi-sync
 構建

```shell
git clone --branch 2026/05/venera-parser-bangumi-sync https://github.com/bGZo/playground.git
cd playground
pipx install .
```

2. 直接安裝

```shell
pipx install venera-parser-bangumi
```

Source via: https://note.bgzo.cc/weekly/20260503-venera-to-bangumi