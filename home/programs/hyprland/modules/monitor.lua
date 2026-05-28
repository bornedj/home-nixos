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
    output   = vars.benq_output,
    mode     = "1920x1080@144",
    position = "-2160x0",
    scale    = 1,
    transform = 1
})

-- workspaces
hl.workspace_rule({workspace = "1", monitor = vars.benq_output, default = true, layout_opts = { direction = "down" }, default_name = vars.workspace.browser})
hl.workspace_rule({workspace = "2", monitor = vars.benq_output, layout_opts = { direction = "down" }, default_name = vars.workspace.discord})
hl.workspace_rule({workspace = "3", monitor = vars.benq_output, layout_opts = { direction = "down" }})
hl.workspace_rule({workspace = "4", monitor = vars.benq_output, layout_opts = { direction = "down" }})
hl.workspace_rule({workspace = "5", monitor = vars.benq_output, layout_opts = { direction = "down" }})

hl.workspace_rule({workspace = "6", monitor = vars.sceptre_output, default = true, default_name = vars.workspace.terminal})
hl.workspace_rule({workspace = "7", monitor = vars.sceptre_output, default_name = vars.workspace.steam})
hl.workspace_rule({workspace = "8", monitor = vars.sceptre_output, default_name = vars.workspace.music})
hl.workspace_rule({workspace = "9", monitor = vars.sceptre_output})
hl.workspace_rule({workspace = "0", monitor = vars.sceptre_output})
