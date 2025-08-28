local ensure_installed = {
    "lua_ls",
    "ts_ls",
    "rust_analyzer",
    "svelte",
    "html"
}

local cargo_target_directory = "target/ra";

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

        -- Additional config rust_analyzer
        vim.lsp.config("rust_analyzer", {
            settings = {
                cargo = {
                    -- separate dir for
                    extraEnv = { CARGO_TARGET_DIR = cargo_target_directory },
                },
                checkOnSave = {
                    extraArgs = { "--target-dir", cargo_target_directory },
                },
            },
        })
    end,
}
