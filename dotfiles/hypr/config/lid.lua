-- Laptop Lid Handling
-- When lid closes: lock session and suspend. When opens: resume.

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("noctalia msg session lock && systemctl suspend"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd(""), { locked = true })