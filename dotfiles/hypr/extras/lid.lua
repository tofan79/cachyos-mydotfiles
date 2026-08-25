-- ═══════════════════════════════════════════
-- Laptop Lid Handling (adapted from ryoku-arch)
-- ═══════════════════════════════════════════
-- Handles lid close/open events. When lid closes, lock the session and suspend.
-- When lid opens, resume. Uses systemctl for suspend/resume.

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("noctalia msg session lock && systemctl suspend"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd(""), { locked = true })
