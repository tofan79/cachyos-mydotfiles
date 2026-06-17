#!/usr/bin/env bash
# Hyprland + Noctalia installer for CachyOS/Arch
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/hyprland-noctalia.log"

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
    git clone --depth 1 https://aur.archlinux.org/paru.git "$tmp/paru" 2>/dev/null || { rm -rf "$tmp"; return 1; }
    (cd "$tmp/paru" && makepkg -si --noconfirm) 2>/dev/null || { rm -rf "$tmp"; return 1; }
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
    local pkgs=("$@") pkg missing=()
    for pkg in "${pkgs[@]}"; do
        if pacman -Q "$pkg" &>/dev/null || command -v "$pkg" &>/dev/null; then
            log_ok "${pkg} already installed."
            continue
        fi
        missing+=("$pkg")
    done
    [[ ${#missing[@]} -eq 0 ]] && return 0
    sudo pacman -S --noconfirm "${missing[@]}" || log_warn "Some packages failed."
}

install_packages() {
    log_info "Installing Hyprland-specific packages..."
    pacman_install hyprland rofi-wayland cliphist xdg-desktop-portal-hyprland hyprpicker switcheroo-control
    ensure_paru
    aur_install noctalia-git
    log_ok "Packages installed."
}

setup_session_file() {
    if [[ -f /usr/share/wayland-sessions/hyprland.desktop ]]; then
        log_ok "Session file already exists."
        return 0
    fi
    sudo mkdir -p /usr/share/wayland-sessions
    sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=Hyprland (Noctalia)
Comment=Hyprland Wayland Compositor with Noctalia Shell
Exec=hyprland
Type=Application
DesktopNames=Hyprland
EOF
    log_ok "Session file created (hyprland.desktop)."
}

setup_polkit_fix() {
    local rules_file="/etc/polkit-1/rules.d/49-networkmanager.rules"
    if [[ -f "$rules_file" ]]; then
        log_ok "Polkit rules already exist."
        return 0
    fi
    log_info "Adding polkit rules for Noctalia WiFi..."
    sudo mkdir -p /etc/polkit-1/rules.d
    sudo tee "$rules_file" > /dev/null << 'POLKIT'
polkit.addRule(function(action, subject) {
	var allowed_actions = [
		"org.freedesktop.NetworkManager.enable-disable-network",
		"org.freedesktop.NetworkManager.enable-disable-wifi",
		"org.freedesktop.NetworkManager.enable-disable-wimax",
		"org.freedesktop.NetworkManager.enable-disable-wwan",
		"org.freedesktop.NetworkManager.network-control",
		"org.freedesktop.NetworkManager.settings.modify.own",
		"org.freedesktop.NetworkManager.settings.modify.system",
		"org.freedesktop.NetworkManager.wifi.scan",
		"org.freedesktop.NetworkManager.wifi.share.open",
		"org.freedesktop.NetworkManager.wifi.share.protected"
	]
	if (allowed_actions.indexOf(action.id) >= 0) {
		if (subject.isInGroup("wheel")) {
			return polkit.Result.YES;
		}
	}
})
POLKIT
    log_ok "Polkit rules added."
}

copy_dotfiles() {
    local -A config_map=(
        ["hypr"]=".config/hypr"
        ["rofi"]=".config/rofi"
        ["xdg-desktop-portal"]=".config/xdg-desktop-portal"
        ["fastfetch"]=".config/fastfetch"
        ["MangoHud"]=".config/MangoHud"
        ["nvim"]=".config/nvim"
    )
    for src_dir in "${!config_map[@]}"; do
        local src="${SCRIPT_DIR}/dotfiles/${src_dir}"
        local dst="$HOME/${config_map[$src_dir]}"
        if [[ -d "$src" ]]; then
            mkdir -p "$dst"
            cp -r "$src"/* "$dst/" 2>/dev/null || true
            log_ok "${src_dir} dotfiles copied."
        else
            log_warn "${src_dir} dotfiles not found, skipping."
        fi
    done
}

main() {
    preflight_checks
    install_packages
    setup_session_file
    setup_polkit_fix
    copy_dotfiles

    echo ""
    log_ok "Hyprland + Noctalia setup complete."
    log_info "Log saved to: ${LOG_FILE}"
    log_info "Reboot and select 'Hyprland (Noctalia)' in SDDM."
}

main "$@"
