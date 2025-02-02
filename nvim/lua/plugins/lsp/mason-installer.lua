local ensure_installed = {
                "rzls",
                "roslyn",
                "lua_ls",
                "ts_ls",
                "rust_analyzer",
                "svelte",
                "html"
}

return {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    config = function()
        require("mason-tool-installer").setup({
                ensure_installed = ensure_installed,
                auto_update = true,
                run_on_start = true,
            })

    end
}
