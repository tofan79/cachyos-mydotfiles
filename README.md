# 🏠 CachyOS My Dotfiles

Personal dotfiles for **ASUS TUF Gaming A15 FA506ICB** — AMD Renoir + NVIDIA RTX 3050.

Setup:
- **Current:** Hyprland (stable, Lua API) + Noctalia Shell v5

---

## 📦 Quick Install

```bash
git clone https://github.com/tofan79/cachyos-mydotfiles.git && cd cachyos-mydotfiles
chmod +x *.sh
```

| Step | Script | What it does |
|------|--------|-------------|
| 1 | `./install.sh` | Core OS (packages + fonts + themes, Nerd Fonts, Oh My Zsh + Powerlevel10k, mise, opencode, Flatpak + Flathub, dotfiles for foot/gtk/qt/btop/cava/zsh, wallpapers) |
| 2 | `./hyprland-noctalia.sh` | Hyprland + Noctalia + SDDM + rofi + switcheroo-control (enabled) + polkit fix + HM dotfiles (hypr/, rofi/, xdg-desktop-portal/, fastfetch/, MangoHud/, nvim/) |
| 3 | `./apps.sh` | Apps: Nautilus, Zen browser, Neovim + AstroNvim, tmux, Yazi, MPV, imv, Telegram, LocalSend, ASUS tools, desktop file fixes, remove CachyOS bloat |
| 4 | `sudo ./firewall.sh` | UFW: deny incoming, allow LocalSend (53317/udp+tcp), enable + systemctl enable |

---

## 🧩 Scripts Detail

### `install.sh`

**Packages:**
- **Dev:** `base-devel git curl wget rsync libva-utils cmake meson ninja python python-pip shellcheck openssh flatpak`
- **Display/WM:** `foot foot-terminfo`
- **CLI:** `bat fzf zoxide fastfetch jq tmux ripgrep fd tree unzip zip bc lsof pciutils usbutils hwinfo grim slurp wl-clipboard brightnessctl playerctl eza pamixer wlsunset lm_sensors ddcutil dua-cli`
- **Fonts:** `ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-meslo-nerd-font-powerlevel10k noto-fonts noto-fonts-emoji adobe-source-code-pro-fonts otf-comicshanns-nerd ttf-ms-fonts`
- **Theming:** `qt6ct qt5ct gtk3 gtk4 libadwaita adwaita-icon-theme papirus-icon-theme nordic-theme bibata-cursor-theme tela-icon-theme`
- **GStreamer:** `gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav x264 x265`
- **FS tools:** `exfatprogs ntfs-3g btrfs-progs cifs-utils dosfstools smartmontools logrotate tcpdump`

**Setup:**
- Flatpak + Flathub remote + OBS Studio (+ PipeWire plugin) + Karere
- Tela icon theme (`tela-icon-theme` → `Tela-nord-dark`)
- Bibata cursor (`bibata-cursor-theme` → `Bibata-Modern-Ice`)
- JetBrainsMono + FiraCode Nerd Fonts (manual download)
- Oh My Zsh + Powerlevel10k + zsh-autosuggestions + zsh-syntax-highlighting + zsh-completions
- `.zshrc` backup existing then overwrite; `.p10k.zsh` overwrites
- `chsh` to zsh, pacman aliases (including `update = sudo pacman -Syu && flatpak update -y`)
- fastfetch config: Noctalia version line (`pacman -Q noctalia`), font size parsing fix
- mise (runtime manager)
- opencode
- Foot as default terminal (`xdg-mime`, foot.ini)
- Fontconfig: ComicShannsMono Nerd Font monospace (from omarchy)
- Git config: aliases, pull.rebase, push.autoSetupRemote, diff histogram, rerere, defaultBranch=main
- Sensors auto-detect

