#!/bin/sh

# 定义一个函数来根据 class 返回相应的图标
get_icon() {
    local class="$1" # 第一个参数是 class

    case "$class" in
    "code")
        echo "󰨞" # 只返回图标
        ;;
    "firefox")
        echo "" # 只返回图标
        ;;
    "wechat")
        echo "" # 只返回图标
        ;;
    "thunderbird")
        echo "" # 只返回图标
        ;;
    "baidunetdisk")
        echo "" # 只返回图标
        ;;
    "google-chrome")
        echo "" # 只返回图标
        ;;
    "kitty")
        echo "󰄛" # 只返回图标
        ;;
    *)
        echo " " # 默认返回空字符串
        ;;
    esac
}

# 检查是否提供了参数
if [ "$#" -ne 1 ]; then
    echo "请提供一个参数：'icon' 或 'title'"
    exit 1
fi

# 获取当前活动窗口的标题和类
title=$(hyprctl activewindow -j | jq -r .title) # 使用 -r 选项以获取原始字符串
class=$(hyprctl activewindow -j | jq -r .class) # 使用 -r 选项以获取原始字符串

# 根据输入参数执行不同的操作
input="$1" # 第一个参数

if [[ "$input" == "icon" ]]; then
    result=$(get_icon "$class") # 只返回图标
elif [[ "$input" == "title" ]]; then
    result="$title" # 返回标题
else
    echo "无效的参数：'$input'。请提供 'icon' 或 'title'。"
    exit 1
fi

# 输出结果
echo "$result"

# 套接字路径
socket_path="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# 监听套接字事件
socat -u UNIX-CONNECT:"$socket_path" - | while read -r event; do
    # 只处理以 'activewindow>>' 开头的事件
    if [[ "$event" == activewindow\>\>* ]]; then
        # 提取 'activewindow>>' 后面的值
        window_info="${event#activewindow>>}"

        # 假设 window_info 的格式是 'class,title'
        IFS=',' read -r class title <<<"$window_info"

        # 根据输入参数执行不同的操作
        if [[ "$input" == "icon" ]]; then
            result=$(get_icon "$class") # 只返回图标
        elif [[ "$input" == "title" ]]; then
            result="$title" # 返回标题
        fi

        # 输出结果
        echo "$result"
    fi
done
