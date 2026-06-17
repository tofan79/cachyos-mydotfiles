#!/usr/bin/env bash
# UFW firewall setup for CachyOS/Arch
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/firewall.log"

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

[[ "$(id -u)" -eq 0 ]] || { log_err "Run as root: sudo $0"; exit 1; }

log_info "Installing UFW..."
pacman -S --noconfirm ufw || { log_err "UFW install failed."; exit 1; }

log_info "Configuring UFW rules..."
ufw default deny incoming
ufw default allow outgoing

ufw allow 53317/udp
ufw allow 53317/tcp

ufw --force enable
systemctl enable ufw

log_ok "UFW firewall configured. Log: ${LOG_FILE}"
