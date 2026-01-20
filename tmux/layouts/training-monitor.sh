#!/bin/bash
# 三栏监控布局: 训练脚本 | GPU监控 | CPU监控

# 分割当前窗格为左右两栏 (70%-30%)
tmux split-window -h -p 30 -c "#{pane_current_path}"

# 在右侧栏再分割为上下两栏
tmux split-window -v -c "#{pane_current_path}"

# 在右上窗格运行 GPU 监控 (如果有 nvidia-smi)
tmux select-pane -t 1
if command -v nvidia-smi &> /dev/null; then
    tmux send-keys "watch -n 1 nvidia-smi" C-m
else
    tmux send-keys "echo 'GPU监控: nvidia-smi 不可用'" C-m
fi

# 在右下窗格运行 CPU 监控
tmux select-pane -t 2
if command -v htop &> /dev/null; then
    tmux send-keys "htop" C-m
else
    tmux send-keys "top" C-m
fi

# 选择左边窗格 (用于运行训练脚本)
tmux select-pane -t 0

# 显示提示信息
tmux display-message "布局: 训练 | GPU | CPU"
