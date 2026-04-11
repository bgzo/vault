---
title: 用 Astro 重做網站這件事
aliases: ['用 Astro 重做網站這件事']
created: 2025-10-12 00:39:37
modified: 2026-04-11 18:50:19
published: 2025-10-12 00:39:37
tags: ['public', 'writing/lab']
draft: False
description: Astro 是什麼 核心思想是羣島架構，不同與傳統 VUE 的單頁應用，而是對於不用頁面按需加載，在網頁加載速度和架構兼容性上來說是一流。 模板的注入類似 Jekyll，但是比前者更加靈活。 Bun 是什麼 是用 Zig 語言實現的另一個 Javascript 運行時，目標是兼容 Node.js，提供更加快速的構建體驗。 初始化一個 Astro 項目 添加 Vue / TailwindCSS 等依...
---

## Astro 是什麼

核心思想是羣島架構，不同與傳統 VUE 的單頁應用，而是對於不用頁面按需加載，在網頁加載速度和架構兼容性上來說是一流。

模板的注入類似 Jekyll，但是比前者更加靈活。

## Bun 是什麼

是用 Zig 語言實現的另一個 Javascript 運行時，目標是兼容 `Node.js`，提供更加快速的構建體驗。

## 初始化一個 Astro 項目

```shell
mkdir astro-demo
npm create astro@latest
```

## 添加 Vue / TailwindCSS 等依賴

```shell
npm install @astrojs/vue
npm install @astrojs/tailwind
```

不正確安裝 Tailwind CSS 可能提醒：

```shell
[plugin:vite:css] [postcss] It looks like you're trying to use `tailwindcss` directly as a PostCSS plugin. The PostCSS plugin has moved to a separate package, so to continue using Tailwind CSS with PostCSS you'll need to install `@tailwindcss/postcss` and update your PostCSS configuration.
```

via: https://tailwindcss.com/docs/installation/framework-guides/astro

## 創建頁面基本骨架、引入博客頁面

```ts
import { getCollection } from 'astro:content';

export async function getStaticPaths() {
  const posts = await getCollection('blog');

  return posts.map((post) => ({
    params: { slug: post.slug },
    props: { post },
  }));
}
```

- [ ] `getStaticPaths` 的作用是什麼？爲什麼加上這一行就會變成靜態頁面？
- [ ] 爲什麼命名 `[slug].astro`

- 文檔參考: https://docs.astro.build/en/guides/content-collections/
- 利用 `tailwindcss@typography` 優化內容排版顯示；

source via: https://github.com/bGZo/playground/commit/0545ea8c6122266cfe6249497136f1f9543559f5

## 遷移 BroadcastChannel

via: https://github.com/bGZo/playground/commit/cd7875a32ce00d3c5fb150dc5f4e346225a4b54

目前還不清楚爲什麼原項目用 `ofetch` 可以直接用環境變量的代理，而我遷移過來的代碼不行，報錯：

```shell
Fetching https://telegram.dog/s/imbgzo { before: '', after: '', q: '', type: 'list', id: '' }
Fetch failed: [GET] "https://telegram.dog/s/imbgzo?before=&after=&q=": <no response> [TimeoutError]: The operation was aborted due to timeout
Error details: FetchError: [GET] "https://telegram.dog/s/imbgzo?before=&after=&q=": <no response> [TimeoutError]: The operation was aborted due to timeout
    at runNextTicks (node:internal/process/task_queues:65:5)
    at process.processTimers (node:internal/timers:546:9)
    at async $fetchRaw2 (file:///home/bgzo/workspaces/playground/astro-demo/node_modules/ofetch/dist/shared/ofetch.03887fc3.mjs:270:14)
    at async $fetch2 (file:///home/bgzo/workspaces/playground/astro-demo/node_modules/ofetch/dist/shared/ofetch.03887fc3.mjs:316:15)
    at async getChannelInfo (file:///home/bgzo/workspaces/playground/astro-demo/dist/server/chunks/index_BEp_DU6L.mjs:219:22)
    at async file:///home/bgzo/workspaces/playground/astro-demo/dist/server/pages/talk.astro.mjs?time=1760286561784:13:19
    at async callComponentAsTemplateResultOrResponse (file:///home/bgzo/workspaces/playground/astro-demo/node_modules/astro/dist/runtime/server/render/astro/render.js:91:25)
    at async renderToAsyncIterable (file:///home/bgzo/workspaces/playground/astro-demo/node_modules/astro/dist/runtime/server/render/astro/render.js:133:26)
    at async renderPage (file:///home/bgzo/workspaces/playground/astro-demo/node_modules/astro/dist/runtime/server/render/page.js:36:24)
    at async lastNext (file:///home/bgzo/workspaces/playground/astro-demo/node_modules/astro/dist/core/render-context.js:201:25) {
  [cause]: Error [TimeoutError]: [TimeoutError]: The operation was aborted due to timeout
      at node:internal/deps/undici/undici:13484:13
      at runNextTicks (node:internal/process/task_queues:65:5)
      at process.processTimers (node:internal/timers:546:9)
      at async $fetchRaw2 (file:///home/bgzo/workspaces/playground/astro-demo/node_modules/ofetch/dist/shared/ofetch.03887fc3.mjs:258:26) {
    code: 23
  }
}
```

