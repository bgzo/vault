---
title: How to compress video size
aliases: ['How to compress video size', 'MP4 無損壓縮']
created: 2025-07-16 20:18:49
modified: 2026-04-11 18:50:21
published: 2025-07-16 20:18:49
tags: ['public', 'writing/how-to']
draft: False
description: -crf option scale 0 – 51 (0 is lossless, 23 is the default, and 51 is worst quality possible) Consider 17 or 18 to be visually lossless or nearly so; it should look the same or nearly the same as the ...
---

```shell
ffmpeg -i $in -c:v libx264 -c:a libfaac -crf 20 -preset:v veryslow $out
```


- `-crf` option
	- scale: 0 – 51 (0 is lossless, 23 is the default, and 51 is worst quality possible)
	- Consider 17 or 18 to be visually lossless or nearly so; it should look the same or nearly the same as the input but it isn't technically lossless
	- The range is exponential, so increasing the CRF value +6 results in roughly half the bitrate / file size, while -6 leads to roughly twice the bitrate.
	- via: [shell - FFMPEG convert .mpg video to .mp4 without lose quality - Stack Overflow](https://stackoverflow.com/questions/33672960/ffmpeg-convert-mpg-video-to-mp4-without-lose-quality)

自己試了下 0, 無損壓縮, 文件大小從 30M -> 300M

300M 這個結果有合理預期。
4. **實驗結論**：建議補充一句總結，例如"因此無損壓縮並不適合以縮小體積爲目標的場景"，或者改爲展示推薦參數下更合理的壓縮結果。

這段內容對讀者理解影響很大，建議優先重寫。
-->

## References

- [Encode/H.264 – FFmpeg](https://trac.ffmpeg.org/wiki/Encode/H.264)

## 整體總結

**主要優點：**
- 提供了一個立即可用的 `ffmpeg` 命令，適合快速上手。
- `CRF` 參數說明詳細，並給出了可信來源，體現出調研基礎。
- 文章簡潔，不被不必要的細節拖慢節奏。

**最需要注意的 2-3 個模式或侷限：**
1. **實驗數據的有效性問題**：30M 到 300M 的結果與文章主題相反，說明實驗呈現方式存在嚴重誤導風險，需要澄清或重做。
2. **參數解釋不足**：雖然說明了 `-crf`，但 `libx264`、`libfaac`、`preset:v veryslow` 等參數缺少簡潔解釋，新手難以直接遷移使用。
3. **使用指南不完整**：缺少對變量 `$in`、`$out` 的說明，以及對 veryslow 轉碼耗時成本的提醒。

**整體建議：**
這篇文章目前不適合直接發佈。建議先重測並解釋 30M 到 300M 的原因，或改用更符合"壓縮"目標的參數做對照；然後補充參數用途、適用場景和耗時提示。修正後，這篇文章會更像一篇可執行的經驗總結，而不是一條未經解釋的命令摘錄。

Source via: https://note.bgzo.cc/weekly/20250716-compress-video-size