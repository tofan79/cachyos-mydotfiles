-- ═══════════════════════════════════════════
-- Key Bindings — Omarchy Standard
-- ═══════════════════════════════════════════

local M = "SUPER"

-- ───────────────────────────────────────────
-- Core
-- ───────────────────────────────────────────
hl.bind(M .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "Reload Hyprland configuration" })
hl.bind(M .. " + Q", hl.dsp.window.close(), { description = "Close active window" })
hl.bind(M .. " + CTRL + M", hl.dsp.exit(), { description = "Exit Hyprland" })
hl.bind(M .. " + Escape", hl.dsp.exec_cmd("noctalia msg panel-toggle session"), { description = "Session menu" })
hl.bind(M .. " + slash", hl.dsp.exec_cmd("kitty -T btop -e btop"), { description = "System monitor (btop)" })

-- ───────────────────────────────────────────
-- Noctalia Shell
-- ───────────────────────────────────────────
hl.bind(M .. " + Space", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"), { description = "App launcher" })
hl.bind(M .. " + ALT + Space", hl.dsp.exec_cmd("noctalia msg panel-toggle control-center"), { description = "Control center" })
hl.bind(M .. " + CTRL + Space", hl.dsp.exec_cmd("noctalia msg settings-toggle"), { description = "Settings toggle" })

-- ───────────────────────────────────────────
-- Window Focus (Super + Arrows)
-- ───────────────────────────────────────────
hl.bind(M .. " + left", hl.dsp.focus({ direction = "left" }), { description = "Move focus left" })
hl.bind(M .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Move focus right" })
hl.bind(M .. " + up", hl.dsp.focus({ direction = "up" }), { description = "Move focus up" })
hl.bind(M .. " + down", hl.dsp.focus({ direction = "down" }), { description = "Move focus down" })

-- ───────────────────────────────────────────
-- Window Swapping (Super + Shift + Arrows)
-- ───────────────────────────────────────────
hl.bind(M .. " + SHIFT + left", hl.dsp.window.swap({ direction = "l" }), { description = "Swap window left" })
hl.bind(M .. " + SHIFT + right", hl.dsp.window.swap({ direction = "r" }), { description = "Swap window right" })
hl.bind(M .. " + SHIFT + up", hl.dsp.window.swap({ direction = "u" }), { description = "Swap window up" })
hl.bind(M .. " + SHIFT + down", hl.dsp.window.swap({ direction = "d" }), { description = "Swap window down" })

-- Move to adjacent workspace
hl.bind(M .. " + CTRL + left", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind(M .. " + CTRL + right", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })

-- ───────────────────────────────────────────
-- Window States
-- ───────────────────────────────────────────
hl.bind(M .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
    { description = "Toggle Fullscreen" })
hl.bind(M .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
    { description = "Toggle Maximize Window" })
hl.bind(M .. " + SHIFT + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Floating" })
hl.bind(M .. " + ALT + T",
    function()
        hl.dispatch(hl.dsp.window.float({ action = "toggle" })); hl.dispatch(hl.dsp.window.pin())
    end, { description = "Toggle floating + pinned" })
-- hl.bind(M .. " + SHIFT + O", hl.dsp.layout("overview"))  -- needs hyprland-overview plugin
-- ───────────────────────────────────────────
-- Window Cycling
-- ───────────────────────────────────────────
hl.bind("ALT + Tab", hl.dsp.window.cycle_next(), { description = "Cycle windows" })

-- ───────────────────────────────────────────
-- Scratchpad
-- ───────────────────────────────────────────
hl.bind(M .. " + S", hl.dsp.workspace.toggle_special("magic"), { description = "Toggle special workspace magic" })
hl.bind(M .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }),
    { description = "Send window to special workspace" })
hl.bind(M .. " + SHIFT + CTRL + S", hl.dsp.window.move({ workspace = "previous" }),
    { description = "Move window out of special workspace" })

