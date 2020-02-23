---
title: Git命令整理
tags:
  - git
description: git指令整理
abbrlink: 2687911277
date: 2020-02-23 22:39:06
---
# 初始化
```git
git init
```

# 版本管理
* 添加文件：git add \<fileName>
* 提交至暂存区：git commit -m "something"
* 查看状态：git status
* 查看不同：git diff \<fileName>
* 查看日志：git log
* 回滚历史版本：git reset --hard \<commit_id>
* 查看命令历史：git reflog
* 丢弃工作区修改：git checkout -- file
* 丢弃暂存区修改：git reset HEAD \<fileName>
* 删除文件：git rm \<fileName>

# 远程仓库
* 关联远程仓库：git remote add origin \<address>
* 推送并关联master分支：git push -u origin master
* 推送master分支：git push origin master
* 克隆项目：git clone \<address>

# 分支
* 创建分支：git branch \<name>
* 切换分支：git checkout \<name>
* 创建并切换分支：git checkout -b \<name>
* 查看当前分支：git branch
* 与当前分支合并：git merge \<name>
* 删除分支：git branch -d \<name>
* 产看合并图：git log --graph
* 推送分支：git push origin \<name>
* 拉取：git pull
* 链接关系创建：git branch --set-upstream-to \<name> origin/\<name>
* 查看远程库信息：git remote -v
## 新版本命令
* 创建：git switch -c \<name>
* 切换：git switch \<name>

## Bug分支
* 暂存当前分支：git stash
* 查看当前暂存列表：git stash list
* 恢复暂存：git stash apply
* 删除暂存：git stash drop
* 恢复暂存并删除：git stash pop
* 复制bug分支修改内容到当前分支：git cherry-pick \<commit>

# 标签
* 创建标签：git tag \<name> ?\<commit>
* 查看所有标签：git tag
* 查看标签详情：git show \<name>
* 创建带注释的标签：git tag -a \<name> -m "\<message>" \<commit>
* 删除标签：git tag -d \<name>
* 推送标签：git push origin \<name>
* 推送所有标签：git push origin --tags
* 删除远程标签：git push origin :refs/tags/\<name>
