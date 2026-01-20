#!/bin/bash
# 获取 CPU 使用率

# 检测操作系统
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - 使用 top 命令
    cpu_usage=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | tr -d '%')
    # 如果获取失败,使用 iostat
    if [ -z "$cpu_usage" ]; then
        cpu_usage=$(iostat -c 2 | tail -1 | awk '{print 100-$6}' | cut -d. -f1)
    fi
else
    # Linux - 使用 mpstat 或 top
    if command -v mpstat &> /dev/null; then
        cpu_usage=$(mpstat 1 1 | tail -1 | awk '{print 100-$NF}' | cut -d. -f1)
    else
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | tr -d '%us,')
    fi
fi

# 确保有值
cpu_usage=${cpu_usage:-0}

# 根据使用率选择颜色
if [ "${cpu_usage%.*}" -gt 80 ]; then
    color="#[fg=#bf616a]"  # 红色 (高负载)
elif [ "${cpu_usage%.*}" -gt 50 ]; then
    color="#[fg=#ebcb8b]"  # 黄色 (中负载)
else
    color="#[fg=#a3be8c]"  # 绿色 (低负载)
fi

echo "${color}CPU:${cpu_usage}%"
