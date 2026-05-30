local vars = require("modules.vars")

-- autostart
hl.on("hyprland.start", function ()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("qs")

    hl.exec_cmd(vars.terminal)

    -- fix tmux.conf not loading the stlying
    hl.exec_cmd("tmux source-file ~/.config/tmux/tmux.conf")
end)
