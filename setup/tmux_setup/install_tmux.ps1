# Set TPM directory
$TPM_DIR = "$HOME\.tmux\plugins\tpm"

# Check if Git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Git is not installed. Please install Git first." -ForegroundColor Red
    exit 1
}

# Clone TPM if not installed
if (-not (Test-Path $TPM_DIR)) {
    Write-Host "Cloning TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm $TPM_DIR
} else {
    Write-Host "TPM is already installed."
}

# Reload tmux configuration (only applicable if running inside WSL/Git Bash)
Write-Host "Ensure tmux is running, then press Prefix + I to install plugins."
