-- ═══════════════════════════════════════════
-- Autostart
-- ═══════════════════════════════════════════

hl.on("hyprland.start", function()
    -- Import env for systemd
    hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd --all")

    -- GNOME keyring (start early for apps that need secrets)
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11")

    -- Set cursor theme
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")

    -- Dark mode for GTK
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark")

    -- Portal services (for Flatpak, file dialogs, etc.)
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland >/dev/null 2>&1 &")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-gtk >/dev/null 2>&1 &")
    hl.exec_cmd("sleep 1 && /usr/lib/xdg-desktop-portal >/dev/null 2>&1 &")

    -- Clipboard history
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Noctalia shell
    hl.exec_cmd("noctalia")
end)
