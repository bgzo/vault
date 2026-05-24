# #!/bin/bash
# # 同步一系列平台内容到本地
# # git pull origin clippers --ff
# # 1. 先拉取最新的 clippers 分支
# git pull origin clippers --rebase

# # 2. 准备环境变量
# sat_date=$(date -d "saturday" +"%Y%m%d")
# index_file="./newsletters/sync/index/${sat_date}-index.md"
 

# # 3. 同步内容
# # Weread [Obdisian Required]
# # Snippd [Manual export required]
# # RSS reader
# eto --index-file "${index_file}" qireader -t tag-Jw3lnV59k7Vaky2g -o ./qireader/


# # Bangumi
# # 小说
# eto --index-file "${index_file}" bangumi -t ./newsletters/sync/templates/bangumi.md -s 1 -c 2 -o ./bangumi/
# # 动画
# eto --index-file "${index_file}" bangumi -t ./newsletters/sync/templates/bangumi.md -s 2 -c 2 -o ./bangumi/
# # 三次元
# eto --index-file "${index_file}" bangumi -t ./newsletters/sync/templates/bangumi.md -s 3 -c 2 -o ./bangumi/
# # 游戏
# eto --index-file "${index_file}" bangumi -t ./newsletters/sync/templates/bangumi.md -s 4 -c 2 -o ./bangumi/

# # CnBlog
# eto --index-file "${index_file}" cnblog --output ./cnblogs/

# # Zhihu
# eto --index-file "${index_file}" zhihu -c 908297073 -o ./zhihu/

# # V2EX 
# # TODO: 时间顺序 
# eto --index-file "${index_file}" v2ex -o ./v2ex/

# # Telegram TODO

# # Weibo TODO
# # eto --index-file "${index_file}" weibo -u 8221250887 -o ./weibo/

# # bilibili
# eto --index-file "${index_file}" bilibili -f 49128283 -o ./bilibili/

# # 4. 提交到 git
# git add .
# git commit -m "docs(bot): Sync content for ${sat_date}"
# git push origin clippers
