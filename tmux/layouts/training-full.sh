#!/bin/bash
# 四栏全功能布局: 代码 | 训练
#                  日志 | 监控

# 分割当前窗格为左右两栏
tmux split-window -h -c "#{pane_current_path}"

# 在左边栏分割为上下两栏
tmux select-pane -t 0
tmux split-window -v -c "#{pane_current_path}"

# 在右边栏分割为上下两栏
tmux select-pane -t 2
tmux split-window -v -c "#{pane_current_path}"

# 在右下窗格运行监控 (htop 或 top)
tmux select-pane -t 3
if command -v htop &> /dev/null; then
    tmux send-keys "htop" C-m
elif command -v nvidia-smi &> /dev/null; then
    tmux send-keys "watch -n 1 nvidia-smi" C-m
else
    tmux send-keys "top" C-m
fi

# 选择左上窗格 (用于编辑代码)
tmux select-pane -t 0

# 显示提示信息
tmux display-message "布局: 代码|训练 / 日志|监控"
