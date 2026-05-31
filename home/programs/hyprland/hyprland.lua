require("modules.monitor")
require("modules.binds")
require("modules.autostart")
local colors = require("modules.colors")

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
        gaps_out = 7,
        layout = "scrolling",
        col = {
            inactive_border = colors.base16.base01,
            active_border = colors.base16.base00,
        }
    },
    decoration = {
        rounding = 12,
        rounding_power = 7,
        active_opacity = 0.85,
        inactive_opacity = 0.8,
        fullscreen_opacity = 1,
        blur = {
            enabled = true,
            size = 2,
        },
    },
    cursor = {
        default_monitor = "DP-6",
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        font_family = "Mono Mable NF"
    },
})
