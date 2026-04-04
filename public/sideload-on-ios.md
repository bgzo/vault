---
published: 2025-06-02 11:50:24
aliases: ['側載', '測載', '巨魔', 'How to sideload on iOS', 'Make it like Android Sideload', 'Sideload-on-ios']
created: 2025-06-02 11:50:24
modified: 2026-01-02 23:41:18
tags: ['writing/how-to', 'public']
draft: False
title: Sideload-on-ios
type: how-to
description: Troll Store How it works? The latest releases of TrollStore (specifically 2.0 and later) work through the use of a CoreTrust bug in which code signatures are not correctly verified under certain circu...
---

## Troll Store

### How it works?

> The latest releases of TrollStore (specifically 2.0 and later) work through the use of a CoreTrust bug in which code signatures are not correctly verified under certain circumstances.
> https://ios.cfw.guide/installing-trollstore/

### Check version

| From             | To          | arm64 (A8 – A11)                                                                                | arm64e (A12 – A17 / M1 – M2)                                                                |
| ---------------- | ----------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| 13.7 and earlier |             | Unsupported                                                                                     |                                                                                             |
| 14.0             | 14.8.1      | [Installing TrollStore (TrollHelper)](https://trollstore.app/installing-trollhelper/)           | [Installing TrollStore (TrollHelperOTA)](https://trollstore.app/installing-trollhelperota/) |
| 15.0             | 15.5 beta 4 | [Installing TrollStore (TrollHelperOTA)](https://trollstore.app/installing-trollhelperota/)     |                                                                                             |
| 15.5             | 15.5        | [Installing TrollStore (TrollInstallerMDC)](https://trollstore.app/installing-trollhelper-mdc/) | [Installing TrollStore (TrollHelperOTA)](https://trollstore.app/installing-trollhelperota/) |
| 15.6 beta 1      | 15.6 beta 4 | [Installing TrollStore (TrollHelperOTA)](https://trollstore.app/installing-trollhelperota/)     |                                                                                             |
| 15.6             | 15.6.1      | [Installing TrollStore (TrollInstallerMDC)](https://trollstore.app/installing-trollhelper-mdc/) | [Installing TrollStore (TrollHelperOTA)](https://trollstore.app/installing-trollhelperota/) |
| 15.7             | 15.7.1      | [Installing TrollStore (TrollInstallerMDC)](https://trollstore.app/installing-trollhelper-mdc/) |                                                                                             |
| 15.7.2           | 15.7.6      | [Installing TrollStore (TrollHelper)](https://trollstore.app/installing-trollhelper/)           | **Coming Soon**                                                                             |
| 15.7.7           | 15.8        | [Installing TrollStore (TrollHelper)](https://trollstore.app/installing-trollhelper/)           | **Not Applicable**                                                                          |
| 16.0             | 16.1.2      | [Installing TrollStore (TrollInstallerMDC)](https://trollstore.app/installing-trollhelper-mdc/) |                                                                                             |
| 16.2             | 16.5        | [Installing TrollStore (TrollHelper)](https://trollstore.app/installing-trollhelper/)           | [Installing TrollStore (Misaka)](https://trollstore.app/installing-trollhelper-misaka/)     |
| 16.5.1           | 16.5.1      | [Installing TrollStore (TrollHelper)](https://trollstore.app/installing-trollhelper/)           | No Installation Method                                                                      |
| 16.6 beta 1      | 16.6 beta 1 | [Installing TrollStore (TrollHelper)](https://trollstore.app/installing-trollhelper/)           | [Installing TrollStore (Misaka)](https://trollstore.app/installing-trollhelper-misaka/)     |
| 16.6 beta 2      | 16.6.1      | [Installing TrollStore (TrollHelper)](https://trollstore.app/installing-trollhelper/)           | No Installation Method                                                                      |
| 16.7             | 16.7.2      | Unsupported                                                                                     |                                                                                             |
| 17.0             | 17.0        | [Installing TrollStore (TrollHelper)](https://trollstore.app/installing-trollhelper/)           | No Installation Method                                                                      |
| 17.0.1 and later |             | Unsupported                                                                                     |                                                                                             |

<center>via: https://trollstore.app/</center>

![](https://x.com/alfiecg_dev/status/1801329232104071665)

- 中文安裝指南 via https://github.com/XLsn0w/TrollStore2

## Official SideStore

1. 先用 AltServer 側載 AltStore
2. 用 AltStore 側載 SideStore
3. 用 Jitterbug 得到配對文件 `xxx.mobiledevicepairing`
4. 將配對文件 `xxx.mobiledevicepairing` 載入 SideStore
5. 安裝 StosVPN https://apps.apple.com/us/app/stosvpn/id6744003051

1. 或者 WireGuard VPN (需要額外配置文件)
6. 打開 VPN，然後重新側載 SideStore

<iframe src='https://faq.altstore.io/altstore-classic/how-to-install-altstore-macos' style='height:40vh;width:100%' class='iframe-radius' allow='fullscreen'></iframe>
<center>via: <a href='https://faq.altstore.io/altstore-classic/how-to-install-altstore-macos' target='_blank' class='external-link'>https://faq.altstore.io/altstore-classic/how-to-install-altstore-macos</a></center>

<iframe width="560" height="315" src="https://www.youtube.com/embed/yLuyVakPpUM?si=na-qbcpp3Xi09SPw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
<center>via: <a href='https://www.youtube.com/clip/UgkxROxdCFzoG49W51lxAPaNZO6gV6nUIeev' target='_blank' class='external-link'>https://www.youtube.com/clip/UgkxROxdCFzoG49W51lxAPaNZO6gV6nUIeev</a></center>

<iframe src="https://www.youtube.com/embed/Mt4cwFyPsoM" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
<center>via: <a href='https://www.youtube.com/watch?v=Mt4cwFyPsoM' target='_blank' class='external-link'>https://www.youtube.com/watch?v=Mt4cwFyPsoM</a></center>

### Q&A

> Q: Develop mode is hidden by default
> A: [I cant find dev mode : r/ios --- 我找不到開發模式：r/ios](https://www.reddit.com/r/ios/comments/14v97pv/i_cant_find_dev_mode/)

> Q: Jitterbug commandline have no ARM version.
> A: use `.dmg` and install it.

> Q: AFC unable to manage files
> ![](https://raw.githack.com/bGZo/assets/dev/2025/1745357262178.PNG)
> A: 可能是沒有開啓 VPN ，重試就解決了。
> via: https://github.com/SideStore/SideStore/issues/156

> Q: 啓動調試服務器失敗。請確保 DeveloperDiskImage.dmg 已掛載。
> Mount Developer Image (DMG) onto iOS device without computer
>
> A DDI is a dmg drive which gets mounted on your device in /Developer whenever you use Xcode. It contains some additional binaries which can assist you with development. For the device to "trust" those external binaries the device writes some hashes in something called a "trustcache" which is part of the kernel.
> https://www.reddit.com/r/jailbreak/comments/8ynygq/question_what_is_a_developer_disk_image/
>
> 簡單來說，連接 Xcode，然後再啓用 JIT 就行了

> Q: The device has reached the maximux number of installed apps using a developer profile
> ![](https://raw.githack.com/bGZo/assets/dev/2025/1745360291647.PNG)
> A: 最多支持 3 個 APP 激活，10 個 APP IDs

### Community: Replace Android

> [!warning]
> 因爲第三方商店來自社區，所以沒有人知道應用是否安全。
>
> 請自行甄別！

> [!note]
> Android 收費的軟件可能會重新在 App Store 上買；真是麻了

- 去廣告軟件
    - Revanced Youtube: https://www.reddit.com/r/sideloaded/comments/12dfaa9
    - c001apk：酷安

- 遊戲模擬器
    - ONScripter Plus: https://apptopia.com/ios/app/1459512942/about
    - [ ] 吉里吉里 2
    - [ ] YUZU
    - [ ] JoiPlay
    - [ ] Citra
    - [ ] Dolphin Emulator
    - [ ] ViTA

- 追番看漫畫
    - Aidoku
    - ~open-ani-animeko
    - Kazumi：動漫
        - Need resign [^runing-with-live-container]
        - ![200](https://raw.githack.com/bGZo/assets/dev/2025/1745360745622.PNG)
    - mangayomi：漫畫
    - ~Mihon-(Tachiyomi)-使用教學-手機免費看漫畫的開源APP-附常用漫畫源
    - mihon 不支持 iOS，且沒有計劃支持
        - https://github.com/mihonapp/mihon/issues/1041

- 通話錄音：TrollRecorder
- USB 攝像頭
- VPN 熱點
- NFC 門禁卡模擬
- 虛擬機: UTM
- 圖牀: flutter-picgo
- 全面屏手勢: Mugunghwa
- [ ] 簡樸

### Wishlist

- [蘋果ios系統有哪些免費好用的閱讀app？ - 知乎](https://www.zhihu.com/question/265181314)
- [Reddit - Dive into anything](https://www.reddit.com/r/EmulationOnAndroid/comments/1f8mr51/which_is_better_citra_or_dolphin/)
- [實用工具 | J.F's BLOG](https://blog.zzbd.org/about/sam/)
- [IPA-for-self/index.js at main · WangGuibin/IPA-for-self](https://github.com/WangGuibin/IPA-for-self/blob/main/index.js)
- [TrollStore巨魔商店1永久安裝APP，永不過期 – 玄燁品果](https://dkxuanye.cn/?p=5149)

## References

- ~SideStore-安裝指南-如何在-iOSiPadOS-設備上側載應用
- ~巨魔玩家轉戰越獄的經歷-來自-香菜真難喫Y
- [How to sideload application on iOS, iPadOS : r/sideloaded](https://www.reddit.com/r/sideloaded/comments/1ak3x9t/how_to_sideload_application_on_ios_ipados/)
- [Free Sideloading - Google Docs](https://docs.google.com/document/d/1QseJR-ZTGJO0q99l9eh1-wsR-tldtbsM6rbsti08EDQ/edit?pli=1&tab=t.0)
- [Free Sideloading! [Any iOS!] [No Computer!] [No App Limit!] [No Revokes!] [No 7 day Resigning!] [Add Repos for quick install!] : u/PuReEnVyUs](https://www.reddit.com/user/PuReEnVyUs/comments/1cvgqi0/free_sideloading_any_ios_no_computer_no_app_limit/?share_id=oK4ALfJoN3atNuWd2X0Ef)
- [Free Sideloading Guide for iPhone Users [Any IOS] : r/Piracy](https://www.reddit.com/u/PuReEnVyUs/s/Qr8HO7KVcN)
- [開源 ios 軟件分享，自籤/巨魔使用](https://www.v2ex.com/t/1085401#reply0)
- [iOS 越獄後插件推薦 | 始終](https://liam.page/2023/01/19/Tweaks-that-I-ve-installed-on-my-iPhone/)
- 利用 DNS 證書測載 https://docs.google.com/document/d/1QseJR-ZTGJO0q99l9eh1-wsR-tldtbsM6rbsti08EDQ/mobilebasic

[^runing-with-live-container]: https://github.com/Predidit/Kazumi/issues/819, 一個更簡單的方法是用 https://github.com/LiveContainer/LiveContainer 直接運行無簽名的 IPA 文件，並且不額外佔用 App IDs 和 3 個激活 App 的名額。

Source via: https://note.bgzo.cc/weekly/sideload-on-ios