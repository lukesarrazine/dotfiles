#!/bin/bash

# Determine OS type
OS_TYPE="$(uname -s)"

# Set TPM directory based on OS
if [[ "$OS_TYPE" == "Darwin" || "$OS_TYPE" == "Linux" ]]; then
    TPM_DIR="$HOME/.tmux/plugins/tpm"
elif [[ "$OS_TYPE" == "CYGWIN"* || "$OS_TYPE" == "MINGW"* || "$OS_TYPE" == "MSYS"* ]]; then
    TPM_DIR="$HOME/.tmux/plugins/tpm" # Should work in Git Bash or WSL
else
    echo "Unsupported OS: $OS_TYPE"
    exit 1
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    echo "Error: Git is not installed. Please install Git first."
    exit 1
fi

# Clone TPM if not installed
if [ ! -d "$TPM_DIR" ]; then
    echo "Cloning TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "TPM is already installed."
fi

# Reload tmux configuration if inside tmux
if [ -n "$TMUX" ]; then
    echo "Reloading tmux configuration..."
    tmux source ~/.tmux.conf
fi

# Install tmux plugins
echo "Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins"