**Copied:**
- `dotfiles/foot/` → `~/.config/foot/`
- `dotfiles/fontconfig/` → `~/.config/fontconfig/`
- `dotfiles/git/` → `~/.config/git/`
- `dotfiles/gtk-3.0/` → `~/.config/gtk-3.0/`
- `dotfiles/gtk-4.0/` → `~/.config/gtk-4.0/`
- `dotfiles/imv/` → `~/.config/imv/`
- `dotfiles/qt5ct/` → `~/.config/qt5ct/`
- `dotfiles/qt6ct/` → `~/.config/qt6ct/`
- `dotfiles/btop/` → `~/.config/btop/`
- `dotfiles/cava/` → `~/.config/cava/`
- `dotfiles/yazi/` → `~/.config/yazi/`
- `dotfiles/zed/` → `~/.config/zed/`
- `dotfiles/zsh/.zshrc` → `~/` (backup existing then overwrite). `.p10k.zsh` → `~/`
- `Wallpapers/` → `~/Pictures/Wallpapers/`
- `dotfiles/clean/clean.sh` → `~/.config/clean/`
- ASUS audio/mic fix → `fix-audio.sh` (portable, self-contained — WirePlumber conf + systemd services embedded)
- `docker-db/` → `~/Projects/docker-db/`

### `hyprland-noctalia.sh`

**Packages:** `hyprland rofi cliphist xdg-desktop-portal-hyprland hyprpicker nvidia-utils lib32-nvidia-utils sddm switcheroo-control noctalia`

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
- **Desktop:** `nautilus gvfs gvfs-afc gvfs-gphoto2 gvfs-smb libmtp nautilus-open-any-terminal yazi neovim btop mpv mpv-mpris imv evince gnome-disk-utility gnome-calculator`
- **Qt:** `qt6-declarative qt6-svg qt6-multimedia qt6-multimedia-ffmpeg qt6-5compat pavucontrol`
- **Utils:** `tesseract tesseract-data-eng imagemagick xdg-desktop-portal-gtk xdg-utils xdg-user-dirs python-gobject wtype wdisplays cava satty tldr gum lazydocker gpu-screen-recorder dua-cli bat eza fd`
- **Network:** `ncdu httpie bind whois traceroute mtr socat nmap github-cli strace python-pipx`
- **Apps:** `telegram-desktop localsend zen-browser-bin zed font-manager protonplus ab-download-manager faugus-launcher android-studio intellij-idea-community-edition zoom`
- **Gaming:** `gamemode lib32-gamemode`
- **Dev:** `ffmpegthumbnailer nautilus-image-converter lazygit nodejs bottom gdu docker docker-buildx docker-compose`

**Setup:**
- ASUS hardware auto-detected via DMI: `asusctl` + `rog-control-center` installed only on ASUS laptops
- ASUS daemon (`asusd`) enabled (if installed)
- Desktop file fixes: btop, nvim, yazi → run inside Foot
- Nautilus: right-click folder → Open in Terminal (foot), set via gsettings
- Docker service enabled + user added to docker group
- Desktop entries for lazydocker + dua with custom omarchy icons
- Icon deployment to hicolor/48x48/apps/
- Neovim AstroNvim config (from `dotfiles/nvim/`)
- tmux config (from `dotfiles/tmux/`)
- Icon/cursor theme applied via `gsettings`
- Removes pre-installed CachyOS bloat: micro, alacritty, meld, cachyos-micro-settings
- Hides unused desktop entries: avahi-discover, bssh, bvnc, footclient, foot-server, java-java21-openjdk, jconsole-java21-openjdk, jshell-java21-openjdk, qv4l2, qvidcap, rofi, rofi-theme-selector

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
Also includes `hyprtoolkit.conf` with color definitions.

