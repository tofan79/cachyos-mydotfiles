#!/usr/bin/env bash
# fix-audio.sh — ASUS TUF A15 FA506ICB (Realtek ALC256) mic/audio fix
#
# Portable: works on CachyOS/Arch AND other distros (Debian/Ubuntu/Fedora).
# Self-contained: all configs are embedded below (no external file deps).
# Detects the audio stack (PipeWire / PulseAudio / ALSA) and init system
# (systemd / other) and deploys accordingly.
#
# Usage:
#   ./fix-audio.sh            # auto-detect ASUS, apply + enable
#   ./fix-audio.sh --force    # apply even on non-ASUS hardware
#   ./fix-audio.sh --apply    # apply levels now, skip service setup
#   ./fix-audio.sh --uninstall

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log_info() { echo -e "${CYAN}[INFO]${NC}  $*"; }
log_ok()   { echo -e "${GREEN}[OK]${NC}   $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_err()  { echo -e "${RED}[ERROR]${NC} $*"; }

FORCE=false
APPLY_ONLY=false
UNINSTALL=false
for arg in "$@"; do
    case "$arg" in
        --force) FORCE=true ;;
        --apply) APPLY_ONLY=true ;;
        --uninstall) UNINSTALL=true ;;
        -h|--help) sed -n '2,18p' "$0"; exit 0 ;;
    esac
done

# ---- hardware detection ----
is_asus() {
    [[ "$(cat /sys/class/dmi/id/sys_vendor 2>/dev/null)" == "ASUSTeK COMPUTER INC." ]]
}
has_alc256() {
    grep -rl 'ALC256' /proc/asound/card*/codec* 2>/dev/null | head -1 | grep -q .
}
if ! is_asus && ! $FORCE; then
    log_warn "Non-ASUS hardware detected. Skipping (use --force to override)."
    exit 0
fi
if ! has_alc256 && ! $FORCE; then
    log_warn "ALC256 codec not found. Skipping (use --force to override)."
    exit 0
fi
log_ok "ASUS ALC256 audio hardware detected."

# ---- embedded files ----
SOFT_MIXER_CONF='monitor.alsa.rules = [
  {
    matches = [ { device.name = "~alsa_card.*" } ]
    actions = { update-props = { api.alsa.soft-mixer = true } }
  }
]'

FIX_SCRIPT='#!/bin/bash
# ASUS TUF A15 FA506ICB (ALC256) audio/mic fix — applied on boot + jack change
CARD=$(grep -l "ALC256" /proc/asound/card*/codec* 2>/dev/null | head -1 | grep -oP "card\K\d+")
[[ -z $CARD ]] && exit 0

# Stable mic capture levels
amixer -c "$CARD" sset "Capture" 45 unmute 2>/dev/null || true
amixer -c "$CARD" sset "Internal Mic Boost" 1 2>/dev/null || true
amixer -c "$CARD" sset "Headset Mic Boost" 1 2>/dev/null || true
amixer -c "$CARD" sset "Master" 87 unmute 2>/dev/null || true
amixer -c "$CARD" sset "Auto-Mute Mode" Enabled 2>/dev/null || true

# Auto-switch mic & speaker/headphone based on headphone jack
JACK=$(amixer -c "$CARD" cget numid=15 2>/dev/null | grep -oP "values=on")
if [[ $JACK == "values=on" ]]; then
    amixer -c "$CARD" sset "Speaker" 0 mute 2>/dev/null || true
    amixer -c "$CARD" sset "Headphone" 87 unmute 2>/dev/null || true
    amixer -c "$CARD" cset numid=6 1 2>/dev/null || true
    amixer -c "$CARD" sset "Internal Mic" nocap 2>/dev/null || true
    amixer -c "$CARD" sset "Headset Mic" cap 2>/dev/null || true
else
    amixer -c "$CARD" sset "Speaker" 87 unmute 2>/dev/null || true
    amixer -c "$CARD" sset "Headphone" 0 mute 2>/dev/null || true
    amixer -c "$CARD" cset numid=6 0 2>/dev/null || true
    amixer -c "$CARD" sset "Internal Mic" cap 2>/dev/null || true
    amixer -c "$CARD" sset "Headset Mic" nocap 2>/dev/null || true
fi'

AUDIO_SERVICE='[Unit]
Description=Fix ASUS ALC256 mic/speaker levels
After=pipewire-session-manager.service
PartOf=pipewire-session-manager.service

