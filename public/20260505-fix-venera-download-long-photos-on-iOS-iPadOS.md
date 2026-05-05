---
title: Venera 無法在 iOS/iPad OS 上保存圖片
aliases: ['Venera 無法在 iOS/iPad OS 上保存圖片']
created: 2026-05-05 14:00:12
modified: 2026-05-05 23:09:35
published: 2026-05-05 23:09:35
tags: ['apple', 'flutter', 'public', 'venera', 'writing/lab']
draft: False
description: 我之前不是說用魔改的 venera 客戶端「漫閱」嗎？它和官方都有一個問題，在漫畫名特別長的時候，下載圖片會不顯示保存按鈕，也就是置灰狀態： 很頭疼啊，我的一個壞毛病就是看到好看的章節直接下載到本地，不用官方自帶的圖片收藏，漫閱這個東西已經發布至少半年了，就沒有一個人發現這玩意有問題嗎？？？ 還好 Venera 是開源的，可以直接調試，過程比較痛苦，因爲這個問題只存在 iOS 和 iPad 上面，...
---

我之前不是說用魔改的 venera 客戶端「漫閱」嗎？它和官方都有一個問題，在漫畫名特別長的時候，下載圖片會不顯示保存按鈕，也就是置灰狀態：

![image](https://github.com/user-attachments/assets/8ac0d719-e6c9-42d4-a969-f502b8844c13)

很頭疼啊，我的一個壞毛病就是看到好看的章節直接下載到本地，不用官方自帶的圖片收藏，漫閱這個東西已經發布至少半年了，就沒有一個人發現這玩意有問題嗎？？？

還好 Venera 是開源的，可以直接調試，過程比較痛苦，因爲這個問題只存在 iOS 和 iPad 上面，所以只能連接 iPad 進行調試。

## 真機調試需要 Rosetta 兼容層

我用的 SDK 是 3.41.9，這可是最新的穩定版，這麼多年了，iPad 調試還讓我安裝 Rosetta？

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

臥槽，有沒有搞錯，怎麼可能爲了這個東西安裝虛擬層，無奈，只能幹掉這個 x86 的包了：

```shell
which iproxy

mv /Users/bgzo/fvm/versions/3.41.9/bin/cache/artifacts/libusbmuxd/iproxy /Users/bgzo/fvm/versions/3.41.9/bin/cache/artifacts/libusbmuxd/iproxy.bak

ln -s /opt/homebrew/bin/iproxy /Users/bgzo/fvm/versions/3.41.9/bin/cache/artifacts/libusbmuxd/iproxy
```

然後重新起服務：

```shell
fvm flutter run
```

## 定位問題

一開始以爲是文件名稱超長的問題，修改了一下截斷邏輯：

```dart
String buildIOSSaveDialogFilename(String filename, {int maxUtf8Bytes = 120}) {
  final sanitized = sanitizeFileName(filename);
  if (utf8.encode(sanitized).length <= maxUtf8Bytes) {
    return sanitized;
  }

  final extension = p.extension(sanitized);
  final hasExtension = extension.isNotEmpty && sanitized != extension;
  final baseName = hasExtension ? p.basenameWithoutExtension(sanitized) : sanitized;
  final preservedSuffix = _extractPreservedFilenameSuffix(baseName);
  final availableBaseBytes =
      maxUtf8Bytes -
      utf8.encode(extension).length -
      utf8.encode(preservedSuffix).length;

  if (!hasExtension || availableBaseBytes <= 0) {
    return _truncateUtf8Bytes(sanitized, maxUtf8Bytes);
  }

  final prefix = preservedSuffix.isEmpty
      ? baseName
      : baseName.substring(0, baseName.length - preservedSuffix.length);
  final truncatedBaseName = _truncateUtf8Bytes(prefix, availableBaseBytes);
  if (truncatedBaseName.isEmpty) {
    return _truncateUtf8Bytes(sanitized, maxUtf8Bytes);
  }

  return truncatedBaseName + preservedSuffix + extension;
}

String _extractPreservedFilenameSuffix(String baseName) {
  final chapterSuffix = RegExp(r'(_EP\d+_P\d+)$').firstMatch(baseName);
  return chapterSuffix?.group(0) ?? '';
}

String _truncateUtf8Bytes(String value, int maxUtf8Bytes) {
  if (maxUtf8Bytes <= 0 || value.isEmpty) {
    return '';
  }

  final buffer = StringBuffer();
  var currentBytes = 0;
  for (final rune in value.runes) {
    final char = String.fromCharCode(rune);
    final charBytes = utf8.encode(char).length;
    if (currentBytes + charBytes > maxUtf8Bytes) {
      break;
    }
    buffer.write(char);
    currentBytes += charBytes;
  }
  return buffer.toString();
}
//...
Future<void> saveFile({
  Uint8List? data,
  required String filename,
  File? file,
}) async {
  if (data == null && file == null) {
    throw Exception("data and file cannot be null at the same time");
  }
  IO._isSelectingFiles = true;
  try {
	// 改造點
    final mobileFilename =  App.isIOS?
	    buildIOSSaveDialogFilename(filename)
	    :filename;
    if (data != null) {
      var cache = FilePath.join(App.cachePath, mobileFilename);
      if (File(cache).existsSync()) {
        File(cache).deleteSync();
      }
      await File(cache).writeAsBytes(data);
      file = File(cache);
    }
    if (App.isMobile) {
      final params = SaveFileDialogParams(
        sourceFilePath: file!.path,
        // 僅當 iOS 生效
        fileName: App.isIOS ? mobileFilename : null,
      );
      await FlutterFileDialog.saveFile(params: params);
    } else {
      final result = await file_selector.getSaveLocation(
        suggestedName: filename,
      );
      if (result != null) {
        var xFile = file_selector.XFile(file!.path);
        await xFile.saveTo(result.path);
      }
    }
  } finally {
    Future.delayed(const Duration(milliseconds: 100), () {
      IO._isSelectingFiles = false;
    });
  }
}
```

然後發現問題修復了，太好了。

因爲這個問題 Mac 上無法復現，所以我從始至終都有點納悶，這可能不是系統文件名長度的限制，即不是文件截斷的問題，於是我嘗試在彈窗之後，把原本超長的文件名替換進去，發現 Files 還是可以寫入的。實錘了，肯定不是文件名的問題，然後刪刪改改，把上面添加的 `buildIOSSaveDialogFilename` 函數移除之後，我發現問題也可以被解決。

我 TM 更納悶了，也就是說，其實影響 iOS/iPad OS 彈窗保存的，僅僅是 params 的一個參數！

```dart
// FIX: iOS export dialog cannot show filename and save.
final params = SaveFileDialogParams(
  sourceFilePath: file!.path,
  fileName: App.isIOS ? filename : null,
);
await FlutterFileDialog.saveFile(params: params);
```

爲什麼啊？

最終定位到 Swift 的源碼，可以看到多傳一個參數，僅僅是多走了一個複製分支的事情，然後這個問題就解決了？！沒有辦法，加點日誌在上面，重新啓動看看調用過程：

```swift
// /Users/bgzo/.pub-cache/hosted/pub.dev/flutter_file_dialog-3.0.3/ios/Classes/SaveFileDialog.swift
// Copyright (c) 2020 KineApps. All rights reserved.
//
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.

import Foundation
import UIKit

class SaveFileDialog: NSObject, UIDocumentPickerDelegate {
    private var flutterResult: FlutterResult?
    private var params: SaveFileDialogParams?
    private var tempFileUrl: URL?

    deinit {
        writeLog("")
        deleteTempFile()
    }

    func saveFileToDirectory(_ params: SaveFileToDirectoryParams, result: @escaping FlutterResult) {
        if params.data == nil {
            result(FlutterError(code: "invalid_arguments",
                                message: "Missing 'data'",
                                details: nil)
            )
            return
        }

        if params.directory == nil {
            result(FlutterError(code: "invalid_arguments",
                                message: "Missing 'directory'",
                                details: nil)
            )
            return
        }

        var directory: URL?
        do {
            var isStale = false
            directory = try URL(resolvingBookmarkData: Data(base64Encoded: params.directory!)!, bookmarkDataIsStale: &isStale)
            if (isStale) {
                result(FlutterError(code: "accessing_stale",
                                    message: "picked directory accessing staled",
                                    details: nil)
                )
                return
            }
        } catch let error {
            result(FlutterError(code: "invalid_arguments",
                                message: "invalid 'directory' data",
                                details: error.localizedDescription)
            )
            return
        }

        if params.fileName == nil || params.fileName!.isEmpty {
            result(FlutterError(code: "invalid_arguments",
                                message: "Missing 'fileName'",
                                details: nil)
            )
            return
        }

        let fileUrl = directory!.appendingPathComponent(params.fileName!, isDirectory: false)

        if FileManager.default.fileExists(atPath: fileUrl.path) {
            if !params.replace {
                result(FlutterError(code: "file_already_exists",
                                    message: "File already exists: '\(fileUrl.absoluteString)'",
                                    details: nil)
                )
                return
            }

            do {
                try FileManager.default.removeItem(at: fileUrl)
            } catch let error {
                result(FlutterError(code: "file_remove_failed",
                                    message: error.localizedDescription,
                                    details: nil)
                )
                return
            }
        }

        let fileContents = Data(bytes: params.data!, count: params.data!.count)
        do {
            try fileContents.write(to: fileUrl)
        } catch {
            result(FlutterError(code: "file_create_failed",
                                message: error.localizedDescription,
                                details: nil)
            )
            return
        }

        result(fileUrl.path)
    }

	// 調用點
    func saveFile(_ params: SaveFileDialogParams, result: @escaping FlutterResult) {
        flutterResult = result
        self.params = params
        writeLog(buildParameterLog(params))

        var fileUrl: URL?

        if params.data == nil {
            // get source file URL
            guard let sourceFilePath = params.sourceFilePath else {
                result(FlutterError(code: "invalid_arguments",
                                    message: "Missing 'sourceFilePath'",
                                    details: nil)
                )
                return
            }

            // note: fileExists fails if path contains relative elements, so standardize the path
            fileUrl = URL(fileURLWithPath: sourceFilePath).standardized
            writeLog(describeUrl("sourceFileUrl", fileUrl!))

            // check that source file exists
            if !FileManager.default.fileExists(atPath: fileUrl!.path) {
                result(FlutterError(code: "file_not_found",
                                    message: "File not found: '\(fileUrl!.path)'",
                                    details: nil)
                )
                return
            }
        }

        // if file name was specified, create a temp file with the requested file name
        if params.fileName != nil {
            let directory = NSTemporaryDirectory()
            tempFileUrl = NSURL.fileURL(withPathComponents: [directory, params.fileName!])
            writeLog(describeUrl("tempFileUrl", tempFileUrl!))

            do {
                // overwrite existing file
                if FileManager.default.fileExists(atPath: tempFileUrl!.path) {
                    try FileManager.default.removeItem(at: tempFileUrl!)
                }

                if params.data != nil {
                    writeLog("Writing data \(params.data!.count) bytes to temp file \(tempFileUrl!)")
                    let d = Data(bytes: params.data!, count: params.data!.count)
                    try d.write(to: tempFileUrl!)
                } else {
                    writeLog("Copying \(fileUrl!) to \(tempFileUrl!)")
                    try FileManager.default.copyItem(at: fileUrl!, to: tempFileUrl!)
                }
            } catch {
                writeLog(error.localizedDescription)
                result(FlutterError(code: "creating_temp_file_failed",
                                    message: error.localizedDescription,
                                    details: nil)
                )
                return
            }
            fileUrl = tempFileUrl!
        }

        writeLog(describeUrl("documentPickerExportUrl", fileUrl!))

        // get parent view controller
        guard let parentViewController = UIApplication.shared.keyWindow?.rootViewController else {
            result(FlutterError(code: "fatal",
                                message: "Getting rootViewController failed",
                                details: nil)
            )
            return
        }

        // create document picker
        let documentPickerViewController = UIDocumentPickerViewController(url: fileUrl!, in: .exportToService)
        documentPickerViewController.delegate = self

        // show dialog
        parentViewController.present(documentPickerViewController, animated: true, completion: nil)
    }

    private func deleteTempFile() {
        if tempFileUrl != nil {
            do {
                if FileManager.default.fileExists(atPath: tempFileUrl!.path) {
                    writeLog("Deleting temp file \(tempFileUrl!)")
                    try FileManager.default.removeItem(at: tempFileUrl!)
                }
                tempFileUrl = nil
            } catch {
                writeLog(error.localizedDescription)
            }
        }
    }

    // MARK: - UIDocumentPickerDelegate

    public func documentPicker(_: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        writeLog("didPickDocumentAt")
        deleteTempFile()
        flutterResult?(url.path)
    }

    public func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        writeLog("didPickDocumentsAt")
        deleteTempFile()
        flutterResult?(urls[0].path)
    }

    public func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
        writeLog("documentPickerWasCancelled")
        deleteTempFile()
        flutterResult?(nil)
    }

    private func buildParameterLog(_ params: SaveFileDialogParams) -> String {
        let sourcePath = params.sourceFilePath ?? "nil"
        let requestedFileName = params.fileName ?? "nil"
        let sourcePathUtf8Count = sourcePath == "nil" ? 0 : sourcePath.lengthOfBytes(using: .utf8)
        let fileNameUtf8Count = requestedFileName == "nil" ? 0 : requestedFileName.lengthOfBytes(using: .utf8)
        return "saveFile params sourceFilePath=\(sourcePath) sourceFilePath.utf8=\(sourcePathUtf8Count) fileName=\(requestedFileName) fileName.utf8=\(fileNameUtf8Count) dataBytes=\(params.data?.count ?? 0)"
    }

    private func describeUrl(_ label: String, _ url: URL) -> String {
        let path = url.path
        let fileName = url.lastPathComponent
        return "\(label) path=\(path) path.utf8=\(path.lengthOfBytes(using: .utf8)) path.count=\(path.count) fileName=\(fileName) fileName.utf8=\(fileName.lengthOfBytes(using: .utf8)) fileName.count=\(fileName.count)"
    }
}

```

調試打印日誌

```shell
2026-05-05 07:30:29 +0000 [SwiftFlutterFileDialogPlugin.swift:24 handle(_:result:)] saveFile
2026-05-05 07:30:29 +0000 [SaveFileDialog.swift:15 deinit]
2026-05-05 07:30:29 +0000 [SaveFileDialog.swift:102 saveFile(_:result:)] saveFile params sourceFilePath=/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/[漫漫長夜翻譯組] [よのき] 鬼畜英雄_EP106_P6.png sourceFilePath.utf8=153 fileName=nil fileName.utf8=0 dataBytes=0
2026-05-05 07:30:29 +0000 [SaveFileDialog.swift:118 saveFile(_:result:)] sourceFileUrl path=/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/[漫漫長夜翻譯組] [よのき] 鬼畜英雄_EP106_P6.png path.utf8=153 path.count=125 fileName=[漫漫長夜翻譯組] [よのき] 鬼畜英雄_EP106_P6.png fileName.utf8=61 fileName.count=33
2026-05-05 07:30:29 +0000 [SaveFileDialog.swift:161 saveFile(_:result:)] documentPickerExportUrl path=/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/[漫漫長夜翻譯組] [よのき] 鬼畜英雄_EP106_P6.png path.utf8=153 path.count=125 fileName=[漫漫長夜翻譯組] [よのき] 鬼畜英雄_EP106_P6.png fileName.utf8=61 fileName.count=33
2026-05-05 07:28:33 +0000 [SwiftFlutterFileDialogPlugin.swift:24 handle(_:result:)] saveFile
2026-05-05 07:28:33 +0000 [SaveFileDialog.swift:15 deinit]
2026-05-05 07:28:33 +0000 [SaveFileDialog.swift:102 saveFile(_:result:)] saveFile params sourceFilePath=/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png sourceFilePath.utf8=267 fileName=nil fileName.utf8=0 dataBytes=0
2026-05-05 07:28:33 +0000 [SaveFileDialog.swift:118 saveFile(_:result:)] sourceFileUrl path=/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png path.utf8=273 path.count=165 fileName=轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png fileName.utf8=181 fileName.count=73
2026-05-05 07:28:33 +0000 [SaveFileDialog.swift:161 saveFile(_:result:)] documentPickerExportUrl path=/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png path.utf8=273 path.count=165 fileName=轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png fileName.utf8=181 fileName.count=73
2026-05-05 14:28:42 +0000 [SwiftFlutterFileDialogPlugin.swift:24 handle(_:result:)] saveFile
2026-05-05 14:28:42 +0000 [SaveFileDialog.swift:15 deinit]
2026-05-05 14:28:42 +0000 [SaveFileDialog.swift:102 saveFile(_:result:)] saveFile params sourceFilePath=/var/mobile/Containers/Data/Application/3E03D305-2716-41AB-B7CA-2D4F4CCD8518/Library/Caches/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png sourceFilePath.utf8=434 fileName=nil fileName.utf8=0 dataBytes=0
2026-05-05 14:28:42 +0000 [SaveFileDialog.swift:118 saveFile(_:result:)] sourceFileUrl path=/var/mobile/Containers/Data/Application/3E03D305-2716-41AB-B7CA-2D4F4CCD8518/Library/Caches/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png path.utf8=455 path.count=222 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=363 fileName.count=130
2026-05-05 14:28:42 +0000 [SaveFileDialog.swift:161 saveFile(_:result:)] documentPickerExportUrl path=/var/mobile/Containers/Data/Application/3E03D305-2716-41AB-B7CA-2D4F4CCD8518/Library/Caches/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png path.utf8=455 path.count=222 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=363 fileName.count=130

2026-05-05 07:27:27 +0000 [SwiftFlutterFileDialogPlugin.swift:24 handle(_:result:)] saveFile
2026-05-05 07:27:27 +0000 [SaveFileDialog.swift:102 saveFile(_:result:)] saveFile params sourceFilePath=/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png sourceFilePath.utf8=267 fileName=轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png fileName.utf8=175 dataBytes=0
2026-05-05 07:27:27 +0000 [SaveFileDialog.swift:118 saveFile(_:result:)] sourceFileUrl path=/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png path.utf8=273 path.count=165 fileName=轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png fileName.utf8=181 fileName.count=73
2026-05-05 07:27:27 +0000 [SaveFileDialog.swift:134 saveFile(_:result:)] tempFileUrl path=/private/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/tmp/轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png path.utf8=270 path.count=162 fileName=轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png fileName.utf8=181 fileName.count=73
2026-05-05 07:27:27 +0000 [SaveFileDialog.swift:147 saveFile(_:result:)] Copying file:///var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/%E8%BD%89%E7%94%9F%E5%A5%B4%E9%9A%B8%E8%A7%92%E9%AC%A5%E5%A0%B4%20%5Bzunta%20%E3%81%AF%E3%82%89%E3%82%8F%E3%81%9F%E3%81%95%E3%81%84%E3%81%9D%E3%82%99%E3%81%86%5D%20%E8%BD%89%E7%94%9F%E3%82%B3%E3%83%AD%E3%82%B7%E3%82%A2%E3%83%A0%EF%BD%9E%E6%9C%80%E5%BC%B1%E3%82%B9%E3%82%AD%E3%83%AB%E3%81%A6%E3%82%99%E6%9C%80%E5%BC%B7%E3%81%AE%E5%A5%B3%E3%81%9F%E3%81%A1%E3%82%92%E6%94%BB%E7%95%A5%E3%81%97%E3%81%A6%E5%A5%B4%E9%9A%B7%E3%83%8F%E3%83%BC%E3%83%AC%E3%83%A0%E4%BD%9C%E3%82%8A%E3%81%BE%E3%81%99%EF%BD%9E_EP23_P1.png to file:///private/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/tmp/%E8%BD%89%E7%94%9F%E5%A5%B4%E9%9A%B8%E8%A7%92%E9%AC%A5%E5%A0%B4%20%5Bzunta%20%E3%81%AF%E3%82%89%E3%82%8F%E3%81%9F%E3%81%95%E3%81%84%E3%81%9D%E3%82%99%E3%81%86%5D%20%E8%BD%89%E7%94%9F%E3%82%B3%E3%83%AD%E3%82%B7%E3%82%A2%E3%83%A0%EF%BD%9E%E6%9C%80%E5%BC%B1%E3%82%B9%E3%82%AD%E3%83%AB%E3%81%A6%E3%82%99%E6%9C%80%E5%BC%B7%E3%81%AE%E5%A5%B3%E3%81%9F%E3%81%A1%E3%82%92%E6%94%BB%E7%95%A5%E3%81%97%E3%81%A6%E5%A5%B4%E9%9A%B7%E3%83%8F%E3%83%BC%E3%83%AC%E3%83%A0%E4%BD%9C%E3%82%8A%E3%81%BE%E3%81%99%EF%BD%9E_EP23_P1.png
2026-05-05 07:27:27 +0000 [SaveFileDialog.swift:161 saveFile(_:result:)] documentPickerExportUrl path=/private/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/tmp/轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png path.utf8=270 path.count=162 fileName=轉生奴隸角鬥場 [zunta はらわたさいぞう] 轉生コロシアム～最弱スキルで最強の女たちを攻略して奴隷ハーレム作ります～_EP23_P1.png fileName.utf8=181 fileName.count=73
2026-05-05 14:34:01 +0000 [SwiftFlutterFileDialogPlugin.swift:24 handle(_:result:)] saveFile
2026-05-05 14:34:01 +0000 [SaveFileDialog.swift:102 saveFile(_:result:)] saveFile params sourceFilePath=/var/mobile/Containers/Data/Application/729E2F1F-8B47-4C11-9309-8D4092A90588/Library/Caches/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png sourceFilePath.utf8=434 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=342 dataBytes=0
2026-05-05 14:34:01 +0000 [SaveFileDialog.swift:118 saveFile(_:result:)] sourceFileUrl path=/var/mobile/Containers/Data/Application/729E2F1F-8B47-4C11-9309-8D4092A90588/Library/Caches/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png path.utf8=455 path.count=222 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=363 fileName.count=130
2026-05-05 14:34:01 +0000 [SaveFileDialog.swift:134 saveFile(_:result:)] tempFileUrl path=/private/var/mobile/Containers/Data/Application/729E2F1F-8B47-4C11-9309-8D4092A90588/tmp/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png path.utf8=452 path.count=219 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=363 fileName.count=130
2026-05-05 14:34:01 +0000 [SaveFileDialog.swift:147 saveFile(_:result:)] Copying file:///var/mobile/Containers/Data/Application/729E2F1F-8B47-4C11-9309-8D4092A90588/Library/Caches/%E8%88%87%E6%98%8E%E6%98%8E%E7%9C%8B%E8%B5%B7%E4%BE%86%E5%BE%88%E6%B8%85%E7%B4%94%E5%8D%BB%E7%94%A8%E4%B8%8B%E6%B5%81%E7%9A%84%E8%A8%80%E8%BE%AD%E5%91%BB%E5%90%9F%E8%B5%B7%E4%BE%86%E7%9A%84%E9%84%B0%E5%AE%B6%E5%B7%A8%E4%B9%B3%E5%A4%A7%E5%A7%90%E5%A7%90%E6%BF%83%E5%8E%9A%E8%A6%AA%E5%AF%86%E6%81%A9%E6%84%9B%E6%80%A7%E6%84%9B%E7%9A%84%E6%95%85%E4%BA%8B%20%5B%E3%81%B2%E3%81%A4%E3%81%97%E3%82%99%E3%81%AE%E3%81%86%E3%81%A8%E3%82%99%E3%82%93%E5%B1%8B%20(%E3%81%84%E3%81%AA%E3%81%BF%E3%81%BF)%5D%20%E6%B8%85%E6%A5%9A%E3%81%A3%E3%81%BB%E3%82%9A%E3%81%84%E3%81%AE%E3%81%AB%E4%B8%8B%E5%93%81%E3%81%AA%E8%A8%80%E8%91%89%E3%81%A4%E3%82%99%E3%81%8B%E3%81%84%E3%81%A6%E3%82%99%E3%82%AA%E3%83%9B%E5%96%98%E3%81%8D%E3%82%99%E3%81%97%E3%81%A1%E3%82%83%E3%81%86%E8%BF%91%E6%89%80%E3%81%AE%E5%B7%A8%E4%B9%B3%E3%81%8A%E5%A7%89%E3%81%95%E3%82%93%E3%81%A8%E6%BF%83%E5%8E%9A%E3%81%84%E3%81%A1%E3%82%83%E3%83%A9%E3%83%95%E3%82%99%E3%81%88%E3%81%A3%E3%81%A1%E3%81%99%E3%82%8B%E8%A9%B1%20%5B%E4%B8%AD%E5%9C%8B%E7%BF%BB%E8%AD%AF%5D%20%5B%E7%A6%81%E6%BC%AB%E5%8E%BB%E7%A2%BC%5D_EP1_P1.png to file:///private/var/mobile/Containers/Data/Application/729E2F1F-8B47-4C11-9309-8D4092A90588/tmp/%E8%88%87%E6%98%8E%E6%98%8E%E7%9C%8B%E8%B5%B7%E4%BE%86%E5%BE%88%E6%B8%85%E7%B4%94%E5%8D%BB%E7%94%A8%E4%B8%8B%E6%B5%81%E7%9A%84%E8%A8%80%E8%BE%AD%E5%91%BB%E5%90%9F%E8%B5%B7%E4%BE%86%E7%9A%84%E9%84%B0%E5%AE%B6%E5%B7%A8%E4%B9%B3%E5%A4%A7%E5%A7%90%E5%A7%90%E6%BF%83%E5%8E%9A%E8%A6%AA%E5%AF%86%E6%81%A9%E6%84%9B%E6%80%A7%E6%84%9B%E7%9A%84%E6%95%85%E4%BA%8B%20%5B%E3%81%B2%E3%81%A4%E3%81%97%E3%82%99%E3%81%AE%E3%81%86%E3%81%A8%E3%82%99%E3%82%93%E5%B1%8B%20(%E3%81%84%E3%81%AA%E3%81%BF%E3%81%BF)%5D%20%E6%B8%85%E6%A5%9A%E3%81%A3%E3%81%BB%E3%82%9A%E3%81%84%E3%81%AE%E3%81%AB%E4%B8%8B%E5%93%81%E3%81%AA%E8%A8%80%E8%91%89%E3%81%A4%E3%82%99%E3%81%8B%E3%81%84%E3%81%A6%E3%82%99%E3%82%AA%E3%83%9B%E5%96%98%E3%81%8D%E3%82%99%E3%81%97%E3%81%A1%E3%82%83%E3%81%86%E8%BF%91%E6%89%80%E3%81%AE%E5%B7%A8%E4%B9%B3%E3%81%8A%E5%A7%89%E3%81%95%E3%82%93%E3%81%A8%E6%BF%83%E5%8E%9A%E3%81%84%E3%81%A1%E3%82%83%E3%83%A9%E3%83%95%E3%82%99%E3%81%88%E3%81%A3%E3%81%A1%E3%81%99%E3%82%8B%E8%A9%B1%20%5B%E4%B8%AD%E5%9C%8B%E7%BF%BB%E8%AD%AF%5D%20%5B%E7%A6%81%E6%BC%AB%E5%8E%BB%E7%A2%BC%5D_EP1_P1.png
2026-05-05 14:34:01 +0000 [SaveFileDialog.swift:161 saveFile(_:result:)] documentPickerExportUrl path=/private/var/mobile/Containers/Data/Application/729E2F1F-8B47-4C11-9309-8D4092A90588/tmp/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png path.utf8=452 path.count=219 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=363 fileName.count=130

2026-05-05 14:52:28 +0000 [SwiftFlutterFileDialogPlugin.swift:24 handle(_:result:)] saveFile
2026-05-05 14:52:28 +0000 [SaveFileDialog.swift:102 saveFile(_:result:)] saveFile params sourceFilePath=/var/mobile/Containers/Data/Application/937B0DC2-646D-478D-A881-E4CBF25A9990/Library/Caches/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png sourceFilePath.utf8=434 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=342 dataBytes=0
2026-05-05 14:52:28 +0000 [SaveFileDialog.swift:118 saveFile(_:result:)] sourceFileUrl path=/var/mobile/Containers/Data/Application/937B0DC2-646D-478D-A881-E4CBF25A9990/Library/Caches/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png path.utf8=455 path.count=222 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=363 fileName.count=130
2026-05-05 14:52:28 +0000 [SaveFileDialog.swift:134 saveFile(_:result:)] tempFileUrl path=/private/var/mobile/Containers/Data/Application/937B0DC2-646D-478D-A881-E4CBF25A9990/tmp/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png path.utf8=452 path.count=219 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=363 fileName.count=130
2026-05-05 14:52:28 +0000 [SaveFileDialog.swift:147 saveFile(_:result:)] Copying file:///var/mobile/Containers/Data/Application/937B0DC2-646D-478D-A881-E4CBF25A9990/Library/Caches/%E8%88%87%E6%98%8E%E6%98%8E%E7%9C%8B%E8%B5%B7%E4%BE%86%E5%BE%88%E6%B8%85%E7%B4%94%E5%8D%BB%E7%94%A8%E4%B8%8B%E6%B5%81%E7%9A%84%E8%A8%80%E8%BE%AD%E5%91%BB%E5%90%9F%E8%B5%B7%E4%BE%86%E7%9A%84%E9%84%B0%E5%AE%B6%E5%B7%A8%E4%B9%B3%E5%A4%A7%E5%A7%90%E5%A7%90%E6%BF%83%E5%8E%9A%E8%A6%AA%E5%AF%86%E6%81%A9%E6%84%9B%E6%80%A7%E6%84%9B%E7%9A%84%E6%95%85%E4%BA%8B%20%5B%E3%81%B2%E3%81%A4%E3%81%97%E3%82%99%E3%81%AE%E3%81%86%E3%81%A8%E3%82%99%E3%82%93%E5%B1%8B%20(%E3%81%84%E3%81%AA%E3%81%BF%E3%81%BF)%5D%20%E6%B8%85%E6%A5%9A%E3%81%A3%E3%81%BB%E3%82%9A%E3%81%84%E3%81%AE%E3%81%AB%E4%B8%8B%E5%93%81%E3%81%AA%E8%A8%80%E8%91%89%E3%81%A4%E3%82%99%E3%81%8B%E3%81%84%E3%81%A6%E3%82%99%E3%82%AA%E3%83%9B%E5%96%98%E3%81%8D%E3%82%99%E3%81%97%E3%81%A1%E3%82%83%E3%81%86%E8%BF%91%E6%89%80%E3%81%AE%E5%B7%A8%E4%B9%B3%E3%81%8A%E5%A7%89%E3%81%95%E3%82%93%E3%81%A8%E6%BF%83%E5%8E%9A%E3%81%84%E3%81%A1%E3%82%83%E3%83%A9%E3%83%95%E3%82%99%E3%81%88%E3%81%A3%E3%81%A1%E3%81%99%E3%82%8B%E8%A9%B1%20%5B%E4%B8%AD%E5%9C%8B%E7%BF%BB%E8%AD%AF%5D%20%5B%E7%A6%81%E6%BC%AB%E5%8E%BB%E7%A2%BC%5D_EP1_P1.png to file:///private/var/mobile/Containers/Data/Application/937B0DC2-646D-478D-A881-E4CBF25A9990/tmp/%E8%88%87%E6%98%8E%E6%98%8E%E7%9C%8B%E8%B5%B7%E4%BE%86%E5%BE%88%E6%B8%85%E7%B4%94%E5%8D%BB%E7%94%A8%E4%B8%8B%E6%B5%81%E7%9A%84%E8%A8%80%E8%BE%AD%E5%91%BB%E5%90%9F%E8%B5%B7%E4%BE%86%E7%9A%84%E9%84%B0%E5%AE%B6%E5%B7%A8%E4%B9%B3%E5%A4%A7%E5%A7%90%E5%A7%90%E6%BF%83%E5%8E%9A%E8%A6%AA%E5%AF%86%E6%81%A9%E6%84%9B%E6%80%A7%E6%84%9B%E7%9A%84%E6%95%85%E4%BA%8B%20%5B%E3%81%B2%E3%81%A4%E3%81%97%E3%82%99%E3%81%AE%E3%81%86%E3%81%A8%E3%82%99%E3%82%93%E5%B1%8B%20(%E3%81%84%E3%81%AA%E3%81%BF%E3%81%BF)%5D%20%E6%B8%85%E6%A5%9A%E3%81%A3%E3%81%BB%E3%82%9A%E3%81%84%E3%81%AE%E3%81%AB%E4%B8%8B%E5%93%81%E3%81%AA%E8%A8%80%E8%91%89%E3%81%A4%E3%82%99%E3%81%8B%E3%81%84%E3%81%A6%E3%82%99%E3%82%AA%E3%83%9B%E5%96%98%E3%81%8D%E3%82%99%E3%81%97%E3%81%A1%E3%82%83%E3%81%86%E8%BF%91%E6%89%80%E3%81%AE%E5%B7%A8%E4%B9%B3%E3%81%8A%E5%A7%89%E3%81%95%E3%82%93%E3%81%A8%E6%BF%83%E5%8E%9A%E3%81%84%E3%81%A1%E3%82%83%E3%83%A9%E3%83%95%E3%82%99%E3%81%88%E3%81%A3%E3%81%A1%E3%81%99%E3%82%8B%E8%A9%B1%20%5B%E4%B8%AD%E5%9C%8B%E7%BF%BB%E8%AD%AF%5D%20%5B%E7%A6%81%E6%BC%AB%E5%8E%BB%E7%A2%BC%5D_EP1_P1.png
2026-05-05 14:52:28 +0000 [SaveFileDialog.swift:161 saveFile(_:result:)] documentPickerExportUrl path=/private/var/mobile/Containers/Data/Application/937B0DC2-646D-478D-A881-E4CBF25A9990/tmp/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png path.utf8=452 path.count=219 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=363 fileName.count=130
flutter: Data uploaded successfully
2026-05-05 14:52:33 +0000 [SaveFileDialog.swift:203 documentPicker(_:didPickDocumentsAt:)] didPickDocumentsAt
2026-05-05 14:52:33 +0000 [SaveFileDialog.swift:184 deleteTempFile()] Deleting temp file file:///private/var/mobile/Containers/Data/Application/937B0DC2-646D-478D-A881-E4CBF25A9990/tmp/%E8%88%87%E6%98%8E%E6%98%8E%E7%9C%8B%E8%B5%B7%E4%BE%86%E5%BE%88%E6%B8%85%E7%B4%94%E5%8D%BB%E7%94%A8%E4%B8%8B%E6%B5%81%E7%9A%84%E8%A8%80%E8%BE%AD%E5%91%BB%E5%90%9F%E8%B5%B7%E4%BE%86%E7%9A%84%E9%84%B0%E5%AE%B6%E5%B7%A8%E4%B9%B3%E5%A4%A7%E5%A7%90%E5%A7%90%E6%BF%83%E5%8E%9A%E8%A6%AA%E5%AF%86%E6%81%A9%E6%84%9B%E6%80%A7%E6%84%9B%E7%9A%84%E6%95%85%E4%BA%8B%20%5B%E3%81%B2%E3%81%A4%E3%81%97%E3%82%99%E3%81%AE%E3%81%86%E3%81%A8%E3%82%99%E3%82%93%E5%B1%8B%20(%E3%81%84%E3%81%AA%E3%81%BF%E3%81%BF)%5D%20%E6%B8%85%E6%A5%9A%E3%81%A3%E3%81%BB%E3%82%9A%E3%81%84%E3%81%AE%E3%81%AB%E4%B8%8B%E5%93%81%E3%81%AA%E8%A8%80%E8%91%89%E3%81%A4%E3%82%99%E3%81%8B%E3%81%84%E3%81%A6%E3%82%99%E3%82%AA%E3%83%9B%E5%96%98%E3%81%8D%E3%82%99%E3%81%97%E3%81%A1%E3%82%83%E3%81%86%E8%BF%91%E6%89%80%E3%81%AE%E5%B7%A8%E4%B9%B3%E3%81%8A%E5%A7%89%E3%81%95%E3%82%93%E3%81%A8%E6%BF%83%E5%8E%9A%E3%81%84%E3%81%A1%E3%82%83%E3%83%A9%E3%83%95%E3%82%99%E3%81%88%E3%81%A3%E3%81%A1%E3%81%99%E3%82%8B%E8%A9%B1%20%5B%E4%B8%AD%E5%9C%8B%E7%BF%BB%E8%AD%AF%5D%20%5B%E7%A6%81%E6%BC%AB%E5%8E%BB%E7%A2%BC%5D_EP1_P1.png

2026-05-05 07:41:50 +0000 [SwiftFlutterFileDialogPlugin.swift:24 handle(_:result:)] saveFile
2026-05-05 07:41:50 +0000 [SaveFileDialog.swift:15 deinit]
2026-05-05 07:41:50 +0000 [SaveFileDialog.swift:102 saveFile(_:result:)] saveFile params sourceFilePath=/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png sourceFilePath.utf8=434 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=342 dataBytes=0
2026-05-05 07:41:50 +0000 [SaveFileDialog.swift:118 saveFile(_:result:)] sourceFileUrl path=/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png path.utf8=455 path.count=222 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=363 fileName.count=130
2026-05-05 07:41:50 +0000 [SaveFileDialog.swift:134 saveFile(_:result:)] tempFileUrl path=/private/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/tmp/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png path.utf8=452 path.count=219 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=363 fileName.count=130
2026-05-05 07:41:50 +0000 [SaveFileDialog.swift:147 saveFile(_:result:)] Copying file:///var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/Library/Caches/%E8%88%87%E6%98%8E%E6%98%8E%E7%9C%8B%E8%B5%B7%E4%BE%86%E5%BE%88%E6%B8%85%E7%B4%94%E5%8D%BB%E7%94%A8%E4%B8%8B%E6%B5%81%E7%9A%84%E8%A8%80%E8%BE%AD%E5%91%BB%E5%90%9F%E8%B5%B7%E4%BE%86%E7%9A%84%E9%84%B0%E5%AE%B6%E5%B7%A8%E4%B9%B3%E5%A4%A7%E5%A7%90%E5%A7%90%E6%BF%83%E5%8E%9A%E8%A6%AA%E5%AF%86%E6%81%A9%E6%84%9B%E6%80%A7%E6%84%9B%E7%9A%84%E6%95%85%E4%BA%8B%20%5B%E3%81%B2%E3%81%A4%E3%81%97%E3%82%99%E3%81%AE%E3%81%86%E3%81%A8%E3%82%99%E3%82%93%E5%B1%8B%20(%E3%81%84%E3%81%AA%E3%81%BF%E3%81%BF)%5D%20%E6%B8%85%E6%A5%9A%E3%81%A3%E3%81%BB%E3%82%9A%E3%81%84%E3%81%AE%E3%81%AB%E4%B8%8B%E5%93%81%E3%81%AA%E8%A8%80%E8%91%89%E3%81%A4%E3%82%99%E3%81%8B%E3%81%84%E3%81%A6%E3%82%99%E3%82%AA%E3%83%9B%E5%96%98%E3%81%8D%E3%82%99%E3%81%97%E3%81%A1%E3%82%83%E3%81%86%E8%BF%91%E6%89%80%E3%81%AE%E5%B7%A8%E4%B9%B3%E3%81%8A%E5%A7%89%E3%81%95%E3%82%93%E3%81%A8%E6%BF%83%E5%8E%9A%E3%81%84%E3%81%A1%E3%82%83%E3%83%A9%E3%83%95%E3%82%99%E3%81%88%E3%81%A3%E3%81%A1%E3%81%99%E3%82%8B%E8%A9%B1%20%5B%E4%B8%AD%E5%9C%8B%E7%BF%BB%E8%AD%AF%5D%20%5B%E7%A6%81%E6%BC%AB%E5%8E%BB%E7%A2%BC%5D_EP1_P1.png to file:///private/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/tmp/%E8%88%87%E6%98%8E%E6%98%8E%E7%9C%8B%E8%B5%B7%E4%BE%86%E5%BE%88%E6%B8%85%E7%B4%94%E5%8D%BB%E7%94%A8%E4%B8%8B%E6%B5%81%E7%9A%84%E8%A8%80%E8%BE%AD%E5%91%BB%E5%90%9F%E8%B5%B7%E4%BE%86%E7%9A%84%E9%84%B0%E5%AE%B6%E5%B7%A8%E4%B9%B3%E5%A4%A7%E5%A7%90%E5%A7%90%E6%BF%83%E5%8E%9A%E8%A6%AA%E5%AF%86%E6%81%A9%E6%84%9B%E6%80%A7%E6%84%9B%E7%9A%84%E6%95%85%E4%BA%8B%20%5B%E3%81%B2%E3%81%A4%E3%81%97%E3%82%99%E3%81%AE%E3%81%86%E3%81%A8%E3%82%99%E3%82%93%E5%B1%8B%20(%E3%81%84%E3%81%AA%E3%81%BF%E3%81%BF)%5D%20%E6%B8%85%E6%A5%9A%E3%81%A3%E3%81%BB%E3%82%9A%E3%81%84%E3%81%AE%E3%81%AB%E4%B8%8B%E5%93%81%E3%81%AA%E8%A8%80%E8%91%89%E3%81%A4%E3%82%99%E3%81%8B%E3%81%84%E3%81%A6%E3%82%99%E3%82%AA%E3%83%9B%E5%96%98%E3%81%8D%E3%82%99%E3%81%97%E3%81%A1%E3%82%83%E3%81%86%E8%BF%91%E6%89%80%E3%81%AE%E5%B7%A8%E4%B9%B3%E3%81%8A%E5%A7%89%E3%81%95%E3%82%93%E3%81%A8%E6%BF%83%E5%8E%9A%E3%81%84%E3%81%A1%E3%82%83%E3%83%A9%E3%83%95%E3%82%99%E3%81%88%E3%81%A3%E3%81%A1%E3%81%99%E3%82%8B%E8%A9%B1%20%5B%E4%B8%AD%E5%9C%8B%E7%BF%BB%E8%AD%AF%5D%20%5B%E7%A6%81%E6%BC%AB%E5%8E%BB%E7%A2%BC%5D_EP1_P1.png
2026-05-05 07:41:50 +0000 [SaveFileDialog.swift:161 saveFile(_:result:)] documentPickerExportUrl path=/private/var/mobile/Containers/Data/Application/BB25DC58-B23C-40E7-A7A2-1C76278E5572/tmp/與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png path.utf8=452 path.count=219 fileName=與明明看起來很清純卻用下流的言辭呻吟起來的鄰家巨乳大姐姐濃厚親密恩愛性愛的故事 [ひつじのうどん屋 (いなみみ)] 清楚っぽいのに下品な言葉づかいでオホ喘ぎしちゃう近所の巨乳お姉さんと濃厚いちゃラブえっちする話 [中國翻譯] [禁漫去碼]_EP1_P1.png fileName.utf8=363 fileName.count=130
```

依然什麼都看不出來，只能看出來多走了一個 TMP 轉換，然後 iOS 的問題就可以解決，我服了，完全不知道爲什麼 iOS 的文件無法顯示。

![](https://pub-89c11651a8434f18a530bd6f93e399da.r2.dev/2026/20260505230857427.webp)

沒招了，至少把這個問題修了，最終提了 PR：

https://github.com/haukuen/venera/pull/46

Source via: https://note.bgzo.cc/weekly/20260505-fix-venera-download-long-photos-on-iOS-iPadOS