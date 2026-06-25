-- ═══════════════════════════════════════════
-- Autostart
-- ═══════════════════════════════════════════

hl.on("hyprland.start", function()
    -- Import env for systemd
    hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd --all")

    -- Portal services (for Flatpak, file dialogs, etc.)
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland >/dev/null 2>&1 &")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-gtk >/dev/null 2>&1 &")
    hl.exec_cmd("sleep 1 && /usr/lib/xdg-desktop-portal >/dev/null 2>&1 &")

    -- Clipboard history
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Portal recovery after Gaming Mode
    hl.exec_cmd("/usr/local/bin/deckshift-portal-recovery")

    -- Noctalia shell
    hl.exec_cmd("noctalia")
end)
