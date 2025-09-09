if [ "$(uname)" = "Linux" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$PATH:/opt/nvim/:$BUN_INSTALL/bin"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
