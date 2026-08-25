-- ═══════════════════════════════════════════
-- Resize Submap (from ryoku-arch)
-- ═══════════════════════════════════════════
-- Enter with SUPER+R. Arrows/hjkl resize the active window.
-- Escape, Return, or SUPER+R again exits back to normal keymap.
-- Exclusive submap: bare arrows resize here without fighting SUPER+arrow focus.

local step = 40

hl.define_submap("resize", function()
    hl.bind("Left",   hl.dsp.window.resize({ x = -step, y = 0,     relative = true }), { repeating = true })
    hl.bind("Right",  hl.dsp.window.resize({ x = step,  y = 0,     relative = true }), { repeating = true })
    hl.bind("Up",     hl.dsp.window.resize({ x = 0,     y = -step, relative = true }), { repeating = true })
    hl.bind("Down",   hl.dsp.window.resize({ x = 0,     y = step,  relative = true }), { repeating = true })
    hl.bind("h",      hl.dsp.window.resize({ x = -step, y = 0,     relative = true }), { repeating = true })
    hl.bind("l",      hl.dsp.window.resize({ x = step,  y = 0,     relative = true }), { repeating = true })
    hl.bind("k",      hl.dsp.window.resize({ x = 0,     y = -step, relative = true }), { repeating = true })
    hl.bind("j",      hl.dsp.window.resize({ x = 0,     y = step,  relative = true }), { repeating = true })
    hl.bind("Escape", hl.dsp.submap("reset"))
    hl.bind("Return", hl.dsp.submap("reset"))
    hl.bind("SUPER + CTRL + R", hl.dsp.submap("reset"))
end)
