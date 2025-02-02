local autocmd = vim.api.nvim_create_autocmd

autocmd("BufWritePre", {
            pattern = "*",
            callback = function()
                vim.lsp.buf.format({ async = false }) -- Synchronous formatting before saving
            end,
        })
