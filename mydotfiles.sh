#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/mydotfiles.log"

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

DOTFILES_SRC="${SCRIPT_DIR}/dotfiles"
CONFIG_DST="${HOME}/.config"
WALLPAPER_SRC="${SCRIPT_DIR}/Wallpapers"
PICTURES_DST="${HOME}/Pictures"

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME/.config-backup-$STAMP"

preflight() {
    [[ "$(id -u)" -ne 0 ]] || { log_err "Do not run as root."; exit 1; }
}

copy_dotfiles() {
    log_info "Copying all dotfiles to ~/.config..."
    [[ -d "$DOTFILES_SRC" ]] || { log_err "dotfiles not found at $DOTFILES_SRC"; return 1; }
    mkdir -p "$CONFIG_DST"

    log_info "Backing up existing configs to ${BACKUP_DIR} ..."

    for dir in "$DOTFILES_SRC"/*; do
        [[ -e "$dir" ]] || continue
        base="$(basename "$dir")"
        if [[ -d "$CONFIG_DST/$base" ]]; then
            mkdir -p "$BACKUP_DIR"
            cp -a "$CONFIG_DST/$base" "$BACKUP_DIR/" 2>/dev/null
            log_ok "Backed up ${base} -> ${BACKUP_DIR}/${base}"
        fi
        mkdir -p "$CONFIG_DST/$base"
        rsync -a "$dir"/. "$CONFIG_DST/$base/"
        log_ok "Copied ${base} -> ${CONFIG_DST}/${base}"
    done

    hyprctl reload 2>/dev/null && log_ok "Hyprland reloaded." || log_warn "Hyprland not running, reload skipped."
}

copy_wallpapers() {
    log_info "Copying wallpapers to ~/Pictures..."
    if [[ ! -d "$WALLPAPER_SRC" ]]; then
        log_warn "Wallpapers directory not found at $WALLPAPER_SRC, skipping."
        return 0
    fi
    mkdir -p "$PICTURES_DST"
    local count=0
    for wp in "$WALLPAPER_SRC"/*; do
        [[ -f "$wp" ]] || continue
        local name
        name="$(basename "$wp")"
        if [[ -f "$PICTURES_DST/$name" ]]; then
            mkdir -p "$BACKUP_DIR"
            cp -a "$PICTURES_DST/$name" "$BACKUP_DIR/$name" 2>/dev/null
            log_ok "Backed up existing $name -> ${BACKUP_DIR}/${name}"
        fi
        cp -a "$wp" "$PICTURES_DST/$name"
        log_ok "Copied wallpaper ${name} -> ${PICTURES_DST}/${name}"
        ((count++))
    done
    [[ "$count" -gt 0 ]] && log_ok "Wallpapers copied (${count} files)." || log_warn "No wallpapers found."
}

main() {
    preflight
    [[ -d "$DOTFILES_SRC" ]] || { log_err "dotfiles not found at $DOTFILES_SRC"; exit 1; }
    copy_dotfiles
    copy_wallpapers
    echo ""
    log_ok "All done! Log: ${LOG_FILE}"
}

main "$@"