所以用硬編碼 `HttpsProxyAgent` 和 `SocksProxyAgent` 作 `agent` 的方式，發現仍然不行，最後用 `node-fetch` 替代 `ofetch`，最終成功了，確定是網絡因素，關鍵代碼如下：

```ts
export async function getChannelInfo(Astro, { before = '', after = '', q = '', type = 'list', id = '' } = {}) {
  // xxx
  console.info('Fetching', url, { before, after, q, type, id })
  const agent = getEnv(import.meta.env, Astro, 'HTTP_PROXY') ?
    new HttpsProxyAgent(getEnv(import.meta.env, Astro, 'HTTP_PROXY')) : undefined
  // const proxyUrl = 'socks5://127.0.0.1:10800'
  // const agent = new SocksProxyAgent(proxyUrl)
  // console.info('Fetch agent:', agent)
  try {
    const queryString = new URLSearchParams({
      before: before || '',
      after: after || '',
      q: q || '',
    }).toString()
    const fullUrl = queryString ? `${url}?${queryString}` : url
    const response = await fetch(fullUrl, {
      headers,
      agent,
      timeout: 30000,
    })
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`)
    }
    const html = await response.text()
    console.info('Fetch successful, HTML length:', html.length)
    // xxxx
    return channelInfo
  } catch (error) {
    console.error('Fetch failed:', error.message)
    console.error('Error details:', error)
    throw error
  }
}
```

- [ ] `middleware.js` 的作用是什麼？
- [ ] `prefetch.json.ts` 的作用是什麼？
	- [ ] 提醒瀏覽器預先加載頁面。

## 博客頁面排序/分類切換

via: https://github.com/bGZo/playground/commit/11237705d03722c5e63c1a1168761cd7844b17d4

排序原理是 b 的日期比 a 的打，即爲正數，即會排到前面：

```ts
posts.sort(
  (a: any, b: any) =>
    new Date(b.data.created).getTime() - new Date(a.data.created).getTime()
);
```

目前博客的分類切換爲 CSS 樣式切換，關鍵代碼如下：

```js

document.addEventListener("DOMContentLoaded", () => {
  const select = document.getElementById(
    "category-select"
  ) as HTMLSelectElement;
  const listItems = document.querySelectorAll(
    "li[data-category]"
  ) as NodeListOf<HTMLElement>;
  select.addEventListener("change", () => {
    const selected = select.value;
    listItems.forEach((li: HTMLElement) => {
      const category = li.dataset.category;
      if (selected === "" || category === selected) {
        li.style.display = "";
      } else {
        li.style.display = "none";
      }
    });
  });
});
```

後續打算用 VUE 直接操作展示列表進行動態切換。

## 設置創建時間和更新時間

via: https://github.com/bGZo/playground/commit/11511f4eaac9dbe27ce34ea1f545de79a63a63f7

讀取 post 的時間，在博客頁面設置屬性即可，關鍵代碼如下：

```markdown
---
import dayjs from 'dayjs';
---
<p class="text-gray-600 text-sm">Created: {dayjs(post.data.created).format('YYYY-MM-DD')} | Updated: {dayjs(post.data.modified).format('YYYY-MM-DD')}</p>
```

## 增加在線工具頁面，引用 VUE

via: https://github.com/bGZo/playground/commit/44d085d111a33ceb87aaa6681aa16a696b97c0e2

動態加載 `tool` 文件夾下面的工具組件，加載內部的標題和描述；

```ts
// 過濾掉索引頁面本身，只保留工具頁面
const toolPromises = Object.entries(toolModules)
	.filter(([path]) => path !== './tool.astro') // 排除當前文件
	.map(async ([path, module]) => {
		const page = await module() as any;
		return {
			slug: path.replace('./', '').replace('.astro', ''), // 獲取文件名作爲 slug
			title: page.title || '未命名工具',
			description: page.description || '暫無描述'
		};
	});

