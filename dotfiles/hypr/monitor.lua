-- ═══════════════════════════════════════════
-- Monitor Configuration
-- ═══════════════════════════════════════════

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "auto",
    scale    = 1,
    vrr      = 1,
})

-- Uncomment for external monitor (right of built-in):
-- hl.monitor({
--     output   = "HDMI-A-1",
--     mode     = "1920x1080@60",
--     position = "1920x0",
--     scale    = 1,
-- })

-- Uncomment for external monitor (below built-in):
-- hl.monitor({
--     output   = "HDMI-A-1",
--     mode     = "1920x1080@60",
--     position = "0x1080",
--     scale    = 1,
-- })
