<p align="center">
  <a href="README.md">🇬🇧 English</a>
</p>

<h1 align="center">
  🖥️ CachyOS My Dotfiles
</h1>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue" alt="MIT"></a>
  <img src="https://img.shields.io/badge/ASUS-TUF%20A15%20FA506ICB-orange" alt="ASUS TUF">
  <img src="https://img.shields.io/badge/WM-Hyprland%20Noctalia-ff69b4" alt="Hyprland">
  <img src="https://img.shields.io/badge/OS-CachyOS-cyan" alt="CachyOS">
  <img src="https://img.shields.io/badge/GPU-NVIDIA%20RTX%203050-grey" alt="NVIDIA">
</p>

<p align="center">
  <b>Dotfiles CachyOS + Hyprland Noctalia simple</b> untuk ASUS TUF Gaming A15 (AMD Renoir + NVIDIA RTX 3050, Wayland).
</p>

---

## 📸 Screenshots

<p align="center">
  <img src="assets/screenshots/ss-desktop.png" alt="Desktop" width="600"/>
</p>

<p align="center">
  <img src="assets/screenshots/ss-launcher.png" alt="Launcher" width="300"/>
  <img src="assets/screenshots/ss-animation.png" alt="Animations" width="300"/>
</p>

<p align="center">
  <img src="assets/screenshots/ss-layout.png" alt="Layout" width="300"/>
  <img src="assets/screenshots/ss-monitor.png" alt="Monitor" width="300"/>
</p>

<p align="center">
  <img src="assets/screenshots/ss-btop.png" alt="btop" width="300"/>
  <img src="assets/screenshots/ss-fastfetch.png" alt="Fastfetch" width="300"/>
</p>

---

## ✨ Tentang

Dotfiles minimal untuk desktop **CachyOS + Hyprland Noctalia**, dibangun di atas opsi instalasi **CachyOS Hyprland Noctalia** resmi — tanpa membangun DE manual, tanpa setup "No Desktop".

- **Shell / panel / launcher:** Noctalia (gaya Noctalia Shell)
- **Konfigurasi WM:** Hyprland Lua API (`hyprland.lua`, di-load lewat uwsm)
- **Keybind:** gaya Noctalia/Omarchy (modifier `SUPER`)
- **GPU:** default AMD Renoir iGPU (hemat baterai), NVIDIA RTX 3050 on-demand untuk edit/gaming

---

## 🚀 Install CachyOS + Hyprland

Hyprland Noctalia kini adalah **opsi desktop utama** di installer CachyOS (sejak **ISO Juni 2026**).

1. Unduh ISO desktop: <https://cachyos.org/download/>, lalu flash ke USB (mis. `dd` atau Ventoy).
2. Boot dari USB, jalankan **CachyOS Hello**, lalu klik **Install**.
3. Di **desktop picker**, pilih **Hyprland Noctalia** (opsi yang sudah terkonfigurasi).
4. Selesaikan installer Calamares (partisi, user, bootloader). Disarankan **Btrfs + Snapper** untuk rollback.
5. Setelah reboot, masuk ke sesi **Hyprland (Noctalia)**.

> Installer kini menyediakan Noctalia sebagai opsi desktop utama (selain KDE, GNOME, Niri, i3, bspwm, Sway, Wayfire, Qtile). `paru` diganti dengan **Shelly** — pakai `shelly` untuk install AUR.

---

## 📦 Install dotfiles ini

Clone dan jalankan **satu script**:

```bash
git clone https://github.com/tofan79/cachyos-mydotfiles
cd cachyos-mydotfiles
chmod +x mydotfiles.sh
./mydotfiles.sh
```

`mydotfiles.sh` sekarang **simple dan aman** — hanya:

1. **Backup** `~/.config/{fastfetch,hypr,uwsm}` yang sudah ada ke `~/.config-backup-<timestamp>/`
2. **Menyalin** tiga folder config tersebut dari `dotfiles/` ke tempatnya
3. **Menyalin** `Wallpapers/` → `~/Pictures/` (backup dulu file dengan nama sama)
4. Reload Hyprland

