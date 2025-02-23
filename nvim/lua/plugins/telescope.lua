return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "ThePrimeagen/harpoon",
    },
    config = function()
        require("ext-dependencies.ripgrep").ensure_ripgrep()

        local telescope = require("telescope")
        local conf = require("telescope.config")
        local builtin = require("telescope.builtin")
        local harpoon = require("harpoon")

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                    },
                },
                layout_config = {
                    height = 0.45,
                    width = 0.7,
                    prompt_position = "bottom",
                    preview_cutoff = 120,
                },
                file_ignore_patterns = {
                    "target/",
                    "bin/",
                    "obj/",
                    "node_modules/",
                    '%__virtual.cs$'
                },
            },
        })

        local function find_files_with_harpoon()
            local function get_finder()
                local harpoon_list = harpoon:list()
                local harpoon_set = {}

                for _, item in ipairs(harpoon_list.items) do
                    harpoon_set[item.value] = true
                end

                return require("telescope.finders").new_table({
                    results = vim.fn.systemlist("rg --files"), --use ripgrep
                    entry_maker = function(entry)
                        local filename = vim.fn.fnamemodify(entry, ":p") -- Get absolute path
                        local icon = harpoon_set[entry] and "⭐ " or "  " -- Harpoon marker

                        return {
                            value = entry,
                            display = icon .. entry, -- Add icon dynamically
                            ordinal = entry,
                            path = filename,
                        }
                    end
                })
            end

            -- Invoke Telescope with the custom finder
            require("telescope.pickers").new({}, {
                prompt_title = "Find Files",
                finder = get_finder(),
                sorter = require("telescope.config").values.generic_sorter({}),
                attach_mappings = function(prompt_bufnr, map)
                    map("i", "<C-a>", function()
                        local state = require("telescope.actions.state")
                        local entry = state.get_selected_entry()
                        local current_picker = state.get_current_picker(prompt_bufnr)

                        if entry and entry.value then
                            harpoon:list():add({ value = entry.value, context = { col = 0, row = 1 } })
                            vim.notify("Added to Harpoon: " .. entry.value, vim.log.levels.INFO)

                            entry.display = entry.display .. "⭐ "
                            current_picker:refresh(current_picker.finder, { reset_prompt = false })
                        else
                            vim.notify("Invalid file selection", vim.log.levels.ERROR)
                        end
                    end)
                    return true
                end,
            }):find()
        end

        -- Keymaps
        vim.keymap.set("n", "<leader>ff", find_files_with_harpoon, { desc = "Find Files (Harpoon Highlighted)" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help Tags" })
    end,
}
