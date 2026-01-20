#!/bin/bash
# 获取当前目录的 Git 分支名

# 获取 tmux 当前窗格的工作目录
if [ -n "$TMUX" ]; then
    # 在 tmux 中,获取当前窗格的路径
    current_dir=$(tmux display-message -p '#{pane_current_path}')
else
    current_dir="$PWD"
fi

# 进入该目录并检查是否在 Git 仓库中
cd "$current_dir" 2>/dev/null || exit 0

# 获取 Git 分支名
branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)

if [ -n "$branch" ]; then
    echo "$branch"
fi
