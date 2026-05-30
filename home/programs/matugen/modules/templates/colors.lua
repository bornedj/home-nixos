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

-- vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
-- vim.api.nvim_set_hl(0, "CocInlayHint", {bg = "none"})
-- vim.api.nvim_set_hl(0, 'TelescopeNormal', {bg= "none"})
-- vim.api.nvim_set_hl(0, 'TelescopeBackground', {bg= "none"})
-- vim.api.nvim_set_hl(0, 'NormalFloat', {bg= "none"})
-- vim.api.nvim_set_hl(0, 'FloatBorder', {bg= "none"})
-- vim.api.nvim_set_hl(0, 'LspDiagnosticsDefaultError', {bg= "none"})
-- vim.api.nvim_set_hl(0, 'LspDiagnosticsDefaultWarning', {bg= "none"})
-- vim.api.nvim_set_hl(0, 'LspDiagnosticsDefaultInformation', {bg= "none"})
-- vim.api.nvim_set_hl(0, 'LspDiagnosticsDefaultHint', {bg= "none"})
-- vim.api.nvim_set_hl(0, 'LspDiagnosticsUnderlineWarning', {bg= "none"})
-- vim.api.nvim_set_hl(0, 'Normal', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'NormalNC', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Comment', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Identifier', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'CursorLineNr', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Special', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Constant', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Underlined', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Todo', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Statement', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'String', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Function', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'PreProc', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Type', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Operator', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Repeat', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Conditional', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'StatusLine', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'LineNr', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'Structure', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'CursorLine', { bg = "NONE", ctermbg = "NONE" })
-- vim.api.nvim_set_hl(0, 'SignColumn', { bg = "NONE", ctermbg = "NONE" })
--
