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
        local marked_icon = "⭐"

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

        local function get_harpoon_items()
            local harpoon_list = harpoon:list()
            local harpoon_set = {}

            for _, item in ipairs(harpoon_list.items) do
                harpoon_set[item.value] = true
            end

            return harpoon_set
        end

        local function map_harpoon_item(prompt_bufnr, map)
            map("i", "<C-a>", function()
                vim.notify("Adding", vim.log.levels.INFO)
                local state = require("telescope.actions.state")
                local entry = state.get_selected_entry()
                local current_picker = state.get_current_picker(prompt_bufnr)

                local current_row = current_picker:get_selection_row()

                if entry and entry.value then
                    harpoon:list():add({ value = entry.value, context = { col = 0, row = 1 } })
                    vim.notify("Added to Harpoon: " .. entry.value, vim.log.levels.INFO)

                    current_picker:refresh(current_picker.finder, {
                        reset_prompt = false,
                    })

                    vim.defer_fn(function()
                        current_picker:set_selection(current_row)
                    end, 10)
                else
                    vim.notify("Invalid file selection", vim.log.levels.ERROR)
                end
            end)
            return true
        end

        local function find_files_with_harpoon()
            local function get_finder()
                return require("telescope.finders").new_table({
                    --use ripgrep
                    results = vim.fn.systemlist("rg --files"),
                    entry_maker = function(entry)
                        local filename = vim.fn.fnamemodify(entry, ":p")

                        return {
                            value = entry,
                            display = function()
                                local harpoon_set = get_harpoon_items()
                                local icon = harpoon_set[entry] and (marked_icon .. " ") or ""
                                return icon .. entry
                            end,
                            ordinal = entry,
                            path = filename,
                        }
                    end
                })
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Find Files",
                finder = get_finder(),
                sorter = conf.values.generic_sorter({}),
                previewer = conf.values.file_previewer({}),
                attach_mappings = map_harpoon_item
            }):find()
        end

        local function find_grep_with_harpoon()
            local function get_finder()
                return require("telescope.finders").new_job(
                    function(prompt)
                        if not prompt or prompt == "" then
                            return nil
                        end
                        return { "rg", "--vimgrep", "--smart-case", prompt }
                    end,
                    function(entry)
                        local filename, lnum, col, text = entry:match("([^:]+):(%d+):(%d+):(.*)")
                        if not filename then return nil end

                        return {
                            value = filename,
                            display = function()
                                local harpoon_set = get_harpoon_items()
                                local icon = harpoon_set[filename] and (marked_icon .. " ") or ""
                                return icon .. filename .. ":" .. lnum .. ":" .. col .. " " .. text
                            end,
                            ordinal = filename .. text,
                            path = filename,
                            lnum = tonumber(lnum),
                            col = tonumber(col),
                        }
                    end
                )
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Live Grep",
                finder = get_finder(),
                sorter = conf.values.generic_sorter({}),
                previewer = conf.values.grep_previewer({}),
                attach_mappings = map_harpoon_item
            }):find()
        end

        -- Keymaps
        vim.keymap.set("n", "<leader>ff", find_files_with_harpoon, { desc = "Find Files (Harpoon Highlighted)" })
        vim.keymap.set("n", "<leader>fg", find_grep_with_harpoon, { desc = "Live Grep (Harpoon Highlighted)" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
        vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find Help Tags" })
    end,
}
