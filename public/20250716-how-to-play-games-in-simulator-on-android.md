---
title: 如何在安卓模擬器上玩遊戲
aliases: ['How to play game in anndroid', '如何在安卓模擬器上玩遊戲']
created: 2025-07-16 20:04:24
modified: 2026-03-29 09:38:13
comments: True
draft: False
tags: ['android', 'writing/how-to']
description: 上學校的時候沒有自己的電腦，充其量就配一臺手機，所以唯一能承載娛樂的就是一臺安卓機，如今遊戲手機市場不在像十年前那樣繁榮，我記得遊戲強制版號還沒出來的時候，TapTap 還沒有分國際服和國服，上面還是會有一大堆直裝遊戲。我以爲自己撿到了寶，印象非常深刻，比如： 異次元通訊 銀河牛仔 .... 具體還有什麼我已經記不清了，只是後來一切都變了，taptap.io，也就是國際服分出去之後，雖然還能支持支...
---

上學校的時候沒有自己的電腦，充其量就配一臺手機，所以唯一能承載娛樂的就是一臺安卓機，如今遊戲手機市場不在像十年前那樣繁榮，我記得遊戲強制版號還沒出來的時候，TapTap 還沒有分國際服和國服，上面還是會有一大堆直裝遊戲。我以爲自己撿到了寶，印象非常深刻，比如：

- 異次元通訊
- 銀河牛仔
- ....

具體還有什麼我已經記不清了，只是後來一切都變了，taptap.io，也就是國際服分出去之後，雖然還能支持支付寶收款，但屏蔽國區，已經沒有再辦法正常用了。後面我就把賬號註銷了，儘管我已經在上面花錢買了很多遊戲，比如：

- 去月球
- 我在 7 年之後等你
- 帕斯卡契約
- MushDash
- ....

還買了什麼也不記得了，甚至因爲什麼刪號的，我也忘記了。總之，能在安卓手機上玩到更多的遊戲，總不見的是一件壞事。

我是沒想到自己在成爲社畜之後仍然有這個需求，因爲公司市場要加班，就總是需要一些東西打發時間，等待時間打卡下班。所以這個需求只增不減，好慘😭

如果你財力雄厚，可以直接用國內出的雲電腦服務，當然這不是這片文章的重點，就不展開了。

根據你的喜好，能玩的遊戲種類還是比較多的，比如：

- Galgame 模擬器
- Switch 模擬器
- Windows / PC 模擬器
- PSP 模擬器
- GBA 模擬器

## Galgame

這類遊戲我接觸的比較多，因爲性能要求不高，有這方面需求的人也早在十多年前就開始折騰了，解決方案很多，還有非常多安卓直裝包，甚至還有把自家付費程序打包進軟件的廠商。綠絨混雜，請自行臻辯。

總體上來說，根據製作遊戲的引擎不通，需要用的模擬器也不盡然，如：

- KrKr2
	- https://github.com/zeas2/Kirikiroid2
	- https://github.com/2468785842/krkr2
- JoiPlay
	- https://joiplay.cyou
- [Tyranor模擬器正式發佈|個人日記 - 緋月ScarletMoon](https://bbs.kfmax.com/read.php?tid=912800&sf=233)
	- https://wwa.lanzoui.com/i3138upab7i
	- https://www.kungal.com/topic/150
	- https://www.bilibili.com/opus/576235167744858799?jump_opus=1
- [Studio O.G.A.](https://onscripter.osdn.jp/)
	- [onsshare/onscripter: onscripter clootection](https://github.com/onsshare/onscripter)
- [xupefei/Locale-Emulator: Yet Another System Region and Language Simulator](https://github.com/xupefei/Locale-Emulator)

爲了弄懂這些東西，你可能需要懂一些這些遊戲背後的製作引擎，如：

- KiriKiri -> `Krkr2`
- NScripter -> `OneScripts Plus`

更多請參考： https://en.wikipedia.org/wiki/List_of_visual_novel_engines

---

## Switch 模擬器

2023、2024 年本身就要發佈 Switch 2 的，但是考慮到模擬器橫行，任天堂跳票了，在 2024 年大規範起訴模擬器，大部分模擬器被牽連關閉，比如

- Yuzu / https://yuzu-emulator.com
	- 包含其他分支，如 Suyu、Nuzu
- Ryujinx / 龍神 https://github.com/GreemDev/Ryujinx
- Sudachi / https://github.com/emuplace/sudachi.emuplace.app / https://sudachi-emulator.com

當然，還要大量的模擬器出現，2025 年仍然有效的有：

- https://github.com/eden-emulator
- https://github.com/winterwisperer/sudachi / https://sudachiemulator.org
- https://git.citron-emu.org/citron/emulator / https://citron-emu.org / https://github.com/Zephyron-Dev/Citron-CI/tree/main

當然這些全是 Yuzu 的 Fork 版，就是改包換名而已。如果你要玩，下面是一些有用的鏈接 [^switch-link-ref]：

- `prod.keys` 下載
	- https://raw.githubusercontent.com/ZeeWanderer/s/refs/heads/master/prod.keys
	- https://prodkeys.net/version15/
- 固件下載：
	- https://github.com/THZoria/NX_Firmware
	- https://prodkeys.net/yuzu-f
- 驅動下載：
	- AdrenoToolsDrivers https://github.com/K11MCH1/AdrenoToolsDrivers
	- https://suyuemulator.dev/switch-gpu-drivers-download
- 遊戲下載：
	- https://www.gamer520.com

<iframe src="https://www.youtube.com/embed/Php0Idwajtc" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
<center>via: <a href='https://www.youtube.com/watch?v=Php0Idwajtc' target='_blank' class='external-link'>https://www.youtube.com/watch?v=Php0Idwajtc</a></center>

[^switch-link-ref]: https://www.reddit.com/r/EmulationOnAndroid/comments/17d0fmfario_bros_wonder_run_30_fps_stable_on_yuzu/t, https://docs.mesa3d.org/drivers/freedreno.html, https://gitee.com/dreamboyn81/dreaming-space

## PC 模擬器

這個視頻說的很清楚了：

<iframe src='https://player.bilibili.com/player.html?isOutside=true&bvid=BV1QSJfzQEEg&p=1&autoplay=false' style='height:40vh;width:100%' class='iframe-radius' allow='fullscreen'></iframe>
<center>via: <a href='https://www.bilibili.com/video/BV1QSJfzQEEg' target='_blank' class='external-link'>https://www.bilibili.com/video/BV1QSJfzQEEg</a></center>

總之有幾個問題，概括起來就是全部模擬器都不像 SD 那樣集成度高，如果想要模仿 SD，就要走一遍 SD 的路：

1. 內容分發，手機沒有原生的 Steam，所以你只能從電腦倒入到手機；
2. 驅動下載，基本沒有哪個商家願意花時間去做驅動，你只能用五花八門的開源驅動，並且表現都不一樣；
3. 社區支持，大多數玩家的折騰都是在社媒上零零散散地分佈着，很多經驗和資源無法重複利用，存在大量的浪費；

- mobox
- Winlator

## 待解決的問題

- [ ] Switch 模擬器鎖幀

Source via: https://note.bgzo.cc/weekly/20250716-how-to-play-games-in-simulator-on-android