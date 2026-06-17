#!/usr/bin/env bash
# Noctalia Shell installer for CachyOS/Arch (v5 alpha — noctalia-git)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/mango-noctalia.log"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log_info() { echo -e "${CYAN}[INFO]${NC}  $*"; }
log_ok()   { echo -e "${GREEN}[OK]${NC}   $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_err()  { echo -e "${RED}[ERROR]${NC} $*"; }

if [[ -f "$LOG_FILE" ]]; then
    mv "$LOG_FILE" "${LOG_FILE}.old.$(date +%Y%m%d%H%M%S)"
fi
exec > >(tee -a "$LOG_FILE") 2>&1
trap 'log_err "Failed at line ${LINENO}: ${BASH_COMMAND}"' ERR

detect_os() {
    [[ -f /etc/os-release ]] && . /etc/os-release
    case "${ID:-}" in arch|cachyos) return 0 ;; esac
    log_err "CachyOS/Arch only."; exit 1
}

preflight_checks() {
    [[ "$(id -u)" -ne 0 ]] || { log_err "Do not run as root."; exit 1; }
    detect_os
    sudo -n true 2>/dev/null || sudo -v
}

ensure_paru() {
    if command -v paru &>/dev/null; then
        log_ok "paru already installed."
        return 0
    fi
    log_info "Installing paru (AUR helper)..."
    local tmp
    tmp="$(mktemp -d)"
    sudo pacman -S --noconfirm --needed base-devel git || true
    git clone --depth 1 https://aur.archlinux.org/paru.git "$tmp/paru" || { log_err "Failed to clone paru from AUR."; rm -rf "$tmp"; return 1; }
    (cd "$tmp/paru" && makepkg -si --noconfirm) || { log_err "makepkg failed for paru."; rm -rf "$tmp"; return 1; }
    rm -rf "$tmp"
    log_ok "paru installed."
}

aur_install() {
    local pkgs=("$@") pkg
    for pkg in "${pkgs[@]}"; do
        if pacman -Q "$pkg" &>/dev/null || command -v "$pkg" &>/dev/null; then
            log_ok "${pkg} already installed."
            continue
        fi
        log_info "Installing ${pkg}..."
        paru -S --noconfirm "$pkg" || log_warn "Failed to install ${pkg}."
    done
}

pacman_install() {
    local pkgs=("$@") pkg
    for pkg in "${pkgs[@]}"; do
        if pacman -Q "$pkg" &>/dev/null || command -v "$pkg" &>/dev/null; then
            log_ok "${pkg} already installed."
            continue
        fi
        log_info "Installing ${pkg}..."
        sudo pacman -S --noconfirm "$pkg" || log_warn "${pkg} FAILED to install."
    done
}

install_packages() {
    log_info "Installing packages..."
    pacman_install mangowm cliphist gpu-screen-recorder gpu-screen-recorder-ui ttf-fira-code
    ensure_paru
    aur_install noctalia-git
    log_ok "Packages installed."
}

setup_session_file() {
    if [[ -f /usr/share/wayland-sessions/mango.desktop ]]; then
        log_ok "Session file already exists."
        return 0
    fi
    sudo mkdir -p /usr/share/wayland-sessions
    sudo tee /usr/share/wayland-sessions/mango.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=MangoWM
Comment=Mango Wayland Compositor
Exec=mango
Type=Application
DesktopNames=MangoWM
EOF
    log_ok "Session file created (mango.desktop)."
}

setup_sddm() {
    pacman_install sddm
    if ! systemctl is-enabled sddm &>/dev/null; then
        sudo systemctl enable sddm
        log_ok "SDDM enabled."
    else
        log_ok "SDDM already enabled."
    fi
    if [[ ! -f /etc/sddm.conf.d/cursor.conf ]]; then
        sudo mkdir -p /etc/sddm.conf.d
        sudo tee /etc/sddm.conf.d/cursor.conf > /dev/null << 'EOF'
[Theme]
CursorTheme=Bibata-Modern-Ice
EOF
        log_ok "SDDM cursor theme set."
    fi
}

copy_dotfiles() {
    local src="${SCRIPT_DIR}/dotfiles/mango-noctalia"
    local dst="$HOME/.config/mango"
    if [[ -d "$src" ]]; then
        mkdir -p "$dst"
        cp -r "$src"/* "$dst/" 2>/dev/null || true
        log_ok "Noctalia dotfiles copied."
    else
        log_warn "Noctalia dotfiles not found, skipping."
    fi
}

main() {
    preflight_checks
    install_packages
    setup_session_file
    setup_sddm
    copy_dotfiles

    echo ""
    log_ok "Noctalia setup complete."
    log_info "Log saved to: ${LOG_FILE}"
    log_info "Reboot and select 'MangoWM' in SDDM."
}

main "$@"
