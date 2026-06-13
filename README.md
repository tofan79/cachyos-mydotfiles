# CachyOS My Dotfiles

Setup CachyOS untuk ASUS TUF Gaming A15 FA506ICB dengan Noctalia Shell.

## Target Sistem

- AMD Renoir iGPU (default)
- SDDM + MangoWM
- Zen browser, Noctalia v5 (alpha)
- Podman (bukan Docker)

## Cara Pakai

```bash
chmod +x install.sh apps.sh mango-noctalia.sh firewall.sh

# 1. Core OS: packages, icons, fonts, mise, opencode
./install.sh
sudo reboot

# 2. Noctalia shell (setelah reboot)
./mango-noctalia.sh

# 3. Aplikasi harian
./apps.sh

# 4. Firewall (opsional)
sudo ./firewall.sh
```

## Script

| Script | Fungsi |
|--------|--------|
| `install.sh` | Core packages, Tela icons, Bibata cursor, Nerd Fonts, Oh My Zsh, mise, opencode |
| `mango-noctalia.sh` | Noctalia v5 + mangowm + config `dotfiles/mango-noctalia/` |
| `apps.sh` | Nautilus, Zen browser, NvChad, tmux, imv, Yazi, Neovim, GNOME tools, Telegram, ASUS tools |
| `firewall.sh` | UFW — deny incoming, allow LocalSend (53317), Docker DNS |

## Shell

### Noctalia (mango-noctalia.sh)
- **Paket:** `noctalia-git` (AUR), `cliphist`, `fira-code-fonts`
- **Setup:** `dotfiles/mango-noctalia/` di-copy ke `~/.config/mango/`
- **IPC:** `noctalia msg <command>` (panel-toggle, volume-up/down, brightness-up/down, media toggle/next/prev, mic-mute, screenshot, session lock)
- **exec:** `exec-once=noctalia` (per v5 docs)

## Dotfiles

| Direktori | Isi |
|-----------|-----|
| `dotfiles/mango-noctalia/` | Noctalia: config.conf, env.conf, settings.conf, keybinds.conf, layouts.conf, monitor.conf, rules.conf, autostart.sh, bin/ |
| `dotfiles/kitty/` | Kitty terminal config |
| `dotfiles/xdg-desktop-portal/` | Portal config (wlr screencast) |
| `dotfiles/tmux/tmux.conf` | tmux config |
| `dotfiles/nvim/` | NvChad starter |
| `dotfiles/clean/` | CachyOS maintenance script |

## Catatan

- **Zen browser** default (Firefox-based, mic stabil di WebRTC)
- **Qt6 packages** tetap diinstall (dibutuhkan qylock screen lock)
- **playerctl** diinstall untuk media key support
- **Session name:** "MangoWM"
- Hanya `noctalia-git` dari AUR; sisanya dari CachyOS repo
