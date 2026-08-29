-- need to figure out why the Command shows as unknown 
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
