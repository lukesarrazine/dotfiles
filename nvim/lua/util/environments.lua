local M = {}

function M.is_windows()
    return vim.loop.os_uname().sysname:match("Windows") ~= nil
end

function M.is_mac()
    return vim.loop.os_uname().sysname == "Darwin"
end

function M.is_executable(name)
    return vim.fn.executable(name) == 1
end

return M
