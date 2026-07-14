-- need to figure out why the Command shows as unknown 
-- vim.keymap.set('n', "<leader>cp", vim.cmd.Copilot { args = {"copilot_enabled!"} })
vim.keymap.set('i', '<C-y>', 'copilot#Accept("")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
