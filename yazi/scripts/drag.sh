#!/bin/bash
# Yazi 拖拽脚本

# 记录日志用于调试
echo "拖拽文件: $@" >> /tmp/yazi_drag.log
echo "时间: $(date)" >> /tmp/yazi_drag.log

# 启动 ripdrag
/Users/charles_chx/.cargo/bin/ripdrag -x "$@" >> /tmp/yazi_drag.log 2>&1 &

# 记录进程 ID
echo "ripdrag PID: $!" >> /tmp/yazi_drag.log
