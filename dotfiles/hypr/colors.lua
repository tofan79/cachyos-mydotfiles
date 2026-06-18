-- Auto-read colors from Noctalia (survives regeneration)
local function get_noctalia_colors()
    local file = io.open(os.getenv("HOME") .. "/.config/hypr/noctalia.lua", "r")
    if not file then return end
    local content = file:read("*all")
    file:close()

    primary = content:match('primary%s*=%s*"([^"]+)"')
    surface = content:match('surface%s*=%s*"([^"]+)"')
    secondary = content:match('secondary%s*=%s*"([^"]+)"')
    error = content:match('error%s*=%s*"([^"]+)"')
    on_primary = content:match('on_primary%s*=%s*"([^"]+)"') or surface
    on_surface = content:match('on_surface%s*=%s*"([^"]+)"') or primary
end

get_noctalia_colors()

hl.config({
    general = {
        col = {
            active_border = primary,
            inactive_border = surface,
        },
    },

    group = {
        col = {
            border_active = secondary,
            border_inactive = surface,
            border_locked_active = error,
            border_locked_inactive = surface,
        },

        groupbar = {
            col = {
                active = secondary,
                inactive = surface,
                locked_active = error,
                locked_inactive = surface,
            },
        },
    },
})
