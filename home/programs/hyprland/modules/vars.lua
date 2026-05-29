local module = {}
-- programs
module.terminal    = "ghostty"
module.fileManager = "dolphin"
module.menu        = "hyprlauncher"
module.browser = "zen"
module.music = "cider-2"
module.discord = "discord"
module.steam = "steam"

-- monitors
module.sceptre_output = "DP-6"
module.benq_output = "DP-5"

-- workspace names
module.workspace = {
    browser = "browser",
    discord = module.discord,
    terminal = "terminal",
    steam = module.steam,
    music = "music",
}

-- MAIN MOD
module.mainMod = "SUPER" -- Sets "Windows" key as main modifier

return module
