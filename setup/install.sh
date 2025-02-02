#!/bin/bash
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
echo "init symlinks"

# Run with "bash ~/dotfiles/install.sh" 
# Make sure the .config/nvim directory doesn't exist before running this script
