-- Window rules wiki https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Generic floating position
hl.window_rule({ match = { float = true }, center = true, persistent_size = true })

-- btop monitor (via keybind) — floating 800x600
hl.window_rule({
    match = { title = "^btop-monitor$" },
    float = true,
    center = true,
    size = { 1200, 600 },
})

-- Picture-in-Picture
hl.window_rule({
    match             = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
    float             = true,
    keep_aspect_ratio = true,
    size              = { "max(monitor_w, monitor_h)*0.25", "min(monitor_w, monitor_h)*0.25" },
    pin               = true,
})

-- Gaming
local gamingApps = "^(steam_app.*|gamescope)$"
local gamingWorkspace = "name:gaming"

hl.window_rule({ match = { content = "game" }, workspace = gamingWorkspace })
hl.window_rule({ match = { xdg_tag = "^(.*game.*)$" }, workspace = gamingWorkspace, fullscreen_state = 2, content = "game", sync_fullscreen = true })
hl.window_rule({ match = { class = gamingApps }, workspace = gamingWorkspace })
hl.window_rule({ match = { class = "^(steam)$", title = "^(Friends List)$" }, float = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^(Launching\\.{3})$" }, float = true, center = true, workspace = gamingWorkspace })
hl.window_rule({
    match = {
        class         = gamingApps,
        title         = "^(.+)$",
        initial_title = "negative:^(.*\\\\home\\\\.*)$",
    },
    content          = "game",
    decorate         = false,
    fullscreen_state = 2,
    size             = { "monitor_w", "monitor_h" },
    sync_fullscreen  = true,
})
hl.window_rule({
    match = {
        class         = "^(steam_app.*)$",
        initial_title = "^$",
    },
    center           = true,
    float            = true,
    fullscreen       = false,
    fullscreen_state = 0,
    workspace        = gamingWorkspace,
})

-- Apps
hl.window_rule({ match = { class = "^(.*\\.exe)$", float = true }, monitor = PRIMARY_MONITOR, center = true, fullscreen_state = 0 })
hl.window_rule({ match = { class = "^(.*[Ll]auncher.*)$" }, float = true, monitor = PRIMARY_MONITOR })
hl.window_rule({ match = { class = "^(vesktop|discord)$" }, monitor = PRIMARY_MONITOR })
hl.window_rule({ match = { class = "^(.*[Cc]alc.*)$" }, float = true, size = { "max(monitor_w, monitor_h)*0.17", "min(monitor_w, monitor_h)*0.43" } })
hl.window_rule({ match = { class = "^(org\\.kde\\.keditfiletype)$" }, float = true })
hl.window_rule({ match = { class = "^(org\\.kde\\.ark)$" }, size = { "max(monitor_w, monitor_h)*0.40", "min(monitor_w, monitor_h)*0.40" } })
hl.window_rule({ match = { class = "^(.*satty.*)$", title = "^(Satty)$" }, min_size = { "max(monitor_w, monitor_h)*0.35", "min(monitor_w, monitor_h)*0.35" }, float = true })
hl.window_rule({ match = { class = "^(dev\\.)?(noctalia\\.Noctalia(\\.Settings)?)$" }, float = true, size = { "monitor_w*0.70", "monitor_h*0.70" } })
hl.window_rule({
    match = {
        class = "^(org\\.kde\\.dolphin)$",
        title = "negative:^(Moving.*|Create New.*|Extract.*|Compress.*|Copying.*|Progress.*|Configure.*|Properties.*|Choose\\sApplication.*)$",
    },
    size = { "max(monitor_w, monitor_h)*0.50", "min(monitor_w, monitor_h)*0.55" },
    move = {
        "max(20, min(cursor_x - (window_w*0.50), monitor_w - window_w + 20))", -- X axis clamping
        "max(20, min(cursor_y - 50, monitor_h - window_h + 20))" -- Y axis clamping
    },
})

-- Opacity Overrides
-- Hanya pemutar video & image viewer yang di-override 100% (biar konten media terlihat benar).
-- Browser, terminal, dan app lain ikut opacity global (active 0.9 / inactive 0.7).
-- Fullscreen di-set 1.0 (opaque) biar main game tanpa transparan.

hl.window_rule({ match = { class = "^(mpv|org.kde.haruna|.*plex.*|org\\.kde\\.gwenview|.*vlc.*|loupe|org.gnome.Loupe)$" }, opacity = "1.0 override" })

-- Float Utility Windows
local floatApps = {
    { class = "^(kvantummanager|qt[56]ct|nwg-look)$" },
    { class = "^(org.pulseaudio.pavucontrol|blueman-manager|nm-applet|nm-connection-editor)$" },
    { title = "^(Winetricks.*|Protontricks.*)$" },
}
for _, m in ipairs(floatApps) do hl.window_rule({ match = m, float = true }) end

-- Float Common Modals
local modalMatches = {
    { title = "^(Open|Authentication Required|Add Folder to Workspace|Choose Files|Save As|Confirm to replace files|File Operation Progress)$" },
    { initial_title = "^(Open File)$" },
    { class = "^([Xx]dg-desktop-portal-gtk)$" },
    { title = "^(File Upload|Choose wallpaper|Library)(.*)$" },
    { class = "^(.*dialog.*)$" },
    { title = "^(.*dialog.*)$" },
    { class = "^(hyprland-share-picker)$"},
}
for _, m in ipairs(modalMatches) do hl.window_rule({ match = m, float = true }) end

-- Ignore maximize requests from all apps. You'll probably like this.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Layer rules (animasi fade)
hl.layer_rule({ match = { namespace = "hyprpicker" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "selection" }, animation = "fade" })

-- Noctalia layers (blur untuk bar/panel/notification/dock)
hl.layer_rule({
    name = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
    },
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})

-- btop (diluncurkan via ghostty -T btop)
hl.window_rule({
    name  = "btop-float",
    match = { title = "^btop$" },
    float = true,
    size  = { 1200, 700 },
})

-- LocalSend — floating (multi appid)
hl.window_rule({
    name  = "localsend-float",
    match = { class = "^localsend$" },
    float = true,
    size  = { 800, 600 },
})
hl.window_rule({
    name  = "localsend-org-float",
    match = { class = "^org\\.localsend\\.localsend_app$" },
    float = true,
    size  = { 800, 600 },
})

-- Calculator
hl.window_rule({
    name  = "calc-gnome-float",
    match = { class = "^org\\.gnome\\.Calculator$" },
    float = true,
    size  = { 400, 500 },
})

-- Image viewers (loupe)
hl.window_rule({
    name   = "loupe-float",
    match  = { class = "^org\\.gnome\\.Loupe$" },
    float  = true,
    size   = { 900, 700 },
    opaque = true,
})
hl.window_rule({
    name   = "zoom",
    match  = { class = "^zoom$" },
    float  = true,
    opaque = true,
})

-- Spotify
hl.window_rule({
    name  = "float-spotify",
    match = { class = "[Ss]potify" },
    float = true,
})

-- Media / editor apps (opaque)
hl.window_rule({
    name   = "media-editors-opaque",
    match  = { class = "^(krita|gimp|inkscape|darktable|resolve|kdenlive|shotcut|blender|godot)$" },
    opaque = true,
})

-- Archive manager (file-roller)
hl.window_rule({
    name  = "file-roller-float",
    match = { class = "org\\.gnome\\.FileRoller|file-roller" },
    float = true,
})

-- yad / zenity dialogs (float)
hl.window_rule({
    name  = "yad-zenity-float",
    match = { class = "^yad|zenity$" },
    float = true,
})

-- System settings (gnome) sized float
hl.window_rule({
    name  = "gnome-settings-float",
    match = { class = "^org\\.gnome\\.Settings$" },
    float = true,
    size  = { "(monitor_w*0.7)", "(monitor_h*0.8)" },
})

-- Printer config (system-config-printer)
hl.window_rule({
    name  = "printer-float",
    match = { class = "^system-config-printer$" },
    float = true,
    size  = { "(monitor_w*0.5)", "(monitor_h*0.6)" },
})
