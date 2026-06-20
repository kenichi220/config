#!/usr/bin/env bash
set -euo pipefail

NIRI_CONFIG_DIR="$HOME/.config/niri"

# Install niri
if ! command -v niri &>/dev/null; then
    echo "Installing niri..."
    sudo dnf copr enable -y yalter/niri
    sudo dnf install -y niri
else
    echo "niri already installed: $(niri --version)"
fi

# Copy config
mkdir -p "$NIRI_CONFIG_DIR"
cp config.kdl "$NIRI_CONFIG_DIR/config.kdl"

echo "Done. Config at $NIRI_CONFIG_DIR/config.kdl"