// 等待所有異步操作完成
const tools = await Promise.all(toolPromises);
```

- [ ] `Promiss.all()` 的作用是什麼？爲什麼使用它？

引入 VUE 組件，潛入頁面：

```markdown
---
import StringEscape from '../../components/StringEscape.vue';
export const title = '字符串轉義工具';
export const description = '用於轉義字符串中的特殊字符，如 HTML 實體編碼。';
---
<StringEscape client:load/>
```

- [ ] `<StringEscape client:load/>` 中 `client:load` 的作用是什麼？

## 合併 `playground` 項目到本博客中

via: https://github.com/bGZo/playground/commit/baa2b2904841639a7f3e3e21e7fbbda935ebc0ec

之前的 playground 實際上只是一個單頁應用，潛入進來也比較簡單，直接引入 `vue`，然後像 `tool` 頁面一樣引入即可。

## 主頁引入 ICON 圖標

via:

- https://github.com/bGZo/playground/commit/2ae4e9e62dc18588603a997b1e191a6149433df4
- https://github.com/bGZo/playground/commit/30ed935aca00999d4a78924f3869b9857b879d94

有幾種引入方式：

### VUE 引入

```vue
<template>
  <svg class="h-6 w-6 align-middle" xmlns="http://www.w3.org/2000/svg" aria-hidden="true" focusable="false" viewBox="0 0 24 24" >
    <path
      d="M12,1C5.9,1,1,5.9,1,12s4.9,11,11,11s11-4.9,11-11S18.1,1,12,1z M20.9,11h-4c-0.2-2.8-1.1-5.4-2.7-7.7C17.8,4.2,20.5,7.3,20.9,11zM9.1,13h5.9c-0.3,2.7-1.3,5.3-2.9,7.4C10.3,18.3,9.3,15.7,9.1,13zM9.1,11c0.3-2.7,1.3-5.3,2.9-7.4c1.7,2.2,2.7,4.8,2.9,7.4H9.1z M9.7,3.3C8.2,5.6,7.3,8.2,7.1,11h-4C3.5,7.3,6.2,4.2,9.7,3.3zM3.1,13h4c0.2,2.8,1.1,5.4,2.7,7.7C6.2,19.8,3.5,16.7,3.1,13z M14.3,20.7c1.5-2.3,2.4-4.9,2.7-7.7h4C20.5,16.7,17.8,19.8,14.3,20.7z">
    </path>
  </svg>
</template>
```

然後在具體位置

```html
<span class="text-lg flex items-center">
	<span class="mr-1"><Location /></span>
	{profile.location}
