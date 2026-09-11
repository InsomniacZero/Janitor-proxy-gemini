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
LOG_DIR="${TMPDIR:-$PREFIX/tmp}"
if [ ! -d "$LOG_DIR" ] || [ ! -w "$LOG_DIR" ]; then
    LOG_DIR="$HOME/.gemini_logs"
    mkdir -p "$LOG_DIR"
fi
LOG_FILE="$LOG_DIR/gemini_server.log"
TUNNEL_LOG="$LOG_DIR/gemini_tunnel.log"

# Cleanup on exit (Ctrl+C)
cleanup() {
    echo ""
    echo -e "\033[1;33m[!] Stopping Gemini Server...\033[0m"
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

# Kill any previous instance lingering on the port
pkill -f "python3 gemini_web2api.py --port ${PORT}" 2>/dev/null || true
sleep 0.5

# Start Python Gemini server
python3 gemini_web2api.py --port ${PORT} > "$LOG_FILE" 2>&1 &
SERVER_PID=$!

sleep 1

# Verify local server is alive
if ! kill -0 $SERVER_PID 2>/dev/null; then
    echo -e "\033[1;31m[ERROR] Failed to start python server. Log:\033[0m"
    cat "$LOG_FILE"
    exit 1
fi

# Check if user requested a public tunnel with --tunnel flag
WANT_TUNNEL=false
for arg in "$@"; do
    if [ "$arg" == "--tunnel" ] || [ "$arg" == "-t" ]; then
        WANT_TUNNEL=true
    fi
done

if [ "$WANT_TUNNEL" = true ]; then
    echo -e "\033[1;36m[+] Starting public HTTPS tunnel (--tunnel requested)...\033[0m"
    rm -f "$TUNNEL_LOG"
    TUNNEL_URL=""
    
    # Try instant Pinggy SSL tunnel first (port 443 TCP, never blocked on mobile)
    ssh -p 443 -R 0:localhost:${PORT} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null a.pinggy.io > "$TUNNEL_LOG" 2>&1 &
    TUNNEL_PID=$!
    
    for i in {1..8}; do
        if [ -f "$TUNNEL_LOG" ]; then
            TUNNEL_URL=$(grep -o -E 'https://[-0-9a-z.]+\.(pinggy-free\.link|pinggy\.link|free\.pinggy\.net)' "$TUNNEL_LOG" | head -n 1)
            if [ -n "$TUNNEL_URL" ]; then
                break
            fi
        fi
        sleep 1
    done
    
    # If Pinggy timed out, try Cloudflare
    if [ -z "$TUNNEL_URL" ]; then
        kill "$TUNNEL_PID" 2>/dev/null
        cloudflared tunnel --url http://127.0.0.1:${PORT} --protocol http2 --edge-ip-version 4 > "$TUNNEL_LOG" 2>&1 &
        TUNNEL_PID=$!
        for i in {1..8}; do
            if [ -f "$TUNNEL_LOG" ]; then
                TUNNEL_URL=$(grep -o 'https://[-0-9a-z]*\.trycloudflare\.com' "$TUNNEL_LOG" | head -n 1)
                if [ -n "$TUNNEL_URL" ]; then
                    break
                fi
            fi
            sleep 1
        done
    fi
    
    if [ -n "$TUNNEL_URL" ]; then
        PROXY_URL="${TUNNEL_URL}/v1"
        MODE_INFO="Mode: Public HTTPS Tunnel"
    else
        echo -e "\033[1;33m[!] Tunnel timed out. Falling back to direct Localhost URL...\033[0m"
        PROXY_URL="http://127.0.0.1:${PORT}/v1"
        MODE_INFO="Mode: Direct Localhost (No internet lag)"
    fi
else
    # PURE LOCALHOST - Zero delay, starts in 0.5s!
    PROXY_URL="http://127.0.0.1:${PORT}/v1"
    MODE_INFO="Mode: Direct Localhost (100% Local, zero lag)"
fi

# Copy to clipboard on Termux if termux-api is installed
if command -v termux-clipboard-set >/dev/null 2>&1; then
    echo -n "$PROXY_URL" | termux-clipboard-set
    COPIED_NOTICE="✓ Auto-copied to your phone clipboard!"
else
    COPIED_NOTICE="(Copy the Proxy URL below into Janitor)"
fi

clear

# Display Clean Roleplay Banner
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
echo -e "\033[1;32m║\033[0m  \033[1;34m${MODE_INFO}\033[0m"
echo -e "\033[1;32m║\033[0m  \033[1;30mPress [Ctrl + C] to stop. Start anytime with: \033[1;33minsom\033[0m                 \033[1;32m║\033[0m"
echo -e "\033[1;32m╚═══════════════════════════════════════════════════════════════════╝\033[0m"
echo ""
echo -e "\033[1;34m[Live Logs - Chat requests will appear here]:\033[0m"

# Follow server log in foreground
tail -f "$LOG_FILE"
