---
title: 修復 h5player 腳本在巴哈姆特注入 CSS
aliases: 修復 h5player 腳本在巴哈姆特注入 CSS
created: 2026-08-11 20:10:06
modified: 2026-08-11 23:53:11
tags: ['bahamute', 'javascript', 'tampermonkey', 'userscripts', 'writing/lab', 'public']
draft: False
published: 2026-08-11 23:56:00
description: 很喜歡 h5player 的截圖功能，喜歡到了剛需的程度！它強大到自己可以讓網頁上的一切視頻都能截圖，甚至做到下載。雖然它如今已經適配 37+ 網站，但它還是不對付我常用的兩個看番網站： 1. https//ani.gamer.com.tw/ 2. https//anime1.me 這個問題我 22 年左右就發現了，一直沒有提 ISSUE，也沒有下載下來自己定位看看，時至如今，這個問題依舊，終於在...
---

很喜歡 h5player 的截圖功能，喜歡到了剛需的程度！它強大到自己可以讓網頁上的一切視頻都能截圖，甚至做到下載。雖然它如今已經適配 37+ 網站，但它還是不對付我常用的兩個看番網站：

1. https://ani.gamer.com.tw/
2. https://anime1.me

這個問題我 22 年左右就發現了，一直沒有提 ISSUE，也沒有下載下來自己定位看看，時至如今，這個問題依舊，終於在這周看無職轉生的時候，因爲忍受不了，決定着手看看能不能 patch 一個版本自己先用着。

## 問題定位

因爲幾乎沒有大型腳本開發經驗，是個純新手、菜鳥，所以毫不忌諱地說，全程幾乎是用 LLM 幫我去探索的。而且很有意思的是，因爲腳本需要模擬瀏覽器注入的行爲，所以所有操作只能通過 CLI 環境實現，所以發現了很多有意思的東西：

### Chrome DevTools Protocol (CDP)

他和瀏覽器交互使用的協議就是 F12 開發工具與後端交互的那套 —— **JSON-RPC 2.0**，本質來說，讓 Agent 運行無頭模式後：

```shell
Google Chrome --headless=new --remote-debugging-port=9222
```

就能通過請求 9222 端口拿到結構化的數據，通過一個本地的 JS 客戶端，可以進行本地調試：

