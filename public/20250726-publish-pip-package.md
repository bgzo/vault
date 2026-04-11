---
title: How to publish pip package
aliases: ['How to publish pip package', 'Publish-pip-package']
created: 2025-07-26 23:07:16
modified: 2026-04-11 18:50:20
published: 2025-07-26 23:07:16
tags: ['public', 'writing/how-to']
draft: False
description: poetry Firstly, register an account via https//pypi.org Then get account publish token in account setting, and config it " 的說明足夠清楚。建議補充一行："這會將 token 保存到本地配置中。" --> Then you could publish it. Source vi...
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


Source via: https://note.bgzo.cc/weekly/20250726-publish-pip-package