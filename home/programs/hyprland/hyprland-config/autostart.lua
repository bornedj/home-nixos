require("hyprland-config.vars")

-- autostart
hl.on("hyprland.start", function ()
    hl.exec_cmd(vars.terminal)
    -- hl.exec_cmd(discord)
    -- hl.exec_cmd(browser)
    -- hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

