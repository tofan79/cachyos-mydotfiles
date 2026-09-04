-- ═══════════════════════════════════════════
-- Key Bindings — Omarchy Standard
-- ═══════════════════════════════════════════

local M = "SUPER"
local launchPrefix = "uwsm app -- " -- if you are not using UWSM, make this empty (e.g. "")

-- ───────────────────────────────────────────
-- Core
-- ───────────────────────────────────────────
hl.bind(M .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload && notify-send -u low 'Hyprland reloaded'"), { description = "Reload Hyprland config" })
hl.bind(M .. " + SHIFT + K", hl.dsp.exec_cmd("noctalia msg panel-toggle kenn/keybind-cheatsheet:cheatsheet"), { description = "Show keybindings" })
hl.bind(M .. " + Q", hl.dsp.window.close(), { description = "Close active window" })
hl.bind(M .. " + Escape", hl.dsp.exec_cmd("noctalia msg panel-toggle session"), { description = "Session menu" })
hl.bind(M .. " + CTRL + L", hl.dsp.exec_cmd("noctalia msg session lock"), { description = "Lock screen" })
hl.bind(M .. " + slash", hl.dsp.exec_cmd("noctalia msg panel-toggle tordex/nvtop:panel -mem"), { description = "System monitor (procmon)" })
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(launchPrefix .. TERMINAL .. " --title btop-monitor -e btop"), { description = "System monitor (btop, floating)" })

-- ───────────────────────────────────────────
-- Noctalia Shell
-- ───────────────────────────────────────────
hl.bind(M .. " + Space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"), { description = "App launcher" })
hl.bind(M .. " + ALT + Space",hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"),{ description = "Control center" })
hl.bind(M .. " + CTRL + Space", hl.dsp.exec_cmd("noctalia msg settings-toggle"), { description = "Settings toggle" })
hl.bind(M .. " + CTRL + W", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"), { description = "Wallpaper picker" })
hl.bind(M .. " + CTRL + period", hl.dsp.exec_cmd("noctalia msg notification-clear-history"),{ description = "Clear notifications" })
hl.bind(M .. " + CTRL + comma", hl.dsp.exec_cmd("noctalia msg clipboard-clear"), { description = "Clear clipboard" })
hl.bind(M .. " + CTRL + C", hl.dsp.exec_cmd("noctalia msg caffeine-toggle"), { description = "Toggle caffeine" })
hl.bind(M .. " + CTRL + slash",hl.dsp.exec_cmd("noctalia msg panel-toggle noctalia/wallhaven:browser"), { description = "Wallhaven wallpaper" })
hl.bind(M .. " + CTRL + backslash", hl.dsp.exec_cmd("noctalia msg panel-toggle nomadcxx/gslapper:picker"),{ description = "Video wallpaper" })
hl.bind(M .. " + ALT + P", hl.dsp.exec_cmd("hyprpicker -a -n"), { description = "Color picker (hyprpicker)" })
hl.bind(M .. " + ALT + period", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher /emo"), { description = "Emoji panel" })
hl.bind(M .. " + SHIFT + B", hl.dsp.exec_cmd("noctalia msg plugin mindset/gamer-mode:service all toggle"), { description = "Toggle gamer mode" })
hl.bind(M .. " + ALT + B", hl.dsp.exec_cmd("noctalia msg panel-toggle mindset/gamer-mode:main"), { description = "Gamer mode panel" })
hl.bind(M .. " + CTRL + R", hl.dsp.exec_cmd("noctalia msg panel-toggle mindset/today-reminders:main"), { description = "Today Reminders panel" })

-- ───────────────────────────────────────────
-- Window Focus (Super + Arrows)
-- ───────────────────────────────────────────
hl.bind(M .. " + left",	hl.dsp.exec_cmd("~/.config/hypr/scripts/focus-dir.sh left"), { description = "Smart focus left" })
hl.bind(M .. " + right", hl.dsp.exec_cmd("~/.config/hypr/scripts/focus-dir.sh right"), { description = "Smart focus right" })
hl.bind(M .. " + up", hl.dsp.exec_cmd("~/.config/hypr/scripts/focus-dir.sh up"), { description = "Smart focus up" })
hl.bind(M .. " + down",	hl.dsp.exec_cmd("~/.config/hypr/scripts/focus-dir.sh down"), { description = "Smart focus down" })

-- ───────────────────────────────────────────
-- Window Swapping (Super + Shift + Arrows)
-- ───────────────────────────────────────────
hl.bind(M .. " + SHIFT + left", hl.dsp.exec_cmd("~/.config/hypr/scripts/swap-dir.sh left"), { description = "Smart swap left" })
hl.bind(M .. " + SHIFT + right", hl.dsp.exec_cmd("~/.config/hypr/scripts/swap-dir.sh right"), { description = "Smart swap right" })
hl.bind(M .. " + SHIFT + up", hl.dsp.exec_cmd("~/.config/hypr/scripts/swap-dir.sh up"), { description = "Smart swap up" })
hl.bind(M .. " + SHIFT + down", hl.dsp.exec_cmd("~/.config/hypr/scripts/swap-dir.sh down"), { description = "Smart swap down" })

-- Move to adjacent workspace
hl.bind(M .. " + CTRL + up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind(M .. " + CTRL + down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })

-- ───────────────────────────────────────────
-- Window States
-- ───────────────────────────────────────────
hl.bind(M .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }), { description = "Toggle Fullscreen" })
hl.bind(M .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Toggle Maximize Window" })
hl.bind(M .. " + SHIFT + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Floating" })
hl.bind(M .. " + CTRL + T", function()
	hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
	hl.dispatch(hl.dsp.window.pin())
end, { description = "Toggle floating + pinned" })
hl.bind(M .. " + ALT + R", hl.dsp.submap("resize"), { description = "Enter resize mode" })

