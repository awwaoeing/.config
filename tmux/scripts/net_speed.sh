#!/bin/bash
# 显示网络速度 (下载/上传)

# 缓存文件
CACHE_FILE="/tmp/tmux_net_speed_$$"

# 检测操作系统
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    INTERFACE=$(route get default 2>/dev/null | grep interface | awk '{print $2}')
    [ -z "$INTERFACE" ] && INTERFACE="en0"

    # 获取当前流量统计
    current_stats=$(netstat -ibn | grep "$INTERFACE" | head -1)
    rx_bytes=$(echo "$current_stats" | awk '{print $7}')
    tx_bytes=$(echo "$current_stats" | awk '{print $10}')
else
    # Linux
    INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)
    [ -z "$INTERFACE" ] && INTERFACE="eth0"

    # 获取当前流量统计
    rx_bytes=$(cat "/sys/class/net/$INTERFACE/statistics/rx_bytes" 2>/dev/null || echo 0)
    tx_bytes=$(cat "/sys/class/net/$INTERFACE/statistics/tx_bytes" 2>/dev/null || echo 0)
fi

# 如果缓存文件存在,计算速度
if [ -f "$CACHE_FILE" ]; then
    read prev_time prev_rx prev_tx < "$CACHE_FILE"
    current_time=$(date +%s)

    time_diff=$((current_time - prev_time))
    if [ $time_diff -gt 0 ]; then
        rx_speed=$(( (rx_bytes - prev_rx) / time_diff ))
        tx_speed=$(( (tx_bytes - prev_tx) / time_diff ))

        # 格式化速度显示
        format_speed() {
            local speed=$1
            if [ $speed -gt 1048576 ]; then
                printf "%.1fM" $(echo "scale=1; $speed / 1048576" | bc)
            elif [ $speed -gt 1024 ]; then
                printf "%.0fK" $(echo "$speed / 1024" | bc)
            else
                printf "%dB" $speed
            fi
        }

        down=$(format_speed $rx_speed)
        up=$(format_speed $tx_speed)
        echo "↓${down} ↑${up}"
    fi
fi

# 保存当前统计
echo "$(date +%s) $rx_bytes $tx_bytes" > "$CACHE_FILE"
