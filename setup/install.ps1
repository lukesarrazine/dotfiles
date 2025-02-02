New-Item -ItemType SymbolicLink -Path $HOME/.config/nvim -Target $HOME/dotfiles/nvim -Force
New-Item -ItemType SymbolicLink -Path $HOME/.tmux.conf -Target $HOME/dotfiles/tmux/.tmux.conf -Force
Write-Output "init symlinks"

# run with "powershell -ExecutionPolicy Bypass -File ~/dotfiles/install.ps1" 
# make sure the .config/nvim directory doesn't exist before running this script
