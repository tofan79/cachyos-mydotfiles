#!/usr/bin/env bash
# fix-audio-mic-asus.sh — ASUS TUF A15 FA506ICB (Realtek ALC256) mic/audio fix
#
# Meniru state stabil yang sudah tervalidasi di RakuOS:
#   mic dipin penuh & dibiarkan (Capture 100%, boost max),
#   Auto-Mute Mode DISABLED, tanpa aturan soft-mixer WirePlumber.
#
# Perbedaan dengan fix-asus-audio.sh (versi PulseAudio/CachyOS):
#   - TIDAK mengaktifkan Auto-Mute Mode  -> sumber utama mic naik-turun
#   - TIDAK memasang soft-mixer rule     -> WirePlumber normalize ulang gain
#   - TIDAK menurunkan Mic Boost          -> biarkan maksimal, stabil
#   - Hanya pin level stabil + watcher jack headphone (switch speaker/HP)
#
# Portabel: PipeWire/PulseAudio/ALSA, systemd atau non-systemd.
# Self-contained: semua config di-embed, tidak butuh file eksternal.
#
# Usage:
#   ./fix-audio-mic-asus.sh               # auto-detect ASUS, apply + enable service
#   ./fix-audio-mic-asus.sh --apply       # apply sekali saja, tanpa service
#   ./fix-audio-mic-asus.sh --force       # paksa walau hardware bukan ASUS/ALC256
#   ./fix-audio-mic-asus.sh --uninstall

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
        -h|--help) sed -n '2,17p' "$0"; exit 0 ;;
        *) log_err "Argumen tidak dikenal: $arg"; exit 1 ;;
    esac
done

# ------------------------------------------------------------
# Paths
# ------------------------------------------------------------

BIN_DIR="$HOME/.local/bin"
AUTOSTART_DIR="$HOME/.config/autostart"
SYSTEMD_DIR="$HOME/.config/systemd/user"

FIX_SCRIPT="$BIN_DIR/fix-audio-mic-asus-levels.sh"
AUDIO_SERVICE="$SYSTEMD_DIR/fix-audio-mic-asus.service"
WATCHER_SERVICE="$SYSTEMD_DIR/fix-audio-mic-asus-watcher.service"
AUTOSTART_FILE="$AUTOSTART_DIR/fix-audio-mic-asus.desktop"

# ------------------------------------------------------------
# Uninstall (didahulukan supaya tidak butuh cek hardware/deps)
# ------------------------------------------------------------

if $UNINSTALL; then
    log_info "Menghapus ASUS ALC256 audio fix..."
    systemctl --user disable --now fix-audio-mic-asus.service 2>/dev/null || true
    systemctl --user disable --now fix-audio-mic-asus-watcher.service 2>/dev/null || true
    rm -f "$AUDIO_SERVICE" "$WATCHER_SERVICE" "$FIX_SCRIPT" "$AUTOSTART_FILE"
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

# ------------------------------------------------------------
# Embedded ALSA fix script
# ------------------------------------------------------------
# Hanya pin level stabil (state RakuOS) + switch speaker/headphone
# berdasarkan state jack. TIDAK menyentuh Auto-Mute / boost / soft-mixer.
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

# --- Pin level stabil (state RakuOS) ---
# Auto-Mute harus tetap DISABLED: kalau enabled, route capture
# ikut fluktuasi jack dan mic naik-turun.
$AMIXER sset "Auto-Mute Mode" Disabled 2>/dev/null || true
$AMIXER sset "Capture" 100% unmute 2>/dev/null || true
$AMIXER sset "Internal Mic Boost" 100% 2>/dev/null || true
$AMIXER sset "Headset Mic Boost" 100% 2>/dev/null || true
$AMIXER sset "Master" 100% unmute 2>/dev/null || true
$AMIXER sset "Speaker" 100% unmute 2>/dev/null || true

# --- Switch speaker/headphone berdasarkan state jack ---
# Cari kontrol jack yang relevan (prefer "Headphone Jack").
JACK_CTL="$($AMIXER controls 2>/dev/null | grep -o "name='[^']*' " | sed "s/name='//;s/'.*//" | grep -i 'jack' | head -1)"
[[ -z "$JACK_CTL" ]] && exit 0

JACK_STATE="$($AMIXER cget name="$JACK_CTL" 2>/dev/null | grep -o 'values=on' | head -1)"

if [[ "$JACK_STATE" == "values=on" ]]; then
    # headphone colok: speaker diam, headphone bunyi
    $AMIXER sset "Speaker" 0 mute 2>/dev/null || true
    $AMIXER sset "Headphone" 100% unmute 2>/dev/null || true
else
    # headphone cabut: speaker bunyi, headphone diam
    $AMIXER sset "Speaker" 100% unmute 2>/dev/null || true
    $AMIXER sset "Headphone" 0 mute 2>/dev/null || true
fi
SCRIPT
chmod +x "$FIX_SCRIPT"

apply_now() {
    log_info "Menerapkan level audio stabil (state RakuOS)..."
    "$FIX_SCRIPT"
    log_ok "Level audio diterapkan."
}

if $APPLY_ONLY; then
    apply_now
    exit 0
fi

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
Description=ASUS ALC256 mic/audio level pin (state RakuOS)
After=wireplumber.service pipewire.service
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
    systemctl --user enable --now fix-audio-mic-asus.service 2>/dev/null || true
    log_ok "Service fix-audio-mic-asus.service terpasang."

    # Watcher jack hanya dipasang kalau pactl ada (auto-switch realtime
    # saat colok/cabut headphone). Tidak mengubah level mic.
    if $HAS_PACTL; then
        cat > "$WATCHER_SERVICE" <<EOF
[Unit]
Description=Watch for ASUS audio jack changes via pactl
After=wireplumber.service pipewire.service
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
        systemctl --user enable --now fix-audio-mic-asus-watcher.service 2>/dev/null || true
        log_ok "Watcher jack (auto-switch) aktif."
    else
        log_ok "pactl tidak ada — auto-switch saat colok/cabut TIDAK aktif."
    fi

    systemctl --user restart wireplumber.service pipewire.service 2>/dev/null || true
else
    # Tanpa systemd: pasang autostart .desktop, tidak ada watcher realtime.
    mkdir -p "$AUTOSTART_DIR"
    cat > "$AUTOSTART_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=ASUS ALC256 Mic/Audio Fix
Exec=$FIX_SCRIPT
Terminal=false
X-GNOME-Autostart-enabled=true
EOF
    log_ok "Tidak ada systemd — autostart .desktop terpasang (tanpa auto-switch realtime)."
fi

log_ok "ASUS TUF A15 ALC256 mic/audio fix (state RakuOS) selesai."
log_info "Re-apply manual : $FIX_SCRIPT"
log_info "Uninstall        : $0 --uninstall"