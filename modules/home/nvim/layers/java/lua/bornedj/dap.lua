local M = {}

M.attach = function(bufnr)
    -- require('jdtls.dap').setup_dap_main_class_configs()
    require('jdtls').setup_dap({ hotcodereplace = 'auto' })

    local map = function(mode, lhs, rhs)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
    end

    --breakpoints
    map('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
    map('n', '<Leader>B', function() require('dap').set_breakpoint() end)
    map('n', '<Leader>lp',
        function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
    map('n', '<Leader>dr', function() require('dap').repl.open() end)
    map('n', '<Leader>dl', function() require('dap').run_last() end)
    map('n', '<Leader>cb', function() require('dap').clear_breakpoints() end)

    -- breakpoint motions
    map('n', '<leader>dc', function() require('dap').continue() end)
    map('n', '<leader>dj', function() require('dap').step_over() end)
    map('n', '<leader>dk', function() require('dap').step_into() end)
    map('n', '<leader>do', function() require('dap').step_out() end)

    -- widgets
    map({ 'n', 'v' }, '<Leader>dh', function()
        require('dap.ui.widgets').hover()
    end)
    map({ 'n', 'v' }, '<Leader>dp', function()
        require('dap.ui.widgets').preview()
    end)
    map('n', '<Leader>df', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
    end)
    map('n', '<Leader>ds', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.scopes)
    end)
end

return M
