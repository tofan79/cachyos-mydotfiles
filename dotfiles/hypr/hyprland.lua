-- ═══════════════════════════════════════════
-- Hyprland Config — Converted from MangoWM
-- ═══════════════════════════════════════════

-- Set module search path so require() finds files in ~/.config/hypr/
package.path = os.getenv("HOME") .. "/.config/hypr/?.lua;" .. package.path

require("monitor")
require("env")
require("noctalia").apply_theme()
dofile(os.getenv("HOME") .. "/.config/hypr/colors.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/windows/glass.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/decorations/rounding-all-blur.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/animations/wipe-meta.lua")
require("keybinds")
require("rules")
require("layouts")
require("gestures")
require("startup")
