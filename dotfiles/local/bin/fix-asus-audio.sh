#!/bin/bash
CARD=$(grep -l 'ALC256' /proc/asound/card*/codec* | head -1 | grep -oP 'card\K\d+')
[[ -z $CARD ]] && exit 0
amixer -c "$CARD" sset 'Capture' 45 unmute
amixer -c "$CARD" sset 'Internal Mic Boost' 1
amixer -c "$CARD" sset 'Speaker' 87 unmute
amixer -c "$CARD" sset 'Headphone' 87 unmute
amixer -c "$CARD" sset 'Master' 87 unmute
amixer -c "$CARD" sset 'Auto-Mute Mode' Disabled
