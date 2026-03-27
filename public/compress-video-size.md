---
draft: False
aliases: ['How to compress video size', 'MP4 無損壓縮']
created: 2025-07-16 20:18:49
modified: 2025-07-16 20:22:28
title: How to compress video size
tags: ['writing/how-to']
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

## References

- [Encode/H.264 – FFmpeg](https://trac.ffmpeg.org/wiki/Encode/H.264)

Source via: https://note.bgzo.cc/weekly/compress-video-size