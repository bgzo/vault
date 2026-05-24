# +--------------------------+
# Auto Push (changes) Sctipts
# +--------------------------+
# 1. git submodule so parent can use lastest version.
# we assume run this sctipt on root of projects.
# 添加常用工具
git add ./obsidian/
git add ./weekly/
git add ./tools/
git add ./pages/
git add ./journals/2026/
git add -u
git commit -m "docs: update vault by scripts"
git pull --rebase --autostash origin obsidian &&
git push origin obsidian

cd clippers
git add .
git commit -m "docs: update clippers by scripts"
git pull --rebase --autostash origin clippers &&
git push origin clippers 
cd -

# 最后一步失败了也没事
cd .obsidian
git add -u
git commit -m "docs: update config by scripts"
git pull --rebase --autostash origin obsidian-config &&
git push origin obsidian-config
