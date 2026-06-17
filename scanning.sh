#!/usr/bin/env bash
# AUR Security Scanner — cek package AUR terinstal dari daftar known compromised
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/scanning.log"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log_info() { echo -e "${CYAN}[INFO]${NC}  $*"; }
log_ok()   { echo -e "${GREEN}[OK]${NC}   $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC}  $*"; }
log_err()  { echo -e "${RED}[ERROR]${NC} $*"; }

if [[ -f "$LOG_FILE" ]]; then
    mv "$LOG_FILE" "${LOG_FILE}.old.$(date +%Y%m%d%H%M%S)"
fi
exec > >(tee -a "$LOG_FILE") 2>&1

echo "╔══════════════════════════════════════════════════════════╗"
echo "║       AUR Security Scanner — Atomic Arch Check          ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

KNOWN_LIST_URL="https://raw.githubusercontent.com/lenucksi/aur-malware-check/main/package_list.txt"
NPM_IOC=("atomic-lockfile" "js-digest" "lockfile-js")

detect_pkg_manager() {
    if command -v pacman &>/dev/null; then
        log_ok "Package manager: pacman (Arch/CachyOS)"
        return 0
    fi
    log_err "Hanya untuk Arch/CachyOS (pake pacman)."
    exit 1
}

check_aur_packages() {
    log_info "Mengambil daftar AUR package terinstal..."
    local aur_pkgs
    aur_pkgs=$(pacman -Qqm 2>/dev/null || true)
    if [[ -z "$aur_pkgs" ]]; then
        log_ok "Tidak ada AUR package terinstal."
        return 0
    fi
    echo -e "  AUR packages: $(echo "$aur_pkgs" | wc -l)"
    echo ""

    log_info "Mendownload daftar known compromised packages..."
    local known_list
    known_list=$(curl -fsSL "$KNOWN_LIST_URL" 2>/dev/null || true)
    if [[ -z "$known_list" ]]; then
        log_warn "Gagal download daftar compromised. Cek koneksi."
        return 1
    fi

    local found=0
    while IFS= read -r pkg; do
        [[ -z "$pkg" ]] && continue
        if echo "$known_list" | grep -qi "^${pkg}$"; then
            log_err "TERINFEKSI: ${pkg} — ada di daftar compromised!"
            found=$((found + 1))
        fi
    done <<< "$aur_pkgs"

    if [[ $found -eq 0 ]]; then
        log_ok "Tidak ada AUR package yang cocok dengan daftar compromised."
    else
        echo ""
        log_warn "Ditemukan ${found} package terinfeksi. Segera hapus: sudo pacman -Rns <package>"
    fi
}

check_pacman_cache() {
    log_info "Memeriksa pacman cache untuk file .install mencurigakan..."
    local cache_dirs=("/var/cache/pacman/pkg" "$HOME/.cache/yay" "$HOME/.cache/paru")
    local suspicious=0
    for dir in "${cache_dirs[@]}"; do
        [[ -d "$dir" ]] || continue
        while IFS= read -r file; do
            if grep -qE 'npm install (atomic-lockfile|js-digest|lockfile-js)' "$file" 2>/dev/null; then
                log_err "SUSPICIOUS: ${file} mengandung npm malicious!"
                suspicious=$((suspicious + 1))
            fi
            if grep -qE 'bun install (atomic-lockfile|js-digest|lockfile-js)' "$file" 2>/dev/null; then
                log_err "SUSPICIOUS: ${file} mengandung bun malicious!"
                suspicious=$((suspicious + 1))
            fi
        done < <(find "$dir" -name "*.install" -o -name "PKGBUILD" 2>/dev/null || true)
    done
    if [[ $suspicious -eq 0 ]]; then
        log_ok "Tidak ada file .install/PKGBUILD mencurigakan di cache."
    fi
}