-- ───────────────────────────────────────────
-- Layout Controls
-- ───────────────────────────────────────────
hl.bind(M .. " + CTRL + L", hl.dsp.exec_cmd([[sh -c '
ID=$(hyprctl activeworkspace -j | jq -r .id)
CUR=$(hyprctl activeworkspace -j | jq -r ".tiledLayout // \"dwindle\"")
case "$CUR" in
  dwindle)   NXT=scrolling ;;
  scrolling) NXT=dwindle ;;
esac
hyprctl eval "hl.workspace_rule({ workspace = $ID, layout = \"$NXT\" })"
notify-send "Layout: $NXT"
']]), { description = "Cycle layout" })
hl.bind(M .. " + CTRL + K", hl.dsp.layout("swapsplit"), { description = "Swap split" })
hl.bind(M .. " + CTRL + J", hl.dsp.layout("togglesplit"), { description = "Toggle split" })

-- ───────────────────────────────────────────
-- Window Grouping
-- ───────────────────────────────────────────
hl.bind(M .. " + CTRL + G", hl.dsp.group.toggle(), { description = "Toggle window group" })
hl.bind(M .. " + ALT + G", hl.dsp.window.move({ out_of_group = true }), { description = "Out of group" })
hl.bind(M .. " + ALT + left", hl.dsp.window.move({ into_group = "l" }), { description = "Into group left" })
hl.bind(M .. " + ALT + right", hl.dsp.window.move({ into_group = "r" }), { description = "Into group right" })
hl.bind(M .. " + ALT + up", hl.dsp.window.move({ into_group = "u" }), { description = "Into group up" })
hl.bind(M .. " + ALT + down", hl.dsp.window.move({ into_group = "d" }), { description = "Into group down" })
hl.bind(M .. " + Tab", hl.dsp.group.next(), { description = "Group next" })
hl.bind(M .. " + SHIFT + Tab", hl.dsp.group.prev(), { description = "Group prev" })
for i = 1, 5 do
    hl.bind(M .. " + ALT + " .. i, hl.dsp.group.active({ index = i }), { description = "Group index " .. i })
end

-- ───────────────────────────────────────────
-- Toggle Animations
-- ───────────────────────────────────────────
hl.bind(M .. " + SHIFT + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle-animations.sh"),
    { description = "Toggle animations" })
hl.bind(M .. " + CTRL + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/switch-animations.sh"),
    { description = "Switch animation preset" })
hl.bind(M .. " + ALT + A", hl.dsp.exec_cmd("~/.config/hypr/scripts/text-extractor.sh"),
    { description = "Extract text from area" })
hl.bind(M .. " + SHIFT + K", hl.dsp.exec_cmd("~/.config/hypr/scripts/keybindings.sh"),
    { description = "Show keybindings" })
hl.bind(M .. " + CTRL + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/switch-decorations.sh"),
    { description = "Switch decoration preset" })
hl.bind(M .. " + CTRL + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/switch-windows.sh"),
    { description = "Switch window preset" })

-- ───────────────────────────────────────────
-- Media Keys (via PipeWire — Noctalia)
-- ───────────────────────────────────────────
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), { locked = true, repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { locked = true, repeating = true, description = "Volume down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true, description = "Mute audio" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"), { locked = true, description = "Mute mic" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("noctalia msg media toggle"), { locked = true, description = "Play/pause" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("noctalia msg media next"), { locked = true, description = "Next track" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("noctalia msg media previous"), { locked = true, description = "Previous track" })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), { locked = true, repeating = true, description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), { locked = true, repeating = true, description = "Brightness down" })
hl.bind("XF86Calculator", hl.dsp.exec_cmd("gnome-calculator"), { locked = true, description = "Calculator" })
hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-region"), { locked = true, description = "Screenshot region" })
hl.bind(M .. " + SHIFT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"), { locked = true, description = "Screenshot fullscreen" })

-- ───────────────────────────────────────────
-- Workspace Navigation (Super + 1-9)
-- ───────────────────────────────────────────
for i = 1, 9 do
    local key = tostring(i)
    hl.bind(M .. " + " .. key, hl.dsp.focus({ workspace = i }), { description = "Workspace " .. i })
    hl.bind(M .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { description = "Move to workspace " .. i })
