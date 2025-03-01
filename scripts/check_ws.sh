#!/bin/sh

# 定义一个函数来生成 JSON
generate_json() {
    # 创建一个空的 JSON 对象
    json="{"
    
    # 获取工作区 ID
    ids=$(hyprctl -j workspaces | jq '.[].id')
    
    # 将工作区 ID 存储在数组中
    declare -A id_map
    
    # 将获取到的 ID 设置为 true
    for id in $ids; do
        id_map[$id]=true
    done
    
    # 循环从 1 到 10
    for i in {1..10}; do
        # 检查 ID 是否存在于 id_map 中
        if [[ -n "${id_map[$i]}" ]]; then
            value="true"
        else
            value="false"
        fi
        
        # 添加到 JSON 对象中
        json+="\"$i\": $value, "
    done
    
    # 移除最后一个多余的逗号和空格
    json=${json%, }
    
    # 关闭 JSON 对象
    json+="}"
    
    # 输出 JSON
    echo "$json"
}

echo '{"1": false, "2": false, "3": false, "4": false, "5": false, "6": false, "7": false, "8": false, "9": false, "10": false}'
generate_json
# 使用 socat 监听输入
socat -u UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r; do
    # 每次接收到数据时调用 generate_json 函数
    generate_json
done
