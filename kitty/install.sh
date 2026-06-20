#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KITTY_CONF_DIR="$HOME/.config/kitty"

log() { printf '[install] %s\n' "$*"; }
die() { printf '[ERROR] %s\n' "$*" >&2; exit 1; }

# --- Kitty install ---
if command -v kitty &>/dev/null; then
    log "kitty already installed: $(kitty --version)"
else
    log "Installing kitty..."
    if command -v dnf &>/dev/null; then
        sudo dnf install -y kitty
    elif command -v apt &>/dev/null; then
        sudo apt install -y kitty
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm kitty
    else
        log "No known package manager found. Using official installer..."
        curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
    fi
fi

# --- Config dir ---
mkdir -p "$KITTY_CONF_DIR"

# --- Copy kitty.conf ---
if [[ -f "$SCRIPT_DIR/kitty.conf" ]]; then
    log "Copying kitty.conf..."
    cp "$SCRIPT_DIR/kitty.conf" "$KITTY_CONF_DIR/kitty.conf"
else
    die "kitty.conf not found in $SCRIPT_DIR"
fi

# --- Copy themes ---
if [[ -d "$SCRIPT_DIR/kitty-themes" ]]; then
    log "Copying kitty-themes/..."
    cp -r "$SCRIPT_DIR/kitty-themes" "$KITTY_CONF_DIR/kitty-themes"
else
    die "kitty-themes/ not found in $SCRIPT_DIR"
fi

log "Done. Config at $KITTY_CONF_DIR"
