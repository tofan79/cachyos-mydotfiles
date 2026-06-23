#!/bin/bash
CARD=$(grep -l 'ALC256' /proc/asound/card*/codec* | head -1 | grep -oP 'card\K\d+')
[[ -z $CARD ]] && exit 0

# Fix levels
amixer -c "$CARD" sset 'Capture' 45 unmute
amixer -c "$CARD" sset 'Internal Mic Boost' 1
amixer -c "$CARD" sset 'Headset Mic Boost' 1
amixer -c "$CARD" sset 'Master' 87 unmute
amixer -c "$CARD" sset 'Auto-Mute Mode' Enabled

# Auto-switch mic & speaker/headphone based on headphone jack
JACK=$(amixer -c "$CARD" cget numid=15 2>/dev/null | grep -oP 'values=on')
if [[ $JACK == "values=on" ]]; then
  # Headphone active — mute speaker, enable headset mic
  amixer -c "$CARD" sset 'Speaker' 0 mute
  amixer -c "$CARD" sset 'Headphone' 87 unmute
  amixer -c "$CARD" cset numid=6 1 2>/dev/null
  amixer -c "$CARD" sset 'Internal Mic' 0 2>/dev/null
  amixer -c "$CARD" sset 'Headset Mic' 1 2>/dev/null
else
  # No headphone — enable speaker, mute headphone, switch to internal mic
  amixer -c "$CARD" sset 'Speaker' 87 unmute
  amixer -c "$CARD" sset 'Headphone' 0 mute
  amixer -c "$CARD" cset numid=6 0 2>/dev/null
  amixer -c "$CARD" sset 'Internal Mic' 1 2>/dev/null
  amixer -c "$CARD" sset 'Headset Mic' 0 2>/dev/null
fi
