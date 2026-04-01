---
comments: True
draft: False
aliases: ['在 Steam Deck 上開啓用戶級別的 SMB']
created: 2025-09-16 21:21:32
modified: 2025-12-08 22:17:15
tags: ['writing/how-to']
title: 在 Steam Deck 上開啓用戶級別的 SMB
description: 重要性不言而喻，遠程打個補丁，從 SD 上下載點文件都非常有用，導出一些遊戲也比較實用。 傳統上，SMB 必須使用 Sudo 開啓，但是 SteamOS 這種不可變系統有個毛病就是，每次更新完系統，之前所有的東西全部重裝，包括你的 SMB，而跳過系統更新對於 SD 來說更是不可能，這點簡直是跟 MC 學的，笑死。 所以一個合理的方案就是一用戶級別的權限開啓 SMB，這需要走一些彎路。 前置要求：H...
---

重要性不言而喻，遠程打個補丁，從 SD 上下載點文件都非常有用，導出一些遊戲也比較實用。

傳統上，SMB 必須使用 Sudo 開啓，但是 SteamOS 這種不可變系統有個毛病就是，每次更新完系統，之前所有的東西全部重裝，包括你的 SMB，而跳過系統更新對於 SD 來說更是不可能，這點簡直是跟 MC 學的，笑死。

所以一個合理的方案就是一用戶級別的權限開啓 SMB，這需要走一些彎路。

## 前置要求：HomeBrew

相比於 ArchLinux 自帶的 Pacman 管理器，HB 完全安裝在本地用戶目錄，不會被 SD 的系統更新整掛掉，所以比較方便，我們需要藉助 HB 安裝 SMB，安裝時間比較久，運行：

```shell
brew install samba
smbd -v
where smbd
```

## 保存配置文件

```shell
cat /home/deck/env/linux/samba/deck.conf
#
#
#
#
#

#======================= Global Settings =======================

[global]
   # 將運行所需目錄放到用戶目錄
   pid directory = /home/deck/.local/var/samba/run
   lock directory = /home/deck/.local/var/samba/lock
   state directory = /home/deck/.local/var/samba/state
   cache directory = /home/deck/.local/var/samba/cache
   private dir = /home/deck/.local/var/samba/private

   # 日誌放到用戶目錄
   log file = /home/deck/.local/var/log/samba/log.%m
   logging = file
   max log size = 1000

   server role = standalone server
   map to guest = bad user

   # 關閉打印相關，避免依賴系統路徑和權限
   load printers = no
   printing = bsd
   printcap name = /dev/null
   disable spoolss = yes

   # 端口
   smb ports = 1445

[deck]
    path = /home/deck
    browseable = yes
    writable = yes
    read only = no
    guest ok = no
    valid users = deck
    create mask = 0660
    directory mask = 0770

[sd]
    path = /run/media/deck/deck/
    browseable = yes
    writable = yes
    read only = no
    guest ok = no
    valid users = deck
    create mask = 0660
    directory mask = 0770
```

> [!NOTE]
> 配置文件裏有個坑，就是端口不能是一般的 SMB 端口，如 445，所以我在上面配置中改成了 1445，可能是權限保留問題，總之，如果是 445 端口，總是連接超時。

## 開啓自啓動

就像前面說的，開啓自啓動的文件最好還是放在用戶目錄，目錄在 `/home/deck/.config/systemd/user`，編輯文件：

```shell
[Unit]
Description=User-level SMB Service for Deck
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/home/linuxbrew/.linuxbrew/sbin/smbd -i -d 3 -s /home/deck/env/linux/samba/deck.conf
Restart=on-failure
RestartSec=5

[Install]
WantedBy=default.target
```

保存，重載並啓動配置文件：

```shell
systemctl --user daemon-reload
systemctl --user enable --now deck-smb.service
```

接下來應該就可以放心使用了，一勞永逸。Mac 連接服務器：

