local M = {}
local time_utils = require("util.time")
local environment_utils = require("util.environments")
local colorscheme_priority = 1000
local colorscheme_change_seconds = 1000 * 60 * 60; -- milliseconds * seconds * minutes
math.randomseed(os.time())                         -- seed randomness

M.day_colorschemes = {
    "everforest-hard",
    "everforest-soft",
    "kanagawa-lotus",
}

M.night_colorschemes = {
    "nightfox",
    "tokyonight-moon",
    "everforest-hard",
    "everforest-soft",
    "bamboo",
    "kanagawa-dragon",
    'OceanicNext',
    'nord',
    'miasma'
}

M.special_colorschemes = {
    ["12-25"] = "everforest", -- Christmas (Dec 25)
}

M.set_colorscheme = function()
    local is_daytime = time_utils.is_daytime()
    local selected_colorcheme
    if is_daytime then
        selected_colorcheme = M.get_random_element(M.day_colorschemes)
    else
        selected_colorcheme = M.get_random_element(M.night_colorschemes)
    end

    if is_daytime then
        vim.opt.background = "light"
    else
        vim.opt.background = "dark"
    end

    if selected_colorcheme:match("everforest") then
        if selected_colorcheme == "everforest-medium" then
            vim.g.everforest_background = "medium"
        elseif selected_colorcheme == "everforest-soft" then
            vim.g.everforest_background = "soft"
        end
        selected_colorcheme = "everforest" --apply base
    end

    if environment_utils.is_windows() then -- like using a default at work
        selected_colorcheme = "onedark"
    end

    vim.cmd("colorscheme " .. selected_colorcheme)
    print("Using colorscheme " .. selected_colorcheme)
end

vim.keymap.set("n", "<leader>cc", M.set_colorscheme, { desc = "Cycle through colorschemes" })

M.get_random_element = function(list)
    return list[math.random(#list)]
end

M.setup = function()
    M.set_colorscheme();

    local timer = vim.loop.new_timer()
    timer:start(
        colorscheme_change_seconds, -- delay
        colorscheme_change_seconds, -- interval
        vim.schedule_wrap(function()
            M.set_colorscheme()
        end)
    )
end

return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = colorscheme_priority,
        config = M.setup, -- Call setup
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    {
        "shaunsingh/nord.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "mhartington/oceanic-next",
        lazy = false,
        priority = 1000,
    },
    {
        "navarasu/onedark.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require('onedark').setup {
                style = "darker",
                transparent = false,
            }
        end
    },
    {
        "ribru17/bamboo.nvim",
        lazy = false,
        priority = colorscheme_priority,
        config = function()
            require("bamboo").setup({})
        end,
    },
    {
        "sainnhe/everforest",
        lazy = false,
        priority = colorscheme_priority,
        config = function()
            vim.g.everforest_enable_italic = false
        end,
    },
    {
        "xero/miasma.nvim",
        lazy = false,
        priority = 1000,
    },
    {
        "rebelot/kanagawa.nvim",
        priority = colorscheme_priority,
        lazy = false,
        config = function()
            require("kanagawa")
        end
    },
}
