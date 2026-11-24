-- One entry point for the core layer, so a module that fails, for example
-- obsidian without its vault directories, is reported without stopping the
-- ones after it.
vim.iter({
    "bornedj.remap",
    "bornedj.fugitive",
    "bornedj.telescope",
    "bornedj.harpoon",
    "bornedj.comment",
    "bornedj.treesitter",
    "bornedj.trouble",
    "bornedj.devicons",
    "bornedj.which-key",
    "bornedj.claude-code",
    "bornedj.undotree",
    "bornedj.obsidian",
    "bornedj.dadbod",
    "bornedj.lsp",
    "bornedj.cmp",
}):each(function(module)
    local ok, err = xpcall(require, debug.traceback, module)
    if not ok then
        vim.notify(string.format("%s failed: %s", module, err), vim.log.levels.ERROR)
    end
end)
