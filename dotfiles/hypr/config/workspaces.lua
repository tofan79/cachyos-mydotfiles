-- Workspace rules wiki https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- Add your workspace rules here. Increment the workspace number as you go. Do not have duplicate workspaces.
-- Named gaming workspace. No `default = true` here: with it, Hyprland treats the
-- named workspace as a low-id default and lands the session there on login instead
-- of workspace 1. Window rules still route matching apps here.
hl.workspace_rule({ workspace = "name:gaming", monitor = PRIMARY_MONITOR })
hl.workspace_rule({ workspace = "1", monitor = MONITOR1, default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = MONITOR1, default = true, persistent = true })
hl.workspace_rule({ workspace = "3", monitor = MONITOR1, default = true, persistent = true })
hl.workspace_rule({ workspace = "4", monitor = MONITOR1, default = true, persistent = true })
hl.workspace_rule({ workspace = "5", monitor = MONITOR1, default = true, persistent = true })
hl.workspace_rule({ workspace = "6", monitor = MONITOR2, default = true, persistent = true })
hl.workspace_rule({ workspace = "7", monitor = MONITOR2, default = true, persistent = true })
hl.workspace_rule({ workspace = "8", monitor = MONITOR2, default = true, persistent = true })
hl.workspace_rule({ workspace = "9", monitor = MONITOR2, default = true, persistent = true })

-- For other layouts such as scrolling, see example below
-- hl.workspace_rule({ workspace = "1", monitor = MONITOR1, default = true, persistent = true, layout = scroling })
