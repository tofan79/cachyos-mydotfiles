#!/bin/bash
# clean.sh — System cleanup for CachyOS/Arch

echo "========================================="
echo "        CACHYOS SYSTEM CLEANUP"
echo "========================================="

echo -e "\n[1/10] Pacman cache..."
sudo rm -rf /var/cache/pacman/pkg/* 2>/dev/null && echo "  ✔ All packages wiped" || sudo paccache -rk2 2>/dev/null && echo "  ✔ Cache cleaned (keep 2)"

echo -e "\n[2/10] Orphan packages..."
sudo pacman -Rns "$(pacman -Qtdq 2>/dev/null)" --noconfirm 2>/dev/null && echo "  ✔ Orphans removed" || echo "  ✔ No orphans"

echo -e "\n[3/10] AUR + dev caches..."
[[ -d ~/.cache/yay ]] && rm -rf ~/.cache/yay/* && echo "  ✔ yay cache cleaned"
[[ -d ~/.cache/paru ]] && rm -rf ~/.cache/paru/* && echo "  ✔ paru cache cleaned"
paru -Scc --noconfirm 2>/dev/null && echo "  ✔ paru AUR cache cleaned"
[[ -d ~/.cache/go-build ]] && rm -rf ~/.cache/go-build/* && echo "  ✔ Go build cache cleaned"
[[ -d ~/.cache/pip ]] && rm -rf ~/.cache/pip && echo "  ✔ pip cache cleaned"
[[ -d ~/.cache/npm ]] && rm -rf ~/.cache/npm/* && echo "  ✔ npm cache cleared"

echo -e "\n[4/10] mise cache..."
rm -rf ~/.local/share/mise/http-tarballs/* 2>/dev/null && echo "  ✔ mise tarballs cleaned"
mise cache clear 2>/dev/null && echo "  ✔ mise cache cleared"

echo -e "\n[5/10] JetBrains Toolbox cache..."
rm -rf ~/.local/share/JetBrains/Toolbox/cache/* 2>/dev/null && echo "  ✔ Toolbox cache cleaned"
rm -rf ~/.cache/JetBrains/* 2>/dev/null && echo "  ✔ JetBrains cache cleaned"

echo -e "\n[6/10] System temp..."
sudo rm -rf /tmp/* 2>/dev/null
sudo rm -rf /var/tmp/* 2>/dev/null
sudo journalctl --vacuum-time=3d 2>/dev/null && echo "  ✔ Old journal logs cleaned"

echo -e "\n[7/10] Trash..."
rm -rf ~/.local/share/Trash/* 2>/dev/null && echo "  ✔ Trash cleaned"

echo -e "\n[8/10] Browser caches..."
[[ -d ~/.cache/zen ]] && rm -rf ~/.cache/zen/* && echo "  ✔ Zen cache cleaned"
[[ -d ~/.cache/chromium ]] && rm -rf ~/.cache/chromium/* && echo "  ✔ Chromium cache cleaned"

echo -e "\n[9/10] Graphics & misc caches..."
rm -rf ~/.cache/mesa_shader_cache/* 2>/dev/null && echo "  ✔ Mesa shader cache cleaned"
rm -rf ~/.cache/radv_builtin_shaders/* 2>/dev/null && echo "  ✔ RADV shader cache cleaned"
rm -rf ~/.cache/nvidia/* 2>/dev/null && echo "  ✔ NVIDIA cache cleaned"
rm -rf ~/.cache/gtk-4.0/* 2>/dev/null && echo "  ✔ GTK 4 cache cleaned"
rm -rf ~/.cache/qtshadercache-*/* 2>/dev/null && echo "  ✔ Qt shader cache cleaned"
rm -rf ~/.cache/opencode/* 2>/dev/null && echo "  ✔ opencode cache cleaned"
rm -rf ~/.cache/zed/* 2>/dev/null && echo "  ✔ Zed cache cleaned"

echo -e "\n[10/10] Zsh history + thumbnails..."
[[ -f ~/.zsh_history ]] && > ~/.zsh_history && echo "  ✔ zsh history cleared"
rm -rf ~/.cache/thumbnails/* 2>/dev/null && echo "  ✔ Thumbnail cache cleaned"

echo -e "\n========================================="
echo "           CLEANUP COMPLETE"
echo "========================================="