-- ───────────────────────────────────────────
-- Layout Controls
-- ───────────────────────────────────────────
hl.bind(M .. " + ALT + W", hl.dsp.exec_cmd("noctalia msg panel-toggle mindset/hypr-layouts:panel"), { description = "Switch layout (panel)" })
-- Window Cycling
hl.bind("ALT + Tab", hl.dsp.window.cycle_next({ tiled = true }), { description = "Cycle windows" })
-- dwindle
hl.bind(M .. " + CTRL + K", hl.dsp.layout("swapsplit"), { description = "(Dwindle) Swap split" })
hl.bind(M .. " + CTRL + J", hl.dsp.layout("togglesplit"), { description = "(Dwindle) Toggle split" })
-- master
hl.bind(M .. " + CTRL + M", hl.dsp.layout("orientationnext"), { description = "(Master) Cycle master orientation" })

-- ───────────────────────────────────────────
-- Window Grouping
-- ───────────────────────────────────────────
hl.bind(M .. " + SHIFT + G", hl.dsp.group.toggle(), { description = "Toggle window group" })
hl.bind(M .. " + CTRL + G", hl.dsp.window.move({ out_of_group = true }), { description = "Out of group" })
hl.bind(M .. " + CTRL + Bracketleft", hl.dsp.window.move({ into_group = "l" }), { description = "Into group left" })
hl.bind(M .. " + CTRL + Bracketright", hl.dsp.window.move({ into_group = "r" }), { description = "Into group right" })
hl.bind(M .. " + ALT + Bracketright", hl.dsp.window.move({ into_group = "u" }), { description = "Into group up" })
hl.bind(M .. " + ALT + Bracketleft", hl.dsp.window.move({ into_group = "d" }), { description = "Into group down" })
hl.bind(M .. " + Tab", hl.dsp.group.next(), { description = "Group next" })
hl.bind(M .. " + SHIFT + Tab", hl.dsp.group.prev(), { description = "Group prev" })
for i = 1, 9 do
	hl.bind(M .. " + CTRL + " .. i, hl.dsp.group.active({ index = i }), { description = "Group index " .. i })
end

-- ───────────────────────────────────────────
-- Toggle Animations
-- ───────────────────────────────────────────
hl.bind(M .. " + SHIFT + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-animations.sh"), { description = "Toggle animations" })
hl.bind(M .. " + ALT + A", hl.dsp.exec_cmd("noctalia msg panel-toggle mindset/hypr-animations:panel"), { description = "Switch animation preset (panel)" })


