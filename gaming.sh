#!/usr/bin/env bash
# CachyOS Gaming Mode — DeckShift (Steam Deck-style session switch)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GM_DIR="${SCRIPT_DIR}/dotfiles/gaming-mode"
LOG_FILE="${SCRIPT_DIR}/gaming.log"

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

preflight() {
    [[ "$(id -u)" -ne 0 ]] || { log_err "Do not run as root."; exit 1; }
    [[ -d "$GM_DIR/scripts" ]] || { log_err "gaming-mode scripts not found at $GM_DIR"; exit 1; }
    sudo -n true 2>/dev/null || sudo -v
}

install_packages() {
    log_info "Installing ChimeraOS session packages..."
    local pkgs=()
    pacman -Qi gamescope-session-git &>/dev/null || pkgs+=("gamescope-session-git")
    pacman -Qi gamescope-session-steam-git &>/dev/null || pkgs+=("gamescope-session-steam-git")
    if ((${#pkgs[@]})); then
        sudo pacman -S --noconfirm "${pkgs[@]}" || log_warn "Failed to install: ${pkgs[*]}"
    fi
    log_ok "Packages OK"
}

install_scripts() {
    log_info "Installing session scripts to /usr/local/bin/..."
    for f in "$GM_DIR/scripts/"*; do
        sudo install -m 755 "$f" /usr/local/bin/
    done
    log_ok "Scripts installed"

    if [[ -f "$GM_DIR/configs/gamescope-nvidia-wrapper" ]]; then
        sudo mkdir -p /usr/local/lib/gamescope-nvidia
        sudo install -m 755 "$GM_DIR/configs/gamescope-nvidia-wrapper" /usr/local/lib/gamescope-nvidia/gamescope
        log_ok "NVIDIA wrapper installed"
    fi

    if [[ -f "$GM_DIR/scripts/os-session-select" ]]; then
        sudo install -m 755 "$GM_DIR/scripts/os-session-select" /usr/lib/
        log_ok "Steam exit handler installed"
    fi
}

setup_sddm() {
    log_info "Configuring SDDM..."
    if [[ -f "$GM_DIR/sddm/gamescope-session-steam-nm.desktop" ]]; then
        sudo install -m 644 "$GM_DIR/sddm/gamescope-session-steam-nm.desktop" /usr/share/wayland-sessions/
    fi

    local autologin_user="$USER"
    if [[ -f /etc/sddm.conf.d/autologin.conf ]]; then
        autologin_user=$(sed -n 's/^User=//p' /etc/sddm.conf.d/autologin.conf 2>/dev/null | head -1)
        [[ -z "$autologin_user" ]] && autologin_user="$USER"
    fi
    if [[ -f "$GM_DIR/sddm/zz-gaming-session.conf" ]]; then
        sudo install -m 644 "$GM_DIR/sddm/zz-gaming-session.conf" /etc/sddm.conf.d/
        if grep -q "^User=" /etc/sddm.conf.d/zz-gaming-session.conf 2>/dev/null; then
            sudo sed -i "s/^User=.*/User=${autologin_user}/" /etc/sddm.conf.d/zz-gaming-session.conf
        else
            sudo sed -i "/^\[Autologin\]/a User=${autologin_user}" /etc/sddm.conf.d/zz-gaming-session.conf
        fi
    fi
    log_ok "SDDM configured"
}

setup_permissions() {
    log_info "Setting up permissions..."
    sudo rm -f /etc/sudoers.d/gaming-session-switch
    if [[ -f "$GM_DIR/configs/sudoers-gaming-session-switch" ]]; then
        sudo install -m 0440 "$GM_DIR/configs/sudoers-gaming-session-switch" /etc/sudoers.d/
    fi

    if [[ -f "$GM_DIR/configs/polkit-networkmanager.rules" ]]; then
        sudo mkdir -p /etc/polkit-1/rules.d
        sudo install -m 644 "$GM_DIR/configs/polkit-networkmanager.rules" /etc/polkit-1/rules.d/50-gamescope-networkmanager.rules
        sudo systemctl restart polkit.service 2>/dev/null || true
    fi

    sudo usermod -a -G input,video "$USER" 2>/dev/null || true
    log_ok "Permissions OK (relogin for group changes)"
}

setup_performance() {
    log_info "Applying performance configs..."

    if [[ -f "$GM_DIR/configs/udev-99-gaming-performance.rules" ]]; then
        sudo install -m 644 "$GM_DIR/configs/udev-99-gaming-performance.rules" /etc/udev/rules.d/
        sudo udevadm control --reload-rules 2>/dev/null || true
    fi
    if [[ -f "$GM_DIR/configs/gaming-memlock.conf" ]]; then
        sudo install -m 644 "$GM_DIR/configs/gaming-memlock.conf" /etc/security/limits.d/
    fi
    if [[ -f "$GM_DIR/configs/pipewire-10-gaming-latency.conf" ]]; then
        sudo mkdir -p /etc/pipewire/pipewire.conf.d
        sudo install -m 644 "$GM_DIR/configs/pipewire-10-gaming-latency.conf" /etc/pipewire/pipewire.conf.d/
    fi
    if [[ -f "$GM_DIR/configs/shader-cache.conf" ]]; then
        sudo mkdir -p /etc/environment.d
        sudo install -m 644 "$GM_DIR/configs/shader-cache.conf" /etc/environment.d/99-shader-cache.conf
    fi
    if lspci 2>/dev/null | grep -qi nvidia && [[ -f "$GM_DIR/configs/nvidia-environment.conf" ]]; then
        sudo mkdir -p /etc/environment.d
        sudo install -m 644 "$GM_DIR/configs/nvidia-environment.conf" /etc/environment.d/90-nvidia-gamescope.conf
    fi
    log_ok "Performance configs applied"
}

summary() {
    echo ""
    echo "╔══════════════════════════════════════════════╗"
    echo "║     Gaming Mode (DeckShift) setup complete   ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    echo "  Usage:"
    echo "    Super+Shift+G  → Switch to Gaming Mode"
    echo "    Super+Shift+R  → Return to Desktop (inside Gaming Mode)"
    echo "    Steam → Power → Exit to Desktop (alternative)"
    echo ""
    echo "  Notes:"
    echo "    - Log out & back in for input/video group changes"
    echo "    - Edit ~/.config/environment.d/gamescope-session-plus.conf"
    echo "      for display/GPU settings"
    echo ""
}

main() {
    preflight
    install_packages
    install_scripts
    setup_sddm
    setup_permissions
    setup_performance
    summary
}

main "$@"
