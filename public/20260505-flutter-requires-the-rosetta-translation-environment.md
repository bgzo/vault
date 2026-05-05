---
title: Flutter requires the Rosetta translation environment
aliases: ['Flutter requires the Rosetta translation environment']
created: 2026-05-05 21:15:14
modified: 2026-05-05 21:21:20
tags: ['apple', 'flutter', 'public', 'writing/how-to']
draft: False
published: 2026-05-05 16:07:21
description: 一般是 SDK 裏面的工具還是舊的，沒有適配 Apple ARM 平臺，所以在 iOS/iPad 上面調試的時候會出現下面的報錯，讓我們裝兼容層： 臥槽，怎麼可能，我們只需要幹掉這個 x86 的包即可： 重新起服務 Source via https//note.bgzo.cc/weekly/20260505-flutter-requires-the-rosetta-translation-envi...
---

一般是 SDK 裏面的工具還是舊的，沒有適配 Apple ARM 平臺，所以在 iOS/iPad 上面調試的時候會出現下面的報錯，讓我們裝兼容層：

```shell
Installing and launching...
The Dart VM Service was not discovered after 60 seconds. This is taking
much longer than expected...
Installing and launching...                                              227.0s
0.5
0.5
Error: Flutter failed to run
"/Users/bgzo/fvm/versions/3.41.9/bin/cache/artifacts/libusbmuxd/iproxy
49822:49622 --udid 00008130-000131EC1091401C".
The binary was built with the incorrect architecture to run on this
machine.
If you are on an ARM Apple Silicon Mac, Flutter requires the Rosetta
translation environment. Try running:
  sudo softwareupdate --install-rosetta --agree-to-license
```

臥槽，怎麼可能，我們只需要幹掉這個 x86 的包即可：

```shell
which iproxy

mv /Users/bgzo/fvm/versions/3.41.9/bin/cache/artifacts/libusbmuxd/iproxy /Users/bgzo/fvm/versions/3.41.9/bin/cache/artifacts/libusbmuxd/iproxy.bak

ln -s /opt/homebrew/bin/iproxy /Users/bgzo/fvm/versions/3.41.9/bin/cache/artifacts/libusbmuxd/iproxy
```

重新起服務

```shell
fvm flutter run
```

Source via: https://note.bgzo.cc/weekly/20260505-flutter-requires-the-rosetta-translation-environment