[Service]
Type=oneshot
ExecStartPre=sleep 2
ExecStart=%h/.local/bin/fix-asus-audio.sh
RemainAfterExit=yes

[Install]
WantedBy=pipewire-session-manager.service'

WATCHER_SERVICE='[Unit]
Description=Watch for audio jack changes via pactl
After=pipewire-session-manager.service
PartOf=pipewire-session-manager.service

[Service]
Type=simple
ExecStart=bash -c "stdbuf -oL pactl subscribe | while read -r line; do case \"$line\" in *\"card\"*) ~/.local/bin/fix-asus-audio.sh;; esac; done"
Restart=always
RestartSec=2

[Install]
WantedBy=pipewire-session-manager.service'

# ---- uninstall ----
if $UNINSTALL; then
    log_info "Uninstalling ASUS audio fix..."
    systemctl --user disable --now fix-asus-audio.service 2>/dev/null || true
    systemctl --user disable --now fix-audio-watcher.service 2>/dev/null || true
    rm -f ~/.config/systemd/user/fix-asus-audio.service \
          ~/.config/systemd/user/fix-audio-watcher.service \
          ~/.local/bin/fix-asus-audio.sh \
          ~/.config/wireplumber/wireplumber.conf.d/alsa-soft-mixer.conf
    systemctl --user daemon-reload 2>/dev/null || true
    log_ok "Uninstalled."
    exit 0
fi

# ---- apply now ----
apply_now() {
    mkdir -p ~/.local/bin
    cat > ~/.local/bin/fix-asus-audio.sh <<< "$FIX_SCRIPT"
    chmod +x ~/.local/bin/fix-asus-audio.sh
    ~/.local/bin/fix-asus-audio.sh
    log_ok "Audio levels applied."
}

if $APPLY_ONLY; then
    apply_now
    exit 0
fi

# ---- detect audio stack + init ----
HAS_SYSTEMD=false; command -v systemctl &>/dev/null && systemctl --user status 2>/dev/null | grep -q . && HAS_SYSTEMD=true || HAS_SYSTEMD=false
HAS_PIPEWIRE=false; command -v pipewire &>/dev/null && HAS_PIPEWIRE=true || HAS_PIPEWIRE=false
HAS_PULSE=false; command -v pulseaudio &>/dev/null && HAS_PULSE=true || HAS_PULSE=false

log_info "Audio stack: $( $HAS_PIPEWIRE && echo PipeWire; $HAS_PULSE && echo PulseAudio; [[ ! $HAS_PIPEWIRE && ! $HAS_PULSE ]] && echo ALSA-only ) | systemd: $HAS_SYSTEMD"

# ---- deploy ----
mkdir -p ~/.config/wireplumber/wireplumber.conf.d
cat > ~/.config/wireplumber/wireplumber.conf.d/alsa-soft-mixer.conf <<< "$SOFT_MIXER_CONF"
log_ok "WirePlumber soft-mixer rule installed."

apply_now

if $HAS_SYSTEMD; then
    mkdir -p ~/.config/systemd/user
    cat > ~/.config/systemd/user/fix-asus-audio.service <<< "$AUDIO_SERVICE"
    cat > ~/.config/systemd/user/fix-audio-watcher.service <<< "$WATCHER_SERVICE"
    systemctl --user daemon-reload 2>/dev/null || true
    systemctl --user enable --now fix-asus-audio.service 2>/dev/null || true
    systemctl --user enable --now fix-audio-watcher.service 2>/dev/null || true
    if $HAS_PIPEWIRE; then
        systemctl --user restart wireplumber.service 2>/dev/null || true
    fi
    log_ok "Systemd user services enabled."
else
    # No systemd: drop an autostart entry so the fix runs on login
    mkdir -p ~/.config/autostart
    cat > ~/.config/autostart/fix-asus-audio.desktop <<EOF
[Desktop Entry]
Type=Application
Name=ASUS Audio Fix
Exec=$HOME/.local/bin/fix-asus-audio.sh
Hidden=false
X-GNOME-Autostart-enabled=true
EOF
    log_ok "No systemd — installed autostart .desktop instead."
fi

log_ok "ASUS TUF A15 audio/mic fix complete."
log_info "Re-apply anytime: ~/.local/bin/fix-asus-audio.sh"
