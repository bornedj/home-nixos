vim.g.colors_name = "musashi"

local c = {
  bg = "{{base16.base00.default.hex}}",
  fg = "{{base16.base05.default.hex}}",

  black   = "{{base16.base00.default.hex}}",
  red     = "{{base16.base08.default.hex}}",
  green   = "{{base16.base0b.default.hex}}",
  yellow  = "{{base16.base0a.default.hex}}",
  blue    = "{{base16.base0d.default.hex}}",
  magenta = "{{base16.base0e.default.hex}}",
  cyan    = "{{base16.base0c.default.hex}}",
  white   = "{{base16.base07.default.hex}}",

  comment = "{{base16.base03.default.hex}}",
}

vim.cmd("highlight clear")
vim.opt.termguicolors = true

-- UI
vim.api.nvim_set_hl(0, "Normal", { fg = c.fg, bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })

-- Syntax
vim.api.nvim_set_hl(0, "Comment", { fg = c.comment, italic = true })
vim.api.nvim_set_hl(0, "Keyword", { fg = c.magenta })
vim.api.nvim_set_hl(0, "String", { fg = c.green })
vim.api.nvim_set_hl(0, "Function", { fg = c.blue })
vim.api.nvim_set_hl(0, "Type", { fg = c.yellow })

-- UI accents
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })
vim.api.nvim_set_hl(0, "Visual", { bg = c.comment, fg = c.bg })