```shell
smb://192.168.31.29:1445/deck
```

## 配置中踩的一些坑

第一次啓動報錯啓動太快，無法開啓用戶級別的 SMB：

```shell
~/.config/systemd/user > systemctl --user status smb.service
× smb.service - User-level SMB Service for Deck
     Loaded: loaded (/home/deck/.config/systemd/user/smb.service; enabled; preset: enabled)
     Active: failed (Result: exit-code) since Mon 2025-09-15 00:21:48 +08; 19s ago
   Duration: 72ms
 Invocation: 6b48f8fc4ef041bba66f33868b3b21bd
   Main PID: 33601 (code=exited, status=1/FAILURE)

Sep 15 00:21:48 steamdeck systemd[1655]: smb.service: Scheduled restart job, restart counter is at 5.
Sep 15 00:21:48 steamdeck systemd[1655]: smb.service: Start request repeated too quickly.
Sep 15 00:21:48 steamdeck systemd[1655]: smb.service: Failed with result 'exit-code'.
Sep 15 00:21:48 steamdeck systemd[1655]: Failed to start User-level SMB Service for Deck.
Sep 15 00:21:55 steamdeck systemd[1655]: smb.service: Start request repeated too quickly.
Sep 15 00:21:55 steamdeck systemd[1655]: smb.service: Failed with result 'exit-code'.
Sep 15 00:21:55 steamdeck systemd[1655]: Failed to start User-level SMB Service for Deck.
```

當時在前臺運行沒有問題，一旦用 systemctl 就報錯，查看日誌發現：

```shell
journalctl --user -u smb.service -e --no-pager
Sep 16 00:05:27 steamdeck systemd[1655]: Started User-level SMB Service for Deck.
Sep 16 00:05:27 steamdeck systemd[1655]: smb.service: Main process exited, code=exited, status=1/FAILURE
Sep 16 00:05:27 steamdeck systemd[1655]: smb.service: Failed with result 'exit-code'.
Sep 16 00:05:27 steamdeck systemd[1655]: smb.service: Scheduled restart job, restart counter is at 1.
Sep 16 00:05:27 steamdeck systemd[1655]: Started User-level SMB Service for Deck.
Sep 16 00:05:27 steamdeck systemd[1655]: smb.service: Main process exited, code=exited, status=1/FAILURE
Sep 16 00:05:27 steamdeck systemd[1655]: smb.service: Failed with result 'exit-code'.
Sep 16 00:05:27 steamdeck systemd[1655]: smb.service: Scheduled restart job, restart counter is at 2.
Sep 16 00:05:27 steamdeck systemd[1655]: Started User-level SMB Service for Deck.
Sep 16 00:05:27 steamdeck systemd[1655]: smb.service: Main process exited, code=exited, status=1/FAILURE
Sep 16 00:05:27 steamdeck systemd[1655]: smb.service: Failed with result 'exit-code'.
Sep 16 00:05:28 steamdeck systemd[1655]: smb.service: Scheduled restart job, restart counter is at 3.
Sep 16 00:05:28 steamdeck systemd[1655]: Started User-level SMB Service for Deck.
Sep 16 00:05:28 steamdeck systemd[1655]: smb.service: Main process exited, code=exited, status=1/FAILURE
Sep 16 00:05:28 steamdeck systemd[1655]: smb.service: Failed with result 'exit-code'.
Sep 16 00:05:28 steamdeck systemd[1655]: smb.service: Scheduled restart job, restart counter is at 4.
Sep 16 00:05:28 steamdeck systemd[1655]: Started User-level SMB Service for Deck.
Sep 16 00:05:28 steamdeck systemd[1655]: smb.service: Main process exited, code=exited, status=1/FAILURE
Sep 16 00:05:28 steamdeck systemd[1655]: smb.service: Failed with result 'exit-code'.
Sep 16 00:05:28 steamdeck systemd[1655]: smb.service: Scheduled restart job, restart counter is at 5.
Sep 16 00:05:28 steamdeck systemd[1655]: smb.service: Start request repeated too quickly.
Sep 16 00:05:28 steamdeck systemd[1655]: smb.service: Failed with result 'exit-code'.
Sep 16 00:05:28 steamdeck systemd[1655]: Failed to start User-level SMB Service for Deck.
```

