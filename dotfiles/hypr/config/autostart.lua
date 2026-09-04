-- Auto-start config
-- if you dont use UWSM add your auto start programs here, otherwise use XDG autostart https://wiki.archlinux.org/title/XDG_Autostart

hl.on("hyprland.start", function ()
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("xhost +SI:localuser:root")
    hl.exec_cmd("hyprpm reload")

    -- Plugin (e.g. gloview) must be loaded before binds referencing it are evaluated.
    hl.exec_cmd("sleep 1")
    hl.exec_cmd("hyprctl reload")

    -- Clipboard history
    hl.exec_cmd("wl-paste --watch cliphist store")
end)
