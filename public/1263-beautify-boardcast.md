---
comments: True
draft: False
aliases: ['美化 BroadcastChannel']
created: 2025-10-25 11:19:59
modified: 2025-11-15 12:52:20
tags: ['writing/lab']
title: 美化 BroadcastChannel
description: 原項目設計很新穎，用 Cloudflare / Netlify / Vercel 等平臺天然支持 SSR 特性，完成了原網頁 https//t.me/s/ 的代理工作。最重要的是，這些平臺作爲中間轉發（代理），可以直接讓國內訪問到這部分內容（受衆 ++）。 原理 之前一直以爲是從 Telegram 網頁端拉取數據，然後再生成動態站點，但運行一段時間之後發現不是，博文同步更新的很快，部署一次之後，沒...
---

原項目設計很新穎，用 [Cloudflare](https://broadcast-channel.pages.dev/) / [Netlify](https://broadcast-channel.netlify.app/) / [Vercel](https://broadcast-channel.vercel.app/) 等平臺天然支持 SSR 特性，完成了原網頁 https://t.me/s/ 的代理工作。最重要的是，這些平臺作爲中間轉發（代理），可以直接讓國內訪問到這部分內容（受衆 ++）。

## 原理

之前一直以爲是從 Telegram 網頁端拉取數據，然後再生成動態站點，但運行一段時間之後發現不是，博文同步更新的很快，部署一次之後，沒有什麼感知。

看了源碼之後，發現原來每次加載頁面，服務端都會向 Telegram Web 的藉口請求一次接口，然後再把數據解包，映射回 Broadcast，給應用作展示。就是這麼簡單，網頁不能做的，這裏一樣不能做。

那麼後來者還能做什麼呢？

當然可以，目前項目還存在一些問題：

1. [ ] 一些消息格式不會展示在網頁端，這裏自然也不會展示；
2. [ ] 自定義樣式

第一點目前還沒有什麼好的辦法，但第二點，還是能做一些文章的，那我自己來說，博客篇幅一般要更長，內容更深，更連貫，而 Telegram Channel 我不打算這麼用，從發佈第一個消息的時候，我就決定把它作爲社交媒體的替代物。

而中國人都熟知的社交媒體往往就是「朋友圈」，之前看過很多博主把自己的主題整成這樣，其實還蠻羨慕的，比如：

- https://github.com/xiaopanglian/icefox

## 美化

說幹就幹，這是優化前：

![](https://raw.githack.com/bGZo/assets/dev/2025/202510251122073.png)

這是優化後：

![](https://raw.githack.com/bGZo/assets/dev/2025/202510251124670.png)

左側的主體還是保持朋友圈的設計，右側導航欄變成卡片，公告右移，必要的時候隱藏，我覺得還是蠻好看的。

### Changelog

本次改造較多，有些可能與原項目設計衝突，主要有

1. [Remove] 放棄 `PNPM`，改用 bun；
2. [Remove] 放棄 `elint`，遷移過程一直報依賴衝突；
3. [Remove] 移除原項目大部分無用的友鏈；
4. [Chore] 註釋大部分 CSS，改用 tailwindcss；
5. [Chore] 放棄在 Vercel 後臺改動變量，直接操作 `.env` 並提交；
6. [Feature] 增加黑暗模式；
7. [Feature] 增加自定義作者名稱功能；
8. [Feature] 增加 Google analyse；

### 移除 `elint` 噩夢

幾個月前我記得 install 不會報錯，但這幾個月用 `npm` 就回陷入無止盡的依賴地獄：

```shell
npm install --registry=http://registry.npm.taobao.org
(node:1730496) ExperimentalWarning: CommonJS module /home/bgzo/.nvm/versions/node/v23.3.0/lib/node_modules/npm/node_modules/debug/src/node.js is loading ES Module /home/bgzo/.nvm/versions/node/v23.3.0/lib/node_modules/npm/node_modules/supports-color/index.js using require().
Support for loading ES Module in require() is an experimental feature and might change at any time
(Use `node --trace-warnings ...` to show where the warning was created)
npm error code ERESOLVE
npm error ERESOLVE unable to resolve dependency tree
npm error
npm error While resolving: broadcast-channel@0.1.7
npm error Found: prismjs@1.30.0
npm error node_modules/prismjs
npm error   prismjs@"^1.29.0" from the root project
npm error
npm error Could not resolve dependency:
npm error peer prismjs@"1.28.0" from prismjs-components-importer@0.2.0
npm error node_modules/prismjs-components-importer
npm error   prismjs-components-importer@"^0.2.0" from the root project
npm error
npm error Fix the upstream dependency conflict, or retry
npm error this command with --force or --legacy-peer-deps
npm error to accept an incorrect (and potentially broken) dependency resolution.
npm error
npm error
npm error For a full report see:
npm error /home/bgzo/.npm/_logs/2025-10-25T04_06_35_645Z-eresolve-report.txt
npm error A complete log of this run can be found in: /home/bgzo/.npm/_logs/2025-10-25T04_06_35_645Z-debug-0.log
```

```shell
npm install --registry=http://registry.npm.taobao.org
(node:1734078) ExperimentalWarning: CommonJS module /home/bgzo/.nvm/versions/node/v23.3.0/lib/node_modules/npm/node_modules/debug/src/node.js is loading ES Module /home/bgzo/.nvm/versions/node/v23.3.0/lib/node_modules/npm/node_modules/supports-color/index.js using require().
Support for loading ES Module in require() is an experimental feature and might change at any time
(Use `node --trace-warnings ...` to show where the warning was created)
npm error code ERESOLVE
npm error ERESOLVE unable to resolve dependency tree
npm error
npm error While resolving: broadcast-channel@0.1.7
npm error Found: eslint@9.5.0
npm error node_modules/eslint
npm error   dev eslint@"9.5.0" from the root project
npm error   peer eslint@"^8.57.0 || ^9.0.0" from @eslint-react/eslint-plugin@1.53.1
npm error   node_modules/@eslint-react/eslint-plugin
npm error     peerOptional @eslint-react/eslint-plugin@"^1.19.0" from @antfu/eslint-config@3.16.0
npm error     node_modules/@antfu/eslint-config
npm error       dev @antfu/eslint-config@"^3.0.0" from the root project
npm error
npm error Could not resolve dependency:
npm error peer eslint@"^9.10.0" from @antfu/eslint-config@3.16.0
npm error node_modules/@antfu/eslint-config
npm error   dev @antfu/eslint-config@"^3.0.0" from the root project
npm error
npm error Fix the upstream dependency conflict, or retry
npm error this command with --force or --legacy-peer-deps
npm error to accept an incorrect (and potentially broken) dependency resolution.
npm error
npm error
npm error For a full report see:
npm error /home/bgzo/.npm/_logs/2025-10-25T04_11_14_348Z-eresolve-report.txt
npm error A complete log of this run can be found in: /home/bgzo/.npm/_logs/2025-10-25T04_11_14_348Z-debug-0.log
```

如果忽視衝突直接用 `--legacy-peer-deps` 當然也是可以直接安裝的，或者用 `package.json` 指定的 `pnpm` 也可以。只是 `npm` 不行，比較奇怪。

就算僥倖安裝上了，後面每次提交前的格式化也總是報錯，導致提個代碼也磕磕絆絆：

```shell
pnpm lint-staged
✔ Backed up original state in git stash (b2e494a)
⚠ Running tasks for staged files...
  ❯ package.json — 7 files
    ❯ * — 7 files
      ✖ eslint --fix [FAILED]
↓ Skipped because of errors from tasks.
✔ Reverting to original state because of errors...
✔ Cleaning up temporary files...

✖ eslint --fix:

Oops! Something went wrong! :(

ESLint: 9.5.0

Error: Cannot find module 'typescript'
Require stack:
- /home/bgzo/workspaces/BroadcastChannel/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForProjects.js
- /home/bgzo/workspaces/BroadcastChannel/node_modules/@typescript-eslint/typescript-estree/dist/clear-caches.js
- /home/bgzo/workspaces/BroadcastChannel/node_modules/@typescript-eslint/typescript-estree/dist/index.js
- /home/bgzo/workspaces/BroadcastChannel/node_modules/@typescript-eslint/parser/dist/parser.js
- /home/bgzo/workspaces/BroadcastChannel/node_modules/@typescript-eslint/parser/dist/index.js
    at Function._resolveFilename (node:internal/modules/cjs/loader:1239:15)
    at Function._load (node:internal/modules/cjs/loader:1064:27)
    at TracingChannel.traceSync (node:diagnostics_channel:322:14)
    at wrapModuleLoad (node:internal/modules/cjs/loader:218:24)
    at Module.require (node:internal/modules/cjs/loader:1325:12)
    at require (node:internal/modules/helpers:136:16)
    at Object.<anonymous> (/home/bgzo/workspaces/BroadcastChannel/node_modules/@typescript-eslint/typescript-estree/dist/create-program/getWatchProgramsForPr
ojects.js:43:25)                                                                                                                                                 at Module._compile (node:internal/modules/cjs/loader:1546:14)
    at Object..js (node:internal/modules/cjs/loader:1698:10)
    at Module.load (node:internal/modules/cjs/loader:1303:32)
```

上面報錯可以通過添加 typescript 解決

```shell
pnpm add -D typescript
```

我升級了全部依賴 (`npm update --legacy-peer-deps --registry=http://registry.npm.taobao.org`)，然後發現仍然不能解決這個問題，後面在添加 TailwindCSS 的時候又報版本依賴的錯誤了，爲了最大兼容性，索性直接把 eslint 卸載了：

```shell
pnpm remove @antfu/eslint-config astro-eslint-parser eslint eslint-plugin-astro eslint-plugin-format
pnpm remove lint-staged simple-git-hooks
```

一下子清爽多了。

### 遷移 BUN

遷移很簡單，理想的話，主要變更下 `package.json` 腳本

```json
{
  "packageManager": "bun@1.2.23",
  "scripts": {
    "dev": "bunx astro dev",
    "start": "bunx astro dev",
    "build": "bunx astro build",
    "preview": "bunx astro preview",
    "astro": "bunx astro",
    "postinstall": "test -d .git && true"
  }
}
```

然後刪掉 `node_modules` 和 `*.lock` 文件，重新 install 即可。

### 引入 Google Analyse

官方推薦的代碼直接嵌入網站無法直接在 SSR 站點上起作用，如：

```html
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'G-XXXXXXXXX');
</script>
```

使用 Partytown 可以解決 GA4 在網站上不生效的問題，Partytown 將第三方腳本（如 gtag）移到 Web Worker 中運行，避免阻塞主線程，並允許在 SSR 環境中安全執行客戶端代碼。

```html
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXX" type="text/partytown"></script>
<script type="text/partytown">
  window.dataLayer = window.dataLayer || [];
  window.gtag = function () {
        dataLayer.push(arguments);
    };
  window.gtag('js', new Date());
  window.gtag('config', 'G-XXXXXXXXX');
</script>
```

- `type="text/partytown"`：指示 Partytown 處理此腳本，將其移到 Worker。
- `is:inline`：確保腳本內容內聯加載。
- `src="..."`：異步加載 gtag 庫。

並且在 `astro.config.mjs` 添加配置允許這些函數從 Worker 轉發到主線程，確保 `gtag` 調用正常工作：

```ts
import partytown from '@astrojs/partytown'

export default defineConfig({
  // ...
  integrations: [partytown({ config: { forward: ['dataLayer.push', 'gtag'] } })],
});
```

參考：

- https://shinya.click/fiddling/astro-google-tag-manager/
- https://github.com/QwikDev/partytown/issues/382#issuecomment-1667675238

大致就是這些，寫完了，希望你能玩的快心，我的地址: https://cast.bgzo.cc

Source via: https://note.bgzo.cc/weekly/1263-beautify-boardcast