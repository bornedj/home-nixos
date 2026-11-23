require("obsidian").setup {
    legacy_commands = false,
    workspaces = require("bornedj.generated").obsidian_workspaces,
    daily_notes = {
        folder = "daily"
    },
}
