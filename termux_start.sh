#!/usr/bin/env bash

# ==============================================================================
# Gemini Web2API - 1-Click Termux Launch Script for JanitorAI Roleplay
# ==============================================================================

# Ensure we operate in the script's directory regardless of where it's launched
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 1. Acquire Android Wake Lock (prevents Android OS from sleeping/killing the server)
if command -v termux-wake-lock >/dev/null 2>&1; then
    termux-wake-lock
fi

PORT=8081
LOG_FILE="/tmp/gemini_server.log"
TUNNEL_LOG="/tmp/gemini_tunnel.log"

# Cleanup on exit (Ctrl+C)
cleanup() {
    echo ""
    echo -e "\033[1;33m[!] Stopping Gemini Server and Tunnel...\033[0m"
    if [ -n "$SERVER_PID" ]; then
        kill "$SERVER_PID" 2>/dev/null
    fi
    if [ -n "$TUNNEL_PID" ]; then
        kill "$TUNNEL_PID" 2>/dev/null
    fi
    if command -v termux-wake-unlock >/dev/null 2>&1; then
        termux-wake-unlock
    fi
    echo -e "\033[1;32m[✓] Server stopped safely. Goodbye!\033[0m"
    exit 0
}
trap cleanup SIGINT SIGTERM EXIT

# 2. Check python & dependencies
if ! command -v python3 >/dev/null 2>&1; then
    echo -e "\033[1;33m[!] Python3 not found. Installing via pkg...\033[0m"
    pkg install -y python
fi

if ! python3 -c "import httpx" >/dev/null 2>&1; then
    echo -e "\033[1;33m[!] httpx not found. Installing via pip...\033[0m"
    pip install httpx 2>/dev/null || pip install --break-system-packages httpx
fi

echo -e "\033[1;36m[+] Starting local Gemini server on port ${PORT}...\033[0m"

# Start Python Gemini server
python3 gemini_web2api.py --port ${PORT} > "$LOG_FILE" 2>&1 &
SERVER_PID=$!

sleep 2

# Verify local server is alive
if ! kill -0 $SERVER_PID 2>/dev/null; then
    echo -e "\033[1;31m[ERROR] Failed to start python server. Log:\033[0m"
    cat "$LOG_FILE"
    exit 1
fi

echo -e "\033[1;36m[+] Starting secure HTTPS public tunnel for JanitorAI...\033[0m"

# 3. Check for cloudflared
if ! command -v cloudflared >/dev/null 2>&1; then
    echo -e "\033[1;33m[!] cloudflared not found. Attempting to install via pkg...\033[0m"
    pkg install -y cloudflared
fi

if ! command -v cloudflared >/dev/null 2>&1; then
    echo -e "\033[1;31m[ERROR] cloudflared could not be installed.\033[0m"
    echo -e "Please run: pkg install cloudflared"
    exit 1
fi

# 4. Start cloudflared quick tunnel
rm -f "$TUNNEL_LOG"
cloudflared tunnel --url http://127.0.0.1:${PORT} > "$TUNNEL_LOG" 2>&1 &
TUNNEL_PID=$!

echo -e "\033[1;33m[~] Generating your JanitorAI proxy link (takes ~5-10s)...\033[0m"

TUNNEL_URL=""
for i in {1..30}; do
    if [ -f "$TUNNEL_LOG" ]; then
        TUNNEL_URL=$(grep -o 'https://[-0-9a-z]*\.trycloudflare\.com' "$TUNNEL_LOG" | head -n 1)
        if [ -n "$TUNNEL_URL" ]; then
            break
        fi
    fi
    sleep 1
done

if [ -z "$TUNNEL_URL" ]; then
    echo -e "\033[1;31m[ERROR] Tunnel timed out. Check log below:\033[0m"
    cat "$TUNNEL_LOG"
    exit 1
fi

PROXY_URL="${TUNNEL_URL}/v1"

# Copy to clipboard on Termux if termux-api is installed
if command -v termux-clipboard-set >/dev/null 2>&1; then
    echo -n "$PROXY_URL" | termux-clipboard-set
    COPIED_NOTICE="✓ Auto-copied to your phone clipboard!"
else
    COPIED_NOTICE="(Select and copy the URL below)"
fi

clear

# 5. Display Clean Roleplay Banner
cat << "EOF"
  ____                _       _   __        __   _     ____    _    ____ ___ 
 / ___| ___ _ __ ___ (_)_ __ (_)  \ \      / /__| |__ |___ \  / \  |  _ \_ _|
| |  _ / _ \ '_ ` _ \| | '_ \| |   \ \ /\ / / _ \ '_ \  __) |/ _ \ | |_) | | 
| |_| |  __/ | | | | | | | | | |    \ V  V /  __/ |_) |/ __// ___ \|  __/| | 
 \____|\___|_| |_| |_|_|_| |_|_|     \_/\_/ \___|_.__/|_____/_/   \_\_|  |___|
EOF

echo -e "\033[1;32m╔═══════════════════════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1;32m║              ✨ SERVER IS LIVE & READY TO ROLEPLAY ✨             ║\033[0m"
echo -e "\033[1;32m╠═══════════════════════════════════════════════════════════════════╣\033[0m"
echo -e "\033[1;32m║\033[0m  \033[1;37m1. Open JanitorAI on your phone browser (Chrome/Safari)\033[0m          \033[1;32m║\033[0m"
echo -e "\033[1;32m║\033[0m  \033[1;37m2. Go to: ☰ API Settings -> Proxy\033[0m                                 \033[1;32m║\033[0m"
echo -e "\033[1;32m║\033[0m  \033[1;37m3. Set:\033[0m                                                           \033[1;32m║\033[0m"
echo -e "\033[1;32m║\033[0m     • \033[1;33mProxy URL:\033[0m  \033[1;36m${PROXY_URL}\033[0m"
echo -e "\033[1;32m║\033[0m     • \033[1;33mAPI Key:\033[0m    \033[1;37msk-gemini\033[0m                                        \033[1;32m║\033[0m"
echo -e "\033[1;32m║\033[0m     • \033[1;33mModel:\033[0m      \033[1;37mgemini-3.8-flash\033[0m  (or gemini-3.8-flash-thinking)  \033[1;32m║\033[0m"
echo -e "\033[1;32m╠═══════════════════════════════════════════════════════════════════╣\033[0m"
echo -e "\033[1;32m║\033[0m  \033[1;35m${COPIED_NOTICE}\033[0m"
echo -e "\033[1;32m║\033[0m  \033[1;30mPress [Ctrl + C] to stop. Start anytime with command: \033[1;33minsom\033[0m    \033[1;32m║\033[0m"
echo -e "\033[1;32m╚═══════════════════════════════════════════════════════════════════╝\033[0m"
echo ""
echo -e "\033[1;34m[Live Logs - Requests will appear here as Janitor chats]:\033[0m"

# Follow server log in foreground
tail -f "$LOG_FILE"
