local lspconfig = require('lspconfig')
local hypr = require("hypr")
local qmlls_build_dir = require("qmlls_path")

lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig.util.default_config.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

-- Callback function to bind keys for when lsp is attached
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP Actions',
    callback = function(event)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gi", function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float({ source = true }) end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end
})

-- server configurations
vim.lsp.enable('ts_ls')
-- bug with eslint running in html
-- need to do some debugging on who eslint finds the workspace root
vim.lsp.config('eslint', {
    settings = {
        workingDirectory = {
            mode = 'location'
        }
    },
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
})
vim.lsp.enable('eslint')
vim.lsp.config('rust_analyzer', {
    settings = {
        cargo = {
            buildScripts = {
                enable = true
            }
        }
    }
})
vim.lsp.enable('rust_analyzer')

vim.lsp.config('lua_ls', {
    on_init = function(client)
        if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
            then
                return
            end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using (most
                -- likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Tell the language server how to find Lua modules same way as Neovim
                -- (see `:h lua-module-load`)
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
                    vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
                    hypr.stubs,
                },
            },
        })
    end,
    settings = {
        Lua = {},
    },

})
vim.lsp.enable('lua_ls')
vim.lsp.enable('angularls')
vim.lsp.enable('cssls')
vim.lsp.config('emmet_ls', {
    --  current file types plus xml
    filetypes = { "astro", "css", "eruby", "html", "htmlangular", "htmldjango", "javascriptreact", "less", "pug", "sass", "scss", "svelte", "templ", "typescriptreact", "vue", "xml" }
})
vim.lsp.enable('emmet_ls')
vim.lsp.enable('jsonls')
vim.lsp.enable('html')
vim.lsp.enable('pyright')
vim.lsp.enable('bashls')
vim.lsp.enable('yamlls')
vim.lsp.enable('dockerls')
vim.lsp.enable('nixd')
vim.lsp.enable('terraformls')

vim.lsp.config('qmlls', {
    cmd = { qmlls_build_dir.stubs .. "/bin/qmlls" },
    filetypes = { "qml" }
})
vim.lsp.enable('qmlls')

-- completion setup
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})

cmp.setup.filetype({ "sql", "plsql", "mysql" }, {
    sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" }
    }
})
