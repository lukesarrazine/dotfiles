local M = {
    current_day_index = 1,
    day_colorschemes = {
        "everforest-hard",
        "everforest-soft",
        "kanagawa-lotus",
    },

    current_night_index = 1,
    night_colorschemes = {
        "nightfox",
        "tokyonight-moon",
        "everforest-hard",
        "everforest-soft",
        "bamboo",
        "kanagawa-dragon",
        'OceanicNext',
        'nord',
        'miasma'
    },

    special_colorschemes = {
        ["12-25"] = "everforest", -- Christmas (Dec 25)
    }
}

local time_utils = require("util.time")
local environment_utils = require("util.environments")
local colorscheme_change_seconds = 1000 * 60 * 60; -- milliseconds * seconds * minutes
math.randomseed(os.time())                         -- seed randomness

M.set_colorscheme = function()
    local is_daytime = time_utils.is_daytime()
    local selected_colorcheme

    if is_daytime then
        selected_colorcheme = M.day_colorschemes[M.current_day_index]

        if M.current_day_index == #M.day_colorschemes then
            M.current_day_index = 1
        else
            M.current_day_index = M.current_day_index + 1
        end
    else
        selected_colorcheme = M.night_colorschemes[M.current_night_index]

        if M.current_night_index == #M.night_colorschemes then
            M.current_night_index = 1
        else
            M.current_night_index = M.current_night_index + 1
        end
    end

    --if is_daytime then
    --   vim.opt.background = "light"
    --else
    --   vim.opt.background = "dark"
    --end

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

M.setup_default = function()
    vim.cmd("colorscheme " .. "OceanicNext")
end

return {
    {
        -- Default colorscheme
        "mhartington/oceanic-next",
        lazy = false,
        priority = 1000,
        config = M.setup_default, -- Call setup
    },
    {
        "EdenEast/nightfox.nvim",
        event = "VeryLazy",
    },
    {
        "folke/tokyonight.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "shaunsingh/nord.nvim",
    },
    {
        "navarasu/onedark.nvim",
        event = "VeryLazy",
        config = function()
            require('onedark').setup {
                style = "darker",
                transparent = false,
            }
        end
    },
    {
        "ribru17/bamboo.nvim",
        event = "VeryLazy",
        config = function()
            require("bamboo").setup({})
        end,
    },
    {
        "sainnhe/everforest",
        event = "VeryLazy",
        config = function()
            vim.g.everforest_enable_italic = false
        end,
    },
    {
        "xero/miasma.nvim",
        event = "VeryLazy",
    },
    {
        "rebelot/kanagawa.nvim",
        event = "VeryLazy",
        config = function()
            require("kanagawa")
        end
    },
}
