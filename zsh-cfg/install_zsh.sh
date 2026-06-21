#!/usr/bin/env bash
set -euo pipefail

THEME_SRC="$(cd "$(dirname "$0")" && pwd)/ultima.zsh-theme"
ZSHRC_SRC="$(cd "$(dirname "$0")/.." && pwd)/.zshrc"

echo "==> Installing zsh..."
if command -v dnf &>/dev/null; then
    sudo dnf install -y zsh
elif command -v apt-get &>/dev/null; then
    sudo apt-get install -y zsh
elif command -v pacman &>/dev/null; then
    sudo pacman -S --noconfirm zsh
else
    echo "ERROR: no supported package manager found (dnf/apt/pacman)" >&2
    exit 1
fi

echo "==> Installing oh-my-zsh..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "    oh-my-zsh already installed, skipping"
else
    RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "==> Copying ultima theme..."
cp "$THEME_SRC" "$HOME/.oh-my-zsh/themes/ultima.zsh-theme"

if [ -f "$ZSHRC_SRC" ]; then
    echo "==> Copying .zshrc..."
    cp "$ZSHRC_SRC" "$HOME/.zshrc"
else
    echo "    WARN: $ZSHRC_SRC not found, skipping .zshrc copy"
fi

echo "==> Done."
