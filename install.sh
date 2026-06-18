#!/usr/bin/env bash
# CachyOS Setup — minimal package installer
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/install.log"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log_info() { echo -e "${CYAN}[INFO]${NC}  $*"; }
log_ok()   { echo -e "${GREEN}[OK]${NC}   $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_err()  { echo -e "${RED}[ERROR]${NC} $*"; }

if [[ -f "$LOG_FILE" ]]; then
    mv "$LOG_FILE" "${LOG_FILE}.old.$(date +%Y%m%d%H%M%S)"
fi
exec > >(tee -a "$LOG_FILE") 2>&1
log_info "Logging to: ${LOG_FILE}"
trap 'log_err "Failed at line ${LINENO}: ${BASH_COMMAND}"' ERR

detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        case "${ID:-}" in
            arch|cachyos) log_ok "Detected: ${PRETTY_NAME:-$ID}" ;;
            *) log_err "Unsupported: ${ID:-unknown}. This script is for CachyOS/Arch only."; exit 1 ;;
        esac
    else
        log_err "Cannot detect OS."
        exit 1
    fi
}

preflight_checks() {
    log_info "Running preflight checks..."
    detect_os
    if [[ "$(id -u)" -eq 0 ]]; then
        log_err "Do not run as root."
        exit 1
    fi
    if ! sudo -n true 2>/dev/null; then
        log_warn "Sudo required."
        sudo -v
    fi
    log_ok "Preflight passed."
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

    # Development tools
    pacman_install base-devel

    # Essentials
    pacman_install \
        git curl wget rsync \
        libva-utils \
        kitty \
        flatpak \
        cmake meson ninja python python-pip \
        shellcheck openssh

    # CLI tools
    pacman_install \
        bat fzf zoxide fastfetch jq tmux ripgrep fd tree unzip zip bc lsof pciutils usbutils hwinfo \
        grim slurp wl-clipboard brightnessctl playerctl \
        eza pamixer wlsunset \
        lm_sensors dua-cli

    # Fonts
    pacman_install \
        ttf-jetbrains-mono noto-fonts noto-fonts-emoji adobe-source-code-pro-fonts \
        ttf-jetbrains-mono-nerd ttf-meslo-nerd-font-powerlevel10k \
        otf-comicshanns-nerd ttf-ms-fonts

    # GTK/Qt themes & libs
    pacman_install \
        qt6ct qt5ct gtk3 gtk4 libadwaita adwaita-icon-theme papirus-icon-theme \
        nordic-theme \
        bibata-cursor-theme tela-icon-theme

    # GStreamer codecs + encoders
    pacman_install \
        gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav \
        x264 x265

    # Filesystem tools
    pacman_install \
        exfatprogs ntfs-3g btrfs-progs cifs-utils dosfstools smartmontools logrotate tcpdump

    if command -v sensors-detect &>/dev/null; then
        sudo sensors-detect --auto 2>/dev/null || true
    fi
    log_ok "Packages installed."
}

setup_flatpak() {
    command -v flatpak &>/dev/null || { log_warn "Flatpak not installed."; return 0; }
    log_info "Adding Flathub remote..."
    if flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo; then
        log_ok "Flathub remote ready."
    else
        log_warn "Failed to add Flathub remote."
    fi

    log_info "Installing Flatpak apps..."
    flatpak install --system -y flathub com.obsproject.Studio \
        com.obsproject.Studio.Plugin.OBSPWVideo \
        io.github.tobagin.karere 2>/dev/null || true
    log_ok "Flatpak apps installed."
}

apply_icon_settings() {
    command -v gsettings &>/dev/null || { log_warn "gsettings not available."; return 0; }
    log_info "Setting Tela-nord-dark as default icon theme..."
    gsettings set org.gnome.desktop.interface icon-theme "Tela-nord-dark" 2>/dev/null && log_ok "Tela-nord-dark set." || log_warn "Failed to set Tela-nord-dark"
    log_info "Setting Bibata-Modern-Ice as cursor..."
    gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice" 2>/dev/null && log_ok "Bibata cursor set." || log_warn "Failed to set Bibata cursor"
}

