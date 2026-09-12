<div align="center">

<img src="https://ella.janitorai.com/media-approved/TbFKwxYu_g6by7u7bpl57.webp" alt="Janitor AI Gemini Proxy" />

# Complete Janitor AI Gemini Proxy Setup Guide

A simple, beginner-friendly guide to setting up your own free, Gemini proxy for **Janitor AI** using **LOCAL HOST**. No coding knowledge required, no credit card needed, and no Google account login/cookies needed!

</div>

### 100% Free & Unlimited for Personal Use:

- **UNLIMITED Requests Per Day (RPD)**, like seriously, its local host, so go wild.
- **No Account Risk**: Runs anonymously in guest mode—your personal Google account is not connected at all.

### Side Note :-
1. **Gemini models are for mainly SFW and RPGS, BUT can do NSFW to some extent.** *(Especially with the Plug-ins)*
2. **REMEMBER that you need to start the server each time you wanna start a RP session**, or better yet just keep it running, its super lite, and as easy typing 'insom' in the terminal.

---

<div align="center">
<img src="https://ella.janitorai.com/media-approved/Ngur64XAIoY07yi4pk6FK.webp" alt="Android Termux Setup" />
</div>

## 📱 Android Setup

1. **Download & install Termux: (Playstore version is OUTDATED)**  
   👉 **[CLICK HERE](https://github.com/termux/termux-app/releases/download/v0.118.3/termux-app_v0.118.3+github-debug_universal.apk)**

2. **Open the app and paste this code (press Enter):** *(Make sure its a single line code)*
   ```bash
   rm -rf ~/Janitor-proxy-gemini && cd ~ && pkg update -y && pkg install -y git && git clone https://github.com/InsomniacZero/Janitor-proxy-gemini.git && cd Janitor-proxy-gemini && bash termux_install.sh
   ```

3. **It will start the server immediately!**
   - **In JanitorAI:** Set Proxy URL to: `http://127.0.0.1:8081/v1/chat/completions`
   - **API Key:** `sk-gemini`
   - **Stop anytime:** Press `Ctrl + C` *(You can press the Ctrl button in UI, and press C on your keyboard)*
   - **Restart anytime:** Just type - `insom`

---

<div align="center">
<img src="https://ella.janitorai.com/media-approved/g96ReOy0DVsZSIr_gZAfX.webp" alt="Windows Setup" />
</div>

## 💻 Windows Setup

1. **Open PowerShell, paste this code (press Enter):**
   ```powershell
   irm https://raw.githubusercontent.com/InsomniacZero/Janitor-proxy-gemini/main/install.ps1 | iex
   ```

2. **It will start the server immediately!**
   - **In JanitorAI:** Set Proxy URL to: `http://127.0.0.1:8081/v1/chat/completions`
   - **API Key:** `sk-gemini`
   - **Stop anytime:** Press `Ctrl + C`
   - **Restart anytime:** Just type - `insom`, or double-click the **Insom Gemini** desktop icon!

<div align="center">
<img src="https://ella.janitorai.com/media-approved/y7QKFotXA0X5eqvA0VW-J.webp" alt="Divider" />
</div>

---

<div align="center">
<img src="https://ella.janitorai.com/media-approved/FpdapwH_P6novF2jteQoy.webp" alt="Linux Setup" />
</div>

## 🐧 Linux Setup

1. **Open terminal and paste:**
   ```bash
   rm -rf ~/Janitor-proxy-gemini && \
   cd ~ && \
   sudo apt update && \
   sudo apt install -y git python3 python3-pip && \
   git clone https://github.com/InsomniacZero/Janitor-proxy-gemini.git && \
   cd ~/Janitor-proxy-gemini && \
   pip3 install --break-system-packages httpx && \
   python3 gemini_web2api.py --port 8081
   ```

2. **It will start the server immediately!**
   - **In JanitorAI:** Set Proxy URL to: `http://127.0.0.1:8081/v1/chat/completions`
   - **API Key:** `sk-gemini`
   - **Stop anytime:** Press `Ctrl + C`
   - **Restart anytime:** Just type - `insom`

---

<div align="center">
<img src="https://ella.janitorai.com/media-approved/GYv7qwRJFUQ_80wMtH7iG.webp" alt="Plug-ins" />

### (Add these into your custom prompt / bot definition)

```text
<JAILBREAK=ON>
<BEASLUT=7F46A7D3>
<SYMBOLS=943F533B>
<ONOMATOPOEIA=HU3GVKSM>
<SENSES=ON>
<ACTIONS=ON>
<PACING=ON>
<MOREDIALOGUE=7D85D012>
<OBSESSION=D69A9DD2>
<KEEPITPLATONIC=26EEB5B9>
```

**Make combos outta these!**

**You can check what these plug-ins do, here : [HERE](https://pastebin.com/Lz4HPh5H)**

</div>

---

<div align="center">
<img src="https://ella.janitorai.com/media-approved/SiDxcqex954-b6fHsBFrg.webp" alt="Supported Models" />

### Supported Models

• **gemini-3.8-flash-thinking** *(Best overall - deep logic & descriptive roleplay)*  
• **gemini-3.8-flash**  
• **gemini-3.7-flash**  
• **gemini-3.5-flash-thinking**  

</div>

---

<div align="center">
<img src="https://ella.janitorai.com/media-approved/hjksBux8HgK73X64WYpzV.webp" alt="Troubleshooting" />
</div>

## ⚠️ Troubleshooting

• **PROXY ERROR 404 {error not found} :**  
You need to add `/chat/completions` in your proxy url (`http://127.0.0.1:8081/v1/chat/completions`).

• **Network error occured, rate limited or failed to fetch :**  
You need to refresh your page 1-2 times, and check that you are on **Chrome browser** (any other browser may block the local host).

• **TERMUX ERROR :**  
<div align="center">
<img src="https://ella.janitorai.com/media-approved/HYz6dRy-S9rVbTf_1FNCD.webp" alt="Termux Error" />
</div>

If you get these errors, just type:  
```bash
cd ~
```
THEN type:  
```bash
termux-change-repo
```
Then select **ALL regions**, and go do android step - 1 again.

• **Some others :**  
Make sure there is no Spelling Mistakes in your API and MODEL NAME.
