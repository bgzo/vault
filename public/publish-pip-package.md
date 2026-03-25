---
draft: False
aliases: ['How to publish pip package', 'Publish-pip-package']
created: 2025-07-26 23:07:16
modified: 2025-07-26 23:15:32
title: How to publish pip package
tags: ['writing/how-to']
description: poetry Firstly, register an account via: https://pypi.org Then get account publish token in account setting, and config it: Then you could publish it. Source via: https://note.bgzo.cc/weekly/publish-p...
---


## poetry

Firstly, register an account via: https://pypi.org

Then get **account publish token** in account setting, and config it:

```shell
poetry config pypi-token.pypi <your-token>
```

Then you could publish it.

```shell
poetry publish --build
```

Source via: https://note.bgzo.cc/weekly/publish-pip-package