```js
/**
 * CDP 最小客戶端：通過 Chrome DevTools Protocol 驅動無頭 Chrome
 *
 * 使用前提：以如下方式啓動 Chrome（暴露出調試端點）
 *   Google Chrome --headless=new --remote-debugging-port=9222 --user-data-dir=/tmp/profile
 *
 * 用法示例（配合本文件導出的 newTab / eval / waitFor）：
 *   const { newTab, waitFor } = require('./cdp')
 *   const cdp = await newTab('https://example.com')   // 打開頁面
 *   await waitFor(cdp, `document.querySelector('video') !== null`)  // 等待頁面條件
 *   await cdp.eval(`1 + 1`)                           // 在頁面裏執行 JS
 *
 * 爲什麼需要它：排查"時序競態"類 bug（如本倉庫 tips 樣式殘留問題）時，
 * 靜態讀代碼無法復現問題，需要真實驅動瀏覽器、注入真實腳本、觀察運行時 DOM/CSS。
 * CDP 是公開協議（DevTools 自身就在用），Node 22 內置 WebSocket 客戶端，
 * 因此無需 puppeteer/playwright 等重依賴，手寫這個小客戶端即可。
 */
const http = require('http')

/** HTTP GET 請求輔助（如拉取 http://127.0.0.1:9222/json 獲取標籤頁列表） */
function getJSON (url) {
  return new Promise((resolve, reject) => {
    http.get(url, (res) => {
      let data = ''
      res.on('data', (c) => { data += c })
      res.on('end', () => resolve(JSON.parse(data)))
    }).on('error', reject)
  })
}

let id = 0

/**
 * CDP 會話封裝：通過 WebSocket 與瀏覽器通信
 * 協議是 JSON-RPC 風格：發送 { id, method, params }，瀏覽器回 { id, result/error }；
 * 沒有 id 的消息是瀏覽器主動推送的事件（如 console 日誌），統一收集到 this.events
 */
class CDP {
  constructor (ws) {
    this.ws = ws
    this.pending = new Map() // 記錄"已發送但未返回"的命令，靠 id 對應響應
    this.events = [] // 收集瀏覽器主動推送的事件（異常、console 輸出等）
    ws.onmessage = (ev) => {
      const msg = JSON.parse(ev.data)
      if (msg.id && this.pending.has(msg.id)) {
        // 有 id 且匹配到待處理命令 → 兌現對應 Promise
        const { resolve, reject } = this.pending.get(msg.id)
        this.pending.delete(msg.id)
        msg.error ? reject(new Error(JSON.stringify(msg.error))) : resolve(msg.result)
      } else if (msg.method) {
        this.events.push(msg)
      }
    }
  }

  /** 發送一條 CDP 命令（method 如 'Runtime.evaluate'、'Page.navigate'），返回其 result */
  send (method, params = {}) {
    const msgId = ++id
    return new Promise((resolve, reject) => {
      this.pending.set(msgId, { resolve, reject })
      this.ws.send(JSON.stringify({ id: msgId, method, params }))
    })
  }

  /** 在頁面上下文裏執行一段 JS 表達式並取回結果（awaitPromise 支持返回 Promise 的表達式） */
  async eval (expression, awaitPromise = true) {
    const r = await this.send('Runtime.evaluate', { expression, awaitPromise, returnByValue: true })
    if (r.exceptionDetails) throw new Error('eval exception: ' + JSON.stringify(r.exceptionDetails))
    return r.result.value
  }
}

/**
 * 創建一個新標籤頁並建立 CDP 會話
 * 注：新版 Chrome 的 /json/new 只接受 PUT 方法（GET 會返回 400），
 * 需要創建空白頁時傳空 url
 */
async function newTab (url) {
  const opts = url ? { method: 'PUT' } : { method: 'PUT', body: '' }
  const raw = await new Promise((resolve, reject) => {
    const req = http.request('http://127.0.0.1:9222/json/new', opts, (res) => {
      let data = ''
      res.on('data', (c) => { data += c })
      res.on('end', () => resolve(data))
    })
    req.on('error', reject)
    if (url) {
      req.write(url)
    } else {
      req.write('about:blank')
    }
    req.end()
  })
  const tab = JSON.parse(raw)
  const ws = new WebSocket(tab.webSocketDebuggerUrl)
  await new Promise((resolve, reject) => { ws.onopen = resolve; ws.onerror = reject })
  const cdp = new CDP(ws)
  await cdp.send('Runtime.enable')
  await cdp.send('Page.enable')
  return cdp
}

/** 輪詢等待頁面滿足某個條件（如某元素出現），超時則拋錯 */
async function waitFor (cdp, expression, timeout = 30000) {
  const start = Date.now()
  while (Date.now() - start < timeout) {
    try {
      if (await cdp.eval(expression)) return true
    } catch (e) {}
    await new Promise((r) => setTimeout(r, 300))
  }
  throw new Error('waitFor timeout: ' + expression)
}

module.exports = { CDP, newTab, waitFor }
```

然後就可以通過外部調用把我們的 JS 腳本送進去：

```js
// 客戶端做的事：把 dist 源碼作爲字符串塞給頁面
await cdp.eval(`(() => {
  const s = document.createElement('script')
  s.textContent = ${JSON.stringify(us)}   // us = dist/h5player.user.js 的源碼文本
  document.body.appendChild(s)            // 頁面瀏覽器解析並執行它
  return true
})()`)

```

### WebDriver BiDi

類似的，因爲 Firefox 徹底不支持了 CDP，兩者主要有如下區別：

