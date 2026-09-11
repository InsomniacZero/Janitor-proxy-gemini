#!/usr/bin/env bash

# ==============================================================================
# Gemini Web2API - 1-Click Termux Installer for JanitorAI Roleplay
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "\033[1;36m[+] Setting up Gemini Web2API on Android Termux...\033[0m"

# 1. Update Termux packages & install dependencies
echo -e "\033[1;33m[1/3] Installing Python...\033[0m"
pkg update -y || apt-get update -y
pkg install -y python || apt-get install -y python

# 2. Install Python dependencies
echo -e "\033[1;33m[2/3] Installing Python httpx library...\033[0m"
pip install httpx 2>/dev/null || pip install --break-system-packages httpx

# 3. Make scripts executable & create shortcut
chmod +x "$SCRIPT_DIR/termux_start.sh"
echo -e "\033[1;33m[3/3] Creating shortcut command 'insom'...\033[0m"
if [ -d "$PREFIX/bin" ]; then
    ln -sf "$SCRIPT_DIR/termux_start.sh" "$PREFIX/bin/insom"
    chmod +x "$PREFIX/bin/insom"
fi

# Also add alias to ~/.bashrc for seamless usage
if ! grep -q "alias insom=" "$HOME/.bashrc" 2>/dev/null; then
    echo "alias insom='$SCRIPT_DIR/termux_start.sh'" >> "$HOME/.bashrc"
fi

echo ""
echo -e "\033[1;32m═══════════════════════════════════════════════════════════════════\033[0m"
echo -e "\033[1;32m   🎉 INSTALLATION COMPLETE! YOU'RE READY TO ROLEPLAY! 🎉       \033[0m"
echo -e "\033[1;32m═══════════════════════════════════════════════════════════════════\033[0m"
echo -e "\033[1;37mFrom now on, whenever you want to start the server, just type:\033[0m"
echo ""
echo -e "      \033[1;33minsom\033[0m"
echo ""
echo -e "\033[1;37mand press Enter!\033[0m"
echo -e "\033[1;32m═══════════════════════════════════════════════════════════════════\033[0m"
echo ""
read -p "Would you like to start the server right now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    exec "$SCRIPT_DIR/termux_start.sh"
fi
