#!/usr/bin/env bash
# fix-asus-audio.sh — ASUS TUF A15 FA506ICB (Realtek ALC256) mic/audio fix
#
# Portable: PipeWire/PulseAudio/ALSA, systemd atau non-systemd.
# Self-contained: semua config di-embed, tidak butuh file eksternal.
#
# Usage:
#   ./fix-asus-audio.sh            # auto-detect ASUS, apply + enable
#   ./fix-asus-audio.sh --force    # paksa jalan walau hardware bukan ASUS/ALC256
#   ./fix-asus-audio.sh --apply    # apply level sekarang saja, skip service setup
#   ./fix-asus-audio.sh --uninstall

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log_info() { echo -e "${CYAN}[INFO]${NC}  $*"; }
log_ok()   { echo -e "${GREEN}[OK]${NC}    $*"; }
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
        -h|--help) sed -n '2,13p' "$0"; exit 0 ;;
        *) log_err "Argumen tidak dikenal: $arg"; exit 1 ;;
    esac
done

# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/wireplumber/wireplumber.conf.d"
SYSTEMD_DIR="$HOME/.config/systemd/user"
AUTOSTART_DIR="$HOME/.config/autostart"

FIX_SCRIPT="$BIN_DIR/fix-asus-audio-levels.sh"
WP_CONF="$CONFIG_DIR/51-asus-alc256.conf"
AUDIO_SERVICE="$SYSTEMD_DIR/fix-asus-audio.service"
WATCHER_SERVICE="$SYSTEMD_DIR/fix-asus-audio-watcher.service"
AUTOSTART_FILE="$AUTOSTART_DIR/fix-asus-audio.desktop"

# ------------------------------------------------------------
# Uninstall (didahulukan supaya tidak butuh cek hardware/deps)
# ------------------------------------------------------------

if $UNINSTALL; then
    log_info "Menghapus ASUS ALC256 audio fix..."
    systemctl --user disable --now fix-asus-audio.service 2>/dev/null || true
    systemctl --user disable --now fix-asus-audio-watcher.service 2>/dev/null || true
    rm -f "$AUDIO_SERVICE" "$WATCHER_SERVICE" "$FIX_SCRIPT" "$WP_CONF" "$AUTOSTART_FILE"
    systemctl --user daemon-reload 2>/dev/null || true
    log_ok "Selesai dihapus."
    exit 0
fi

# ------------------------------------------------------------
# Hardware detection
# ------------------------------------------------------------

is_asus() {
    [[ "$(cat /sys/class/dmi/id/sys_vendor 2>/dev/null || true)" == "ASUSTeK COMPUTER INC." ]]
}
has_alc256() {
    grep -rl 'ALC256' /proc/asound/card*/codec* 2>/dev/null | head -1 | grep -q .
}

if ! $FORCE; then
    if ! is_asus; then
        log_warn "Hardware ASUS tidak terdeteksi. Gunakan --force untuk memaksa."
        exit 0
    fi
    if ! has_alc256; then
        log_warn "Codec ALC256 tidak terdeteksi. Gunakan --force untuk memaksa."
        exit 0
    fi
fi
log_ok "ASUS + ALC256 terdeteksi."

# ------------------------------------------------------------
# Dependency check
# ------------------------------------------------------------

if ! command -v amixer >/dev/null 2>&1; then
    log_err "amixer tidak ditemukan. Install paket alsa-utils dulu."
    exit 1
fi

HAS_PACTL=false
command -v pactl >/dev/null 2>&1 && HAS_PACTL=true
if ! $HAS_PACTL; then
    log_warn "pactl tidak ditemukan — auto-switch saat colok/cabut headphone TIDAK aktif."
    log_warn "Fix hanya akan jalan sekali saat boot/login."
fi

# ------------------------------------------------------------
# Embedded ALSA fix script
# ------------------------------------------------------------

mkdir -p "$BIN_DIR"
cat > "$FIX_SCRIPT" <<'SCRIPT'
#!/usr/bin/env bash
set +e

CARD=""
for codec in /proc/asound/card*/codec*; do
    [[ -f "$codec" ]] || continue
    if grep -q "ALC256" "$codec" 2>/dev/null; then
        CARD="$(basename "$(dirname "$codec")" | sed 's/card//')"
        break
    fi
done

# CARD harus numerik, kalau tidak jangan sentuh amixer sama sekali
[[ "$CARD" =~ ^[0-9]+$ ]] || exit 0

AMIXER="amixer -c $CARD"

