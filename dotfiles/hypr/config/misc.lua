hl.config({
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
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
    misc = {
        col = {
            splash = CACHYLGREEN,
        },
        middle_click_paste = false,
        enable_swallow = true,
        swallow_regex = "(kitty|ghostty|[Kk]onsole|Alacritty|gnome-terminal|xfce[0-9]?-terminal)",
        vrr = -1,
        focus_on_activate = true,
        allow_session_lock_restore = true,
        disable_scale_notification = true,
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
    },
    render = {
        direct_scanout = 2,
    },
    xwayland = {
        force_zero_scaling = true
    },
})

hl.config({ general = { layout = "scrolling" } })
