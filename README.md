# 🏠 CachyOS My Dotfiles

Personal dotfiles for **ASUS TUF Gaming A15 FA506ICB** — AMD Renoir + NVIDIA RTX 3050.

Dual setup:
- **Current:** Hyprland (git, Lua API) + Noctalia Shell v5
- **Legacy:** MangoWM + Noctalia (`mango-noctalia.sh`)

---

## 📦 Quick Install

```bash
git clone https://github.com/tofan79/cachyos-mydotfiles.git && cd cachyos-mydotfiles
chmod +x *.sh
```

| Step | Script | What it does |
|------|--------|-------------|
| 1 | `./install.sh` | Core OS (Chaotic-AUR + packages + fonts + themes, Nerd Fonts, Oh My Zsh + Powerlevel10k, mise, opencode, Flatpak + Flathub, dotfiles for kitty/gtk/qt/btop/zsh, wallpapers) |
| 2 | `./hyprland-noctalia.sh` | Hyprland + Noctalia + SDDM + rofi + switcheroo-control (enabled) + polkit fix + HM dotfiles (hypr/, rofi/, xdg-desktop-portal/, fastfetch/, MangoHud/, nvim/) |
| 3 | `./apps.sh` | Apps: Nautilus, Zen browser, Neovim + AstroNvim, tmux, Yazi, MPV, imv, Telegram, LocalSend, ASUS tools, desktop file fixes, remove CachyOS bloat |
| 4 | `sudo ./firewall.sh` | UFW: deny incoming, allow LocalSend (53317/udp+tcp), enable + systemctl enable |

---

## 🧩 Scripts Detail

### `install.sh`

**Packages:**
- **Dev:** `base-devel git curl wget rsync libva-utils cmake meson ninja python python-pip shellcheck openssh flatpak`
- **Display/WM:** `kitty`
- **CLI:** `bat fzf zoxide fastfetch jq tmux ripgrep fd tree unzip zip bc lsof pciutils usbutils hwinfo grim slurp wl-clipboard brightnessctl playerctl eza pamixer wlsunset lm_sensors dua-cli`
- **Fonts:** `ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-meslo-nerd-font-powerlevel10k noto-fonts noto-fonts-emoji adobe-source-code-pro-fonts otf-comicshanns-nerd ttf-ms-fonts`
- **Theming:** `qt6ct qt5ct gtk3 gtk4 libadwaita adwaita-icon-theme papirus-icon-theme adw-gtk-theme bibata-cursor-theme tela-icon-theme`
- **GStreamer:** `gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav x264 x265`
- **FS tools:** `exfatprogs ntfs-3g btrfs-progs cifs-utils dosfstools smartmontools logrotate tcpdump`

**Setup:**
- Chaotic-AUR key, keyring, mirrorlist, added to `/etc/pacman.conf`
- Flatpak + Flathub remote + OBS Studio (+ PipeWire plugin) + Karere
- Tela icon theme (`tela-icon-theme` from Chaotic-AUR → `Tela-nord-dark`)
- Bibata cursor (`bibata-cursor-theme` from Chaotic-AUR → `Bibata-Modern-Ice`)
- JetBrainsMono + FiraCode Nerd Fonts (manual download)
- Oh My Zsh + Powerlevel10k + zsh-autosuggestions + zsh-syntax-highlighting + zsh-completions
- `.zshrc` merges with existing (fastfetch prepended, custom aliases appended); `.p10k.zsh` overwrites
- `chsh` to zsh, pacman aliases (including `update = sudo pacman -Syu && flatpak update -y`)
- fastfetch config: CachyOS logo + Arch icon
- Kitty font: `ComicShannsMono Nerd Font` 11pt
- mise (runtime manager)
- opencode
- Kitty as default terminal (`xdg-mime`)
- Sensors auto-detect

**Copied:**
- `dotfiles/kitty/` → `~/.config/kitty/`
- `dotfiles/gtk-3.0/` → `~/.config/gtk-3.0/`
- `dotfiles/gtk-4.0/` → `~/.config/gtk-4.0/`
- `dotfiles/qt5ct/` → `~/.config/qt5ct/`
- `dotfiles/qt6ct/` → `~/.config/qt6ct/`
- `dotfiles/btop/` → `~/.config/btop/`
- `dotfiles/zsh/.zshrc` → `~/` (merged with existing, not overwritten). `.p10k.zsh` → `~/`
- `Wallpapers/` → `~/Pictures/Wallpapers/`
- `dotfiles/clean/clean.sh` → `~/.config/clean/`

