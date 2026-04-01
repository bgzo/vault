---
draft: False
aliases: ['How to manage app in debian', 'Manage-app-in-debian']
created: 2025-07-16 20:45:43
modified: 2025-07-16 20:46:16
title: How to manage app in [[debian]]
tags: ['writing/how-to']
description: Ubuntu 和 Debian 通喫是因爲 Debian 系的 APT 包管理器。 \#1 Install From mirror source From deb package Use another tool after run sudo apt install gdebi From source code (after tar zxf xxx.tgz) 有些軟件沒有被收錄進軟件鏡像源，或者說...
---

> Ubuntu 和 Debian 通喫是因爲 Debian 系的 APT 包管理器。

## \#1 Install

From mirror source:

```shell
sudo apt install -y xxx
```

From `deb` package:

```shell
sudo dpkg -i xxx.deb
```

Use another tool after run `sudo apt install gdebi`

```shell
sudo gdebi xxx.deb
```

From source code (after `tar zxf xxx.tgz`):

> 有些軟件沒有被收錄進軟件鏡像源，或者說開發者需要去使用他們最新的版本，這時候就要自己去他們的官網或者是代碼託管平臺下載最新的 Linux 源碼，自己來 build. 這種方式安裝需要解決很多的依賴，安裝前多 Google

```shell
sudo make
sudo make install
```

You could install `build-essential` before )

If need to install dependency with prompt:

```shell
sudo apt install -f xxx
```

Or run the script supported by application : )

[通過apt離線下載deb包以及其依賴包_OS與驅動_鯤鵬_華爲雲論壇 (huaweicloud.com)](https://bbs.huaweicloud.com/forum/thread-62703-1-1.html)

[我如何去忽略某些依賴關係？ (qastack.cn)](https://qastack.cn/server/250224/how-do-i-get-apt-get-to-ignore-some-dependencies)

## \#2 Reinstall

```shell
sudo apt reinstall xxx
```

```shell
sudo apt reinstall -d xxx
```


## \#3 Uninstall

```shell
sudo apt purge xxx
```

```shell
dpkg --get-selections | grep XXX
```

```shell
sudo apt purge XXX  #一個帶core的package, 如果沒有帶core的package, 則是情況而定.
```


## \#4 Clean old version software

Most easy way is following, which only work for have updated recently packages:

```shell
sudo apt autoclean
sudo apt autoremove
```

For log:

```shell
sudo echo > /var/log/syslog
sudo echo > /var/log/kern.log
```


For SNAP

```shell
#!/bin/shell
```


```shell
set -eu
snap list --all | awk '/disabled/{print $1, $3}' |
while read snapname revision; do
    snap remove "$snapname" --revision="$revision"
done
```

A more hacker way is:

```shell
dpkg -l |grep ^rc|awk '{print $2}' |sudo xargs dpkg -P
```

> [!tip]
> 這條命令是用於清理 Debian 或 Ubuntu 系統中殘留的已經被標記爲 "rc"（已刪除但配置文件仍然存在）狀態的軟件包。讓我逐步解釋這個命令的各個部分：
> #llm/chatgpt

`dpkg -l`：這部分命令列出系統中安裝的所有軟件包。

`|`：這是管道符號，用於將第一個命令的輸出傳遞給下一個命令。

`grep ^rc`：這部分命令使用 `grep` 工具來過濾出以 "rc" 開頭的行，這些行代表了已刪除但配置文件仍然存在的軟件包。

`awk '{print $2}'`：這部分命令使用 `awk` 工具提取每一行中的第二列，也就是軟件包的名稱。

`|`：再次使用管道符號，將 `awk` 命令的輸出傳遞給下一個命令。

`sudo xargs dpkg -P`：最後，這部分命令使用 `xargs` 來將軟件包名稱傳遞給 `dpkg -P` 命令，以卸載這些軟件包。`dpkg -P` 命令會刪除已標記爲 "rc" 狀態的軟件包及其配置文件。

> [!Warning]
> 使用 `dpkg -P` 命令可能會導致數據丟失，因此在運行此命令之前應謹慎考慮，並確保您瞭解正在刪除的軟件包及其影響。

Source via: https://note.bgzo.cc/weekly/manage-app-in-debian