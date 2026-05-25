require("obsidian").setup {
    legacy_commands = false,
    workspaces = {
        {
            name = "personal",
            path = "~/obsidian/personal",
        },
        {
            name = "daily_notes",
            path = "~/obsidian/daily",
        },
    },
    daily_notes = {
        folder = "daily"
    },
}