# Level dasar
$AMIXER sset "Capture" 45 unmute 2>/dev/null || true
$AMIXER sset "Internal Mic Boost" 1 2>/dev/null || true
$AMIXER sset "Headset Mic Boost" 1 2>/dev/null || true
$AMIXER sset "Master" 87 unmute 2>/dev/null || true
$AMIXER sset "Auto-Mute Mode" Enabled 2>/dev/null || true

# Deteksi jack headphone (numid=15 spesifik ALC256 di board ini)
JACK="$($AMIXER cget numid=15 2>/dev/null | grep -o 'values=on' | head -1)"

if [[ "$JACK" == "values=on" ]]; then
    $AMIXER sset "Speaker" 0 mute 2>/dev/null || true
    $AMIXER sset "Headphone" 87 unmute 2>/dev/null || true
    $AMIXER cset numid=6 1 2>/dev/null || true
    $AMIXER sset "Internal Mic" nocap 2>/dev/null || true
    $AMIXER sset "Headset Mic" cap 2>/dev/null || true
else
    $AMIXER sset "Speaker" 87 unmute 2>/dev/null || true
    $AMIXER sset "Headphone" 0 mute 2>/dev/null || true
    $AMIXER cset numid=6 0 2>/dev/null || true
    $AMIXER sset "Internal Mic" cap 2>/dev/null || true
    $AMIXER sset "Headset Mic" nocap 2>/dev/null || true
fi
SCRIPT
chmod +x "$FIX_SCRIPT"

apply_now() {
    log_info "Menerapkan level ALSA..."
    "$FIX_SCRIPT"
    log_ok "Level audio diterapkan."
}

if $APPLY_ONLY; then
    apply_now
    exit 0
fi

# ------------------------------------------------------------
# WirePlumber soft-mixer rule
# ------------------------------------------------------------

mkdir -p "$CONFIG_DIR"
cat > "$WP_CONF" <<'EOF'
monitor.alsa.rules = [
  {
    matches = [ { device.name = "~alsa_card.*" } ]
    actions = { update-props = { api.alsa.soft-mixer = true } }
  }
]
EOF
log_ok "WirePlumber soft-mixer rule terpasang."

apply_now

# ------------------------------------------------------------
# Deteksi init system + deploy service
# ------------------------------------------------------------

HAS_SYSTEMD=false
command -v systemctl >/dev/null 2>&1 && systemctl --user status >/dev/null 2>&1 && HAS_SYSTEMD=true

if $HAS_SYSTEMD; then
    mkdir -p "$SYSTEMD_DIR"

    cat > "$AUDIO_SERVICE" <<EOF
[Unit]
Description=ASUS ALC256 audio level fix
After=wireplumber.service
PartOf=wireplumber.service

[Service]
Type=oneshot
ExecStartPre=sleep 2
ExecStart=$FIX_SCRIPT
RemainAfterExit=no

[Install]
WantedBy=default.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable --now fix-asus-audio.service 2>/dev/null || true
    log_ok "Service fix-asus-audio.service terpasang."

    # Watcher hanya dipasang kalau pactl ada — kalau tidak, service akan
    # gagal-restart terus-menerus tanpa guna.
    if $HAS_PACTL; then
        cat > "$WATCHER_SERVICE" <<EOF
[Unit]
Description=Watch for ASUS audio jack changes via pactl
After=wireplumber.service
PartOf=wireplumber.service

[Service]
Type=simple
ExecStart=/usr/bin/env bash -c 'stdbuf -oL pactl subscribe | while read -r line; do case "\$line" in *"on card"*) $FIX_SCRIPT ;; esac; done'
Restart=always
RestartSec=2

[Install]
WantedBy=default.target
EOF
        systemctl --user daemon-reload
        systemctl --user enable --now fix-asus-audio-watcher.service 2>/dev/null || true
        log_ok "Watcher jack (auto-switch) aktif."
    fi

    systemctl --user restart wireplumber.service 2>/dev/null || true
else
    # Tanpa systemd: pasang autostart .desktop, tidak ada watcher realtime.
    mkdir -p "$AUTOSTART_DIR"
    cat > "$AUTOSTART_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=ASUS ALC256 Audio Fix
Exec=$FIX_SCRIPT
Terminal=false
X-GNOME-Autostart-enabled=true
EOF
    log_ok "Tidak ada systemd — autostart .desktop terpasang (tanpa auto-switch realtime)."
fi

log_ok "ASUS TUF A15 ALC256 audio fix selesai."
log_info "Re-apply manual : $FIX_SCRIPT"
log_info "Uninstall        : $0 --uninstall"
