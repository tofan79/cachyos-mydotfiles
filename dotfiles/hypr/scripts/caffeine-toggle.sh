#!/usr/bin/env bash
STATE_FILE="/tmp/caffeine-state"
if [[ -f "$STATE_FILE" ]]; then
    STATE=$(cat "$STATE_FILE")
    if [[ "$STATE" == "on" ]]; then
        noctalia msg caffeine-disable
        echo "off" > "$STATE_FILE"
        notify-send -r 9999 -t 2000 "Caffeine" "Disabled — idle will lock"
    else
        noctalia msg caffeine-enable
        echo "on" > "$STATE_FILE"
        notify-send -r 9999 -t 2000 "Caffeine" "Enabled — idle will NOT lock"
    fi
else
    noctalia msg caffeine-enable
    echo "on" > "$STATE_FILE"
    notify-send -r 9999 -t 2000 "Caffeine" "Enabled — idle will NOT lock"
fi