-- ───────────────────────────────────────────
-- Scratchpad
-- ───────────────────────────────────────────
hl.bind(M .. " + S", hl.dsp.workspace.toggle_special("magic"), { description = "Toggle special workspace magic" })
hl.bind(M .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }), { description = "Send window to special workspace" })
hl.bind(M .. " + SHIFT + CTRL + S",	hl.dsp.window.move({ workspace = "previous" }), { description = "Move window out of special workspace" })

-- ───────────────────────────────────────────
-- Media Keys (via PipeWire — Noctalia)
-- ───────────────────────────────────────────
hl.bind("XF86AudioRaiseVolume",	hl.dsp.exec_cmd("noctalia msg volume-up"), { locked = true, repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { locked = true, repeating = true, description = "Volume down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true, description = "Mute audio" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"), { locked = true, description = "Mute mic" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia msg media toggle"), { locked = true, description = "Play/pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia msg media next"), { locked = true, description = "Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia msg media previous"), { locked = true, description = "Previous track" })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), { locked = true, repeating = true, description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), { locked = true, repeating = true, description = "Brightness down" })
hl.bind("XF86Sleep", hl.dsp.exec_cmd("~/.config/hypr/scripts/lock-and-suspend.sh"), { description = "Lock then suspend" })
hl.bind("XF86Calculator", hl.dsp.exec_cmd(launchPrefix .. CALCULATOR), { locked = true, description = "Calculator" })

-- ───────────────────────────────────────────
-- Workspace Navigation (Super + 1-9)
-- ───────────────────────────────────────────
for i = 1, 9 do
	local key = tostring(i)
	hl.bind(M .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Workspace " .. i })
	hl.bind(
		M .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move to workspace " .. i }
	)
end

-- SUPER + 0 -> workspace gaming (permainan/game otomatis masuk sini via window rule)
hl.bind(M .. " + 0", hl.dsp.focus({ workspace = "name:gaming" }), { description = "Workspace gaming" })
hl.bind(
	M .. " + SHIFT + 0",
	hl.dsp.window.move({ workspace = "name:gaming" }),
	{ description = "Move window to gaming workspace" }
)

-- ───────────────────────────────────────────
-- Multi-Monitor
-- ───────────────────────────────────────────
hl.bind(M .. " + CTRL + ALT + Tab", hl.dsp.window.cycle_next(), { description = "Cycle windows" })
hl.bind(M .. " + CTRL + ALT + left", hl.dsp.focus({ monitor = "l" }), { description = "Focus left monitor" })
hl.bind(M .. " + CTRL + ALT + right", hl.dsp.focus({ monitor = "r" }), { description = "Focus right monitor" })
hl.bind(M .. " + CTRL + ALT + up", hl.dsp.focus({ monitor = "u" }), { description = "Focus top monitor" })
hl.bind(M .. " + CTRL + ALT + down", hl.dsp.focus({ monitor = "d" }), { description = "Focus bottom monitor" })
hl.bind(M .. " + CTRL + SHIFT + left", hl.dsp.window.move({ monitor = "l" }), { description = "Move window left monitor" })
hl.bind(M .. " + CTRL + SHIFT + right", hl.dsp.window.move({ monitor = "r" }), { description = "Move window right monitor" })
hl.bind(M .. " + CTRL + SHIFT + up", hl.dsp.window.move({ monitor = "u" }), { description = "Move window top monitor" })
hl.bind(M .. " + CTRL + SHIFT + down", hl.dsp.window.move({ monitor = "d" }), { description = "Move window bottom monitor" })

-- ───────────────────────────────────────────
-- Move Windows (floating)
-- ───────────────────────────────────────────
hl.bind("CTRL + SHIFT + up", hl.dsp.window.move({ x = 0, y = -50, relative = true }), { repeating = true, description = "Move window up" })
hl.bind("CTRL + SHIFT + down", hl.dsp.window.move({ x = 0, y = 50, relative = true }), { repeating = true, description = "Move window down" })
hl.bind("CTRL + SHIFT + left", hl.dsp.window.move({ x = -50, y = 0, relative = true }), { repeating = true, description = "Move window left" })
hl.bind("CTRL + SHIFT + right", hl.dsp.window.move({ x = 50, y = 0, relative = true }), { repeating = true, description = "Move window right" })

-- ───────────────────────────────────────────
-- App Launchers
-- ───────────────────────────────────────────
hl.bind(M .. " + Return", hl.dsp.exec_cmd(launchPrefix .. TERMINAL), { description = "Terminal" })
hl.bind(M .. " + E", hl.dsp.exec_cmd(launchPrefix .. FILE_MANAGER), { description = "File manager" })
hl.bind(M .. " + B", hl.dsp.exec_cmd(launchPrefix .. BROWSER), { description = "Browser (Zen)" })
hl.bind(M .. " + N", hl.dsp.exec_cmd(launchPrefix .. EDITOR), { description = "Editor" })
hl.bind(M .. " + T", hl.dsp.exec_cmd("Telegram"), { description = "Telegram" })
hl.bind(M .. " + W", hl.dsp.exec_cmd("flatpak run io.github.tobagin.karere"), { description = "Karere" })
hl.bind(M .. " + D", hl.dsp.exec_cmd("vesktop"), { description = "Vesktop (Discord)" })
hl.bind(M .. " + G", hl.dsp.exec_cmd("steam"), { description = "Steam" })
hl.bind(M .. " + U", hl.dsp.exec_cmd("/opt/abdownloadmanager/bin/ABDownloadManager"), { description = "AB Download Manager" })

-- ───────────────────────────────────────────
-- Screenshot & Screen Tools
-- ───────────────────────────────────────────
hl.bind("Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot region"), { description = "Screenshot: region" })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot fullscreen"), { description = "Screenshot: fullscreen" })
hl.bind("CTRL + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot window"), { description = "Screenshot: active window" })
hl.bind(M .. " + SHIFT + L", hl.dsp.exec_cmd("~/.config/hypr/scripts/google-lens"), { description = "Google Lens (region)" })
hl.bind(M .. " + SHIFT + C", hl.dsp.exec_cmd("~/.config/hypr/scripts/ocr"), { description = "OCR (region)" })
hl.bind(M .. " + SHIFT + Q", hl.dsp.exec_cmd("~/.config/hypr/scripts/qr-scan"), { description = "QR Scan (region)" })

-- ───────────────────────────────────────────
-- Mouse Bindings
-- ───────────────────────────────────────────
hl.bind(M .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window with mouse" })
hl.bind(M .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window with mouse" })
hl.bind("mouse:274", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { mouse = true, description = "Toggle Maximize (middle click)" })

-- ───────────────────────────────────────────
-- Scroll through workspaces (Super + Scroll)
-- ───────────────────────────────────────────
hl.bind(M .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace (scroll)" })
hl.bind(M .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace (scroll)" })
hl.bind(M .. " + ALT + mouse_up", hl.dsp.window.move({ workspace = "e-1" }), { description = "Move window to previous workspace (scroll)" })
hl.bind(M .. " + ALT + mouse_down", hl.dsp.window.move({ workspace = "e+1" }), { description = "Move window to next workspace (scroll)" })
hl.bind(M .. " + CTRL + mouse_up", hl.dsp.layout("focus l"), { description = "Focus left (scrolling scroll)" })
hl.bind(M .. " + CTRL + mouse_down", hl.dsp.layout("focus r"), { description = "Focus right (scrolling scroll)" })

-- ───────────────────────────────────────────
-- Zoom Cursor (HiDPI assist)
-- ───────────────────────────────────────────
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind(M .. " + Minus", function() zoomfunction(-0.3) end, { repeating = true, description = "Zoom out cursor" })
hl.bind(M .. " + Plus", function() zoomfunction(0.3) end, { repeating = true, description = "Zoom in cursor" })
hl.bind(M .. " + code:82", function() zoomfunction(-0.3) end, { repeating = true, description = "Zoom out cursor (keypad)" })
hl.bind(M .. " + code:86", function() zoomfunction(0.3) end, { repeating = true, description = "Zoom in cursor (keypad)" })

-- ───────────────────────────────────────────
-- GloView (Mission Control overview)
-- ───────────────────────────────────────────
if hl.plugin.gloview then
    hl.bind(M .. " + SHIFT + O", hl.plugin.gloview.toggle, { description = "Toggle overview" })
    hl.bind(M .. " + ALT + O", hl.plugin.gloview.desktop, { description = "Desktop mode" })
    hl.bind(M .. " + CTRL + O", hl.plugin.gloview.allworkspaces, { description = "All workspaces" })
end
