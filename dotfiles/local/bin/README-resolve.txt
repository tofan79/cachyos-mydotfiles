# DaVinci Resolve — Setup State
## System: CachyOS / ASUS TUF A15 FA506ICB

### Versi
- Resolve 21.0 (dari repo cachyos, BUKAN AUR)
- Tunggu update resmi dari `pacman -Syu` — jangan paksa dari AUR

### Wrapper
- `/usr/local/bin/resolve-fix` — launcher utama
- Fungsi: preload GLib + prioritaskan `/opt/resolve/libs` sebelum `/usr/lib`
- GStreamer error: `undefined symbol: gst_log_context_get_category` = gara2 bentrok bundled vs system. Fix: `LD_LIBRARY_PATH=/opt/resolve/libs:/usr/lib:...`
- Update Resolve biasane gak perlu ubah wrapper. Kalo error abis update, cek library: `ldd /opt/resolve/bin/resolve | grep "not found"`

### GPU
- NVIDIA GeForce RTX 3050 Laptop GPU
- Driver: nvidia 610.43.02, opencl-nvidia
- OpenCL terdeteksi (clinfo OK)

### Desktop Launcher
- `~/.local/share/applications/DaVinciResolve.desktop` — override dari `/opt/resolve/share/`
- Exec: `/usr/local/bin/resolve-fix %u` (bukan /opt/resolve/bin/resolve)

### Aliases (.zshrc)
- `resolve-fix` — buka Resolve
- `convert-resolve` — convert H.264/H.265 ke DNxHR
- `backup-resolve` — backup ke ~/Backups/
- `restore-resolve` — restore dari backup terbaru

### Alur Update
1. `sudo pacman -Syu` — update Resolve kalo ada
2. Coba jalanin `resolve-fix` — kalo error:
   - `ldd /opt/resolve/bin/resolve | grep "not found"`
   - Install missing libs via pacman
   - Kalo error GStreamer lagi, pastiin `LD_LIBRARY_PATH=/opt/resolve/libs:/usr/lib:...` masih bener di resolve-fix

### Catatan
- Jangan install `ntfs-3g` — udah dihapus, pake NTFSplus kernel 7.1
- `~/Apps` → symlink ke `/mnt/Data` (NTFS, shared sama Windows)
- Semua dotfiles di `~/Projects/cachyos-mydotfiles/` udah sync
