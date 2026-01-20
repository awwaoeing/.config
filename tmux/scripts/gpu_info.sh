#!/bin/bash
# 获取 GPU 使用率和温度信息 (支持多GPU)

# 检查是否有 nvidia-smi
if command -v nvidia-smi &> /dev/null; then
    # NVIDIA GPU - 获取 GPU 数量
    gpu_count=$(nvidia-smi --list-gpus | wc -l)

    if [ "$gpu_count" -eq 1 ]; then
        # 单卡模式 - 显示详细信息
        gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -1)
        gpu_temp=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits | head -1)

        # 根据使用率选择颜色
        if [ "$gpu_usage" -gt 80 ]; then
            color="#[fg=#bf616a]"  # 红色 (高负载)
        elif [ "$gpu_usage" -gt 50 ]; then
            color="#[fg=#ebcb8b]"  # 黄色 (中负载)
        else
            color="#[fg=#a3be8c]"  # 绿色 (低负载)
        fi

        echo "${color}GPU:${gpu_usage}% ${gpu_temp}°C"
    else
        # 多卡模式 - 显示所有卡的使用率
        output="GPU:"
        while IFS= read -r gpu_usage; do
            # 选择颜色
            if [ "$gpu_usage" -gt 80 ]; then
                color="#[fg=#bf616a]"
            elif [ "$gpu_usage" -gt 50 ]; then
                color="#[fg=#ebcb8b]"
            else
                color="#[fg=#a3be8c]"
            fi
            output="${output}${color}${gpu_usage}#[fg=#d8dee9]% "
        done < <(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)

        echo "$output"
    fi
elif command -v rocm-smi &> /dev/null; then
    # AMD GPU
    gpu_usage=$(rocm-smi --showuse | grep 'GPU use' | awk '{print $4}' | tr -d '%')
    echo "GPU:${gpu_usage}%"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - 无 GPU 监控或使用 Metal
    echo "GPU:N/A"
else
    # 其他系统,无 GPU
    echo "GPU:N/A"
fi
