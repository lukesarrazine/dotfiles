local env_utils = require("util.environments")

local M = {}

local function install_ripgrep()
    if env_utils.is_windows() then
        local ripgrep_url =
        "https://github.com/BurntSushi/ripgrep/releases/latest/download/ripgrep-x86_64-pc-windows-msvc.zip"
        local download_path = vim.fn.stdpath("data") .. "/ripgrep.zip"
        local install_path = vim.fn.stdpath("data") .. "/ripgrep"

        -- Download and extract Ripgrep
        vim.fn.system({ "curl", "-L", ripgrep_url, "-o", download_path })
        vim.fn.system({ "powershell", "Expand-Archive", "-Path", download_path, "-DestinationPath", install_path })

        -- Add Ripgrep to PATH
        vim.env.PATH = install_path .. ";" .. vim.env.PATH
    else
        local ripgrep_cmd = env_utils.is_mac() and "brew install ripgrep"
        vim.fn.system(ripgrep_cmd)
    end
end

function M.ensure_ripgrep()
    if not env_utils.is_executable("rg") then
        print("Ripgrep not found! Installing now...")
        install_ripgrep()
    end
end

return M
