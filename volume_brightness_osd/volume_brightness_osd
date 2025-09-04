#!/bin/bash
# Original: https://gitlab.com/Nmoleo/i3-volume-brightness-indicator
# Adapted for Sway, Wayland, brightnessctl & swaync

bar_color="#7f7fff"
volume_step=5
brightness_step=5
max_volume=100

# Get current volume (first channel only)
get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

# Get mute status
get_mute() {
    pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

# Decide which volume icon to show
get_volume_icon() {
    local volume=$(get_volume)
    local mute=$(get_mute)
    if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ]; then
        volume_icon=""   # muted
    elif [ "$volume" -lt 50 ]; then
        volume_icon=""   # low volume
    else
        volume_icon=""   # high volume
    fi
}

# Show volume notification with swaync (replace-id prevents stacking)
show_volume_notif() {
    local volume=$(get_volume)
    get_volume_icon
    notify-send -t 1000 --replace-id=100 -h int:value:$volume "$volume_icon  $volume%"
}

# Get current brightness (strip % sign)
get_brightness() {
    brightnessctl -m | awk -F, '{print $4}' | tr -d '%'
}

# Decide which brightness icon to show
get_brightness_icon() {
    local brightness=$(get_brightness)
    if [ "$brightness" -le 20 ]; then
        brightness_icon=""   # very low brightness (moon)
    elif [ "$brightness" -le 50 ]; then
        brightness_icon=""   # medium brightness (circle)
    elif [ "$brightness" -le 80 ]; then
        brightness_icon=""   # high brightness (sun)
    else
        brightness_icon="🌞"   # max brightness (sun emoji)
    fi
}

# Show brightness notification with swaync (replace-id prevents stacking)
show_brightness_notif() {
    local brightness=$(get_brightness)
    get_brightness_icon
    notify-send -t 1000 --replace-id=101 -h int:value:$brightness "$brightness_icon  $brightness%"
}

# Main logic
case "$1" in
    volume_up)
        pactl set-sink-mute @DEFAULT_SINK@ 0
        volume=$(get_volume)
        if [ "$volume" -ge "$max_volume" ]; then
            pactl set-sink-volume @DEFAULT_SINK@ ${max_volume}%
        else
            pactl set-sink-volume @DEFAULT_SINK@ +${volume_step}%
        fi
        show_volume_notif
        ;;
    volume_down)
        pactl set-sink-volume @DEFAULT_SINK@ -${volume_step}%
        show_volume_notif
        ;;
    volume_mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        show_volume_notif
        ;;
    brightness_up)
        brightnessctl set +${brightness_step}%
        show_brightness_notif
        ;;
    brightness_down)
        brightnessctl set ${brightness_step}%-
        show_brightness_notif
        ;;
    *)
        echo "Usage: $0 {volume_up|volume_down|volume_mute|brightness_up|brightness_down}"
        exit 1
        ;;
esac
