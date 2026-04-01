---
comments: True
draft: False
aliases: ['導出微博喜歡列表']
created: 2025-12-28 15:22:59
modified: 2025-12-28 18:31:10
tags: ['writing/lab', 'export-to-obsidian']
title: 導出微博喜歡列表
description: 與 導出 V2ex 的收藏主題 和 導出知乎收藏夾 的理由相似，一來爲了做覆盤，而來爲了備份自己賬號的數據，玩意哪天賬號被封禁了，或者不想要了，直接可以拋棄，做到沒有成本。 實現 接口比較簡單，沒有加密，核心邏輯如下： 不用你說我都知道代碼套了這麼多層有點噁心，但是請允許我先吐槽一下微博爲的報文， 因爲好多之前的微博被刪了，或者博主不展示了，所以列表裏面就會展示一些不規範的報文： 加上我也懶得適配...
---

與 導出 V2ex 的收藏主題 和 導出知乎收藏夾 的理由相似，一來爲了做覆盤，而來爲了備份自己賬號的數據，玩意哪天賬號被封禁了，或者不想要了，直接可以拋棄，做到沒有成本。

## 實現

接口比較簡單，沒有加密，核心邏輯如下：

```python
def weibo(uid: int, output: str, force: bool):
    result_index = "";
    page_index = 1
    while True:
        page = get_weibo_like_list(uid, page_index)
        if page is None:
            print("獲取微博喜歡列表失敗，請檢查接口")
            break

        if page.ok == 1:
            list = page.data.list
            if len(list) == 0:
                break

            for item in list:
                try:
                    post_id = item.mblogid
                    post_user = item.user.id
                    post_url = f"https://weibo.com/{post_user}/{post_id}"
                    filename = f"{post_user}-{post_id}"

                    # 提前剪枝
                    if not force:
                        file_path = os.path.join(output, f"~{filename}.md")
                        if os.path.exists(file_path):
                            print(f"已存在: {filename}.md，同步結束")
                            print("導出index\n", result_index)
                            return

                    auther_name = item.user.screen_name
                    context_digest = get_clean_filename(item.text_raw[:10])
                    title = auther_name + ":" + context_digest

                    created_at_str = item.created_at
                    article = item.text_raw
                    # 如果是長文本
                    if item.isLongText:
                        longtext = get_weibo_longtext_by_id(post_id)
                        if longtext is not None:
                            article = get_weibo_longtext_by_id(post_id)

                    # %a: 縮寫星期 (Wed)
                    # %b: 縮寫月份 (Dec)
                    # %d: 日期 (24)
                    # %H:%M:%S: 時間 (04:08:45)
                    # %z: 時區偏移 (+0800)
                    # %Y: 年份 (2025)
                    dt_obj = datetime.strptime(created_at_str, "%a %b %d %H:%M:%S %z %Y")
                    webpage = WebPage(
                        comments=True,
                        draft=True,
                        title=title,
                        source=post_url,
                        created=dt_obj.strftime("%Y-%m-%dT%H:%M:%S"),
                        modified=dt_obj.strftime("%Y-%m-%dT%H:%M:%S"),
                        type="archive-web"
                    )
                    md = dump_markdown_with_frontmatter(
                        webpage.__dict__,
                        article + '\n\n' + handle_weibo_pic(item)
                    )
                    output_content_to_file_path(
                        output,
                        filename,
                        md,
                        "md")

                    print(f"Done: {title}")
                    result_index += f'\n- {title}'

                except Exception as e:
                    print(f"處理報文發生錯誤: {e}，微博可能已經被刪除，跳過處理")

            page_index += 1

        else:
            print("獲取微博喜歡列表失敗，請檢查接口")
            break

def handle_weibo_pic(item) -> str:
    if item.pic_num is None or item.pic_num == 0 or item.pic_ids is None or len(item.pic_ids) == 0 :
        return ""
    result = ""
    pic_infos = item.pic_infos
    for pic_id in item.pic_ids:
        pic_info = pic_infos[pic_id]
        url = pic_info.largest['url']
        result += f"![{pic_id}]({url})\n\n"
    return result
```

不用你說我都知道代碼套了這麼多層有點噁心，但是請允許我先吐槽一下微博爲的報文， 因爲好多之前的微博被刪了，或者博主不展示了，所以列表裏面就會展示一些不規範的報文：

```json
{
	"visible": {
	  "type": 0,
	  "list_id": 0
	},
	"created_at": "Thu May 22 15:26:53 +0800 2025",
	"id": 5169124633215311,
	"idstr": "5169124633215311",
	"mid": "5169124633215311",
	"mblogid": "Pt0fldurR",
	"source": "",
	"attitudes_status": 1,
	"deleted": "1",
	"share_repost_type": 0,
	"showFeedRepost": false,
	"showFeedComment": false,
	"pictureViewerSign": false,
	"showPictureViewer": false,
	"rcList": [],
	"analysis_extra": "",
	"readtimetype": "mblog",
	"mblog_feed_back_menus_format": [],
	"isAd": false,
	"isSinglePayAudio": false,
	"text": "抱歉，此微博已被刪除。查看幫助：<a target=\"_blank\" href=\"https://t.cn/EAL6hw7\"><img class=\"icon-link\" src=\"https://h5.sinaimg.cn/upload/2015/09/25/3/timeline_card_small_web_default.png\"/>網頁鏈接</a>",
	"text_raw": "抱歉，此微博已被刪除。查看幫助：http://t.cn/EAL6hw7"
  }
```

加上我也懶得適配了，所以就寫成這樣了，嘻嘻。

## 侷限

當然這樣的實現非常快，且仍然有幾個侷限：

1. **圖片防盜鏈**，在一些沒有防盜鏈處理的地方，比如編輯器，圖片會顯示，但是像是黑曜石這裏就無法顯示；
2. **Cookie 過期時間**，過期時間還不明確，但大概不超過半個月，也就是說，如果想要每週進行數據導出的話，需要每週事先去對應的頁面去抓包獲取 Cookie，確實有點扯。。。

### 如何使用

```shell
pipx install export_to_obsidian
export WEIBO_COOKIE=""
eto weibo -u xxx -o ./weibo
```

`-u` 是你的用戶 ID，可以去頁面路由中取得，如：

```shell
https://weibo.com/u/page/like/xxx
```

xxx 就是你的 UID

Source via: https://note.bgzo.cc/weekly/1272-export-weibo-like-list