local vars = require("modules.vars")

-- autostart
hl.on("hyprland.start", function ()
    hl.exec_cmd("hyprpaper")

    hl.exec_cmd(vars.terminal)
    hl.exec_cmd(vars.browser)
end)
