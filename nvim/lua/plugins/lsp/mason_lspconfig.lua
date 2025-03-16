return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        'saghen/blink.cmp'
    },
    config = function()
        local capabilities = require('blink.cmp').get_lsp_capabilities()

        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" },
                                },
                            },
                        },
                    }
                end,
                ["svelte"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.svelte.setup {
                        capabilities = capabilities,
                        settings = {
                            svelte = {
                                plugin = {
                                    svelte = {
                                        enable = true,
                                        -- Enable snippets
                                        compilerWarnings = {
                                            ["a11y-missing-content"] = "ignore",
                                        },
                                    },
                                },
                            },
                        },
                    }
                end,

            },
        })
    end
}
