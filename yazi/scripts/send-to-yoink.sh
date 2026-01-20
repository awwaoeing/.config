#!/bin/bash
# 将文件发送到 Yoink 的脚本

# 获取所有选中的文件路径
files=("$@")

if [ ${#files[@]} -eq 0 ]; then
    echo "没有选中文件"
    exit 1
fi

# 使用 open 命令将文件发送到 Yoink
for file in "${files[@]}"; do
    # 转换为绝对路径
    if [[ "$file" = /* ]]; then
        abs_path="$file"
    else
        abs_path="$(cd "$(dirname "$file")" 2>/dev/null && pwd)/$(basename "$file")"
    fi

    # 使用 open -a 命令打开文件到 Yoink
    open -a "Yoink" "$abs_path" 2>/dev/null

    if [ $? -eq 0 ]; then
        echo "✓ $(basename "$abs_path")"
    else
        echo "✗ $(basename "$abs_path")"
    fi
done

echo ""
echo "完成: ${#files[@]} 个文件已发送到 Yoink"
