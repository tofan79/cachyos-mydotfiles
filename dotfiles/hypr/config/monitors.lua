-- Monitor layout. Source of truth for monitor configuration.
-- One line per monitor. Edit mode/position/scale/transform directly here to set defaults.
-- NOTE: better-displays rewrites the line for a monitor you change from its panel.

hl.monitor({ output = "eDP-1", mode = "1920x1080@144.00Hz", position = "0x0", scale = 1, transform = 0, vrr = 3 })
hl.monitor({ output = "HDMI-A-1", mode = "1366x768@59.79000", position = "1920x0", scale = 1, transform = 0, vrr = 3 })
