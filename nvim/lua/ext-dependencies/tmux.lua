local env_utils = require("util.environments")

local M = {}

local function install_tmux()
    local cmd

    if env_utils.is_windows() then
        cmd = "choco install tmux -y"
    elseif env_utils.is_mac() then
        cmd = "brew install tmux"
    else
        vim.notify("Cannot find package manager to install tmux")
        return
    end

    vim.fn.system(cmd)
end

function M.ensure_tmux()
    if not env_utils.is_executable("tmux") then
        print("tmux not found! Installing now...")
        install_tmux()
    end
end

return M
