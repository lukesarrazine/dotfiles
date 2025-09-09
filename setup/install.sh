#!/bin/bash
echo "init symlinks"
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.bashrc ~/.bashrc
echo "symlinks completed"

bash ./tmux_setup/install_tmux.sh
bash ./cli_tools/node_setup.sh
bash ./cli_tools/bun_setup.sh
bash ./cli_tools/ripgrep_setup.sh

# Run with "bash ~/dotfiles/install.sh" 
# Make sure the .config/nvim directory doesn't exist before running this script
