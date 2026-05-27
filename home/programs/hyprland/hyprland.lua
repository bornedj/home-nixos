require("hyprland-config.monitor")
require("hyprland-config.binds")
require("hyprland-config.autostart")

debug.disable_logs = false;
debug.gl_debugging = true;

-- extremely basic config
hl.config({
    input = {
        follow_mouse = 1,
        focus_on_close = 2, -- most recently used active window
    },
    general = {
        gaps_in = 5,
        gaps_out = 12,
        layout = "scrolling",
    },
    decoration = {
        rounding = 10,
        rounding_power = 7,
        active_opacity = 0.8,
        inactive_opacity = 0.8,
        fullscreen_opacity = 0.8,
        blur = {
            enabled = true,
            size = 2,
        },
    },
    cursor = {
        default_monitor = "DP-6",

    },
})