**Tanpa sudo. Tanpa perubahan sistem. Config lain tidak tersentuh.** Semua direktori config lain (GTK, kitty, cava, MangoHud, …) dibiarkan apa adanya.

---

## 📁 Isi `dotfiles/`

| Folder | Isi |
|--------|-----|
| `dotfiles/hypr/` | Config Lua Hyprland + keybind Omarchy + script |
| `dotfiles/uwsm/` | `env` — variabel GPU/env, browser default, env sesi |
| `dotfiles/fastfetch/` | Config fastfetch + tema Noctalia |

### Wallpaper

`Wallpapers/` (`BG02.png`, `BG03.png`) disalin ke `~/Pictures/`.

---

## ⌨️ Keybindings

Semua pakai `SUPER` (tombol Windows). Didefinisikan di `~/.config/hypr/config/binds.lua`.

### Core & Shell

| Key | Aksi |
|-----|------|
| `SUPER + Q` | Tutup jendela |
| `SUPER + SHIFT + R` | Reload Hyprland |
| `SUPER + Escape` | Menu sesi (Noctalia) |
| `SUPER + CTRL + L` | Kunci layar |
| `SUPER + Space` | App launcher (panel Noctalia) |
| `SUPER + CTRL + Space` | Toggle settings |
| `SUPER + CTRL + comma` | Bersihkan clipboard |
| `SUPER + CTRL + C` | Toggle caffeine |
| `CTRL + SHIFT + Escape` | System monitor btop |
| `SUPER + /` | System monitor (procmon) |

### Window & Layout

