#!/usr/bin/env bash
dir="$HOME/.config/hypr/windows"

files=("$dir"/*.lua)
entries=()
for f in "${files[@]}"; do
    label=$(sed -n 's/.*name: "\(.*\)"/\1/p' "$f")
    [[ -z "$label" ]] && label=$(basename "$f" .lua)
    entries+=("$label")
done

selection=$(printf "%s\n" "${entries[@]}" | rofi -dmenu -p "Windows" -matching fuzzy -i -config ~/.config/rofi/config-keybinds.rasi)
[[ -z "$selection" ]] && exit 0

for f in "${files[@]}"; do
    label=$(sed -n 's/.*name: "\(.*\)"/\1/p' "$f")
    [[ -z "$label" ]] && label=$(basename "$f" .lua)
    if [[ "$label" == "$selection" ]]; then
        code=$(sed 's/--.*//' "$f" | tr -d '\n')
        hyprctl eval "$code" && notify-send "Windows" "Switched to $label"
        exit 0
    fi
done
