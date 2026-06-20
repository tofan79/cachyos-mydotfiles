-- ═══════════════════════════════════════════
-- Window & Layer Rules
-- ═══════════════════════════════════════════

-- Steam — floating + idle inhibit
hl.window_rule({
    name  = "steam-float",
    match = { class = "steam" },
    float = true,
    size  = { 1200, 800 },
})
hl.window_rule({
    name  = "steam-idleinhibit",
    match = { class = "steam" },
    idle_inhibit = "always",
})
hl.window_rule({
    name  = "zen-idleinhibit",
    match = { class = "^zen$" },
    idle_inhibit = "always",
})
hl.window_rule({
    name  = "zoom-idleinhibit",
    match = { class = "^zoom$" },
    idle_inhibit = "always",
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
-- PulseAudio Volume Control
hl.window_rule({
    name  = "pavucontrol-gtk-float",
    match = { class = "^org\\.pulseaudio\\.pavucontrol$" },
    float = true,
    size  = { 800, 600 },
})
hl.window_rule({
    name  = "pavucontrol-float",
    match = { class = "^pavucontrol$" },
    float = true,
    size  = { 800, 600 },
})

-- Btop (launched as foot -T btop)
hl.window_rule({
    name  = "btop-float",
    match = { title = "^btop$" },
    float = true,
    size  = { 1200, 700 },
})

-- Image/Media viewers
hl.window_rule({
    name  = "imv-float",
    match = { class = "^imv$" },
    float = true,
    size  = { 900, 700 },
    opaque = true,
})
hl.window_rule({
    name  = "mpv-float",
    match = { class = "^mpv$" },
    float = true,
    size  = { 900, 600 },
    opaque = true,
})

-- Fix XWayland drag issues
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
