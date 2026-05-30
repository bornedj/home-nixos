local vars = require("modules.vars")
-- sceptre monitor
hl.monitor({
    output   = vars.sceptre_output,
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})

-- benq horizontal
hl.monitor({
    output    = vars.benq_output,
    mode      = "1920x1080@144",
    position  = "-2160x0",
    scale     = 1,
    transform = 1
})

-- workspaces
hl.workspace_rule({
    workspace = "1",
    monitor = vars.benq_output,
    default = true, layout_opts = { direction = "down" },
    default_name = vars.workspace.browser
})
hl.workspace_rule({
    workspace = "2",
    monitor = vars.benq_output,
    layout_opts = { direction = "down" },
    default_name = vars.workspace.discord,
    persistent = true
})
hl.workspace_rule({
    workspace = "3",
    monitor = vars.benq_output,
    layout_opts = { direction = "down" }
})
hl.workspace_rule({
    workspace = "4",
    monitor = vars.benq_output,
    layout_opts = { direction = "down" }
})
hl.workspace_rule({
    workspace = "5",
    monitor = vars.benq_output,
    layout_opts = { direction = "down" }
})

hl.workspace_rule({
    workspace = "6",
    monitor = vars.sceptre_output,
    default = true,
    default_name = vars.workspace.terminal,
    persistent = true
})
hl.workspace_rule({
    workspace = "7",
    monitor = vars.sceptre_output,
    default_name = vars.workspace.steam,
    persistent = true
})
hl.workspace_rule({
    workspace = "8",
    monitor = vars.sceptre_output,
    default_name = vars.workspace.music,
    persistent = true
})

hl.workspace_rule({ workspace = "9", monitor = vars.sceptre_output })
hl.workspace_rule({ workspace = "10", monitor = vars.sceptre_output })

hl.window_rule({match = {class = vars.steam}, workspace = vars.workspace.steam, monitor = vars.sceptre_output})
hl.window_rule({match = {class = vars.browser}, workspace = vars.workspace.browser, monitor = vars.benq_output})
hl.window_rule({match = {class = "com.mitchellh.ghostty"}, workspace = vars.workspace.terminal, monitor = vars.sceptre_output})
hl.window_rule({match = {class = "Cider"}, workspace = vars.workspace.music, monitor = vars.sceptre_output})
hl.window_rule({match = {class = vars.discord}, workspace = vars.workspace.discord, monitor = vars.benq_output })
hl.window_rule({
    match = {class = "cs2"},
    workspace = vars.workspace.steam,
    monitor = vars.sceptre_output,
    fullscreen = true,
    decorate = false,
})
