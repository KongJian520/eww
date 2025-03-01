#!/bin/sh

# 检查参数是否提供
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 {up|down|mute}"
    exit 1
fi

if [ "$1" == "up" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ +1%

    # echo "Volume increased by 1%."
elif [ "$1" == "down" ]; then
    pactl set-sink-volume @DEFAULT_SINK@ -1%
    # echo "Volume decreased by 1%."
elif [ "$1" == "mute" ]; then
    # 检查当前静音状态
    MUTE_STATUS=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    
    if [ "$MUTE_STATUS" == "yes" ]; then
        pactl set-sink-mute @DEFAULT_SINK@ 0
        # echo "Audio unmuted."
    else
        pactl set-sink-mute @DEFAULT_SINK@ 1
        # echo "Audio muted."
    fi
else
    echo "Error: Invalid argument. Use 'up', 'down', or 'toggle'."
    exit 1
fi
