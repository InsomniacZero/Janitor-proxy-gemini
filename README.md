# 🎭 Janitor-proxy-gemini (Termux Android)

A lightweight, zero-configuration local reverse-proxy for **JanitorAI** roleplay powered by Google Gemini, running directly on your Android phone via **Termux**.

---

### ✨ Features
- **Zero Cookies & Zero Logins:** Works via Pure Guest Mode from your phone's real IP (no Cloudflare bot bans or Google captcha).
- **One-Command Daily Launch:** Just type `insom` in Termux to start chatting.
- **Auto-Clipboard:** Automatically generates and copies your JanitorAI proxy URL to your phone clipboard.
- **Background Wake-Lock:** Automatically keeps Android from putting the server to sleep while you chat in Chrome/browser.
- **Free Cloudflare Tunnel:** Generates a secure HTTPS link for JanitorAI without requiring any account or port forwarding.

---

## 📱 Quick Setup Guide (One-Time)

### 1. Install Termux
> ⚠️ **IMPORTANT:** Do **NOT** install Termux from the Google Play Store (it is outdated and cannot install packages).
> 
> Download the official Termux APK from **[F-Droid](https://f-droid.org/packages/com.termux/)** (scroll down to "Download APK") or **[GitHub Releases](https://github.com/termux/termux-app/releases/latest)**.

### 2. Run the 1-Line Installer
Open **Termux** on your phone, paste this single command, and press **Enter**:

```bash
rm -rf ~/Janitor-proxy-gemini && cd ~ && pkg update -y && pkg install -y git && git clone https://github.com/InsomniacZero/Janitor-proxy-gemini.git && cd Janitor-proxy-gemini && bash termux_install.sh
```

The installer will:
1. Install Python, Cloudflare Tunnel, and Termux tools.
2. Install dependencies (`httpx`).
3. Set up the shortcut keyword **`insom`**.

---

## 🚀 Daily Use (Starting the Server)

Whenever you want to roleplay:

1. Open **Termux**.
2. Type:
   ```bash
   insom
   ```
   and press **Enter**.
3. You will see a banner with your proxy URL. The link is **already copied to your clipboard**!
4. Go to **JanitorAI** in your browser:
   - **API Type:** `OpenAI` / `Proxy`
   - **Proxy URL:** `https://your-tunnel.trycloudflare.com/v1` *(paste from clipboard)*
   - **API Key:** `sk-gemini` *(or any text)*
   - **Model:** `gemini-3.8-flash` or `gemini-3.8-flash-thinking`
5. Save settings and start chatting!

---

## 🛑 Stopping the Server
When you're finished chatting, switch back to Termux and press **`Ctrl` + `C`**.
This stops the background server and releases the battery lock.

---

## ⚙️ Supported Models
| Model Name | Description |
| :--- | :--- |
| `gemini-3.8-flash` | Ultra-fast, responsive roleplay *(Default)* |
| `gemini-3.8-flash-thinking` | Deep reasoning & detailed responses |
| `gemini-3.7-flash` | High-quality standard generation |
| `gemini-3.1-pro` | Creative long-form writing |
