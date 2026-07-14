vim.keymap.set('n', "<leader>cpe", vim.cmd { cmd = "Copilot", args = {"enable"} })
vim.keymap.set('n', "<leader>cpd", vim.cmd { cmd = "Copilot", args = {"enable"} })
vim.keymap.set('i', '<C-y>', 'copilot#Accept("")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
