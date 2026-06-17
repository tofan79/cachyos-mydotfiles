-- ═══════════════════════════════════════════
-- Autostart
-- ═══════════════════════════════════════════

hl.on("hyprland.start", function()
    -- Import env for systemd
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")

    -- Clipboard history
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Noctalia shell
    hl.exec_cmd("noctalia")
end)