|      | Chrome CDP                                                  | Firefox WebDriver BiDi                                              |
| ---- | ----------------------------------------------------------- | ------------------------------------------------------------------- |
| 出身   | 專有協議                                                        | W3C 標準（2024 正式化），跨瀏覽器通用                                             |
| 建會話  | HTTP `PUT /json/new` 建標籤頁 → 每個標籤頁一個 WebSocket 端點            | 直接連 `ws://host:port/session` → 發 `session.new` 命令                   |
| 命令風格 | `Runtime.evaluate`、`Page.navigate`、`Input.dispatchKeyEvent` | `script.evaluate`、`browsingContext.navigate`、`input.performActions` |
| 事件訂閱 | 連接後自動收到（無訂閱機制）                                              | 需先 `session.subscribe` 顯式訂閱                                         |
| 能力範圍 | 極全：網絡攔截、性能剖析、模擬等                                            | 聚焦 WebDriver 需求：導航、腳本、輸入、日誌                                         |

協議本質相同——都是 **JSON-RPC over WebSocket**：發 `{id, method, params}`，收 `{id, result}`。所以需要根據 Bidi 再次手搓一個腳本，跟上個版本只有 " 建會話 " 和 " 方法名 " 不同：

```js
/**
 * WebDriver BiDi 最小客戶端：驅動 Firefox（與 debug/cdp.js 的 Chrome CDP 版對應）
 *
 * 使用前提：以如下方式啓動 Firefox（暴露 BiDi 端點）
 *   "Firefox Developer Edition.app/Contents/MacOS/firefox" \
 *     --headless --remote-debugging-port=9223 --profile /tmp/ff-profile
 *
 * 用法示例：
 *   const { connect } = require('./bidi2')
 *   const bidi = await connect()                          // 建會話
 *   await bidi.navigate('https://example.com')            // 打開頁面
 *   await bidi.eval(`document.title`)                     // 在頁面裏執行 JS
 *
 * 爲什麼需要它：Firefox 已移除 CDP，只支持 W3C 標準的 WebDriver BiDi。
 * 協議同樣是 JSON-RPC over WebSocket（與 CDP 同構），
 * 但建會話方式、命令命名（script.evaluate / browsingContext.navigate /
 * input.performActions）與 CDP 不同，故單獨寫一個客戶端。
 */
const http = require('http')

let id = 0

/**
 * BiDi 會話封裝：通過 WebSocket 與 Firefox 通信
 * 與 CDP 版相同的模式：發 { id, method, params }，收 { id, result/error }，
 * 用 pending Map 把命令 id 與 Promise 對應起來
 */
class BiDi {
  constructor (ws) {
    this.ws = ws
    this.pending = new Map()
    ws.onmessage = (ev) => {
      const msg = JSON.parse(ev.data)
      if (msg.id && this.pending.has(msg.id)) {
        const { resolve, reject } = this.pending.get(msg.id)
        this.pending.delete(msg.id)
        msg.error ? reject(new Error(JSON.stringify(msg.error))) : resolve(msg.result)
      }
    }
  }

  /** 發送一條 BiDi 命令（如 'script.evaluate'、'session.new'），返回其 result */
  send (method, params = {}) {
    const msgId = ++id
    return new Promise((resolve, reject) => {
      this.pending.set(msgId, { resolve, reject })
      this.ws.send(JSON.stringify({ id: msgId, method, params }))
    })
  }

  /** 在頁面上下文執行 JS 並取回結果（target.context 必須是建會話時拿到的頂層 context id） */
  async eval (expression) {
    const r = await this.send('script.evaluate', {
      expression,
      target: { context: this.context },
      awaitPromise: true,
      returnByValue: true
    })
    const res = r.result
    if (res && res.type === 'exception') {
      throw new Error('eval exception: ' + JSON.stringify(res.exceptionDetails))
    }
    return res && res.type === 'undefined' ? undefined : res.value
  }

  /** 頁面導航（等價於 CDP 的 Page.navigate） */
  async navigate (url) {
    await this.send('browsingContext.navigate', { context: this.context, url })
  }

  /**
   * 註冊文檔加載前預執行腳本（等價於 Chrome 的 Page.addScriptToEvaluateOnNewDocument）
   * 注意：排查 h5player 時實測注入的 GM_* stub 在 eval 裏讀不到（realm 隔離/時序問題），
   * 最終方案是導航完成後直接用 eval 注入 stub，此方法保留備用
   */
  async addPreloadScript (functionDeclaration) {
    const r = await this.send('script.addPreloadScript', { functionDeclaration })
    return r.script
  }

  /**
   * 發送按鍵（等價於 CDP 的 Input.dispatchKeyEvent）
   * 注意：value 須用 WebDriver 標準按鍵碼（如 Enter = '\uE007'），
   * 直接傳 'Enter' 字符串會報 "invalid argument"
   */
  async keyPress (keyValue) {
    await this.send('input.performActions', {
      context: this.context,
      actions: [
        { type: 'key', id: 'kb1', actions: [{ type: 'keyDown', value: keyValue }, { type: 'keyUp', value: keyValue }] }
      ]
    })
  }
}

/**
 * 建立 BiDi 會話
 * 與 Chrome 不同：Firefox 不提供 HTTP 建會話端點（POST /session 會返回
 * "The handshake request must use GET method"），必須直接連接
 * ws://host:port/session，然後在 WebSocket 上發送 session.new 命令完成握手
 */
async function connect (port = 9223) {
  const ws = new WebSocket(`ws://127.0.0.1:${port}/session`)
  await new Promise((resolve, reject) => { ws.onopen = resolve; ws.onerror = () => reject(new Error('ws error')) })
  const bidi = new BiDi(ws)
  const session = await bidi.send('session.new', {
    capabilities: { alwaysMatch: { webSocketUrl: true, acceptInsecureCerts: true } }
  })
  const contexts = await bidi.send('browsingContext.getTree')
  bidi.context = contexts.contexts[0].context
  return bidi
}

