local vars = require("modules.vars")

-- autostart
hl.on("hyprland.start", function ()
    hl.exec_cmd("hyprpaper")

    -- setup the vert monitor
    hl.dsp.focus({ workspace = 1 })
    hl.exec_cmd(vars.browser)
    hl.dsp.focus({ workspace = 2 })
    hl.dsp.exec_cmd(vars.discord)

    -- setup horizontal
    hl.dsp.focus(vars.sceptre_output)
    hl.exec_cmd(vars.terminal)

end)