</span>
```

參考： https://github.com/vuejs/docs/blob/31b4521ad0607a74e284fa7c62502b56a7710e86/src/about/team/TeamMember.vue#L7

## Astro 原生引入

```markdown
---
import bluesky from "../assets/icon/bluesky.svg";
---
{
  profile.socialMedia["Bluesky"] &&
	profile.socialMedia["Bluesky"].length > 0 && (
	  <a
		href={`https://bsky.app/profile/${profile.socialMedia["Bluesky"]}`}
		title="Bluesky"
		target="_blank"
>
		<img
		  {...bluesky}
		  alt={`bsky.app/profile/${profile.socialMedia["Bluesky"]}`}
		  class="social-icon w-6"
		/>
	  </a>
	)
}
```

- [ ] 語法結構如何理解？
- [ ] 官方動態批量引入？

## 引入閱讀時間

via: https://github.com/bGZo/playground/commit/019dfde5c80acf2423b42a2f9d6b509f8c27fa03

官方教程: https://docs.astro.build/zh-cn/recipes/reading-time

## 工具增加雙拼解碼

via: https://github.com/bGZo/playground/commit/c83d30d8dbbad315d457ab0a3e357ffeb2d838e2

編碼，參考： https://sspai.com/post/56134

## Markdown 語法拓展

自帶的語法當前不支持 Callout(admonition note)，不支持 mark 高亮。

## Callout

安裝 https://github.com/myl7/remark-github-beta-blockquote-admonitions

安裝完插件後，發現雖然正確解析了，但是沒有 CSS 樣式，需要自己找。

via: https://ssshooter.com/add-admonitions/, 博主的這個博客沒有開源，只能借下它的 CSS 了。

## Mark

- https://github.com/twardoch/remark-mark-plus#usage-with-remark-cli
	- 這個沒有生效

## Github Pages

via: https://github.com/bGZo/playground/commit/900182f47e79a6fcfa61c8c58c73c93a0ff5ccf8

有幾個注意點：

- 聲明 `.nojekyll`: 默認 GitHub Pages 的站點是 Jekyll，直接部署上去，無法展示 `_astro` 下面的文件，請求會報錯，需要添加 `.nojekyll` 的文件聲明非 Jekyll 站點纔可，via: https://github.com/withastro/starlight/issues/3339
- 相對路徑，因爲普通倉庫的 Github Pages 命名空間不同，需要聲明 `base` 屬性：

```ts
export default defineConfig({
  // via: https://docs.astro.build/en/guides/deploy/github/
  site: 'https://bgzo.github.io',
  base: '/github-pages',
})
```

- 網站內有鏈接跳轉的部分同樣需要重新處理一遍，我使用了全部路徑而非相對路徑處理這個問題，額外的替換處理是爲了避免不設置 base，導致路徑失效

```markdown
---
const { SITE_URL } = Astro.locals
const SITE_URL_NO_SLASH = SITE_URL.endsWith('/') ? SITE_URL.slice(0, -1) : SITE_URL;
---
<a href={SITE_URL_NO_SLASH + '/' + link.path} class={currentPath === link.path ? 'font-bold' : ''}>{link.name}</a>
```

via: https://docs.astro.build/zh-cn/guides/deploy/github, https://docs.astro.build/zh-cn/reference/configuration-reference/#base

## 區分本地和生產

via: https://github.com/bGZo/playground/commit/101009794f945cc97ca5962800d252d317497ea3

本地生產的 `BASE_URL` 不同，正好可以用 `npm run dev` 和 `npm run build` 做區分，直接在 `package.json` 文件中聲明環境即可，如：

```json
"dev": "NODE_ENV=development astro dev",
"build": "NODE_ENV=production astro build && touch dist/client/.nojekyll",
```

然後在配置文件中聲明 URL:

```ts
site: process.env.NODE_ENV === 'development' ? 'http://127.0.0.1:4321' : 'https://bgzo.github.io',
```

## 綁定域名

前幾年綁定域名，我記得還需要將 IPv4 的地址寫到 DNS 解析記錄裏，今天測試了下，用 CNAME 也可以。需要在根目錄下增加一個 `CNAME` 文件，介入對應域名即可。

## 通過局域網調試應用

```shell
bun run dev -- --host
```

有一些不知道要寫在哪裏的點，就統一放在這裏：

- 路由命名，因爲主要依靠 Github Pages（下叫 Pages），所以路徑上，可能會有個子其他 Pages 命名衝突的情況，比如我我的某個路由叫 `bgzo.github.io/playground`， 正好我有個項目就叫 `playground` 且開啓了 Pages，那麼 Gihtub 會優先取後者，即其他項目的頁面，而不是你當前這個項目的路由。
- [ ] 爲什麼 Mac 熄屏後再打開，轉發的端口、頁面就會失效，需要重新轉發；

Source via: https://note.bgzo.cc/weekly/20251012-make-a-blog-again-with-astro