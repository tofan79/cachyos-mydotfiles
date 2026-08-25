-- ═══════════════════════════════════════════
-- Hyprland Config — Converted from MangoWM
-- ═══════════════════════════════════════════

-- Set module search path so require() finds files in ~/.config/hypr/ and extras/
package.path = os.getenv("HOME")
	.. "/.config/hypr/extras/?.lua;"
	.. os.getenv("HOME")
	.. "/.config/hypr/?.lua;"
	.. package.path

require("monitor")
require("env")
require("noctalia").apply_theme()
dofile(os.getenv("HOME") .. "/.config/hypr/colors.lua")
require("decoration")
dofile(os.getenv("HOME") .. "/.config/hypr/extras/animations/bounce.lua")
require("keybinds")
require("resize")
require("lid")
require("rules")
require("execs")
require("group")
require("layouts")
require("gestures")
require("startup")

dofile(os.getenv("HOME") .. "/.config/hypr/layouts/fair.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/layouts/deck.lua")
