------------------
---- MONITORS ----
------------------
local sceptre_output = "DP-6"
-- sceptre monitor
hl.monitor({
    output   = sceptre_output,
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})

local benq_output = "DP-5"
-- benq horizontal
hl.monitor({
    output   = benq_output,
    mode     = "1920x1080@144",
    position = "-2160x0",
    scale    = 1,
    transform = 1
})

-- workspaces
hl.workspace_rule({workspace = "1", monitor = benq_output, default = true, layout_opts = { direction = "down" }})
hl.workspace_rule({workspace = "2", monitor = benq_output, layout_opts = { direction = "down" }})
hl.workspace_rule({workspace = "3", monitor = benq_output, layout_opts = { direction = "down" }})
hl.workspace_rule({workspace = "4", monitor = benq_output, layout_opts = { direction = "down" }})
hl.workspace_rule({workspace = "5", monitor = benq_output, layout_opts = { direction = "down" }})

hl.workspace_rule({workspace = "6", monitor = sceptre_output, default = true})
hl.workspace_rule({workspace = "7", monitor = sceptre_output})
hl.workspace_rule({workspace = "8", monitor = sceptre_output})
hl.workspace_rule({workspace = "9", monitor = sceptre_output})
hl.workspace_rule({workspace = "0", monitor = sceptre_output})
