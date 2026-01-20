#!/bin/bash
# 双栏训练布局: 代码编辑 | 训练日志

# 分割当前窗格为左右两栏 (50%-50%)
tmux split-window -h -c "#{pane_current_path}"

# 选择左边窗格 (用于编辑代码)
tmux select-pane -L

# 显示提示信息
tmux display-message "布局: 代码 | 训练日志"