setup_nerd_fonts() {
    log_info "Installing Nerd Fonts..."
    local fonts_dir="$HOME/.local/share/fonts"
    mkdir -p "$fonts_dir"
    local temp_dir
    temp_dir="$(mktemp -d)"
    for font in JetBrainsMono FiraCode; do
        local tmp_zip="$temp_dir/${font}.zip"
        if curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip" -o "$tmp_zip"; then
            unzip -qo "$tmp_zip" -d "$temp_dir/${font}" 2>/dev/null
            find "$temp_dir/${font}" -maxdepth 1 \( -name '*.ttf' -o -name '*.otf' \) -exec cp {} "$fonts_dir/" \; 2>/dev/null || true
            log_ok "${font} Nerd Font installed."
        else
            log_warn "Failed to download ${font} Nerd Font."
        fi
    done
    rm -rf "$temp_dir"
    fc-cache -fv "$fonts_dir" &>/dev/null || true
    log_ok "Font cache updated."
}

setup_zsh() {
    pacman_install zsh
    command -v zsh &>/dev/null || { log_warn "Zsh not installed."; return 0; }

    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null || true
    else
        log_ok "Oh My Zsh already installed."
    fi

    local p10k_dir="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    if [[ ! -d "$p10k_dir" ]]; then
        log_info "Installing Powerlevel10k..."
        git clone --depth 1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir" 2>/dev/null || true
    else
        log_ok "Powerlevel10k already installed."
    fi

    local plugin
    for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
        local pdir="$HOME/.oh-my-zsh/custom/plugins/$plugin"
        if [[ ! -d "$pdir" ]]; then
            log_info "Installing $plugin..."
            git clone --depth 1 "https://github.com/zsh-users/$plugin.git" "$pdir" 2>/dev/null || true
        else
            log_ok "$plugin already installed."
        fi
    done

    local zsh_dotfiles="${SCRIPT_DIR}/dotfiles/zsh"
    if [[ -d "$zsh_dotfiles" ]]; then
        if [[ -f "$HOME/.zshrc" ]]; then
            # Add fastfetch at the top if not already there
            if ! grep -q "^fastfetch" "$HOME/.zshrc" 2>/dev/null; then
                sed -i '1i # ---- fastfetch ----' "$HOME/.zshrc"
                sed -i '2i fastfetch' "$HOME/.zshrc"
                log_ok "fastfetch added to .zshrc."
            fi
            # Append custom aliases/config without duplicating oh-my-zsh/p10k
            tail -n +17 "$zsh_dotfiles/.zshrc" >> "$HOME/.zshrc"
            log_ok ".zshrc custom config appended."
        else
            cp "$zsh_dotfiles/.zshrc" "$HOME/.zshrc"
            log_ok ".zshrc copied."
        fi
        [[ -f "$zsh_dotfiles/.p10k.zsh" ]] && cp "$zsh_dotfiles/.p10k.zsh" "$HOME/.p10k.zsh" && log_ok ".p10k.zsh copied"
    fi

    local zsh_path
    zsh_path="$(command -v zsh)"
    if [[ "$SHELL" != "$zsh_path" ]]; then
        sudo chsh -s "$zsh_path" "$(whoami)" 2>/dev/null || log_warn "chsh failed"
    fi
    log_ok "Zsh configured."
}

set_kitty_default() {
    command -v kitty &>/dev/null || { log_warn "Kitty not installed."; return 0; }
    xdg-mime default kitty.desktop x-scheme-handler/terminal 2>/dev/null || true
    log_ok "Kitty set as default terminal."
}

setup_mise() {
    command -v mise &>/dev/null && { log_ok "mise already installed."; return 0; }
    log_info "Installing mise..."
    curl -fsSL https://mise.run | sh 2>/dev/null || log_warn "mise install failed."
    log_ok "mise installed."
}

