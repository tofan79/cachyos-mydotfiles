#!/usr/bin/env bash
# UFW firewall setup for CachyOS/Arch
set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'; NC='\033[0m'
log_info() { echo -e "${CYAN}[INFO]${NC}  $*"; }
log_ok()   { echo -e "${GREEN}[OK]${NC}   $*"; }
log_err()  { echo -e "${RED}[ERROR]${NC} $*"; }

[[ "$(id -u)" -eq 0 ]] || { log_err "Run as root: sudo $0"; exit 1; }

log_info "Installing UFW..."
pacman -S --noconfirm ufw

log_info "Configuring UFW rules..."
ufw default deny incoming
ufw default allow outgoing

# Allow ports for LocalSend
ufw allow 53317/udp
ufw allow 53317/tcp

ufw --force enable
systemctl enable ufw

log_ok "UFW firewall configured."
