---
title: 如何在 Steam Deck 上開啓一個默認代理
aliases: ['如何在 Steam Deck 上開啓一個默認代理']
created: 2025-12-08 22:28:59
modified: 2026-04-11 18:50:21
published: 2025-12-08 22:28:59
tags: ['public', 'writing/how-to']
draft: False
description: 因爲種種原因，你需要一個隨時都能訪問遊戲社區的網絡環境，這樣才能查攻略，下載創意工坊，但是這裏是 Steam Deck，你不能總是開手機熱點做這個事情。 借鑑 在 Steam Deck 上開啓用戶級別的 SMB 的思路，你可以在 Linux 上開啓用戶級別的自啓動進程，創建配置 /home/deck/.config/systemd/user/clash.service 如下： 然後設置開啓啓動： ...
---

因爲種種原因，你需要一個隨時都能訪問遊戲社區的網絡環境，這樣才能查攻略，下載創意工坊，但是這裏是 Steam Deck，你不能總是開手機熱點做這個事情。

借鑑 在 Steam Deck 上開啓用戶級別的 SMB 的思路，你可以在 Linux 上開啓用戶級別的自啓動進程，創建配置 `/home/deck/.config/systemd/user/clash.service` 如下：

```shell
[Unit]
Description=You know.
After=network.target

[Service]
Type=simple
Restart=on-failure
ExecStart=/home/deck/proxy/clash-linux-amd64 -d /home/deck/proxy/

[Install]
WantedBy=default.target
```


然後設置開啓啓動：

```shell
systemctl --user daemon-reload
systemctl --user enable clash
systemctl --user status clash
```

然後在 Steam Deck 上的網絡設置裏面設置永久的代理地址，即可。

## 參考

https://github.com/Sitoi/SystemdClash

Source via: https://note.bgzo.cc/weekly/20251208-enable-user-proxy-on-steam-deck