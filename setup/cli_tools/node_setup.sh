#!/usr/bin/env bash

set -euo pipefail

if command -v node >/dev/null 2>&1; then
  echo "Node.js is already installed: $(node -v)"
else
    echo "Downloading & installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

    # in lieu of restarting the shell
    \. "$HOME/.nvm/nvm.sh"

    echo "Downloading & installing Node..."
    nvm install 22

    node -v
    npm -v

    echo "Completed Node installation"
fi
