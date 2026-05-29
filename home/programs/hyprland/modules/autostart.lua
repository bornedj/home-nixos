local vars = require("modules.vars")

-- autostart
hl.on("hyprland.start", function ()
    hl.exec_cmd("hyprpaper")
    h1.exec_cmd("matugen image ~/Pictures/wallpapers/vagabond-water.jpg")

    hl.exec_cmd(vars.terminal)
    hl.exec_cmd(vars.browser)
end)
