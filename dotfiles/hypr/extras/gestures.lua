-------------------------------------------------------
-- Gestures
-------------------------------------------------------

-- Swipe config (dari caelestia-dots)
hl.config({
    gestures = {
        workspace_swipe_distance                 = 700,
        workspace_swipe_cancel_ratio             = 0.15,
        workspace_swipe_min_speed_to_force       = 5,
        workspace_swipe_direction_lock           = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new               = true,
    },
})

-- Workspaces (3 fingers)
hl.gesture({
    fingers = 3,
    direction = "vertical",
    action = "workspace"
})

-- Workspaces (4 fingers)
hl.gesture({
    fingers = 4,
    direction = "vertical",
    action = "workspace"
})
-- Scrolling
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "scroll_move",
    scale = 0.9,
})

-- Fullscreen on  
hl.gesture({ fingers = 4, direction = "pinchout", action = function ()
    hl.dispatch(hl.dsp.window.fullscreen({ action="set" })) 
end})

-- Fullscreen off  
hl.gesture({ fingers = 4, direction = "pinchin", action = function ()
    hl.dispatch(hl.dsp.window.fullscreen({ action="unset" })) 
end})