| Key | Aksi |
|-----|------|
| `SUPER + arrows` | Smart focus |
| `SUPER + SHIFT + arrows` | Smart swap |
| `SUPER + CTRL + up/down` | Workspace sebelum / sesudah |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + SHIFT + F` | Maximize |
| `SUPER + SHIFT + T` | Toggle floating |
| `SUPER + ALT + T` | Toggle floating + pinned |
| `SUPER + CTRL + R` | Masuk mode resize |
| `ALT + Tab` | Cycle windows |
| `SUPER + CTRL + K` | (Dwindle) swap split |
| `SUPER + CTRL + J` | (Dwindle) toggle split |
| `SUPER + CTRL + M` | (Master) cycle orientation |

### Groups

| Key | Aksi |
|-----|------|
| `SUPER + SHIFT + G` | Toggle window group |
| `SUPER + CTRL + G` | Keluar dari group |
| `SUPER + CTRL + [` / `]` | Masuk group kiri / kanan |
| `SUPER + ALT + ]` / `[` | Masuk group atas / bawah |
| `SUPER + Tab` / `SHIFT + Tab` | Group next / prev |
| `SUPER + CTRL + 1-9` | Group index |

### Apps (pakai `variables.lua` — sumber kebenaran tunggal)

| Key | App |
|-----|-----|
| `SUPER + Return` | **kitty** (terminal) |
| `SUPER + E` | **dolphin** (file manager) |
| `SUPER + B` | **zen-browser** (browser) |
| `SUPER + N` | **zeditor** (editor) |
| `SUPER + Y` | Music player (mpv) |
| `SUPER + O` | Video player (mpv) |
| `SUPER + I` | Image viewer (loupe) |
| `XF86Calculator` | Kalkulator (gnome-calculator) |
| `SUPER + T` | Telegram |
| `SUPER + W` | Karere |
| `SUPER + D` | Vesktop (Discord) |
| `SUPER + G` | Steam |

> Semua bind app dibaca dari `~/.config/hypr/config/variables.lua`. Ubah `TERMINAL`, `FILE_MANAGER`, `BROWSER`, `EDITOR`, dst. cukup di satu tempat.

### Workspace & Mouse

| Key | Aksi |
|-----|------|
| `SUPER + 1-9` | Pindah workspace |
| `SUPER + SHIFT + 1-9` | Pindahkan jendela ke workspace |
| `SUPER + S` | Toggle special workspace |
| `SUPER + klik kiri/kanan` | Pindah / resize jendela |
| `SUPER + scroll` | Workspace sebelum / sesudah |

### Media / Lainnya

| Key | Aksi |
|-----|------|
| `XF86Audio*` | Volume / mute / mic / media (panel media) |
| `XF86MonBrightnessUp/Down` | Kecerahan |
| `Print` / `SHIFT+Print` / `CTRL+Print` | Screenshot region / fullscreen / window |
| `SUPER + P` | Color picker (hyprpicker) |
| `SUPER + .` | Panel emoji |
| `SUPER + SHIFT + L` | Google Lens (region) |
| `SUPER + SHIFT + O` | OCR (region) |
| `SUPER + SHIFT + Q` | Scan QR (region) |
| `SUPER + Minus` / `Plus` | Zoom kursor keluar / masuk |

---

## 🎛️ Susunan config

| Layer | Pilihan |
|-------|---------|
| Desktop | CachyOS Hyprland Noctalia |
| Shell | Zsh + Powerlevel10k |
| Terminal | kitty (ComicShannsMono Nerd Font, transparansi, padding) |
| File manager | dolphin |
| Browser | zen-browser |
| Editor | zeditor |
| Panel / launcher | Noctalia |
| Image viewer | loupe |
| Music / video | mpv |

### Mengubah default app

Semua app default ada di `~/.config/hypr/config/variables.lua`:

```lua
TERMINAL     = "kitty"
FILE_MANAGER = "dolphin"
BROWSER      = "zen-browser"
EDITOR       = "zeditor"
```

Binding membaca variabel ini, jadi kamu cukup mengubahnya **di satu tempat**.

---

## 🎮 Gaming

Gaming lewat **Steam / Lutris, dll.** Bisa diluncurkan lewat keybind `SUPER + G` / Steam. Karena sistem memakai **AMD iGPU** sebagai default, `game-launch.sh` memaksa **NVIDIA** untuk gaming, dibungkus GameMode + MangoHud.

Set `game-launch.sh` sebagai launch option Steam:

```bash
#!/usr/bin/env bash
# ~/.config/hypr/scripts/game-launch.sh
set -euo pipefail

# Paksa render NVIDIA (default sistem = AMD iGPU)
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export GBM_BACKEND=nvidia-drm
export __VK_LAYER_NV_optimus=NVIDIA_only

exec gamemoderun mangohud "$@"
```

> Pakai di Steam sebagai `~/.config/hypr/scripts/game-launch.sh %command%`.

Config MangoHud: posisi atas-tengah, statistik GPU/CPU, frametime, background nol.

---

## 🧼 Maintenance

```bash
~/.config/clean/clean.sh
```

Pembersihan sistem yang aman: cache pacman (keep 2), orphan, cache Shelly/flatpak, clipboard, cache browser/GPU/Qt, journal (>3 hari), trash, history zsh, thumbnail. (Tanpa menghapus `/tmp` yang berbahaya.)

---

## 📝 Catatan

- **GPU:** Default adalah AMD Renoir iGPU (hemat baterai). NVIDIA dipakai on-demand untuk editing/gaming. Env ada di `~/.config/uwsm/env`.
- **Runtime config:** `uwsm` memuat config Lua Hyprland (`hyprland.lua`).
- **AUR helper:** Shelly (default CachyOS), bukan paru/yay.
- **Sumber paket:** repo CachyOS + mirror binary Chaotic-AUR.

---

## 🙏 Kredit

- [Noctalia Shell](https://github.com/noctalia-dev/noctalia)
- [Hyprland](https://hyprland.org)
- [CachyOS](https://cachyos.org) — opsi desktop Hyprland Noctalia

---

## 📄 Lisensi

[MIT](LICENSE) © 2026 tofan79