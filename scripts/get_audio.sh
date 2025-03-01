#!/bin/sh

# 获取当前音量并格式化为三位数字
get_current_volume() {
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//')
    mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
    
    if [ "$mute" = "yes" ]; then
        echo "000"  # 静音时输出000
    else
        printf "%03d\n" "$volume"  # 非静音时输出当前音量
    fi
}

# 输出初始音量
get_current_volume

# 订阅PulseAudio事件
pactl subscribe | while read -r line; do
    # 检查是否是音量变化或静音状态变化的事件
    if echo "$line" | grep -q "sink"; then
        get_current_volume
    fi
done
