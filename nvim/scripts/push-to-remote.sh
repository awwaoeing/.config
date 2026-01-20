#!/bin/bash

# Git 推送脚本
# 用于推送 Neovim 配置到远程仓库

set -e  # 遇到错误立即退出

# 禁用 Git 分页器,避免输出被 less 等工具捕获
export GIT_PAGER=cat

echo "=========================================="
echo "Git 推送脚本"
echo "=========================================="
echo ""

# 检查当前目录
CURRENT_DIR=$(pwd)
echo "当前目录: $CURRENT_DIR"
echo ""

# 检查是否在 git 仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ 错误: 当前不在 git 仓库中"
    exit 1
fi

# 显示远程仓库信息
echo "远程仓库:"
git remote -v
echo ""

# 显示当前分支
CURRENT_BRANCH=$(git branch --show-current)
echo "当前分支: $CURRENT_BRANCH"
echo ""

# 显示提交状态
echo "最近的提交:"
git log -1 --oneline
echo ""

# 测试 SSH 连接
echo "测试 GitHub SSH 连接..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ SSH 连接正常"
else
    echo "⚠️  SSH 连接可能有问题,但仍会尝试推送"
fi
echo ""

# 执行推送
echo "开始推送到远程仓库..."
echo "执行命令: git push origin $CURRENT_BRANCH"
echo ""

if git push origin "$CURRENT_BRANCH"; then
    echo ""
    echo "=========================================="
    echo "✅ 推送成功!"
    echo "=========================================="
else
    echo ""
    echo "=========================================="
    echo "❌ 推送失败!"
    echo "=========================================="
    echo ""
    echo "可能的解决方案:"
    echo "1. 检查网络连接"
    echo "2. 验证 SSH 密钥: ssh -T git@github.com"
    echo "3. 检查是否有权限推送到该仓库"
    echo "4. 尝试使用 HTTPS 而非 SSH:"
    echo "   git remote set-url origin https://github.com/awwaoeing/lazyvim_config.git"
    exit 1
fi
