if [ "$(uname)" = "Linux" ]; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$PATH:/opt/nvim/:$BUN_INSTALL/bin"
fi
