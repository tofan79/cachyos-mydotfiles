#!/usr/bin/env bash
cache_file="$HOME/.cache/toggle_animation"
if [ -f "$cache_file" ]; then
    hyprctl eval "hl.config({ animations = { enabled = true } })"
    rm "$cache_file"
    notify-send "Animations: ON"
else
    hyprctl eval "hl.config({ animations = { enabled = false } })"
    touch "$cache_file"
    notify-send "Animations: OFF"
fi