end

-- ───────────────────────────────────────────
-- Multi-Monitor
-- ───────────────────────────────────────────
hl.bind(M .. " + CTRL + ALT + Tab", hl.dsp.window.cycle_next(), { description = "Cycle windows" })
hl.bind(M .. " + CTRL + ALT + left", hl.dsp.focus({ monitor = "l" }), { description = "Focus left monitor" })
hl.bind(M .. " + CTRL + ALT + right", hl.dsp.focus({ monitor = "r" }), { description = "Focus right monitor" })
hl.bind(M .. " + CTRL + ALT + up", hl.dsp.focus({ monitor = "u" }), { description = "Focus top monitor" })
hl.bind(M .. " + CTRL + ALT + down", hl.dsp.focus({ monitor = "d" }), { description = "Focus bottom monitor" })
hl.bind(M .. " + CTRL + ALT + SHIFT + left", hl.dsp.window.move({ workspace = "mon:l" }), { description = "Move window left monitor" })
hl.bind(M .. " + CTRL + ALT + SHIFT + right", hl.dsp.window.move({ workspace = "mon:r" }), { description = "Move window right monitor" })
hl.bind(M .. " + CTRL + ALT + SHIFT + up", hl.dsp.window.move({ workspace = "mon:u" }), { description = "Move window top monitor" })
hl.bind(M .. " + CTRL + ALT + SHIFT + down", hl.dsp.window.move({ workspace = "mon:d" }), { description = "Move window bottom monitor" })

-- ───────────────────────────────────────────
-- Resize Windows (Ctrl+Alt+Arrows)
-- ───────────────────────────────────────────
hl.bind("CTRL + ALT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }),
    { repeating = true, description = "Resize window up" })
hl.bind("CTRL + ALT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }),
    { repeating = true, description = "Resize window down" })
hl.bind("CTRL + ALT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }),
    { repeating = true, description = "Resize window left" })
hl.bind("CTRL + ALT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }),
    { repeating = true, description = "Resize window right" })

-- ───────────────────────────────────────────
-- Move Windows (floating)
-- ───────────────────────────────────────────
hl.bind("CTRL + SHIFT + up", hl.dsp.window.move({ x = 0, y = -50, relative = true }),
    { repeating = true, description = "Move window up" })
hl.bind("CTRL + SHIFT + down", hl.dsp.window.move({ x = 0, y = 50, relative = true }),
    { repeating = true, description = "Move window down" })
hl.bind("CTRL + SHIFT + left", hl.dsp.window.move({ x = -50, y = 0, relative = true }),
    { repeating = true, description = "Move window left" })
hl.bind("CTRL + SHIFT + right", hl.dsp.window.move({ x = 50, y = 0, relative = true }),
    { repeating = true, description = "Move window right" })

-- ───────────────────────────────────────────
-- App Launchers
-- ───────────────────────────────────────────
hl.bind(M .. " + Return", hl.dsp.exec_cmd("kitty"), { description = "Terminal" })
hl.bind(M .. " + E", hl.dsp.exec_cmd("nautilus"), { description = "File manager" })
hl.bind(M .. " + B", hl.dsp.exec_cmd("zen"), { description = "Browser (Zen)" })
hl.bind(M .. " + N", hl.dsp.exec_cmd("zed"), { description = "Editor (Zed)" })
hl.bind(M .. " + H", hl.dsp.exec_cmd("localsend"), { description = "LocalSend" })
hl.bind(M .. " + T", hl.dsp.exec_cmd("Telegram"), { description = "Telegram" })

-- ───────────────────────────────────────────
-- Mouse Bindings
-- ───────────────────────────────────────────
hl.bind(M .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window with mouse" })
hl.bind(M .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window with mouse" })
hl.bind("mouse:274", hl.dsp.window.fullscreen(), { mouse = true, description = "Fullscreen (middle click)" })

-- ───────────────────────────────────────────
-- Scroll through workspaces (Super + Scroll)
-- ───────────────────────────────────────────
hl.bind(M .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace (scroll)" })
hl.bind(M .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace (scroll)" })