setup_opencode() {
    command -v opencode &>/dev/null && { log_ok "opencode already installed."; return 0; }
    log_info "Installing opencode..."
    curl -fsSL https://opencode.ai/install | bash 2>/dev/null || log_warn "opencode install failed."
    log_ok "opencode installed."
}

copy_dotfiles() {
    log_info "Copying dotfiles..."

    local -A config_map=(
        ["kitty"]=".config/kitty"
        ["gtk-3.0"]=".config/gtk-3.0"
        ["gtk-4.0"]=".config/gtk-4.0"
        ["qt5ct"]=".config/qt5ct"
        ["qt6ct"]=".config/qt6ct"
        ["btop"]=".config/btop"
        ["cava"]=".config/cava"
        ["yazi"]=".config/yazi"
    )

    for src_dir in "${!config_map[@]}"; do
        local src="${SCRIPT_DIR}/dotfiles/${src_dir}"
        local dst="$HOME/${config_map[$src_dir]}"
        if [[ -d "$src" ]]; then
            mkdir -p "$dst"
            cp -r "$src"/. "$dst/" 2>/dev/null || true
            log_ok "${src_dir} copied."
        else
            log_warn "${src_dir} not found, skipping."
        fi
    done

    if [[ -f "${SCRIPT_DIR}/dotfiles/clean/clean.sh" ]]; then
        mkdir -p "$HOME/.config/clean" && cp "${SCRIPT_DIR}/dotfiles/clean/clean.sh" "$HOME/.config/clean/clean.sh" 2>/dev/null && chmod +x "$HOME/.config/clean/clean.sh" && log_ok "clean.sh copied."
    fi

    log_ok "Dotfiles copied."
}

copy_wallpapers() {
    local src="${SCRIPT_DIR}/Wallpapers"
    local dst="$HOME/Pictures/Wallpapers"
    [[ -d "$src" ]] || { log_warn "Wallpapers dir not found."; return 0; }
    mkdir -p "$dst"
    cp -r "$src"/* "$dst/" 2>/dev/null || true
    log_ok "Wallpapers copied."
}

copy_project_dirs() {
    local -A projects=(
        ["DaVinci_Resolve"]="DaVinci_Resolve/install_update.txt"
        ["docker-db"]="docker-db/docker-compose.yml"
    )
    for dir in "${!projects[@]}"; do
        local src="${SCRIPT_DIR}/${dir}"
        local dst="$HOME/Projects/${dir}"
        local marker="${projects[$dir]}"
        [[ -d "$src" ]] || { log_warn "${dir} dir not found, skipping."; continue; }
        mkdir -p "$(dirname "$dst")"
        if [[ -f "$dst/$marker" ]]; then
            log_ok "${dir} already exists."
        else
            cp -r "$src" "$dst"
            log_ok "${dir} copied."
        fi
    done
}

setup_chaotic_aur() {
    log_info "Setting up Chaotic-AUR..."
    if pacman -Qi chaotic-keyring &>/dev/null; then
        log_ok "Chaotic-AUR already configured."
        return 0
    fi
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com 2>/dev/null || true
    sudo pacman-key --lsign-key 3056513887B78AEB 2>/dev/null || true
    sudo pacman -U --noconfirm \
        'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
        'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' 2>/dev/null
    if ! grep -q '\[chaotic-aur\]' /etc/pacman.conf 2>/dev/null; then
        echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf >/dev/null
    fi
    sudo pacman -Sy --noconfirm 2>/dev/null
    log_ok "Chaotic-AUR configured."
}

main() {
    preflight_checks
    setup_chaotic_aur
    install_packages
    setup_flatpak
    setup_nerd_fonts
    apply_icon_settings
    set_kitty_default
    setup_mise
    setup_opencode
    copy_dotfiles
    copy_wallpapers
    copy_project_dirs
    echo ""
    log_ok "Setup complete."
    log_info "Log saved to: ${LOG_FILE}"
}

main "$@"
