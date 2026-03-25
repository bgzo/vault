---
draft: False
aliases: ['How to install pip package', 'How to install pip package globally', 'Install-pip-package-global']
created: 2025-07-26 22:52:33
modified: 2025-07-26 22:56:41
title: How to install pip package
tags: ['writing/how-to']
description: Pipx 如果你用 Homebrew / Python >= 3.11 / pip >= 23.0，在全局安裝 PIP 包，會遇到如下錯誤： 可以用 PIPX 實現全局安裝並且對環境依賴無污染 Source via: https://note.bgzo.cc/weekly/install-pip-package-global
---


## Pipx

如果你用 Homebrew / Python >= 3.11 / pip >= 23.0，在全局安裝 PIP 包，會遇到如下錯誤：

```shell
note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
hint: See PEP 668 for the detailed specification.
```

可以用 PIPX 實現全局安裝並且對環境依賴無污染

Source via: https://note.bgzo.cc/weekly/install-pip-package-global