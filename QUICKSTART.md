# Quick Start Guide 🚀

A quick reference for deploying the WhatsApp Auto-Reply Bot.

## 📋 Prerequisites

- Node.js v14+ (for all methods)
- Docker (for Docker method only)
- WhatsApp account
- Gemini API key from [Google AI Studio](https://makersuite.google.com/app/apikey)

## ⚡ Quick Setup (3 Steps)

### 1️⃣ Clone & Configure

```bash
git clone https://github.com/santanu-p/whatsapp-reply-bot.git
cd whatsapp-reply-bot
cp .env.example .env
nano .env  # Add your GEMINI_API_KEY
```

### 2️⃣ Choose Your Method

#### 🐳 **Docker** (Recommended for Production)
```bash
docker-compose up -d
docker-compose logs -f  # Scan QR code
```

#### ⚙️ **PM2** (Process Manager)
```bash
npm install -g pm2
npm install
pm2 start ecosystem.config.js
pm2 logs  # Scan QR code
```

#### 🔧 **Systemd** (Linux Service)
```bash
./deploy.sh  # Interactive setup
# Choose option 3 and follow prompts
```

#### 💻 **Direct Run** (Development/Testing)
```bash
npm install
npm start  # Scan QR code when it appears
```

### 3️⃣ Authenticate

When the QR code appears:
1. Open WhatsApp on your phone
2. Go to Settings → Linked Devices → Link a Device
3. Scan the QR code
4. Done! Bot will auto-reply in groups

## 📚 Full Documentation

- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Complete deployment guide
- **[README.md](README.md)** - Features & usage
- **[EXAMPLES.md](EXAMPLES.md)** - Bot conversation examples

## 🔧 Common Commands

### Docker
```bash
docker-compose up -d        # Start
docker-compose logs -f      # View logs
docker-compose down         # Stop
docker-compose restart      # Restart
```

### PM2
```bash
pm2 start ecosystem.config.js  # Start
pm2 logs whatsapp-bot          # View logs
pm2 restart whatsapp-bot       # Restart
pm2 stop whatsapp-bot          # Stop
pm2 monit                      # Monitor
```

### Systemd
```bash
sudo systemctl start whatsapp-bot     # Start
sudo journalctl -u whatsapp-bot -f    # View logs
sudo systemctl restart whatsapp-bot   # Restart
sudo systemctl stop whatsapp-bot      # Stop
```

## 🆘 Quick Troubleshooting

### QR Code Not Showing
- Check logs: `docker logs -f whatsapp-bot` or `pm2 logs`
- Ensure .env has valid GEMINI_API_KEY

### Bot Not Responding
- Verify bot is in the WhatsApp group
- Check it's not responding to your own messages (by design)
- View logs for errors

### Authentication Expired
- Restart the bot and re-scan QR code
- Ensure `.wwebjs_auth` folder is not deleted

## 🔗 Quick Links

- [Get Gemini API Key](https://makersuite.google.com/app/apikey)
- [Install Docker](https://docs.docker.com/get-docker/)
- [Install Node.js](https://nodejs.org/)
- [GitHub Issues](https://github.com/santanu-p/whatsapp-reply-bot/issues)

---

**Need help?** Check [DEPLOYMENT.md](DEPLOYMENT.md) for detailed instructions or open an issue on GitHub.
