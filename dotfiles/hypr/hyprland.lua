-- CachyOS Hyprland Configuration

require("config.animations")
require("config.autostart")
require("config.colors")
require("config.decorations")
require("config.variables")
require("config.environment")
require("config.inputs")
require("config.binds")
require("config.misc")
require("config.monitors")
require("config.windowrules")
require("config.workspaces")
require("config.lid")
require("config.resize")
dofile(os.getenv("HOME") .. "/.config/hypr/layouts/fair.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/layouts/deck.lua")

-- For Noctalia Color templates
require("noctalia").apply_theme()

-- Override border ke gradient 2 warna (primary->secondary) setelah apply_theme,
local noct = require("noctalia")
hl.config({
    general = {
        col = {
            active_border = {
                colors = { noct.colors.primary, noct.colors.secondary },
                angle = 45,
            },
        },
    },
})
