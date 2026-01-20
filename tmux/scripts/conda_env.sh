#!/bin/bash
# 获取当前激活的 Conda 或虚拟环境名

# 检查 Conda 环境
if [ -n "$CONDA_DEFAULT_ENV" ]; then
    echo "($CONDA_DEFAULT_ENV)"
    exit 0
fi

# 检查 Python 虚拟环境
if [ -n "$VIRTUAL_ENV" ]; then
    env_name=$(basename "$VIRTUAL_ENV")
    echo "($env_name)"
    exit 0
fi

# 没有激活任何环境,不输出任何内容
