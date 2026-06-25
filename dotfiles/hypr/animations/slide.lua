-- -----------------------------------------------------
-- Animations
-- name "Slide"
-- -----------------------------------------------------

--------------------------------------------------------------------------------
-- Animation Master Switch
--------------------------------------------------------------------------------
hl.config({
    animations = {
        enabled = true,
    }
})

--------------------------------------------------------------------------------
-- Animation Curves (Bezier)
--------------------------------------------------------------------------------
hl.curve("slide_decel", { type = "bezier", points = { {0.05, 0.7}, {0.1, 1.0} } })
hl.curve("slide_accel", { type = "bezier", points = { {0.3, 0.0}, {0.8, 0.15} } })
hl.curve("slide_overshoot", { type = "bezier", points = { {0.05, 0.9}, {0.18, 1.1} } })
hl.curve("slide_soft", { type = "bezier", points = { {0.25, 0.1}, {0.25, 1.0} } })
hl.curve("slide_bounce", { type = "bezier", points = { {0.05, 1.2}, {0.3, 1.0} } })

--------------------------------------------------------------------------------
-- Animation Rules
--------------------------------------------------------------------------------
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "slide_overshoot", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "slide_decel", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "slide_accel", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "slide_soft", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "slide_decel" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 6, bezier = "slide_accel" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "slide_soft" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "slide_accel" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 3, bezier = "slide_soft" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 5, bezier = "slide_accel" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "slide_bounce", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "slide_decel", style = "slidevert" })
