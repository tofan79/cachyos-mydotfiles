# CachyOS My Dotfiles

Setup CachyOS untuk ASUS TUF Gaming A15 FA506ICB dengan Hyprland + Noctalia Shell.

## Target Sistem

- AMD Renoir iGPU (default) + NVIDIA RTX 3050 (switcheroo-control)
- SDDM + Hyprland (atau MangoWM via legacy)
- Noctalia v5 (AUR)
- Podman (bukan Docker)

## Cara Pakai

```bash
chmod +x install.sh apps.sh hyprland-noctalia.sh

# 1. Core OS: packages, icons, fonts, mise, opencode
./install.sh
sudo reboot

# 2. Hyprland + Noctalia (setelah reboot)
./hyprland-noctalia.sh

# 3. Aplikasi harian
./apps.sh

# 4. Firewall (opsional)
sudo ./firewall.sh
```

## Script

| Script | Fungsi |
|--------|--------|
| `install.sh` | Core packages, Tela icons, Bibata cursor, Nerd Fonts, Oh My Zsh, mise, opencode |
| `hyprland-noctalia.sh` | Hyprland + Noctalia + rofi + switcheroo-control + polkit fix + config |
| `mango-noctalia.sh` | **Legacy** — MangoWM + Noctalia v5 + config |
| `apps.sh` | Nautilus, Zen browser, AstroNvim, tmux, imv, Yazi, Neovim, GNOME tools, Telegram, ASUS tools |
| `firewall.sh` | UFW — deny incoming, allow LocalSend (53317) |

## Dotfiles

### Hyprland (`hyprland-noctalia.sh`)

| Direktori | Isi |
|-----------|-----|
| `dotfiles/hypr/` | Hyprland config (Lua): keybinds, layouts, monitor, rules, gestures, env, animations/decorations/windows presets, scripts |
| `dotfiles/rofi/` | Rofi theme (noctalia, keybind viewer) |
| `dotfiles/xdg-desktop-portal/` | Portal config (hyprland backend) |
| `dotfiles/fastfetch/` | Fastfetch config |
| `dotfiles/MangoHud/` | MangoHud gaming overlay config |
| `dotfiles/nvim/` | AstroNvim config |

### Base system (`install.sh`)

| Direktori | Isi |
|-----------|-----|
| `dotfiles/kitty/` | Kitty terminal (Noctalia theme) |
| `dotfiles/gtk-3.0/` | GTK3 icon/cursor theme |
| `dotfiles/gtk-4.0/` | GTK4 icon/cursor theme |
| `dotfiles/qt5ct/` | Qt5 theme (Noctalia colors) |
| `dotfiles/qt6ct/` | Qt6 theme (Noctalia colors) |
| `dotfiles/btop/` | Btop system monitor (Noctalia theme) |
| `dotfiles/clean/` | CachyOS maintenance script |

### Apps (`apps.sh`)

| Direktori | Isi |
|-----------|-----|
| `dotfiles/nvim/` | AstroNvim template |
| `dotfiles/tmux/` | tmux config |

### Manual copy

| Direktori | Command |
|-----------|---------|
| `dotfiles/zsh/` | `cp dotfiles/zsh/.zshrc ~/ && cp dotfiles/zsh/.p10k.zsh ~/` |

## Gaming

Untuk menjalankan game di Steam dengan optimasi penuh (NVIDIA GPU + Smooth Motion + Reflex + DLSS update + gamemode + MangoHud):

1. Buka Steam → Properties game → Launch Options
2. Isi:
```
~/.config/hypr/scripts/game-launch.sh %command%
```

Script (`hypr/scripts/game-launch.sh`) otomatis mengaktifkan:
- `NVPRESENT_ENABLE_SMOOTH_MOTION=1` — NVIDIA Smooth Motion (frame gen)
- `DXVK_NVAPI_VKREFLEX=1` — NVIDIA Reflex untuk Vulkan
- `PROTON_ENABLE_NGX_UPDATER=1` — DLSS update ke versi terbaru
- `switcherooctl launch` — jalan di NVIDIA GPU
- `gamemoderun` — game mode optimizations
- `mangohud` — performance overlay

## Catatan

- **Session name:** "Hyprland (Noctalia)" atau "MangoWM" (legacy)
- Hanya `noctalia-git` dari AUR; sisanya dari CachyOS repo
- `switcheroo-control` untuk dual GPU (AMD iGPU + NVIDIA dGPU)
- Polkit rules untuk Noctalia WiFi (auto-apply di hyprland-noctalia.sh)
