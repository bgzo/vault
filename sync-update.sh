# +--------------------------+
# Auto Push (changes) Sctipts
# +--------------------------+
# 1. git submodule so parent can use lastest version.
# we assume run this sctipt on root of projects.
# 添加常用工具
git pull origin obsidian --no-ff

cd clippers
git pull origin clippers --no-ff
cd -

# 最后一步失败了也没事
cd .obsidian
git pull origin obsidian-config --no-ff
cd -
