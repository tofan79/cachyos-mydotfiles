#!/usr/bin/env bash
# CachyOS app support for MangoWM.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/apps.log"

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
    log_err "This script is for CachyOS/Arch only."; exit 1
}

preflight_checks() {
    [[ "$(id -u)" -ne 0 ]] || { log_err "Do not run as root."; exit 1; }
    detect_os
    sudo -n true 2>/dev/null || sudo -v
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

install_core_app_support() {
    log_info "Installing desktop app support..."

    pacman_install \
        nautilus gvfs gvfs-afc gvfs-gphoto2 gvfs-smb libmtp \
        yazi neovim btop mpv imv gnome-disk-utility gnome-calculator \
        qt6-declarative qt6-svg qt6-multimedia qt6-multimedia-ffmpeg pavucontrol \
        tesseract tesseract-data-eng imagemagick \
        xdg-desktop-portal-gtk xdg-utils xdg-user-dirs python-gobject wtype wdisplays \
        cava \
        ncdu httpie bind whois traceroute mtr socat nmap github-cli strace python-pipx \
        telegram-desktop \
        localsend zen-browser-bin asusctl rog-control-center zed nautilus-python \
        ffmpegthumbnailer nautilus-image-converter \
        lazygit nodejs bottom gdu qt6-5compat \
        ab-download-manager gamemode lib32-gamemode faugus-launcher protonplus

    if command -v asusctl &>/dev/null; then
        log_info "Configuring ASUS daemon..."
        sudo mkdir -p /etc/asusd
        sudo systemctl enable --now asusd 2>/dev/null || true
        log_ok "ASUS daemon configured."
    fi

    command -v xdg-user-dirs-update &>/dev/null && xdg-user-dirs-update 2>/dev/null || true
    log_ok "Core desktop app support installed."
}

fix_terminal_desktop() {
    local apps=(btop nvim yazi)
    local app src dst
    mkdir -p ~/.local/share/applications
    for app in "${apps[@]}"; do
        src="/usr/share/applications/${app}.desktop"
        dst="$HOME/.local/share/applications/${app}.desktop"
        [[ -f "$src" ]] || { log_warn "Source desktop not found: ${src}"; continue; }
        grep -q "kitty" "$dst" 2>/dev/null && continue
        cp "$src" "$dst"
        sed -i 's|^Exec=\(.*\)$|Exec=kitty -e \1|; s/^Terminal=true/Terminal=false/' "$dst"
        log_ok "Fixed desktop: ${app} (kitty)"
    done
}

deploy_nvim_config() {
    local src="${SCRIPT_DIR}/dotfiles/nvim"
    local dst="$HOME/.config/nvim"
    if [[ -d "$src" ]] && ! [[ -f "$dst/init.lua" ]]; then
        mkdir -p "$(dirname "$dst")"
        cp -r "$src" "$dst"
        log_ok "AstroNvim config deployed."
    fi
}

deploy_tmux_config() {
    local src="${SCRIPT_DIR}/dotfiles/tmux/tmux.conf"
    local dst="$HOME/.config/tmux/tmux.conf"
    [[ -f "$dst" ]] && return 0
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    log_ok "tmux config deployed."
}

apply_icon_cursor_settings() {
    command -v gsettings &>/dev/null || { log_warn "gsettings not available."; return 0; }

    log_info "Setting Tela-nord-dark as default icon theme..."
    if gsettings set org.gnome.desktop.interface icon-theme "Tela-nord-dark" 2>/dev/null; then
        log_ok "Tela-nord-dark set as default."
    else
        log_warn "Failed to apply Tela-nord-dark icon theme (session may be inactive)."
    fi

    log_info "Setting Bibata-Modern-Ice as default cursor..."
    if gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice" 2>/dev/null; then
        log_ok "Bibata cursor set as default."
    else
        log_warn "Failed to apply Bibata cursor theme (session may be inactive)."
    fi
}

main() {
    preflight_checks
    install_core_app_support
    fix_terminal_desktop
    deploy_nvim_config
    deploy_tmux_config
    apply_icon_cursor_settings
    remove_cachyos_defaults
    log_ok "CachyOS app support complete. Log: ${LOG_FILE}"
}

remove_cachyos_defaults() {
    log_info "Removing CachyOS pre-installed packages (not needed)..."
    sudo pacman -Rns --noconfirm micro alacritty meld cachyos-micro-settings 2>/dev/null || true
    log_ok "Removed micro, alacritty, meld."

    log_info "Hiding unused desktop entries..."
    local entries="avahi-discover.desktop bssh.desktop bvnc.desktop qv4l2.desktop qvidcap.desktop"
    for f in $entries; do
        if [ -f "/usr/share/applications/$f" ]; then
            cp -n "/usr/share/applications/$f" ~/.local/share/applications/ 2>/dev/null || true
            grep -qx "Hidden=true" ~/.local/share/applications/"$f" 2>/dev/null || \
                echo "Hidden=true" >> ~/.local/share/applications/"$f"
        fi
    done
    log_ok "Desktop entries hidden."
}

main "$@"