連續重啓了 5 次然後報錯，懷疑是用戶權限目錄不足，所以創建用戶目錄，加上手動指定輸出日誌目錄

```shell
pid directory = /home/deck/.local/var/samba/run
lock directory = /home/deck/.local/var/samba/lock
state directory = /home/deck/.local/var/samba/state
cache directory = /home/deck/.local/var/samba/cache
private dir = /home/deck/.local/var/samba/private
log file = /home/deck/.local/var/log/samba/log.%m
log level = 2
server role = standalone server
security = user
```

然後發現好像不是這個的問題，排查可能是 SMBD 綁定端口（445）的問題，賦權：

```shell

realbin="$(readlink -f /home/linuxbrew/.linuxbrew/opt/samba/sbin/smbd)"
echo "$realbin"
file "$realbin"            # 確認是 ELF 可執行
sudo setcap 'cap_net_bind_service=+ep' "$realbin"
getcap "$realbin"          # 驗證已生效
```

最後發現還是不行，沒辦法了，直接前臺調試看看：

```shell
/home/linuxbrew/.linuxbrew/sbin/smbd -i -d 3 -s /home/deck/env/linux/samba/deck.conf
```

然後發現了報錯

```shell
/home/linuxbrew/.linuxbrew/sbin/smbd -i -d 3 -s /home/deck/env/linux/samba/deck.conf
lp_load_ex: refreshing parameters
Initialising global parameters
Processing section "[global]"
added interface wlan0 ip=192.168.31.29 bcast=192.168.31.255 netmask=255.255.255.0
smbd version 4.22.4 started.
Copyright Andrew Tridgell and the Samba Team 1992-2025
uid=1000 gid=1000 euid=1000 egid=1000
directory_create_or_exist: mkdir failed on directory /home/deck/.local/var/samba/private/msg.sock: No such file or directory
```

Samba 4.x 需要 private dir 下有 msg.sock 目錄用於進程間通信。之前可能只在 systemd 單元裏只創建了 /home/deck/.local/var/samba/private，但沒有遞歸創建 msg.sock 子目錄。

```shell
mkdir -p /home/deck/.local/var/samba/private/msg.sock
```

再次前臺啓動：

```shell
/home/linuxbrew/.linuxbrew/sbin/smbd -i -d 3 -s /home/deck/env/linux/samba/deck.conf
lp_load_ex: refreshing parameters
Initialising global parameters
Processing section "[global]"
added interface wlan0 ip=192.168.31.29 bcast=192.168.31.255 netmask=255.255.255.0
smbd version 4.22.4 started.
Copyright Andrew Tridgell and the Samba Team 1992-2025
uid=1000 gid=1000 euid=1000 egid=1000
invalid permissions on directory '/home/deck/.local/var/samba/private/msg.sock': has 0755 should be 0700
```

發現權限不對，這是 Samba 的**安全檢查**，要求 `msg.sock` 目錄權限必須是 `0700`（只有所有者可讀寫執行），而你現在是 `0755`（其他用戶也可讀/執行），修正權限

```shell
chmod 700 /home/deck/.local/var/samba/private/msg.sock
```

然後再次啓動，雖然成功啓動了 `waiting for connections`，但似乎仍然有報錯：

