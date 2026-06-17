-- ═══════════════════════════════════════════
-- Autostart
-- ═══════════════════════════════════════════

hl.on("hyprland.start", function()
    -- Import env for systemd
    hl.exec_cmd(
    "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE")

    -- Clipboard history
    hl.exec_cmd("wl-paste --watch cliphist store")

    -- Noctalia shell
    hl.exec_cmd("noctalia")
end)
