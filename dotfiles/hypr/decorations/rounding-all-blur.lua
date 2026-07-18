-- -----------------------------------------------------
-- General window decoration
-- name: "Rounding All Blur"
-- -----------------------------------------------------

hl.config({
    decoration = {
        rounding = 12,
        active_opacity = 0.9,
        inactive_opacity = 0.7,
        fullscreen_opacity = 0.9,

        blur = {
            enabled = true,
            size = 3,
            passes = 2,
            new_optimizations = true,
            ignore_opacity = true,
            xray = true,
        },

        shadow = {
            enabled = true,
            range = 30,
            render_power = 3,
            color = "0x66000000",
        },
    }
})
