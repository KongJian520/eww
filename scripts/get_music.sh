#!/bin/sh

prevtitle=''
prevartist=''

get_length_sec() {
    len=$1
    if [ -z "$len" ]; then
        echo 0
    else
        bc <<<"$len / 1000000"
    fi
}

get_length_time() {
    len=$(playerctl metadata mpris:length)
    if [ -n "$len" ]; then
        # 将长度从微秒转换为秒
        len=$((len / 1000000))
        # 格式化输出为分钟:秒
        printf "%02d:%02d\n" $((len / 60)) $((len % 60))
    else
        echo ""
    fi
}

get_position() {
    pos=$1
    len=$2
    if [ -n "$pos" ]; then
        bc -l <<<"$pos / $len * 100"
    else
        echo 0
    fi
}

get_position_time() {
    pos=$1
    if [ -n "$pos" ]; then
        date -d@"$(bc <<<"$pos / 1000000")" +%M:%S
    else
        echo ""
    fi
}

get_cover() {
    # COVER_URL=$1
    mkdir -p "eww_covers"
    cd "eww_covers" || exit

    IMGPATH="cover_art"
    echo '{"image": "null", "color": {"alpha":"100","colors":{"color0":"null","color1":"null","color10":"null","color11":"null","color12":"null","color13":"null","color14":"null","color15":"null","color2":"null","color3":"null","color4":"null","color5":"null","color6":"null","color7":"null","color8":"null","color9":"null"},"special":{"background":"null","cursor":"null","foreground":"null"},"wallpaper":"~/.config/eww/eww_covers/cover_art","source":"󱛟"},"materialcolor":{"onPrimary":"null","onPrimaryContainer":"null","onSecondaryContainer":"null","primary":"null","primaryContainer":"null","secondaryContainer":"null", "secondaryContainerRgba":"null"}}'
    # echo '{"image": "eww_covers/cover_art_default","source":"󱛟"}}'

    playerctl -F metadata mpris:artUrl 2>/dev/null | while read -r COVER_URL; do
        curl -q COVER_URL

    done
}

# SANITIZE FIX
sanitize() {
    echo "$1" | sed 's/"/\"/g'
}

if [ "$1" = "cover" ]; then
    get_cover
elif [ "$1" == "name" ]; then
    lentolimit=41
    if [ "$2" != "" ]; then
        lentolimit=$2
    fi
    echo '{"artist": "", "title": ""}'
    playerctl -F metadata -f '{{title}}\{{artist}}\' 2>/dev/null | while IFS="$(printf '\\')" read -r title artist; do

        if [[ "$title" == *" - YouTube"* && "$artist" == "" ]]; then
            continue
        elif [[ "$title" == *"YouTube Music" && "$artist" == "" ]]; then
            continue
        fi
        title=$(scripts/limitlen.py "$title" "$lentolimit")
        artist=$(scripts/limitlen.py "$artist" "$lentolimit")

        gojq --null-input -r -c \
            --arg artist "$(sanitize "$artist")" \
            --arg title "$(sanitize "$title")" \
            '{"artist": $artist, "title": $title}'

    done
else
    echo '{"artist": "", "title": "", "status": "", "position": "", "position_time": "", "length": ""}'
    playerctl -F metadata -f '{{title}}\{{artist}}\{{status}}\{{position}}\' 2>/dev/null | while IFS="$(printf '\\')" read -r title artist status position; do

        if [[ "$title" == *" - YouTube" && "$artist" == "" ]]; then
            continue
        elif [[ "$title" == *"YouTube Music" && "$artist" == "" ]]; then
            continue
        fi
        len=$(playerctl metadata mpris:length)
        title=$(scripts/limitlen.py "$title" 40)
        artist=$(scripts/limitlen.py "$artist" 40)

        gojq --null-input -r -c \
            --arg artist "$(sanitize "$artist")" \
            --arg title "$(sanitize "$title")" \
            --arg status "$(get_status "$status")" \
            --arg pos "$(get_position "$position" "$len")" \
            --arg pos_time "$(get_position_time "$position")" \
            --arg length "$(get_length_time "$len")" \
            '{"artist": $artist, "title": $title, "status": $status, "position": $pos, "position_time": $pos_time, "length": $length}'

    done
fi
