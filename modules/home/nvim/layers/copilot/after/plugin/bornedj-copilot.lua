-- cmp wraps the existing insert <C-y> map on its first InsertEnter and uses it
-- when the completion menu is closed, so this map has to exist before then.
vim.keymap.set('n', "<leader>cp", function ()
    if vim.g.copilot_enabled == 0 then
        vim.g.copilot_enabled = 1
    else
        vim.g.copilot_enabled = 0
    end
end)
vim.keymap.set('i', '<C-y>', 'copilot#Accept("")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true

vim.g.copilot_enabled = 0
