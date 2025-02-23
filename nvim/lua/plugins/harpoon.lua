return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope.nvim',
    },
    config = function()
        local harpoon = require('harpoon')
        local map = vim.keymap.set

        harpoon.setup()
        map("n", "<leader>a", function() harpoon:list():add() end, {})

        -- Telescope UI
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local finder = function()
                local paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(paths, item.value)
                end

                return require("telescope.finders").new_table({
                    results = paths,
                })
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = finder(),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr, map_harpoon)
                    map_harpoon("i", "<C-a>", function()
                        local state = require("telescope.actions.state")
                        local selected_entry = state.get_selected_entry()
                        local current_picker = state.get_current_picker(prompt_bufnr)

                        table.remove(harpoon_files.items, selected_entry.index)
                        current_picker:refresh(finder(), { reset_prompt = false })
                    end)
                    return true
                end,
            }):find()
        end

        map("n", "<leader>h", function() toggle_telescope(harpoon:list()) end,
            { desc = "Open harpoon window" })
    end
}
