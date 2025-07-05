local ensure_installed = {
    "lua_ls",
    "ts_ls",
    "rust_analyzer",
    "svelte",
    "html"
}

return {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    opts = {
        ensure_installed = ensure_installed
    },
    dependencies = {
        "mason-org/mason.nvim",
        "neovim/nvim-lspconfig",
        "saghen/blink.cmp"
    },
    config = function(_, opts)
        require("mason").setup()
        require("mason-lspconfig").setup(opts)

        -- Additional config lua_ls
        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                },
            },
        })
    end,
}
