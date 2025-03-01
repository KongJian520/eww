#!/bin/sh

# 亮度文件路径
BRIGHTNESS_FILE="/sys/class/backlight/nvidia_0/actual_brightness"
MAX_BRIGHTNESS_FILE="/sys/class/backlight/nvidia_0/max_brightness"


doing() {
    brightness=$(cat "$BRIGHTNESS_FILE")
    max_brightness=$(cat "$MAX_BRIGHTNESS_FILE")
    percentage=$((brightness * 100 / max_brightness))
    echo "$percentage"  # 输出当前亮度的百分比，不带%
}
doing
# 监听亮度文件的变化
inotifywait -m -e modify "$BRIGHTNESS_FILE" | while read path action file; do
    doing # 输出当前亮度的百分比，不带%
done
