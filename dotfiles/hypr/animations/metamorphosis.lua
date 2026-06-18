-- -----------------------------------------------------
-- Animations
-- name "Metamorphosis"
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
hl.curve("meta_decel", { type = "bezier", points = { {0.05, 0.7}, {0.1, 1.0} } })
hl.curve("meta_accel", { type = "bezier", points = { {0.3, 0.0}, {0.8, 0.15} } })
hl.curve("meta_bounce", { type = "bezier", points = { {0.05, 0.9}, {0.18, 1.3} } })
hl.curve("meta_spring", { type = "bezier", points = { {0.34, 1.56}, {0.64, 1.0} } })
hl.curve("meta_squish", { type = "bezier", points = { {0.1, 1.5}, {0.76, 0.92} } })

--------------------------------------------------------------------------------
-- Animation Rules
--------------------------------------------------------------------------------
hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "meta_bounce", style = "popin 80%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4, bezier = "meta_spring", style = "popin 80%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "meta_accel", style = "popin 20%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "meta_decel", style = "popin 60%" })
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "meta_decel" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 6, bezier = "meta_squish" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "meta_spring", style = "popin 80%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "meta_accel", style = "popin 20%" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 3, bezier = "meta_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 5, bezier = "meta_squish" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "meta_squish", style = "slidefade 20%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "meta_spring", style = "slidefadevert 20%" })
