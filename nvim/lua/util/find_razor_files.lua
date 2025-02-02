local M = {}

M.razor_cache = {}

function M.has_razor_files_cached(root_dir)
    if M.razor_cache[root_dir] ~= nil then
        return M.razor_cache[root_dir]
    end

    local found = M.has_razor_files(root_dir)
    M.razor_cache[root_dir] = found
    return found
end

function M.has_razor_files(root_dir)
    local handle = vim.loop.fs_scandir(root_dir)
    if not handle then return false end

    while true do
        local name, t = vim.loop.fs_scandir_next(handle)
        if not name then break end

        local full_path = root_dir .. '/' .. name

        if t == "file" and name:match("%.razor$") then
            return true
        elseif t == "directory" then
            -- Recursively check subdirectories
            if M.has_razor_files(full_path) then
                return true
            end
        end
    end

    return false
end

return M