```shell
/home/linuxbrew/.linuxbrew/sbin/smbd -i -d 3 -s /home/deck/env/linux/samba/deck.conf
lp_load_ex: refreshing parameters
Initialising global parameters
Processing section "[global]"
added interface wlan0 ip=192.168.31.29 bcast=192.168.31.255 netmask=255.255.255.0
smbd version 4.22.4 started.
Copyright Andrew Tridgell and the Samba Team 1992-2025
uid=1000 gid=1000 euid=1000 egid=1000
Registered MSG_REQ_DMALLOC_MARK and LOG_CHANGED
lp_load_ex: refreshing parameters
Initialising global parameters
Processing section "[global]"
Processing section "[deck]"
adding IPC service
added interface wlan0 ip=192.168.31.29 bcast=192.168.31.255 netmask=255.255.255.0
loaded services
set_profile_level: INFO: Profiling support unavailable in this build.
daemon 'smbd' : Starting process ...
tdb(/home/deck/.local/var/samba/state/registry.tdb): tdb_open_ex: could not open file /home/deck/.local/var/samba/state/registry.tdb: No such file or directory
Could not open tdb: No such file or directory
Failed to fetch domain sid for WORKGROUP
tdb(/home/deck/.local/var/samba/state/account_policy.tdb): tdb_open_ex: could not open file /home/deck/.local/var/samba/state/account_policy.tdb: No such file or directory
Could not open tdb: No such file or directory
account_policy_get: tdb_fetch_uint32_t failed for type 1 (min password length), returning 0
account_policy_get: tdb_fetch_uint32_t failed for type 2 (password history), returning 0
account_policy_get: tdb_fetch_uint32_t failed for type 3 (user must logon to change password), returning 0
account_policy_get: tdb_fetch_uint32_t failed for type 4 (maximum password age), returning 0
account_policy_get: tdb_fetch_uint32_t failed for type 5 (minimum password age), returning 0
account_policy_get: tdb_fetch_uint32_t failed for type 6 (lockout duration), returning 0
account_policy_get: tdb_fetch_uint32_t failed for type 7 (reset count minutes), returning 0
account_policy_get: tdb_fetch_uint32_t failed for type 8 (bad lockout attempt), returning 0
account_policy_get: tdb_fetch_uint32_t failed for type 9 (disconnect time), returning 0
account_policy_get: tdb_fetch_uint32_t failed for type 10 (refuse machine password change), returning 0
tdbsam_open: Converting version 0.0 database to version 4.0.
tdbsam_convert_backup: updated /home/deck/.local/var/samba/private/passdb.tdb file.
tdb(/home/deck/.local/var/samba/state/winbindd_idmap.tdb): tdb_open_ex: could not open file /home/deck/.local/var/samba/state/winbindd_idmap.tdb: No such file or directory
TDBSAM converted successfully.
waiting for connections
```

啓動之後，我的 Mac 連接服務器 `smb://192.168.31.29` 仍然報錯找不到，非常奇怪。排查了端口，服務等等，最終發現是端口的問題，換一個端口就能連上。

```shell
ss -ltnp | grep 445
netstat -anp | grep 445

LISTEN 0      50           0.0.0.0:445        0.0.0.0:*
LISTEN 0      50              [::]:445           [::]:*

sudo iptables -L -n | grep 445
sudo ufw status

sudo setcap 'cap_net_bind_service=+ep' /home/linuxbrew/.linuxbrew/opt/samba/sbin/smbd

sudo /home/linuxbrew/.linuxbrew/bin/smbpasswd -L -c /home/deck/env/linux/samba/deck.conf -a deck
```

一頓操作下來什麼都沒成功，然後 Mac 連接的時候還是迅速報錯：

```shell
smbutil view //deck@192.168.31.29/deck
smbutil: server connection failed: Operation timed out
```

觀察 Deck 的前臺命令行，無任何連接輸出

