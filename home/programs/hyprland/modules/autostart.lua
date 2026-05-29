local vars = require("modules.vars")

-- autostart
hl.on("hyprland.start", function ()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd(vars.terminal)

    -- setup the vert monitor
    -- hl.exec_cmd("hyprctl [workspace name:".. vars.workspace.browser .. " silent] " .. vars.browser)
    -- hl.exec_cmd("hyprctl [workspace name:".. vars.workspace.discord .. " silent] " .. vars.discord)

    -- setup horizontal
    -- hl.exec_cmd("hyprctl [workspace name:".. vars.workspace.terminal .. " silent] " .. vars.terminal)
    -- hl.exec_cmd("hyprctl [workspace name:".. vars.workspace.steam .. " silent] " .. vars.steam)

end)
