-- -----------------------------------------------------
-- Animations
-- name "Moving Meta"
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
-- moving
hl.curve("overshot", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("smoothOut", { type = "bezier", points = { {0.5, 0}, {0.99, 0.99} } })
hl.curve("smoothIn", { type = "bezier", points = { {0.5, -0.5}, {0.68, 1.5} } })

-- metamorphosis
hl.curve("meta_decel", { type = "bezier", points = { {0.05, 0.7}, {0.1, 1.0} } })
hl.curve("meta_accel", { type = "bezier", points = { {0.3, 0.0}, {0.8, 0.15} } })
hl.curve("meta_bounce", { type = "bezier", points = { {0.05, 0.9}, {0.18, 1.3} } })
hl.curve("meta_spring", { type = "bezier", points = { {0.34, 1.56}, {0.64, 1.0} } })
hl.curve("meta_squish", { type = "bezier", points = { {0.1, 1.5}, {0.76, 0.92} } })

--------------------------------------------------------------------------------
-- Animation Rules
--------------------------------------------------------------------------------
-- moving (non-workspace)
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "smoothOut" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "smoothOut" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "smoothIn", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "smoothIn" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 5, bezier = "smoothIn" })

-- metamorphosis (workspace only)
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "meta_squish", style = "slidefade 20%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "meta_spring", style = "slidefadevert 20%" })
