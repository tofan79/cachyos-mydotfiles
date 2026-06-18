-- -----------------------------------------------------
-- Animations
-- name "Wipe"
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
hl.curve("wipe_in", { type = "bezier", points = { {0.0, 0.0}, {0.2, 1.0} } })
hl.curve("wipe_out", { type = "bezier", points = { {0.4, 0.0}, {1.0, 1.0} } })
hl.curve("wipe_clean", { type = "bezier", points = { {0.0, 0.0}, {1.0, 1.0} } })
hl.curve("wipe_snap", { type = "bezier", points = { {0.05, 0.7}, {0.1, 1.0} } })

--------------------------------------------------------------------------------
-- Animation Rules
--------------------------------------------------------------------------------
hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wipe_in", style = "slidefade 15%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "wipe_in", style = "slidefade 15%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "wipe_out", style = "slidefade 15%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wipe_clean", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "wipe_snap" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 6, bezier = "wipe_out" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 5, bezier = "wipe_in", style = "slidefade 15%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "wipe_out", style = "slidefade 15%" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 3, bezier = "wipe_in" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 5, bezier = "wipe_out" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "wipe_clean", style = "slidefade 15%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "wipe_snap", style = "slidefadevert 15%" })
