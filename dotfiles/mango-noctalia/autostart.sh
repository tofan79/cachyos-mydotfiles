#!/bin/bash

set +e

# Import environment for systemd
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE

# Power profile — set balanced on every login (persists across reboots, safety net)
command -v powerprofilesctl &>/dev/null && powerprofilesctl set balanced &>/dev/null

# Mic level — cegah gain max yg bikin volume naik-turun sendiri
command -v amixer &>/dev/null && amixer -c 2 set "Internal Mic Boost" 1 &>/dev/null
command -v amixer &>/dev/null && amixer -c 2 set "Capture" 45 &>/dev/null

# Set mic volume via PipeWire
command -v wpctl &>/dev/null && wpctl set-volume 60 80% 2>/dev/null

# Clipboard history
wl-paste --watch cliphist store &

# Audio idle inhibit — cegah screen lock pas audio/video aktif
~/.config/mango/bin/audio-idle-inhibit.sh &

# Tunggu compositor siap, baru start portal (wlr butuh compositor running)
sleep 3
/usr/libexec/xdg-desktop-portal-wlr >/dev/null 2>&1 &
/usr/libexec/xdg-desktop-portal-gtk >/dev/null 2>&1 &
sleep 1
/usr/libexec/xdg-desktop-portal >/dev/null 2>&1 &

wait
