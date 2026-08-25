-- ═══════════════════════════════════════════
-- Window & Layer Rules
-- ═══════════════════════════════════════════

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

-- Btop (launched as ghostty -T btop)
hl.window_rule({
    name  = "btop-float",
    match = { title = "^btop$" },
    float = true,
    size  = { 1200, 700 },
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
    name   = "mpv-float",
    match  = { class = "^mpv$" },
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

hl.window_rule({
    name   = "satty-float",
    match  = { class = "^com\\.gabm\\.satty$" },
    float  = true,
    size   = { 900, 700 },
    opaque = true,
})

-- Fix XWayland drag issues
hl.window_rule({
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- ═══════════════════════════════════════════
-- Tagged rules
-- (diadaptasi dari caelestia-dots, tanpa konflik)
-- ═══════════════════════════════════════════

-- Tags an array of window matches. If `field` is given, matches should be an
-- array of strings. Otherwise, it should be an array of tables.
local function tagged_rule(tag, matches, field)
    for _, match in ipairs(matches) do
        if field then
            local table = {}
            table[field] = match
            match = table
        end
        hl.window_rule({ match = match, tag = "+" .. tag })
    end
end

local function create_tag(tag, rules)
    local rule = { match = { tag = tag } }
    for k, v in pairs(rules) do
        rule[k] = v
    end
    hl.window_rule(rule)
end

-- All tags
local opaque_tag = "opaque"
local float_tag = "float"
local float_60_70_tag = "float_60_70"
local float_70_80_tag = "float_70_80"
local float_50_60_tag = "float_50_60"
local game_tag = "game"
local xwl_popup_tag = "xwl_popup"

---------------------
---- Window rules ----
---------------------

-- Center all floating windows except xwayland windows
hl.window_rule({ match = { float = true, xwayland = false }, center = true })

-- Picture in picture (move/resize handled by execs.lua)
hl.window_rule({
    match             = { title = "Picture(-| )in(-| )[Pp]icture" },
    move              = "(monitor_w*0.98-window_w) (monitor_h*0.97-window_h)",
    pin               = true,
    float             = true,
    keep_aspect_ratio = true,
})

----------------------
---- Tagged rules ----
----------------------

-- Opaque apps (editors/viewers — ghostty & vesktop sengaja dikecualikan utk tetap transparan)
tagged_rule(opaque_tag, {
    "swappy",                        -- Screenshot editor
    "krita|gimp|inkscape|darktable", -- Image editors
    "resolve|kdenlive|shotcut",      -- Video editors
    "blender|godot",                 -- 3D editors
}, "class")

-- Floating apps
tagged_rule(float_tag, {
    "yad|zenity",                         -- Dialogs
    "wev",                                -- Input detector
    "org.gnome.FileRoller|file-roller",   -- Archive manager
    "blueman-manager",                    -- Bluetooth GUI
}, "class")
tagged_rule(float_tag, {
    "File (Operation|Upload)( Progress)?", -- File manager operation progress (upload, move, copy, etc)
    ".* Properties",                       -- File properties
}, "title")

-- Sized floaters
-- 60% x 70% (pavucontrol sengaja dikecualikan — sudah punya rule sendiri)
tagged_rule(float_60_70_tag, {
    "(Select|Open)( a)? (File|Folder)(s)?", -- File dialogs
    "Save As",                              -- Save dialogs
}, "title")
tagged_rule(float_60_70_tag, {
    { title = "(Save|Export) Image", class = "gimp" }, -- GIMP export/save
})
tagged_rule(float_60_70_tag, {
    "yad-icon-browser", -- GTK icon browser
}, "class")

-- 70% x 80%
tagged_rule(float_70_80_tag, {
    "org.gnome.Settings", -- System settings
}, "class")

-- 50% x 60%
tagged_rule(float_50_60_tag, {
    "nwg-look",              -- GTK theme manager
    "system-config-printer", -- Printer config
}, "class")

-- Games
tagged_rule(game_tag, {
    "steam_app_[0-9]+",  -- Steam games
    "steam_app_default", -- Lutris games
    "gamescope",         -- Gamescope
}, "class")

-- Xwayland popups
tagged_rule(xwl_popup_tag, {
    { xwayland = true, title = "win[0-9]+" },
    { xwayland = true, title = "",         class = "", initial_title = "", initial_class = "" }
})

-----------------------
---- Per app rules ----
-----------------------

-- Steam Friends List
tagged_rule(float_tag, { { class = "steam", title = "Friends List" } })
tagged_rule(xwl_popup_tag, { { class = "steam", title = "" } })

-- Spotify (from ryoku-arch)
hl.window_rule({
    name  = "float-spotify",
    match = { class = "[Ss]potify" },
    float = true,
})

-------------------------
---- Tag definitions ----
-------------------------

create_tag(opaque_tag, { opaque = true })
create_tag(float_tag, { float = true })
create_tag(float_50_60_tag, { float = true, size = "(monitor_w*0.5) (monitor_h*0.6)", center = true })
create_tag(float_60_70_tag, { float = true, size = "(monitor_w*0.6) (monitor_h*0.7)", center = true })
create_tag(float_70_80_tag, { float = true, size = "(monitor_w*0.7) (monitor_h*0.8)", center = true })
create_tag(game_tag, { opaque = true, no_blur = true, no_shadow = true, immediate = true, idle_inhibit = "always" })
create_tag(xwl_popup_tag, {
    no_dim = true,
    no_shadow = true,
    no_blur = true,
    opaque = true,
    rounding = 10,
})

--------------------
---- Layer rules ----
--------------------

hl.layer_rule({ match = { namespace = "hyprpicker" }, animation = "fade" }) -- Colour picker out animation
hl.layer_rule({ match = { namespace = "logout_dialog" }, animation = "fade" }) -- wlogout
hl.layer_rule({ match = { namespace = "selection" }, animation = "fade" }) -- slurp
hl.layer_rule({ match = { namespace = "wayfreeze" }, animation = "fade" }) -- wayfreeze
