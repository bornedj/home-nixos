vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

local daniel_Fugitive = vim.api.nvim_create_augroup("daniel_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd

-- linematch splits a conflict into per-line diff blocks, so fugitive's
-- d2o/d3o (a plain :diffget) would only take the block under the cursor
-- instead of the whole conflict. Keep linematch for regular diffs and drop
-- it only for the duration of the get.
local diffget_without_linematch = function(source_bufnr)
  local diffopt = vim.o.diffopt
  vim.o.diffopt = table.concat(
    vim.tbl_filter(function(opt)
      return not vim.startswith(opt, "linematch")
    end, vim.split(diffopt, ",")),
    ","
  )
  vim.cmd.diffupdate()
  local ok, err = pcall(vim.cmd.diffget, source_bufnr)
  vim.o.diffopt = diffopt
  vim.cmd.diffupdate()
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

local wrap_fugitive_diffget_maps = function(bufnr)
  vim.iter(vim.api.nvim_buf_get_keymap(bufnr, "n"))
    :filter(function(map)
      return map.lhs == "d2o" or map.lhs == "d3o"
    end)
    :each(function(map)
      local source_bufnr = map.rhs and map.rhs:match("^:diffget (%d+)")
      if source_bufnr then
        vim.keymap.set("n", map.lhs, function()
          diffget_without_linematch(tonumber(source_bufnr))
        end, { buffer = bufnr, silent = true })
      end
    end)
end

-- fugitive defines d2o/d3o buffer-locally when :Gvdiffsplit! opens, and the
-- diff it starts fires DiffUpdated once those maps exist.
autocmd("DiffUpdated", {
  group = daniel_Fugitive,
  pattern = "*",
  callback = function()
    vim.iter(vim.api.nvim_tabpage_list_wins(0))
      :map(vim.api.nvim_win_get_buf)
      :each(wrap_fugitive_diffget_maps)
  end,
})
autocmd("BufWinEnter", {
  group = daniel_Fugitive,
  pattern = "*",
  callback = function()
    if vim.bo.ft ~= "fugitive" then
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "<leader>p", function()
      vim.cmd.Git('push')
    end, opts)

    -- rebase push
    vim.keymap.set("n", "<leader>rp", function ()
        vim.cmd.Git('push --force-with-lease')
    end, opts)
    vim.keymap.set("n", "<leader>ri", ":Git ri", opts)

    vim.keymap.set("n", "<leader>P", ":Git pull origin ", opts)

    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
    -- needed if i did not set the branch up correctly
    vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);

    vim.keymap.set("n", "<leader>fap", ":Git fetch -a --prune --tags -f", opts);

    -- override checkout commands with switch
    vim.keymap.set("n", "co<Space>", ":Git switch ",opts)
    vim.keymap.set("n", "coc", ":Git switch -c ",opts)
  end,
})
