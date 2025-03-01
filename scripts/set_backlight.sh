#!/bin/sh

# 检查参数是否提供
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {up|down}"
    exit 1
fi

if [ "$1" == "up" ]; then
    brightnessctl set -q +1%
# echo "Brightness increased by 1%."
elif [ "$1" == "down" ]; then
    brightnessctl set -q 2%-
    brightnessctl set -q +1%
    # echo "Brightness decreased by 1%."
else
    echo "Error: Invalid argument. Use 'up' or 'down'."
    exit 1
fi
