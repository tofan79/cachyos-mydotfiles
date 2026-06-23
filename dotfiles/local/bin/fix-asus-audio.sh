#!/bin/bash
CARD=$(grep -l 'ALC256' /proc/asound/card*/codec* | head -1 | grep -oP 'card\K\d+')
[[ -z $CARD ]] && exit 0

# Fix levels
amixer -c "$CARD" sset 'Capture' 45 unmute
amixer -c "$CARD" sset 'Internal Mic Boost' 1
amixer -c "$CARD" sset 'Headset Mic Boost' 1
amixer -c "$CARD" sset 'Speaker' 87 unmute
amixer -c "$CARD" sset 'Headphone' 87 unmute
amixer -c "$CARD" sset 'Master' 87 unmute
amixer -c "$CARD" sset 'Auto-Mute Mode' Disabled

# Auto-switch mic source based on jack
JACK=$(amixer -c "$CARD" cget numid=14 2>/dev/null | grep -oP 'values=on')
if [[ $JACK == "values=on" ]]; then
  amixer -c "$CARD" cset numid=6 1 2>/dev/null  # Headset Mic
else
  amixer -c "$CARD" cset numid=6 0 2>/dev/null  # Internal Mic
fi
