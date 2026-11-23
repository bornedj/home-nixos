vim.g.db_ui_winwidth = 50
vim.g.db_ui_trim = 40

vim.keymap.set("n", "<leader>db", "<cmd>silent DBUIToggle<CR>")

-- Override dadbod-ui keymappings with vim-tmux-navigator
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dbui",
    callback = function()
        vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { buffer = true })
        vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { buffer = true })
    end,
})

-- add row limit to the oracle list helper
vim.g.db_ui_table_helpers = {
    oracle = {
        List = string.gsub([[
SET linesize 32000;
SET pagesize 4000;

COLUMN column_name FORMAT a~;
COLUMN constraint_type FORMAT a~;
COLUMN index_name FORMAT a~;
COLUMN owner FORMAT a~;
COLUMN table_name FORMAT a~;

SELECT * FROM "{dbname}"."{table}"
WHERE ROWNUM <=200
;
        ]], "~", vim.g.db_ui_trim)
    }
}

-- disable folding
vim.api.nvim_create_autocmd("FileType", {
    pattern = "dbout",
    callback = function()
        vim.wo.foldenable = false
        vim.wo.wrap = false
    end,
})