### `hyprland-noctalia.sh`

**Packages:** `hyprland-git rofi cliphist xdg-desktop-portal-hyprland hyprpicker nvidia-utils lib32-nvidia-utils sddm switcheroo-control`  
**AUR:** `noctalia-git` (via paru)

**Setup:**
- SDDM enabled as display manager
- `switcheroo-control` service enabled for NVIDIA dGPU switching
- Session file: `/usr/share/wayland-sessions/hyprland.desktop` → "Hyprland (Noctalia)"
- Polkit fix: `/etc/polkit-1/rules.d/49-networkmanager.rules` — bypasses polkit prompt for NetworkManager actions (fixes Noctalia WiFi D-Bus crash, GitHub issue #3013)

**Copied:**
- `dotfiles/hypr/` → `~/.config/hypr/`
- `dotfiles/rofi/` → `~/.config/rofi/`
- `dotfiles/xdg-desktop-portal/` → `~/.config/xdg-desktop-portal/`
- `dotfiles/fastfetch/` → `~/.config/fastfetch/`
- `dotfiles/MangoHud/` → `~/.config/MangoHud/`
- `dotfiles/nvim/` → `~/.config/nvim/`

### `apps.sh`

**Packages:**
- **Desktop:** `nautilus gvfs gvfs-afc gvfs-gphoto2 gvfs-smb libmtp yazi neovim btop mpv imv gnome-disk-utility gnome-calculator`
- **Qt:** `qt6-declarative qt6-svg qt6-multimedia qt6-multimedia-ffmpeg qt6-5compat pavucontrol`
- **Utils:** `tesseract tesseract-data-eng imagemagick xdg-desktop-portal-gtk xdg-utils xdg-user-dirs python-gobject wtype wdisplays cava`
- **Network:** `ncdu httpie bind whois traceroute mtr socat nmap github-cli strace python-pipx`
- **Apps:** `telegram-desktop localsend zen-browser-bin asusctl rog-control-center zed nautilus-python protonplus ab-download-manager faugus-launcher`
- **Gaming:** `gamemode lib32-gamemode`
- **Dev:** `ffmpegthumbnailer nautilus-image-converter lazygit nodejs bottom gdu`

**Setup:**
- ASUS daemon (`asusd`) enabled
- Desktop file fixes: btop, nvim, yazi → run inside Kitty
- Neovim AstroNvim config (from `dotfiles/nvim/`)
- tmux config (from `dotfiles/tmux/`)
- Icon/cursor theme applied via `gsettings`
- Removes pre-installed CachyOS bloat: micro, alacritty, meld, cachyos-micro-settings
- Hides unused desktop entries: avahi-discover, bssh, bvnc, qv4l2, qvidcap

### `firewall.sh`

```bash
ufw default deny incoming
ufw default allow outgoing
ufw allow 53317/udp
ufw allow 53317/tcp
ufw --force enable
systemctl enable ufw
```

---

## 🪟 Hyprland Config (`~/.config/hypr/`)

Entry point: `hyprland.lua`

```lua
require("monitor")
require("env")
require("noctalia")
dofile("windows/glass.lua")
dofile("decorations/rounding-all-blur.lua")
dofile("animations/animations-moving.lua")
require("keybinds")
require("rules")
require("layouts")
require("gestures")
require("startup")
```

### `monitor.lua`
```lua
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "auto",
    scale    = 1,
    vrr      = 1,
})
```

### `env.lua`
```lua
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
```

### `noctalia.lua`
Generated by Noctalia. Variables must be **global** (no `local`):
```lua
primary = "rgb(58a6ff)"
surface = "rgb(010409)"
secondary = "rgb(bc8cff)"
error = "rgb(f85149)"
on_primary = "rgb(010409)"

hl.config({
    general = { col = {
        active_border = primary,
        inactive_border = surface,
    }},
    group = { col = { ... }},
})
```
> ⚠️ Noctalia regenerates this file on updates, removing global variable edits. Re-apply after Noctalia updates.

### `layouts.lua`
- **Dwindle:** `preserve_split = true`, `force_split = 2`
- **Scrolling:** `fullscreen_on_one_column = false`
- Noctalia blur layer rule: `^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$`
- Persistent workspaces 1-9
- Workspace layout: 1-4 scrolling, 5-9 dwindle

### `rules.lua`
| App | Behavior |
|-----|----------|
| Steam | Floating (1200×800) + idle inhibit |
| LocalSend | Floating (800×600) — two class patterns |
| GNOME Calculator | Floating (400×500) |
| Pavucontrol | Floating (800×600) |
| Btop (kitty -T btop) | Floating (1200×700) |
| imv | Floating (900×700) |
| mpv | Floating (900×600) |
| XWayland empty drag fix | `no_focus = true` |

### `gestures.lua`
| Gesture | Action |
|---------|--------|
| 3-finger vertical | Workspace switch |
| 3-finger horizontal | Scroll move (0.9 scale) |
| 4-finger pinch out | Fullscreen on |
| 4-finger pinch in | Fullscreen off |

### `startup.lua`
```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment ...")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("noctalia")
end)
```

---

## ⌨️ Keybindings

All binds use `SUPER` (Windows key). View at runtime: `SUPER + SHIFT + K`

### Core
| Key | Action |
|-----|--------|
| `SUPER + Q` | Close window |
| `SUPER + CTRL + R` | Reload Hyprland |
| `SUPER + CTRL + M` | Exit Hyprland |
| `SUPER + Escape` | Session menu (Noctalia) |
| `SUPER + /` | System monitor (btop) |

### Noctalia Shell
| Key | Action |
|-----|--------|
| `SUPER + Space` | App launcher |
| `SUPER + ALT + Space` | Control center |
| `SUPER + CTRL + Space` | Settings toggle |

### Focus & Swap (Vim-style arrows)
| Key | Action |
|-----|--------|
| `SUPER + ↑/←/↓/→` | Move focus |
| `SUPER + SHIFT + ↑/←/↓/→` | Swap window |
| `SUPER + CTRL + ←/→` | Prev/Next workspace |

### Window States
| Key | Action |
|-----|--------|
| `SUPER + F` | Toggle fullscreen |
| `SUPER + SHIFT + F` | Toggle maximized |
| `SUPER + SHIFT + T` | Toggle floating |
| `SUPER + ALT + T` | Toggle floating + pinned |

### Scratchpad
| Key | Action |
|-----|--------|
| `SUPER + S` | Toggle special workspace |
| `SUPER + SHIFT + S` | Send to special |
| `SUPER + SHIFT + CTRL + S` | Move out of special |

### Layout
| Key | Action |
|-----|--------|
| `SUPER + CTRL + L` | Cycle layout (dwindle ↔ scrolling) |
| `SUPER + CTRL + K` | Swap split |
| `SUPER + CTRL + J` | Toggle split |

### Window Groups
| Key | Action |
|-----|--------|
| `SUPER + CTRL + G` | Toggle group |
| `SUPER + ALT + G` | Out of group |
| `SUPER + ALT + ↑/←/↓/→` | Into group direction |
| `SUPER + Tab` / `SUPER + SHIFT + Tab` | Group next/prev |
| `SUPER + ALT + 1-5` | Group index |

### Preset Switching (Rofi)
| Key | Action |
|-----|--------|
| `SUPER + CTRL + A` | Switch animation preset |
| `SUPER + CTRL + D` | Switch decoration preset |
| `SUPER + CTRL + W` | Switch window preset |
| `SUPER + SHIFT + A` | Toggle animations on/off |

### App Launchers
| Key | App |
|-----|-----|
| `SUPER + Enter` | Kitty terminal |
| `SUPER + E` | Nautilus file manager |
| `SUPER + B` | Zen browser |
| `SUPER + N` | Zed editor |
| `SUPER + H` | LocalSend |
| `SUPER + T` | Telegram |

### Workspaces
| Key | Action |
|-----|--------|
| `SUPER + 1-9` | Switch to workspace |
| `SUPER + SHIFT + 1-9` | Move window to workspace |
| `SUPER + Scroll` | Workspace switch |

### Media Keys
| Key | Action |
|-----|--------|
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Mute audio |
| `XF86AudioMicMute` | Mute mic |
| `XF86AudioPlay` | Play/pause |
| `XF86AudioNext` | Next track |
| `XF86AudioPrev` | Previous track |
| `XF86MonBrightnessUp/Down` | Brightness |
| `Print` | Screenshot region |
| `SUPER + SHIFT + Print` | Screenshot fullscreen |

### Multi-Monitor
| Key | Action |
|-----|--------|
| `SUPER + CTRL + ALT + ↑/←/↓/→` | Focus monitor |
| `SUPER + CTRL + ALT + SHIFT + ↑/←/↓/→` | Move to monitor |

### Resize & Move (Floating)
| Key | Action |
|-----|--------|
| `CTRL + ALT + ↑/←/↓/→` | Resize window |
| `CTRL + SHIFT + ↑/←/↓/→` | Move floating window |

### Mouse
| Key | Action |
|-----|--------|
| `SUPER + left click` | Drag/move window |
| `SUPER + right click` | Resize window |
| `Middle click` | Fullscreen toggle |

### Other
| Key | Action |
|-----|--------|
| `ALT + Tab` | Cycle windows |
| `CTRL + ALT + Tab` | Cycle windows (alt) |

---

## 🎨 Presets

### Animations (`~/.config/hypr/animations/*.lua`)
10 presets switchable via `SUPER + CTRL + A` (rofi):
`animations-classic`, `animations-dynamic`, `animations-end4`, `animations-fast`, `animations-high`, `animations-moving`, `animations-smooth`, `default`, `disabled`, `standard`

Default: `animations-moving.lua` — bezier curves (overshot, smoothOut, smoothIn), speed 3-6

### Decorations (`~/.config/hypr/decorations/*.lua`)
10 presets via `SUPER + CTRL + D`:
`blur`, `default`, `gamemode`, `no-blur`, `no-rounding`, `no-rounding-more-blur`, `rounding-all-blur`, `rounding-all-blur-no-shadows`, `rounding`, `rounding-more-blur`

Default: `rounding-all-blur.lua` — rounding 10px, opacity 0.9/0.7, blur size 2/passes 2, xray, shadow range 30

### Windows (`~/.config/hypr/windows/*.lua`)
14 presets via `SUPER + CTRL + W`:
`border-1..4`, `border-1..4-reverse`, `default`, `gamemode`, `glass`, `no-border`, `no-border-more-gaps`, `transparent`

Default: `glass.lua` — gaps_in 5, gaps_out 10, border 2px, gradient active border (primary→on_primary at 90°)

---

## 🎮 Gaming

### `game-launch.sh`

```bash
export NVPRESENT_ENABLE_SMOOTH_MOTION=1    # NVIDIA Smooth Motion (frame gen)
export DXVK_NVAPI_VKREFLEX=1               # NVIDIA Reflex for Vulkan
export PROTON_ENABLE_NGX_UPDATER=1         # DLSS auto-update

exec switcherooctl launch -- gamemoderun mangohud "$@"
```

**Steam launch option:**
```
~/.config/hypr/scripts/game-launch.sh %command%
```

Uses `switcherooctl` to launch on NVIDIA dGPU (Device 1). AMD iGPU is Device 0 (default).

### MangoHud (`~/.config/MangoHud/MangoHud.conf`)
```
position=top-center
gpu_stats gpu_temp gpu_name
cpu_stats cpu_temp
ram fps frame_timing
font_size=15
background_alpha=0
```

---

## 🛠️ Scripts (`~/.config/hypr/scripts/`)

| Script | Bind | Function |
|--------|------|----------|
| `keybindings.sh` | `SUPER + SHIFT + K` | Interactive keybind viewer (rofi, parses `hyprctl binds -j`) |
| `switch-animations.sh` | `SUPER + CTRL + A` | Rofi selector for animation presets |
| `switch-decorations.sh` | `SUPER + CTRL + D` | Rofi selector for decoration presets |
| `switch-windows.sh` | `SUPER + CTRL + W` | Rofi selector for window presets |
| `toggle-animations.sh` | `SUPER + SHIFT + A` | Toggle animations on/off (cache-based) |
| `text-extractor.sh` | `SUPER + ALT + A` | Select region → OCR (Tesseract) → clipboard |
| `game-launch.sh` | — | NVIDIA Smooth Motion + Reflex + DLSS + switcherooctl + gamemode + MangoHud |

---

## 🎨 Theme Stack

| Layer | Theme |
|-------|-------|
| **Icons** | `Tela-nord-dark` (GTK + gsettings) |
| **Cursor** | `Bibata-Modern-Ice` 24px |
| **GTK** | Adwaita theme |
| **Qt5/Qt6** | Fusion style + Noctalia custom palette |
| **Terminal** | Kitty + ComicShannsMono Nerd Font 11pt + Noctalia theme |
| **Shell** | Zsh + Powerlevel10k (rainbow style) |
| **Monitor** | Btop + Noctalia theme |
| **Rofi** | Noctalia theme, centered, rounded 24px, JetBrainsMono Nerd Font |

---

## 📁 Complete Dotfiles Reference

| Dir | Script | Contents |
|-----|--------|----------|
| `hypr/` | `hyprland-noctalia.sh` | Full Hyprland Lua config: keybinds, layouts, monitor, rules, gestures, env, presets (animations/decorations/windows), scripts |
| `rofi/` | `hyprland-noctalia.sh` | Noctalia theme, centered config |
| `xdg-desktop-portal/` | `hyprland-noctalia.sh` | `default=hyprland` |
| `fastfetch/` | `hyprland-noctalia.sh` | Custom Omarchy layout: Hardware (host/cpu/gpu/display/disk/mem/swap), Software (os/kernel/wm/terminal/packages/noctalia scheme/font), Age/Uptime |
| `MangoHud/` | `hyprland-noctalia.sh` | Gaming overlay config |
| `nvim/` | `hyprland-noctalia.sh` + `apps.sh` | AstroNvim v6: Lazy.nvim, Mason, Treesitter, LSP, none-ls, custom plugins |
| `kitty/` | `install.sh` | ComicShannsMono Nerd Font 11pt, Noctalia theme, padding 14, blur 0.9, powerline tabs, splits/stack layouts |
| `gtk-3.0/` | `install.sh` | `Tela-nord-dark`, `Bibata-Modern-Ice`, `Adwaita` |
| `gtk-4.0/` | `install.sh` | `Tela-nord-dark` |
| `qt5ct/` | `install.sh` | Fusion style + Noctalia custom palette |
| `qt6ct/` | `install.sh` | Fusion style + Noctalia custom palette |
| `btop/` | `install.sh` | `color_theme = "noctalia"` + noctalia.theme |
| `zsh/` | `install.sh` | `.zshrc` (fastfetch, P10k, zoxide, fzf, mise, opencode), `.p10k.zsh` |
| `clean/` | `install.sh` | `clean.sh` — system cleanup script |
| `tmux/` | `apps.sh` | Prefix `C-Space`, Vi mode, Kitty integration, minimal blue theme |
| `Wallpapers/` | `install.sh` | Copied to `~/Pictures/Wallpapers/` |
| `DaVinci_Resolve/` | `install.sh` | Install/update notes → `~/Projects/DaVinci_Resolve/` |
| `docker-db/` | `install.sh` | MariaDB + phpMyAdmin + PostgreSQL + pgAdmin dev DB → `~/Projects/docker-db/` |

---

## 🧼 Maintenance

```bash
# System cleanup
~/.config/clean/clean.sh
```
Cleans: pacman cache, orphans, AUR caches (yay/paru), Flatpak unused runtimes, Go build/module cache, pip cache, npm cache, Cargo registry, mise tarballs + cache clear, temp files, journal logs (>3d), trash, browser caches (Zen/Chromium), mesa/RADV/NVIDIA shader caches, Qt/GTK caches, opencode/zed cache, zsh history, thumbnails.

---

## 🔌 Polkit Fix (Noctalia WiFi)

`/etc/polkit-1/rules.d/49-networkmanager.rules` — bypasses polkit prompt for NetworkManager actions. Resolves Noctalia Shell D-Bus timeout crash (GitHub issue #3013).

---

## ⚡ Runtime Config

Change any Hyprland setting at runtime via:
```bash
hyprctl eval "hl.config({ ... })"
```

Swap active layout:
```bash
hyprctl eval "hl.config({ master = { mfactor = 0.5 } })"
```

---

## 🗺️ Workspace Layout

| Workspace | Layout |
|-----------|--------|
| 1-4 | Scrolling |
| 5-9 | Dwindle |

All workspaces persistent (visible in Noctalia bar when empty).

---

## 🐍 Notes

- `hyprctl eval "hl.config({...})"` — cara bener untuk runtime config di Hyprland Lua API
- Noctalia regenerates `noctalia.lua` on updates — global variables (`primary`, `surface`, `secondary`, `error`, `on_primary`) must be re-applied
- Session name: **"Hyprland (Noctalia)"** in SDDM
- **Sumber package:** CachyOS official + Chaotic-AUR (binary) + AUR hanya `noctalia-git` (via `paru`, karena `noctalia-shell` di Chaotic terlalu tua)
