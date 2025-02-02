local map = vim.keymap.set

-- Leader
vim.g.mapleader = " "

-- Formatting
map("n", "<leader>f", vim.lsp.buf.format, {})

-- LSP
map("n", "K", vim.lsp.buf.hover, {})
map("n", "gd", vim.lsp.buf.definition, {})
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
