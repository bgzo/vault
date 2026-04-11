---
title: How to compress photo size
aliases: ['How to compress photo size']
created: 2024-06-26 14:22:35
modified: 2026-04-12 02:13:05
published: 2024-06-26 14:22:35
tags: ['photo', 'public', 'writing/how-to']
draft: False
type: how-to
description: Most tidy -> webp via https//developers.google.com/speed/webp Download via https//developers.google.com/speed/webp/docs/precompiled JEPG -> jpegoptim Convert image to JPEG using https//imagemagick.org...
---

## Most tidy -> `webp`

<iframe src='https://developers.google.com/speed/webp' style='height:40vh;width:100%' class='iframe-radius' allow='fullscreen'></iframe>
<center>via: <a href='https://developers.google.com/speed/webp' target='_blank' class='external-link'>https://developers.google.com/speed/webp</a></center>

Download via: https://developers.google.com/speed/webp/docs/precompiled

```shell
$ sudo apt install webp
$ cwebp -q 50 -lossless picture.png -o picture_lossless.webp
$ cwebp -q 70 picture_with_alpha.png -o picture_with_alpha.webp
$ cwebp -sns 70 -f 50 -size 60000 picture.png -o picture.webp
$ cwebp -o picture.webp picture.png
```

## JEPG -> jpegoptim

```shell
jpegoptim --size=1024k xxx.jpg
```

- Convert image to JPEG using https://imagemagick.org
- Convert image to JPEG using https://github.com/mozilla/mozjpeg

## PNG

- lossy compress with https://pngquant.org

```shell
pngquant image_1653621462242_0.png
pngquant --quality=60-80 image_1653621462242_0.png
pngquant --force --ext .png 202508021025451.png
pngquant --force --ext .png *.png
pngquant --force --ext .png --quality=60-80 202503161837403.png
```

### Optipng

<iframe src='https://optipng.sourceforge.net/' style='height:40vh;width:100%' class='iframe-radius' allow='fullscreen'></iframe>
<center>via: <a href='https://optipng.sourceforge.net/' target='_blank' class='external-link'>https://optipng.sourceforge.net/</a></center>

a PNG optimizer that recompresses image files to a smaller size, without losing any information. This program also converts external formats (BMP, GIF, PNM and TIFF) to optimized PNG, and performs PNG integrity checks and corrections."

用 optipng 壓縮過的圖片合成 == 未用 optipng 壓縮過的圖片合成（對比兩個文件的哈希值都一樣）

```shell
optipng -o3 image.png -out output.png
```

Source via: https://note.bgzo.cc/weekly/20240626-compress-photo-size