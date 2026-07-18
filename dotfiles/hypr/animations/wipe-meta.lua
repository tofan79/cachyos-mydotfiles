-- -----------------------------------------------------
-- Animations
-- name "Wipe Meta"
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
-- wipe
hl.curve("wipe_in", { type = "bezier", points = { {0.0, 0.0}, {0.2, 1.0} } })
hl.curve("wipe_out", { type = "bezier", points = { {0.0, 0.0}, {0.2, 1.0} } })
hl.curve("wipe_clean", { type = "bezier", points = { {0.0, 0.0}, {1.0, 1.0} } })
hl.curve("wipe_snap", { type = "bezier", points = { {0.2, 0.0}, {0.0, 1.0} } })

-- dynamic
hl.curve("wind", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("liner", { type = "bezier", points = { {1, 1}, {1, 1} } })
hl.curve("winIn", { type = "bezier", points = { {0.1, 1.1}, {0.1, 1.1} } })

-- metamorphosis
hl.curve("meta_spring", { type = "bezier", points = { {0.34, 1.56}, {0.64, 1.0} } })
hl.curve("meta_squish", { type = "bezier", points = { {0.1, 1.5}, {0.76, 0.92} } })

--------------------------------------------------------------------------------
-- Animation Rules
--------------------------------------------------------------------------------
-- dynamic (open)
hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slidefade 15%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "slidefade 15%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 12, bezier = "wipe_out", style = "slidefade 15%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wipe_clean", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 20, bezier = "liner", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 15, bezier = "wipe_snap" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 15, bezier = "wipe_out" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 6, bezier = "winIn" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 12, bezier = "wipe_out" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 12, bezier = "wipe_out" })

-- metamorphosis (workspace only)
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "meta_squish", style = "slidefade 20%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "meta_spring", style = "slidefadevert 20%" })