check_npm_bun_cache() {
    log_info "Memeriksa ~/.npm dan ~/.bun cache..."
    local found=0
    for ioc in "${NPM_IOC[@]}"; do
        if [[ -d "$HOME/.npm/_npx/$ioc" ]] || [[ -d "$HOME/.bun/install/cache/$ioc" ]]; then
            log_err "IOC cache ditemukan: ${ioc}"
            found=$((found + 1))
        fi
    done
    if [[ $found -eq 0 ]]; then
        log_ok "Tidak ada IOC cache di npm/bun."
    fi
}

check_installed_files() {
    log_info "Memeriksa system files untuk indikator malware..."
    local iocs=()
    if grep -qr 'atomic-lockfile' /usr/local/lib 2>/dev/null ||
       grep -qr 'atomic-lockfile' /opt 2>/dev/null; then
        iocs+=("atomic-lockfile references di /usr/local/lib atau /opt")
    fi
    if [[ ${#iocs[@]} -gt 0 ]]; then
        for ioc in "${iocs[@]}"; do
            log_err "IOC: ${ioc}"
        done
    else
        log_ok "Tidak ada IOC filesystem."
    fi
}

check_aur_diff() {
    log_info "Memeriksa AUR package yang diupdate antara 1-15 Juni 2026..."
    local aur_pkgs
    aur_pkgs=$(pacman -Qqm 2>/dev/null || true)
    [[ -z "$aur_pkgs" ]] && return 0
    local suspicious=0
    while IFS= read -r pkg; do
        local install_date
        install_date=$(pacman -Qi "$pkg" 2>/dev/null | grep -i "Install Date" | sed 's/.*: //' || true)
        if echo "$install_date" | grep -qE "Jun 0[1-9]|Jun 1[0-5]"; then
            log_warn "${pkg} diinstall/diupdate ${install_date} — rentang serangan, verifikasi manual"
            suspicious=$((suspicious + 1))
        fi
    done <<< "$aur_pkgs"
    if [[ $suspicious -eq 0 ]]; then
        log_ok "Tidak ada AUR package yang diupdate dalam rentang serangan."
    fi
}

main() {
    detect_pkg_manager

    echo "┌────────────────────────────────────────────────────────┐"
    echo "│ 1/6 — Cek AUR package vs compromised list             │"
    echo "└────────────────────────────────────────────────────────┘"
    check_aur_packages

    echo ""
    echo "┌────────────────────────────────────────────────────────┐"
    echo "│ 2/6 — Cek pacman/helper cache                         │"
    echo "└────────────────────────────────────────────────────────┘"
    check_pacman_cache

    echo ""
    echo "┌────────────────────────────────────────────────────────┐"
    echo "│ 3/6 — Cek npm/bun cache                               │"
    echo "└────────────────────────────────────────────────────────┘"
    check_npm_bun_cache

    echo ""
    echo "┌────────────────────────────────────────────────────────┐"
    echo "│ 4/6 — Cek filesystem IOC                              │"
    echo "└────────────────────────────────────────────────────────┘"
    check_installed_files

    echo ""
    echo "┌────────────────────────────────────────────────────────┐"
    echo "│ 5/6 — Cek AUR packages by install date                │"
    echo "└────────────────────────────────────────────────────────┘"
    check_aur_diff

    echo ""
    echo "┌────────────────────────────────────────────────────────┐"
    echo "│ 6/6 — Ringkasan                                       │"
    echo "└────────────────────────────────────────────────────────┘"
    echo ""
    log_info "Log lengkap: ${LOG_FILE}"
    echo ""
    log_info "Jika ada yang terdeteksi:"
    log_info "  1. Hapus package: sudo pacman -Rns <package>"
    log_info "  2. Ganti semua password yang tersimpan di browser"
    log_info "  3. Rotate SSH keys dan API tokens"
    log_info "  4. Cek proses mencurigakan: ps aux | grep -i npm"
    echo ""
    log_info "Info resmi CachyOS: https://discuss.cachyos.org/t/aur-compromised-1500-packages-affected-20260611/31040"
    log_info "Cek manual: pacman -Qm | grep -Ff <(curl -s https://raw.githubusercontent.com/lenucksi/aur-malware-check/main/package_list.txt)"
}

main "$@"
