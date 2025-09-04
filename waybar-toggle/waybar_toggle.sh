#!/usr/bin/env bash

# hide and unhide waybar instances
# by drastically killing and reanimate them

STATEFILE="/tmp/waybar_toggle.state"

if pgrep -x waybar > /dev/null; then
    # Waybar runs = kill
    killall waybar
    echo "off" > "$STATEFILE"
else
    # Waybar does not run = start all instances
    for cfg in ~/.config/waybar/config_*.jsonc; do
        # Derive style path by replacing "config_" with "style_" and ".jsonc" with ".css"
        style="${cfg/config_/style_}"
        style="${style%.jsonc}.css"

        if [[ -f "$style" ]]; then
            waybar -c "$cfg" -s "$style" &
        else
            waybar -c "$cfg" &
        fi
    done
    echo "on" > "$STATEFILE"
fi
