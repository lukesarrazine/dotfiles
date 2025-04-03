#!/bin/bash
echo "init symlinks"
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
echo "symlinks completed"

echo "init tpm"
bash ./tmux_setup/install_tmux.sh
echo "tpm completed"

# Run with "bash ~/dotfiles/install.sh" 
# Make sure the .config/nvim directory doesn't exist before running this script
