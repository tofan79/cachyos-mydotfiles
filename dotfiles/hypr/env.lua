-- ═══════════════════════════════════════════
-- Environment Variables
-- ═══════════════════════════════════════════

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "radeonsi")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("NVD_BACKEND", "direct")

-- GTK4 on wlroots: prevent Nautilus hangs by forcing GL renderer
hl.env("GSK_RENDERER", "gl")

-- NVIDIA Hybrid GPU (switcheroo-control / Optimus)
hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")
hl.env("__VK_LAYER_NV_optimus", "NVIDIA_only")

-- NVIDIA Gaming (DLSS, Reflex, Smooth Motion)
hl.env("PROTON_ENABLE_NGX_UPDATER", "1")
hl.env("DXVK_NVAPI_VKREFLEX", "1")
hl.env("NVPRESENT_ENABLE_SMOOTH_MOTION", "1")

-- Gamescope / Steam
hl.env("STEAM_ALLOW_DRIVE_UNMOUNT", "1")
hl.env("SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS", "0")

-- Toolkit backends (dari caelestia-dots)
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland,x11,windows")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Qt
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")

-- Hyprland NVIDIA Fixes
hl.env("WLR_RENDERER", "vulkan")
hl.env("AQ_FORCE_LINEAR_BLIT", "0")

-- Proton/Wine Tuning
hl.env("VKD3D_CONFIG", "dxr")
hl.env("WINE_FULLSCREEN_FSR", "1")

-- NVIDIA Shader Cache (12GB)
hl.env("__GL_SHADER_DISK_CACHE", "1")
hl.env("__GL_SHADER_DISK_CACHE_SIZE", "12000000000")

-- Java
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")
