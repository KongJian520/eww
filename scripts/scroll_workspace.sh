#!/bin/sh

# 检查参数是否提供
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {up|down}"
    exit 1
fi

# 调用同级的 current_workspace.sh 获取当前值
current_workspace=$(hyprctl activeworkspace | grep 'workspace ID' | awk '{print $3}')

# 检查 current_workspace.sh 的返回值是否为数字
if ! [[ "$current_workspace" =~ ^[0-9]+$ ]]; then
    echo "Error: current_workspace.sh must return a non-negative integer."
    exit 1
fi

# 根据参数决定是增加还是减少
if [ "$1" == "up" ]; then
    new_value=$((current_workspace - 1))
    elif [ "$1" == "down" ]; then
    new_value=$((current_workspace + 1))
else
    echo "Error: Invalid argument. Use 'up' or 'down'."
    exit 1
fi

# 计算对 10 的模
result=$((new_value % 10))

# 如果结果为 0，则定义为 10
if [ "$result" -eq 0 ]; then
    result=10
fi


hyprctl dispatch workspace -q   $result