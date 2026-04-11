---
title: How to run program in background
aliases: ['How to run program in background', 'Run-program-in-background']
created: 2025-07-19 12:08:14
modified: 2026-04-11 18:50:20
published: 2025-07-19 12:08:14
tags: ['public', 'writing/how-to']
draft: False
description: Windows linux tmux nohup bg References What's the nohup on Windows? - Stack Overflow What is the equivalent of 'nohup' in linux PowerShell? - Stack Overflow Start-Process (Microsoft.PowerShell.Managem...
---

## Windows

```powershell
Start-Process
Start Job { & C:\Full\Path\To\my.exe }
```


```cmd
start
```


## linux

- `tmux`
- `nohup`
- `bg`

## References

- [What's the nohup on Windows? - Stack Overflow](https://stackoverflow.com/questions/3382082/whats-the-nohup-on-windows)
- [What is the equivalent of 'nohup' in linux PowerShell? - Stack Overflow](https://stackoverflow.com/questions/64707869/what-is-the-equivalent-of-nohup-in-linux-powershell)
- [Start-Process (Microsoft.PowerShell.Management) - PowerShell | Microsoft Learn](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/start-process)
- [What is the equivalent of 'nohup' in PowerShell? - Stack Overflow](https://stackoverflow.com/questions/19321903/what-is-the-equivalent-of-nohup-in-powershell)
- [Start-Job (Microsoft.PowerShell.Core) - PowerShell | Microsoft Learn](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/start-job)

Source via: https://note.bgzo.cc/weekly/20250719-run-program-in-background