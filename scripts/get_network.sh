#!/bin/sh


# 检查参数数量是否正确
if [ "$#" -ne 2 ]; then
    echo "用法: $0 up|down|ssid interface"
    exit 1
fi
INTERFACE=$2

# 获取当前的 SSID

while true; do
    if [ "$1" = "up" ]; then
        # 获取上传速度
        UPLOAD_SPEED=$(nmcli -t -f GENERAL.CONNECTION dev show "$INTERFACE" | grep 'IP4.UP' | awk '{print $2}')
        echo "$UPLOAD_SPEED"
    elif [ "$1" = "down" ]; then
        # 获取下载速度
        DOWNLOAD_SPEED=$(nmcli -t -f GENERAL.CONNECTION dev show "$INTERFACE" | grep 'IP4.DNS' | awk '{print $2}')
        echo " $DOWNLOAD_SPEED"
    elif [ "$1" = "ssid" ]; then
        SSID=$(nmcli -t -f GENERAL.CONNECTION dev show "$INTERFACE" | cut -d':' -f2)
        echo "$SSID"
    else
        echo "无效参数: $1"
        exit 1
    fi

    # 等待 2 秒
    sleep 2
done
