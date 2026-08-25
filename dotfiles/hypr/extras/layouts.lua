-- Layout & Workspace Configuration

hl.config({

	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border = { colors = { primary, on_primary }, angle = 90 },
			inactive_border = on_primary,
		},
		resize_on_border = true,
		allow_tearing = true,
	},
	dwindle = {
		preserve_split = true,
		force_split = 2,
		smart_split = false,
		smart_resizing = true,
	},
	master = {
		mfact = 0.60,
		new_status = "master",
		smart_resizing = true,
	},
	scrolling = {
		fullscreen_on_one_column = false,
	},
})

hl.layer_rule({
	name = "noctalia",
	match = {
		namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
	},
	ignore_alpha = 0.5,
	blur = true,
	blur_popups = true,
})

for i = 1, 9 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", persistent = true })
end

hl.config({ general = { layout = "scrolling" } })

-- ───────────────────────────────────────────
-- Input (from ryoku-arch)
-- ───────────────────────────────────────────
-- follow_mouse = 2: new windows keep keyboard focus instead of stealing it
-- to the cursor. Click to move focus. Fixes "terminal opens but isn't active
-- until I move the mouse onto it".
hl.config({
    input = {
        follow_mouse = 2,
        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})

-- ───────────────────────────────────────────
-- Misc (from ryoku-arch)
-- ───────────────────────────────────────────
hl.config({
    misc = {
        focus_on_activate = true,
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
        allow_session_lock_restore = true,
        disable_scale_notification = true,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})
