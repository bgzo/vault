---
title: 人生第一臺掌機:Steam Deck
aliases: ['Steam Deck', 'Steam Deck OLED', '人生第一臺掌機:Steam Deck']
created: 2023-06-24 12:00:00
modified: 2026-03-22 21:11:36
comments: True
draft: False
description: None
cover: https://upload.wikimedia.org/wikipedia/commons/5/5d/Steam_Deck_%28front%29.png
cpu: AMD Zen 2 w/ 4-cores/8-threads, variable frequency @ 2.4 – 3.5 GHz
gpu: AMD RDNA 2 w/ 8x CUs, variable frequency @ 1.0 – 1.6 GHz (Up to 1.6 TFLOPS FP32)
price: 4800
ram: 16 GB LPDDR5 @ 5500 MT/s over 4x 32-bit memory channels = 88GB/s total bandwidth
ssd: 512G
tags: ['consume/sailed', 'writing/consume', '3C']
wikipedia: https://en.wikipedia.org/wiki/Steam_Deck
description: via: https://www.steamdeck.com Quick check 維修手冊： https://help.steampowered.com/zh-cn/faqs/view/69E3-14AF-9764-4C28 Windows 驅動： https://help.steampowered.com/zh-cn/faqs/view/6121-ECCD-D643-BAA8 如何修復 St...
---


<iframe src='https://www.steamdeck.com' style='height:40vh;width:100%' class='iframe-radius' allow='fullscreen'></iframe>
<center>via: <a href='https://www.steamdeck.com' target='_blank' class='external-link'>https://www.steamdeck.com</a></center>

```shell
~ > neofetch
              .,,,,.                  deck@steamdeck
        .,'onNMMMMMNNnn',.            --------------
     .'oNMANKMMMMMMMMMMMNNn'.         OS: SteamOS Holo x86_64
   .'ANMMMMMMMXKNNWWWPFFWNNMNn.       Host: Galileo 1
  ;NNMMMMMMMMMMNWW'' ,.., 'WMMM,      Kernel: 6.11.11-valve19-1-neptune-611-g88b36d49a5e3
 ;NMMMMV+##+VNWWW' .+;'':+, 'WMW,     Uptime: 34 days, 22 hours, 8 mins
,VNNWP+######+WW,  +:    :+, +MMM,    Packages: 1125 (pacman), 38 (brew), 16 (flatpak)
'+#############,   +.    ,+' +NMMM    Shell: zsh 5.9
  '*#########*'     '*,,*' .+NMMMM.   Resolution: 3840x2160
     `'*###*'          ,.,;###+WNM,   Terminal: /dev/pts/0
         .,;;,      .;##########+W    CPU: AMD Custom APU 0932 (8) @ 3.501GHz
,',.         ';  ,+##############'    GPU: AMD ATI AMD Custom GPU 0405
 '###+. :,. .,; ,###############'     Memory: 5269MiB / 14809MiB
  '####.. `'' .,###############'
    '#####+++################'
      '*##################*'
         ''*##########*''
              ''''''
