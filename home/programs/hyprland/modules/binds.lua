local vars = require("modules.vars")
---------------------
---- KEYBINDINGS ----
---------------------

-- main apps
hl.bind(vars.mainMod .. " + T", hl.dsp.exec_cmd(vars.terminal))
hl.bind(vars.mainMod .. " + B", hl.dsp.exec_cmd(vars.browser))
hl.bind(vars.mainMod .. " + M", hl.dsp.exec_cmd(vars.music))
hl.bind(vars.mainMod .. " + D", hl.dsp.exec_cmd(vars.discord))
hl.bind(vars.mainMod .. " + E", hl.dsp.exec_cmd(vars.fileManager))
hl.bind(vars.mainMod .. " + R", hl.dsp.exec_cmd(vars.menu))
hl.bind(vars.mainMod .. " + S", hl.dsp.exec_cmd(vars.steam))

-- windows
hl.bind(vars.mainMod .. " + X", hl.dsp.window.close())
-- hl.bind(vars.mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(vars.mainMod .. " + P", hl.dsp.focus({last = "workspace"}))
-- Move focus with mainMod + vim motions
hl.bind(vars.mainMod .. " + h",  hl.dsp.focus({ direction = "left" }))
hl.bind(vars.mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(vars.mainMod .. " + k",    hl.dsp.focus({ direction = "up" }))
hl.bind(vars.mainMod .. " + j",  hl.dsp.focus({ direction = "down" }))
-- move windows
hl.bind(vars.mainMod .. " + SHIFT + H",  hl.dsp.window.move({ direction = "l" }))
hl.bind(vars.mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(vars.mainMod .. " + SHIFT + K",    hl.dsp.window.move({ direction = "u" }))
hl.bind(vars.mainMod .. " + SHIFT + J",  hl.dsp.window.move({ direction = "d" }))
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(vars.mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(vars.mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end
-- Scroll through existing workspaces with mainMod + scroll
hl.bind(vars.mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(vars.mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(vars.mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(vars.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- quit
hl.bind(vars.mainMod .. " + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
