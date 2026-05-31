local function source_matugen()
  local matugen_path = os.getenv("HOME") .. "/.config/nvim/lua/matugen.lua"

  local file, err = io.open(matugen_path, "r")
  if err ~= nil then
    -- Some placeholder theme, this will be overwritten once matugen kicks in
    vim.cmd('colorscheme base16-kanagawa')
    vim.print("A matugen style file was not found, but that's okay! The colorscheme will dynamically change if matugen runs!")
  else
    dofile(matugen_path)
    io.close(file)
  end
end

-- Main entrypoint on matugen reloads
local function auxiliary_function()
  -- Load the matugen style file to get all the new colors
  local matugen_path = os.getenv("HOME") .. "/.config/nvim/generated.lua"
  source_matugen()

  -- Any other options you wish to set upon matugen reloads can also go here!
  -- vim.api.nvim_set_hl(0, "Comment", { italic = true })
end

-- Register an autocmd to listen for matugen updates
vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  callback = auxiliary_function,
})

auxiliary_function()