module.exports = { BiDi, connect }
```

### 巴哈姆特 CSS 問題

最開始也沒找到原因，但是根據視頻高度不變的現象

![](https://github.com/user-attachments/assets/65ea89c4-a678-4f96-a288-dec7f71ae786)

![](https://github.com/user-attachments/assets/a90cc8ac-8e9b-4760-9ffe-7da500b0cdeb)

初步我們可以鎖定，出問題的其實是頁面後來注入的三個屬性：

```css
min-width: 952.8515625px;
min-height: 535.9765625px;
position: relative;
```

![](https://pub-89c11651a8434f18a530bd6f93e399da.r2.dev/2026/20260811214326292.webp)

問題找到了，代碼改起來就有方向了，那麼這個東西是怎麼引入的？

前兩個其實光看名字就知道影響不大，因爲他們定義的是最小寬高，代碼源於：

```js
//https://github.com/bgzo/h5player/blob/0571852e296fbd5f1258943508edf16d7e1ea708/src/h5player/h5player.js#L1634-L1640
const playerBox = player.getBoundingClientRect()
const parentNodeBox = parentNode.getBoundingClientRect()
/* 不存在高寬時，給包裹節點一個最小高寬，才能保證提示能正常顯示 */
if (!parentNodeBox.width || !parentNodeBox.height) {
	newStyleArr.push('min-width:' + playerBox.width + 'px')
	newStyleArr.push('min-height:' + playerBox.height + 'px')
}
```

如果播放器周圍不存在寬高，那就直接加入當前視頻的寬高作爲基準即可，直接注入這兩個樣式不會生效，最致命的就是：

```css
position: relative;
```

就在上面代碼的前幾行：

```js
// https://github.com/bgzo/h5player/blob/0571852e296fbd5f1258943508edf16d7e1ea708/src/h5player/h5player.js#L1626-L1632
const oldPosition = parentNode.getAttribute('def-position') || window.getComputedStyle(parentNode).position
if (parentNode.getAttribute('def-position') === null) {
	parentNode.setAttribute('def-position', oldPosition || '')
}
if (['static', 'inherit', 'initial', 'unset', ''].includes(oldPosition)) {
	newStyleArr.push('position: relative')
}
```

這裏其實我們可以看到它備份了舊位置 oldPosition 到 def-position，當舊位置不存在定位上下文的時候，強制賦值爲 relative 屬性。

爲什麼這裏判斷這麼多值？

這些值都有一個共同點：**它們都不會讓元素成爲一個“定位祖先”**（即不會建立新的定位上下文）。在 CSS 中，只有 `relative`、`absolute`、`fixed`、`sticky` 纔會讓元素成爲子元素 `position: absolute` 的參照容器。

- **`static`**：默認值，元素在正常文檔流中，`top/right/bottom/left` 無效，不建立定位上下文。
- **`inherit`**：繼承父元素的 `position` 值。如果父元素也是 `static`，最終結果還是 `static`，同樣無定位上下文。
- **`initial`**：重置爲規範初始值，即 `static`。
- **`unset`**：如果是繼承屬性則繼承，否則初始值；對 `position` 而言，最終也是 `static`（因爲 `position` 是非繼承屬性，所以 `unset` 等價於 `initial` → `static`）。
- **`''`（空字符串）**：可能來自解析異常、未傳入值或用戶配置缺失，通常會當成未設置，也默認當作 `static` 處理。

**所以，只要 `oldPosition` 是這五種情況之一，就說明當前元素並沒有建立定位上下文。**
而這段代碼的目的，就是人爲地知道一個定位上下文，好讓後面追加的左上角元素正常顯示，能相對於這個父元素定位。

那爲什麼這個元素之後沒有移除掉呢？如果觸發多次 Tips，你其實可以觀察到 `position: relative;` 屬性被注入了好幾次；我們定位到 Tips 條顯示代碼：

```js
// https://github.com/bgzo/h5player/blob/0571852e296fbd5f1258943508edf16d7e1ea708/src/h5player/h5player.js#L1680-L1693
function showTips () {
  style.display = 'block'
  t.on_off[0] = setTimeout(function () {
	style.opacity = 1
  }, 50)
  t.on_off[1] = setTimeout(function () {
	// 隱藏提示框和還原樣式
	style.opacity = 0
	style.display = 'none'
	if (backupStyle) {
	  parentNode.setAttribute('style', backupStyle)
	}
  }, 2000)
}
```

可以發現，只有一種情況，會跳過賦值，那就是 backupStyle 爲空的時候，那麼 backupStyle 的賦值呢？

```js
// https://github.com/bgzo/h5player/blob/0571852e296fbd5f1258943508edf16d7e1ea708/src/h5player/h5player.js#L1592-L1621
let backupStyle = ''
if (!isAudio) {
  // 修復部分提示按鈕位置異常問題
  const defStyle = parentNode.getAttribute('style') || ''

  backupStyle = parentNode.getAttribute('style-backup') || ''
  if (!backupStyle) { // 爲空備份
	let backupSty = defStyle || 'style-backup: none'
	const backupStyObj = inlineStyleToObj(backupSty)

	/**
	 * 修復因爲緩存時機獲取到錯誤樣式的問題
	 * 例如在：https://www.xuetangx.com/
	 */
	if (backupStyObj.opacity === '0') {
	  backupStyObj.opacity = '1'
	}
	if (backupStyObj.visibility === 'hidden') {
	  backupStyObj.visibility = 'visible'
	}

	backupSty = objToInlineStyle(backupStyObj)

	parentNode.setAttribute('style-backup', backupSty)
	backupStyle = defStyle
  } else {
	/* 如果defStyle被外部修改了，則需要更新備份樣式 */
	if (defStyle && !defStyle.includes('style-backup')) {
	  backupStyle = defStyle
	}
  }
  // .....
```

這裏其實可以看到兩個問題：

1. 如果 defStyle 本來就是空的，那就備份也一直都是空的，那麼下面的樣式就永遠無法還原（本次情況）
2. 如果 backupStyle 在後續操作中已經有有有值了，但是這裏賦值的時候沒有排除我們之前強制注入的定位屬性 relative

最終的現象就是，一直觸發 Tips，這個 relative 就一直增加。

那麼問題清楚了，就提 PR 了： https://github.com/xxxily/h5player/pull/755

Source via: https://note.bgzo.cc/weekly/20260811-fix-h5player-bahamut-fix-width