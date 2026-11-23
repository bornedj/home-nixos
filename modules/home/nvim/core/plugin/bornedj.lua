-- Sourcing order across plugins is alphabetical, so every module of the core
-- layer is required from here in an explicit order. remap comes first and
-- harpoon after it so harpoon keeps <M-x> (nav_file 6) over remap's <C-x>
-- decrement. lsp precedes cmp so the capabilities cmp advertises are set
-- before any server starts. A module that fails, for example obsidian without
-- its vault directories, is reported without stopping the ones after it.
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