```lua
require("monitor")
require("env")
require("noctalia")
dofile("colors.lua")
dofile("windows/glass.lua")
dofile("decorations/rounding-all-blur.lua")
dofile("animations/wipe-meta.lua")
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
Generated by Noctalia. Uses `local` variables — no global scope pollution.
```lua
local primary = "rgb(58a6ff)"
local surface = "rgb(010409)"
local secondary = "rgb(bc8cff)"
local error = "rgb(f85149)"

hl.config({
    general = { col = {
        active_border = primary,
        inactive_border = surface,
    }},
    group = { col = { ... }},
})
```
> Colors are re-applied by `colors.lua` (read via `dofile`), which parses `noctalia.lua` as text — survives Noctalia regeneration without global variable hacks.

### `layouts.lua`
- **Dwindle config:** `preserve_split = true`, `force_split = 2`
- **Scrolling config:** `fullscreen_on_one_column = false`
- Noctalia blur layer rule: `^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$`
- Persistent workspaces 1-9 (`monitor = "eDP-1"`)
- Default layout: dwindle (`hl.config({ general = { layout = "dwindle" } })`)

### `rules.lua`
| App | Behavior |
|-----|----------|
| Steam | Floating (1200×800) + idle inhibit |
| Zen Browser | Idle inhibit (nonton video aman) |
| Zoom | Idle inhibit (video call aman) |
| LocalSend | Floating (800×600) — two class patterns |
| GNOME Calculator | Floating (400×500) |
| Pavucontrol | Floating (800×600) |
| Btop (foot -T btop) | Floating (1200×700) |
| imv | Floating (900×700) |
| mpv | Floating (900×600) + idle inhibit fullscreen |
| XWayland empty drag fix | `no_focus = true` |

### `gestures.lua`
| Gesture | Action |
|---------|--------|
| 3-finger vertical | Workspace switch |
| 3-finger horizontal | Scroll move (0.9 scale) |
| 4-finger pinch out | Fullscreen on |
| 4-finger pinch in | Fullscreen off |
| 4-finger vertical | Workspace switch |

### `startup.lua`
```lua
hl.on("hyprland.start", function()
    hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland >/dev/null 2>&1 &")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-gtk >/dev/null 2>&1 &")
    hl.exec_cmd("sleep 1 && /usr/lib/xdg-desktop-portal >/dev/null 2>&1 &")
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
| `SUPER + SHIFT + L` | Lock screen |
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
| `SUPER + Enter` | Foot terminal |
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
| `XF86Calculator` | Calculator |
| `Print` | Screenshot region (grim+slurp+satty) |
| `Shift + Print` | Screenshot fullscreen (grim+satty) |
| `Ctrl + Print` | Screenshot window (grim+satty) |

### Multi-Monitor
| Key | Action |
|-----|--------|
| `SUPER + CTRL + ALT + Tab` | Cycle windows |
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

---

## 🎨 Presets