```

## Quick check

- 維修手冊： https://help.steampowered.com/zh-cn/faqs/view/69E3-14AF-9764-4C28
- Windows 驅動： https://help.steampowered.com/zh-cn/faqs/view/6121-ECCD-D643-BAA8
- 如何修復 Steam Deck OLED 開機卡 Logo

## 緣起

首先，我對 iPad Pro 2022 感到非常失望，因爲它完全無法編程，無法玩模擬器，只能在 Apple 允許的範圍內玩耍，最後我把它賣掉了。

然後，我又對 Macbook Pro 再次祛魅後，對筆記本的渴望，變成了對輕薄本的渴望。如果還要兼顧一些遊戲需求，這就那就剩掌機了。

後來，迫於自己受不了自己的遊戲本（暗影精靈 5）了，下定決心後買了第二臺電腦—— HP 星Book 14 2024。但是它玩遊戲不太好使，正好，Steam Deck OLED 幾個月前發佈，我開始糾結 SD。

$549 的定價摺合人民幣差不多 3900，加上含稅也只是 4400 左右的樣子，現在的價格水分很高，差不多 4800，在糾結 OLED 和 LED 的差距之後 [^lcd-or-oled]，我還是如手了 OLED 版本，它升級了很多配件，我也把它當作送給自己的一份禮物。

[^lcd-or-oled]:: https://www.youtube.com/watch?v=m7FPXLuOY3A 6:40 ：我知道，我不是 SD 的目標用戶，我在意這幾百美元的差價，我也在意升級換代的時間，這些別人口中不那麼在意的點，並不會真正成爲我的需求，他們是他們，我是我，我在意，所以我不買。

在入手後一個月不久，價格就已經降了近 500 塊，虛高的首發不保值是第一點，再者就是 Steam 去年大刀闊斧地把阿區、土區乾沒了，我買遊戲的東西大大降低。

## 聊聊 SD 的競品

- ROG Ally：首先我對 ROG 這個品牌比較陌生，然後 Ally 這個掌機續航沒有 SD 好，前端打造完全不如 Steam，單單看玩 steam 的遊戲的話，肯定不如 SD [^ally]。而且 Ally 把自己外置 PCIE 的接口留給了自家的顯卡，只保留一個 10 Gbps 的接口，這對我來說是不夠的。

[^ally]: 看了很多視頻，如： [ROG掌機首發評測：愚人節玩笑成真 | 筆吧評測室 - YouTube](https://www.youtube.com/watch?v=IqEAFDyk2gg&t=334s)，[【ROG Ally】真是最強掌機？我勸你想好再買。 - YouTube](https://www.youtube.com/watch?v=jBPkilDNwdc&t=4s)， [我真的需要一臺PC掌機嗎？ROG Ally【值不值得買第610期】 - YouTube](https://www.youtube.com/watch?v=FiiV1HNYDPQ&t=562s)， [ROG掌機性能分析：最強掌機來啦！ - YouTube](https://www.youtube.com/watch?v=y3-4FgTmGIQ&t=498s)，[ROG掌機上手體驗：目前最好用的win掌機?!｜大狸子切切裡 - YouTube](https://www.youtube.com/watch?v=mQK5NSnxIVU&t=105s)，[【問題】Rog ally跟Steam deck怎麼選 @電腦應用綜合討論 哈啦板 - 巴哈姆特 (gamer.com.tw)](https://forum.gamer.com.tw/C.php?bsn=60030&snA=627969)，[在 Steam Deck 和 ROG ALLY 中糾結，有沒有買過的進來說說看法？ - V2EX](https://v2ex.com/t/966485)

- 拯救者：這一位就更搞笑了，尺寸比 Ally 和 SD 更大，而且適配同樣垃圾，連 Ally 都不如，無論你是不是聯想的黑膠黑粉，只要你看過他們家的前端之後，就直接可以勸退了，還是算了 [^lenv]。

[^lenv]: https://www.bilibili.com/video/BV1nh4y1i7pi

- Ayaneo：如果不是接觸掌機這個領域，完全不知道原來有一個深耕多年的國產廠商也在做這方面的工作，當然，它搭載的還是 Windows 問題，依然有上面的問題；加上本來就不是什麼大廠，售後質保不放心；最重要的，它的定價跟 SD 一樣自信，Ayaneo Air 1s，7840U 定價 5k，比 SD 還貴，自然不願意嘗試 [^Ayaneo]；

[^Ayaneo]:: [AYANEO AIR全網首測！第一臺OLED屏幕的Win掌機，價格僅為Steam Deck的20%！ ｜大狸子切切裡 - YouTube](https://www.youtube.com/watch?v=URzZdf4-Q4s)

當然還有非常多其他競品，我這裏沒有列，引用一段別人的總結，深以爲然：

> 這幾天研究了一下迷你筆電，做個總結，大致可以分爲如下幾類：
>
> ① 6 英寸級。此類產品尺寸和 switch 相當，某寶帶關鍵詞 switch 搜索即可找到與之搭配的單肩包。此類產品打字的方式與手機類似，用兩大拇指打字。代表產品有 GPD miropc，GPD win mini（7 英寸），GPD win 4。其中，前者爲 intel 系，定位運維工程師，接口豐富，包含全尺寸 hdmi、usb-a 和網口；後兩者爲 AMD 系，定位遊戲掌機，只有 type-c 接口。
>
> ②8 英寸級。此類產品尺寸和 ipad mini 相當，某寶帶關鍵詞 ipad mini 搜索即可找到與之搭配的單肩包。既然蘋果這樣的世界大廠將最小的平板定位在 8 英寸，肯定是有道理的，該尺寸在不失便攜性的基礎上獲得了一個還過得去的視野；另外，該尺寸的鍵盤可以雙手十指打字，效率得到提高。代表產品有 GPD pocket 3、壹號本 A1 pro（7 英寸）、壹號本 OneXPlayer 2 pro 等，其中，GPD pocket 3 同樣定位運維工程師，接口豐富，全尺寸 hdmi、usb-a 和網口，且支持手寫筆。
>
> ③10 英寸級。此類產品尺寸和 surface go 相當，某寶帶關鍵詞 surface go 搜索即可找到與之搭配揹包。來到這個尺寸基本上就和單肩包無緣了，出門還是得背雙肩包，雖然視野得到提高，但便攜性大打折扣。代表產品有壹號本 4 代、5 代、GPD win max 2 等，其中後兩者較重，重量爲 1kg 級，而前兩者接口較少。
>
> https://www.coolapk.com/feed/49916198?shareKey=ZmE0MjMwYWVlNjA5NjViZDllZjU~

## 聊聊 SD 內存拓展

因爲我資金有限，所以買的是丐版，想要更大的存儲，就兩條路：

1. TF 卡
2. 自己換硬盤

雖然都能爲 SD 提供更多存儲空間，但兩者都不完美，而且都有個共性，

### TF 拓展卡

首先看看拓展卡，市面上比較常見的三星 藍卡 / 白卡 存在掉速的問題，如：

> 我一張剛買了不到三個月的三星 512 白卡也也從 80+ 的寫入速度掉到 30 了 今天研究了半天說是標準格式化可以拯救，我打算試試看，從進度條來看，可能格一張卡需要 5 小時 之前用過好幾年的閃迪 extreme pro 的卡和三星紅卡，都沒遇到過這種情況
> https://www.bilibili.com/video/BV1MS4y1F7Ba

這是 TF 卡的通病，你不知道這塊硬盤什麼時候會壞。所以唯一的建議就是不要頻繁的寫入。

TF 卡不是一點有點沒有，它靈活，對你的機器侵害小，支持熱插拔，這意味什麼呢？假設你有 2 塊 TF 卡，並且你是一個擁有非常多遊戲庫存的人，然後，你想對這些遊戲做分類，這段時間我想玩 A 類的遊戲，你就插第一張卡，然後某一段時間你想玩 B 類型的遊戲，那麼你就插入第二張卡，切換很快，讀卡很快。簡直就像 Switch。

選購意見可以參考：

- [2024年SD存儲卡/內存卡/TF卡選購攻略，教你輕鬆避坑選對存儲卡 - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/339102415)
- [關於 TF 卡的價格 - V2EX](https://v2ex.com/t/906655)
- [近期買卡哪個性價比最高？幾款熱門TF卡與SD卡速度實測與建議_存儲卡_什麼值得買 (smzdm.com)](https://post.smzdm.com/p/aev73qgk/#:~:text=%E5%AE%9E%E9%99%85%E6%B5%8B%E4%B8%89%E6%98%9F512G%E7%99%BD,%E5%8D%A1%E7%9A%84%E6%A0%87%E7%A7%B0%E9%80%9F%E5%BA%A6%E3%80%82)
- [U 盤是有使用壽命的，但我好像從來沒有用壞過。大家誰的 U 盤用壞過？用了多久壞的？ - V2EX](https://www.v2ex.com/t/348867)
- [求推薦穩點的硬盤，兩塊希捷酷魚 4T 同時掛了 - V2EX](https://www.v2ex.com/t/830555

### 換固態

這算是最多人的選擇，但是選擇仍然有坑，比如市面上最便宜的 SN740 雖然非常便宜，但其實都是 OEM 產品 [^oem-ssd]，實際使用壽命可能遠遠不如零售的 SN770M。

> OEM，渠道不同價格也不同，是不是翻新沒法識別的，不過這東西主要看店鋪是不是老店，給的店保多不多，一般給 3 年或者以上的基本可以放心購買，說是全新但是就給 1 年的就要看價格了，特別便宜有性價比的也不是不可以買，啥按月算的就別去買了
> ——[\[硬件求助\]爲什麼sn740價格差這麼多？ NGA玩家社區 (ngabbs.com)](https://ngabbs.com/read.php?tid=35687004&rand=494)

[^oem-ssd]: ~什麼是OEM產品-OME固態硬盤爲什麼這麼便宜-OEM固態硬盤有什麼優劣勢 https://www.bilibili.com/opus/244863730592811564, https://www.bilibili.com/video/BV12N4y1S7AK

## 個人使用心得

> [!NOTE]
> 所有需要你解除 Read-only 模式的操作都需要謹慎，因爲下次更新系統一切都會恢復原樣。

### 科學上網

見 如何在 Steam Deck 上開啓一個默認代理

### 傳輸遊戲 / 打補丁

見 在 Steam Deck 上開啓用戶級別的 SMB

另一個路子是 Windows 的收費驅動 Paragon linuxfs，不推薦，因爲實際體驗實際體驗不好，並且拷貝大量小文件的時候容易丟數據 （20240810 > paragon linuxfs for steam-deck）；

參考 https://www.reddit.com/r/visualnovels/comments/ujpjiz/installing_patches_on_steam_deck

### 定製化/美化 Steam Deck

見 decky-loader https://github.com/SteamDeckHomebrew/decky-loader

### 存檔覆蓋

保證自己的網絡沒有問題。

第一次下載遊戲玩的時候，沒有開代理，steam 雲同步錯誤之後就不要開啓遊戲，否則就會像我一樣，把好不容易打死亡細胞的存檔給丟了；

並且，steam 雲存檔裏面沒有歷史備份，全靠廠商兜底！

### 指示燈的含義不同

橙色說明充電攻略不夠，白色纔是快速充電，這一點很反直覺，via: https://www.reddit.com/r/SteamDeck/comments/183xcex/steam_deck_oled_charging_led_light_is_different

### 掛機下載遊戲

deck 模式下需要熄屏就需要進入桌面模式，關掉 steam，掛後臺，這樣纔是真正的熄屏，注意不能顯示 steam 應用，因爲電源管理那裏會顯示，steam 組織休眠，這裏也有一個 bug，就是等到改熄屏的時候，如果還顯示 steam 頁面，那麼顯示器就會變成最大亮度，一度以爲買到壞的了。實際上並非如此；

https://steamcommunity.com/app/1675200/discussions/0/3757725715243231540/

### 導出 Steam 的剪輯

默認 SteamDeck 的錄製是專有格式，需要自行去設置頁面導出才能在 Videos 頁面找到，並且耗時一般都比較舊；

https://www.reddit.com/r/SteamDeck/comments/1hnmeyj/where_do_i_find_the_recorded_videos_on_desktop/?tl=zh-hans

## 待解決的問題

- [ ] 中文輸入法：還沒有思路，SD 的輸入法完全依賴 Steam，如果 steam 不啓動，鍵盤是無法呼出的，折騰第三方鍵盤可以參考： https://www.bilibili.com/video/BV1MY411y7Aw
- [ ] Windows 藍牙驅動：我在切換 Windows 系統之後，藍牙無論如何都無法啓動，不知道爲什；
- [ ] Spotify cannot uses proxy
    - https://github.com/flathub/com.spotify.Client/issues/87
    - https://www.headphonesty.com/2023/12/firewall-blocking-spotify/
    - https://forums.linuxmint.com/viewtopic.php?t=401420

## 後話：爲什麼賣掉，以及下一代

首先，賣掉這個想法早就有了，我在 放棄正版執念，擁抱盜版遊戲 裏面說的比較清楚，我就不贅述了，總之，SD 對我而言留下來肯定是喫灰產品，已經懶得再折騰手上這幾臺機器了。

然後，第二個問題，下一代還會不會買，我們來看看 SD 發佈的時候 Value 怎麼說：

> **Our best estimate on the Steam Deck 2 release date is 2025, as Valve designer Lawrence Yang recently said “a true next-gen Deck with a significant bump in horsepower wouldn’t be for a few years.” That said, we may see a refresh of the original Steam Deck featuring improved battery life and a better display in the interim.**
> — [Steam Deck 2 release date speculation | PCGamesN](https://www.pcgamesn.com/steam-deck/2-release-date-price-specs-performance)

我更新這篇文章的時候，已經是 2025 年末了，雖然發佈了 Steam Mechine，但是它的顯存只有 8G，夠不夠用完全是另一碼事，但這可是主機呀，會不會給的太少了？

我可以確認的是：

1. SM 可能會是一代失敗的產品，我不看好他，尤其是全球硬件成本飆升的 2026 年；
2. SD2 不會是一個堆料的機器，而應該是一個差不多剛剛好的甜點區間；
3. SD2 也不會在 2026 年發佈，甚至是未來 1～2 年，SDO 還會統治這個市場一段時間；

然後，未來我應該還會再次入手 SD，幾點原因：

1. 左右兩塊靈魂般的觸控板，這樣體驗讓 SD 即使在 Windows 也比其他掌機體驗要強，別的 OEM 廠商給不了，也不會給；
2. 入手的時機，我是在發佈 3 個月後入手，那時國內剛剛開始賣 OLED 的機器，價格就比較高，下一次，我可能會發布半年、一年之後，價格迴歸正常區間再說
3. 下一次，我希望自己可以加裝一個 1/2T 的硬盤，然後 2/3 留給 windows 下載盜版遊戲（插電），1/3 留給 SteamOS 玩獨立遊戲（離電），然後用 TF 卡，給自己的 SteamOS 續命；

## 參考

- [【心得】在Linux玩遊戲24天的一點心得 @Steam 綜合討論板 哈啦板 - 巴哈姆特](https://forum.gamer.com.tw/C.php?bsn=60599&snA=34679)
- [【愛折騰】SteamDeck完全折騰指南-C2-系統修復 - 嗶哩嗶哩](https://www.bilibili.com/read/cv20955230/)
- [關於使用Steam Deck（SteamOS）遊玩Galgame（或其他第三方遊戲）的一些心得——踩坑篇 - 嗶哩嗶哩](https://www.bilibili.com/read/cv19258395/)
- [【密技】在 Steam Deck 上玩黃油 @Steam 綜合討論板 哈啦板 - 巴哈姆特](https://forum.gamer.com.tw/C.php?bsn=60599&snA=39878)
- [steam deck科普、上手教程及模擬器配置指南_steamdeck如何添加遊戲-CSDN博客](https://blog.csdn.net/cjs1534717040/article/details/128125940)
- [steamdeck  使用體驗/奇怪的教程 – 復讀機的記事本](https://www.cx03.space/2022/08/21/steamdeck-kde%E4%B8%8D%E8%B4%9F%E8%B4%A3%E4%BB%BB%E6%95%99%E7%A8%8B/)
- [Desktop Mode primer on Steam Deck, and why you SHOULDN'T turn off read-only filesystem - YouTube](https://www.youtube.com/watch?v=fb_365AOESc))

Source via: https://note.bgzo.cc/weekly/20230624-steam-deck