#!/usr/bin/env bash

set -euo pipefail

if command -v rg >/dev/null 2>&1; then
  echo "ripgrep is already installed: $(rg --version)"
else
    echo "Downloading & installing ripgrep..."
    sudo apt update
    sudo apt install ripgrep
    echo "Completed ripgrep installation"
    case "$(uname -s)" in
        Darwin)
            brew install ripgrep
        ;;

        Linux)
            sudo apt update
            sudo apt install ripgrep
        ;;

        *)
            echo "Unsupported OS: $(uname -s)"
            exit 1
            ;;
    esac
fi
