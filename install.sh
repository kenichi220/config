#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

run() {
    echo "==> $1"
    bash "$REPO_DIR/$2"
}

run "fonts"          zsh-cfg/install_fonts.sh
run "zsh"            zsh-cfg/install_zsh.sh
run "nvim"           nvim-cfg/nvim.sh
run "kitty"          kitty-cfg/kitty.sh
run "niri"           niri-cfg/niri.sh
run "noctalia"       noctalia-cfg/install-noctalia.sh

echo "==> done"
