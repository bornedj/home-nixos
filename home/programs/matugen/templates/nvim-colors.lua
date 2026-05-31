require('base16-colorscheme').setup({
  base00 = "{{base16.base00.default.hex}}",
  base01 = "{{base16.base01.default.hex}}",
  base02 = "{{base16.base02.default.hex}}",
  base03 = "{{base16.base03.default.hex}}",
  base04 = "{{base16.base04.default.hex}}",
  base05 = "{{base16.base05.default.hex}}",
  base06 = "{{base16.base06.default.hex}}",
  base07 = "{{base16.base07.default.hex}}",

  base08 = "{{base16.base08.default.hex}}",
  base09 = "{{base16.base09.default.hex}}",
  base0A = "{{base16.base0a.default.hex}}",
  base0B = "{{base16.base0b.default.hex}}",
  base0C = "{{base16.base0c.default.hex}}",
  base0D = "{{base16.base0d.default.hex}}",
  base0E = "{{base16.base0e.default.hex}}",
  base0F = "{{base16.base0f.default.hex}}",
})

-- We first theme base16, but we also need to fix some other colors that don't
-- contrast well by default

-- Helper function to set multiple highlight groups at once
local function set_hl_mutliple(groups, value)
  for _, v in pairs(groups) do
    vim.api.nvim_set_hl(0, v, value)
  end
end

-- Make selected text stand out more
vim.api.nvim_set_hl(0, 'Visual', {
  bg = '{{colors.primary_container.default.hex}}',
  fg = '{{colors.on_primary_container.default.hex}}', -- normal text contrast
})

-- Make "string" text contrast better
set_hl_mutliple({ 'String', 'TSString' }, {
  bg = '{{colors.tertiary.default.hex}}',
  fg = '{{colors.tertiary.default.hex}}',
})

-- Grey out comments
set_hl_mutliple({ 'TSComment', 'Comment' }, {
  fg = '{{base16.base03.default.hex}}',
  italic = true,
})

-- Color in other highlight groups as you see fit!

set_hl_mutliple({ 'TSMethod', 'Method' }, {
  fg = '{{colors.tertiary.default.hex}}',
})

set_hl_mutliple({ 'TSFunction', 'Function' }, {
  fg = '{{colors.primary.default.hex}}',
})

set_hl_mutliple({ 'Keyword', 'TSKeyword', 'TSKeywordFunction', 'TSRepeat' }, {
  fg = '{{colors.inverse_primary.default.hex}}',
})

vim.cmd("highlight clear")

-- transparent backgrounds
set_hl_mutliple({ "Normal", "NormalFloat", "SignColumn"}, {
    fg = "{{base16.base05.default.hex}}",
    bg = "none"
})

-- UI accents
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })

