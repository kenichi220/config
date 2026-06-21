#!/usr/bin/env bash
set -euo pipefail

NOCTALIA_CONFIG="$HOME/.config/noctalia"
NIRI_CONFIG="$HOME/.config/niri"

# ── Terra repo + noctalia ──────────────────────────────────────────────────
if ! rpm -q noctalia-shell &>/dev/null; then
  echo "[+] Adding Terra repo..."
  sudo dnf install --nogpgcheck \
    --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' \
    terra-release -y

  echo "[+] Installing noctalia..."
  sudo dnf install -y noctalia-shell noctalia-qs
else
  echo "[✓] noctalia already installed: $(rpm -q noctalia-shell)"
fi

# ── niri ──────────────────────────────────────────────────────────────────
if ! command -v niri &>/dev/null; then
  echo "[+] Installing niri..."
  sudo dnf copr enable -y yalter/niri
  sudo dnf install -y niri
else
  echo "[✓] niri already installed: $(niri --version)"
fi

# ── noctalia config ───────────────────────────────────────────────────────
if [[ ! -d "./noctalia" ]]; then
  echo "[!] Pasta ./noctalia não encontrada. Rode o script da raiz do repo clonado."
  exit 1
fi

if [[ -d "$NOCTALIA_CONFIG" ]]; then
  BACKUP="$NOCTALIA_CONFIG.bak.$(date +%Y%m%d_%H%M%S)"
  echo "[~] Backup de config existente → $BACKUP"
  mv "$NOCTALIA_CONFIG" "$BACKUP"
fi

echo "[+] Movendo noctalia config → $NOCTALIA_CONFIG"
cp -r ./noctalia "$NOCTALIA_CONFIG"

# ── niri config (opcional) ────────────────────────────────────────────────
if [[ -d "./niri" ]]; then
  if [[ -d "$NIRI_CONFIG" ]]; then
    BACKUP="$NIRI_CONFIG.bak.$(date +%Y%m%d_%H%M%S)"
    echo "[~] Backup niri config → $BACKUP"
    mv "$NIRI_CONFIG" "$BACKUP"
  fi
  echo "[+] Movendo niri config → $NIRI_CONFIG"
  cp -r ./niri "$NIRI_CONFIG"
fi

echo ""
echo "[✓] Instalação concluída."
echo "    Reinicie o noctalia ou faça login para aplicar."
