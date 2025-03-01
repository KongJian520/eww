#!/bin/sh

socket_path="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

current_workspace=$(hyprctl activeworkspace | grep 'workspace ID' | awk '{print $3}')
echo "$current_workspace"

socat -u UNIX-CONNECT:"$socket_path" - | while read -r event; do
    # Check for both focusedmon and workspacev2 events
    echo "$event" | grep -E '^(focusedmon|workspacev2)>>(.*)' | awk -F'>>' '{print $2}' | awk -F',' '{print $2}'
done    
