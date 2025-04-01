return {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
        dashboard = {
            width = 180,
            sections = {
                {
                    section = "terminal",
                    cmd =
                    "chafa ~/dotfiles/.my_stuff/lumon2.png --format symbols --symbols v --size 180; sleep 0.1",
                    height = 35
                },
                {
                    { section = "keys",   gap = 1, padding = 1 },
                    { section = "startup" },
                },
            },

        }
    }
}