### Animations (`~/.config/hypr/animations/*.lua`)
16 presets switchable via `SUPER + CTRL + A` (rofi):
`animations-classic`, `animations-dynamic`, `animations-end4`, `animations-fast`, `animations-high`, `animations-moving`, `animations-moving-meta`, `animations-smooth`, `animations-smooth-meta`, `animations-wipe-meta`, `default`, `disabled`, `metamorphosis`, `slide`, `standard`, `wipe`

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
legacy_layout=false
hud_no_margin
height=120
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
| **GTK** | Nordic theme |
| **Qt5/Qt6** | Fusion style + Noctalia custom palette |
| **Terminal** | Foot + ComicShannsMono Nerd Font 10pt + alpha 0.90 + grapheme-shaping=off |
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
| `foot/` | `install.sh` | ComicShannsMono Nerd Font 10pt, alpha 0.90, grapheme-shaping=no (tweak) |
| `fontconfig/` | `install.sh` | ComicShannsMono Nerd Font monospace, Liberation Sans serif/sans |
| `git/` | `install.sh` | Git config: aliases, pull.rebase, push.autoSetupRemote, defaultBranch=main |
| `imv/` | `install.sh` | Omarchy keybinds: Ctrl+p/x/X/r/e (print, trash, rotate, edit) |
| `fix-audio.sh` | `install.sh` (auto) / standalone | ASUS ALC256 mic/audio fix — portable, self-contained (WirePlumber conf + systemd services embedded); run `./fix-audio.sh --force` on non-ASUS |
| `hypr/icons/` | `apps.sh` | Custom omarchy icons for lazydocker + dua |
| `gtk-3.0/` | `install.sh` | `Tela-nord-dark`, `Bibata-Modern-Ice`, `Nordic` |
| `gtk-4.0/` | `install.sh` | Nordic theme, Tela-nord-dark icons, Bibata-Modern-Ice cursor 24 |
| `qt5ct/` | `install.sh` | Fusion style + Noctalia custom palette |
| `qt6ct/` | `install.sh` | Fusion style + Noctalia custom palette |
| `btop/` | `install.sh` | `color_theme = "noctalia"` + noctalia.theme |
| `cava/` | `install.sh` | Noctalia theme, minimal config (bars, sensitivity) |
| `yazi/` | `install.sh` | Flavor set to noctalia |
| `zed/` | `install.sh` | Noctalia Dark Transparent theme, ui_font_size 16, buffer_font_size 15 |
| `zsh/` | `install.sh` | `.zshrc` (fastfetch, P10k, zoxide, fzf, mise, opencode), `.p10k.zsh` |
| `noctalia/` | `hyprland-noctalia.sh` | `settings.toml` + sounds → `~/.local/state/noctalia/` |
| `clean/` | `install.sh` | `clean.sh` — system cleanup script |
| `tmux/` | `apps.sh` | Prefix `C-Space`, Vi mode, Foot integration, minimal blue theme |
| `Wallpapers/` | `install.sh` | Copied to `~/Pictures/Wallpapers/` |
| `docker-db/` | `install.sh` | MariaDB + phpMyAdmin + PostgreSQL + pgAdmin dev DB → `~/Projects/docker-db/` _(project dir at repo root, not under `dotfiles/`)_ |

---

## 🧼 Maintenance

```bash
# System cleanup
~/.config/clean/clean.sh
```
Cleans: pacman cache, orphans, Flatpak unused runtimes, Go build/module cache, pip cache, npm cache, Cargo registry, mise tarballs + cache clear, temp files, journal logs (>3d), trash, browser caches (Zen/Chromium), mesa/RADV/NVIDIA shader caches, Qt/GTK caches, opencode/zed cache, zsh history, thumbnails.

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

## 🗺️ Workspaces

All workspaces 1-9 persistent (visible in Noctalia bar when empty). Default layout: dwindle.

---

## 🐍 Notes

- `hyprctl eval "hl.config({...})"` — cara bener untuk runtime config di Hyprland Lua API
- Noctalia regenerates `noctalia.lua` — `colors.lua` re-applies colors via text parsing, no global variable needed
- Session name: **"Hyprland (Noctalia)"** in SDDM
- **Sumber package:** CachyOS official repos (cachyos + extra/core). Chaotic-AUR **binary repo mirror** (via pacman, bukan AUR helper/paru/yay) tetap di-setup sebagai fallback repo — bukan untuk install AUR manual. Semua package utama (`hyprland`, `noctalia`, `gamescope-session-cachyos`, `rofi-wayland`, dll) dari repo resmi, tanpa `aur_install`/`paru`.
- **Audio fix portabel:** `fix-audio.sh` self-contained (config ter-embed) — jalan di CachyOS/Arch DAN distro lain (Debian/Ubuntu/Fedora). Deteksi audio stack (PipeWire/PulseAudio/ALSA) + init (systemd/autostart). `install.sh` otomatis jalanin untuk hardware ASUS. Standalone: `./fix-audio.sh` (atau `--force` / `--apply` / `--uninstall`).