```shell
~/env > /home/linuxbrew/.linuxbrew/sbin/smbd -i -d 3 -s /home/deck/env/linux/samba/deck.conf
lp_load_ex: refreshing parameters
Initialising global parameters
Processing section "[global]"
added interface wlan0 ip=192.168.31.29 bcast=192.168.31.255 netmask=255.255.255.0
smbd version 4.22.4 started.
Copyright Andrew Tridgell and the Samba Team 1992-2025
uid=1000 gid=1000 euid=1000 egid=1000
Registered MSG_REQ_DMALLOC_MARK and LOG_CHANGED
lp_load_ex: refreshing parameters
Initialising global parameters
Processing section "[global]"
Processing section "[deck]"
adding IPC service
added interface wlan0 ip=192.168.31.29 bcast=192.168.31.255 netmask=255.255.255.0
loaded services
set_profile_level: INFO: Profiling support unavailable in this build.
daemon 'smbd' : Starting process ...
Failed to fetch domain sid for WORKGROUP
waiting for connections
```

表現是可以 Ping 通 Steam Deck ，但是 NC 連不上

```shell
~ > ping 192.168.31.29
PING 192.168.31.29 (192.168.31.29): 56 data bytes
64 bytes from 192.168.31.29: icmp_seq=0 ttl=64 time=11.890 ms
64 bytes from 192.168.31.29: icmp_seq=1 ttl=64 time=4.102 ms
q64 bytes from 192.168.31.29: icmp_seq=2 ttl=64 time=39.757 ms
64 bytes from 192.168.31.29: icmp_seq=3 ttl=64 time=4.115 ms
^C
--- 192.168.31.29 ping statistics ---
4 packets transmitted, 4 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 4.102/14.966/39.757/14.661 ms

~ > nc -vz 192.168.31.29 445
nc: connectx to 192.168.31.29 port 445 (tcp) failed: Connection refused
```

說明網絡互通，Mac 能到達 Deck。而 Deck 上 445 端口雖然 smbd 啓動時監聽，但實際上**沒有真正開放**，或者監聽的 smbd 進程已退出/崩潰，或者被別的服務佔用後立刻關閉。

懷疑是誰佔了 445 端口，查了一下

```shell
~/env > ps aux | grep smbd
deck       81179  0.0  0.1  84572 26232 pts/5    S+   20:53   0:00 /home/linuxbrew/.linuxbrew/sbin/smbd -i -d 3 -s /home/deck/env/linux/samba/deck.conf
deck       82238  0.0  0.0   6596  4472 pts/7    S+   20:59   0:00 grep --color=auto smbd

~/env > ss -ltnp | grep 445
LISTEN 0      50           0.0.0.0:445        0.0.0.0:*
LISTEN 0      50              [::]:445           [::]:*
~/env > sudo lsof -i :445
COMMAND   PID USER FD   TYPE  DEVICE SIZE/OFF NODE NAME
smbd    81179 deck 30u  IPv6 4205857      0t0  TCP *:microsoft-ds (LISTEN)
smbd    81179 deck 32u  IPv4 4205859      0t0  TCP *:microsoft-ds (LISTEN)
```

發現誰都沒佔 445。實在沒招了，問了下 chatGPT

> 這種情況**99% 是 Linux 內核拒絕了 445 端口的非 root 綁定**，即使你看到 `ss -ltnp` 顯示監聽，實際上內核會直接拒絕外部連接。
> - **普通用戶運行的 smbd，雖然 setcap 後能監聽 445，但部分 Linux 發行版（包括 SteamOS/Arch 衍生）默認限制非 root 進程監聽 445/139，或 setcap 沒有生效。**
> - 這會導致：本地能看到監聽，**但所有外部連接都被內核直接拒絕**，smbd 根本收不到連接，表現爲“Connection refused”。

沒招了，之前的步驟全部用 ROOT 操作一遍，然後啓動這個服務，我發現仍然無法連接。具體的命令就不羅列了，太折騰了，最後試了一下 1445 端口，成功了。

簡直了。

Source via: https://note.bgzo.cc/weekly/enable-user-smb-on-steam-deck