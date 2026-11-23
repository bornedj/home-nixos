vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'jdtls debugger maps',
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.name == 'jdtls' then
            require('bornedj.dap').attach(event.buf)
        end
    end,
})

vim.lsp.enable('jdtls')
