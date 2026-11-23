-- command to open a file with explorer.exe so I can open files with their native
-- windows default program. I.E. open html files in windows chrome
vim.keymap.set("n", "<leader>fp", function()
    local startingDir = vim.fn.getcwd()
    local explorer = string.format("silent !explorer.exe %s", vim.fn.expand('%:t'))
    vim.cmd("cd %:h")
    vim.cmd(explorer)
    vim.cmd(string.format("cd %s", startingDir))
end)

-- command to open a file explorer in the location of the current buffer
vim.keymap.set("n", "<leader>fe", function()
    local startingDir = vim.fn.getcwd()
    vim.cmd("cd %:h")
    vim.cmd("silent !explorer.exe .")
    vim.cmd(string.format("cd %s", startingDir))
end)

-- open windows git bash and cd into the dir of the current buffer. Capital B
-- because telescope's git_branches owns <leader>gb.
vim.keymap.set("n", "<leader>gB", function()
    vim.cmd(string.format("silent !/mnt/c/Program\\ Files/Git/git-bash.exe --cd=%s", vim.fn.getcwd()))
end)

-- another wsl specific bind, used to remove ^M from files
-- that have had windows carriages added to files
vim.keymap.set("n", "<leader>ux", function()
    vim.cmd("update")
    vim.cmd("e ++ff=dos")
    vim.cmd("setlocal ff=unix")
    vim.cmd("w")
end)
