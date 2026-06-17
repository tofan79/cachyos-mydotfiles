-- ═══════════════════════════════════════════
-- Layout & Workspace Configuration
-- ═══════════════════════════════════════════

-- Layout engines
hl.config({
    dwindle = {
        preserve_split = true,
        force_split    = 2,
        smart_split    = false,
        smart_resizing = false,
    },
    scrolling = {
        fullscreen_on_one_column = false,
    },
})

-- Noctalia blur for bar, panels, dock, notifications
hl.layer_rule({
    name         = "noctalia",
    match        = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
    },
    ignore_alpha = 0.5,
    blur         = true,
    blur_popups  = true,
})

-- Persistent workspaces (keep empty workspaces visible in Noctalia bar)
for i = 1, 9 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", persistent = true })
end

-- Per-workspace layout rules
-- 1-4: scrolling, 5-9: dwindle
for i = 1, 4 do
    hl.workspace_rule({ workspace = tostring(i), layout = "scrolling" })
end
for i = 5, 9 do
    hl.workspace_rule({ workspace = tostring(i), layout = "dwindle" })
end
