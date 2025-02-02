-- automate loading all core modules
local core_path = vim.fn.stdpath("config") .. "/lua/core/"
for _, file in ipairs(vim.fn.globpath(core_path, "*.lua", false, true)) do
    local module = file:match("([^/]+)%.lua$")
    if module and module ~= "init" then
        local ok, err = pcall(require, "core." .. module)
        if not ok then
            vim.notify("Error loading core." .. module .. ": " .. err, vim.log.levels.ERROR)
        end
    end
end
