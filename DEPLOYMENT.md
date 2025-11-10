# Deployment Guide 🚀

This guide provides detailed instructions for deploying and running the WhatsApp Auto-Reply Bot in various production environments.

## Table of Contents

- [Quick Start (Local Development)](#quick-start-local-development)
- [Production Deployment Options](#production-deployment-options)
  - [Docker Deployment](#docker-deployment)
  - [VPS/Cloud Server Deployment](#vpscloud-server-deployment)
  - [Process Manager (PM2)](#process-manager-pm2)
  - [Systemd Service (Linux)](#systemd-service-linux)
- [Cloud Platform Deployments](#cloud-platform-deployments)
  - [AWS EC2](#aws-ec2)
  - [DigitalOcean Droplet](#digitalocean-droplet)
  - [Google Cloud Platform](#google-cloud-platform)
  - [Heroku](#heroku)
- [Troubleshooting Deployment Issues](#troubleshooting-deployment-issues)
- [Security Best Practices](#security-best-practices)

---

## Quick Start (Local Development)

For local development and testing, see the [main README.md](README.md) for installation instructions.

---

## Production Deployment Options

### Docker Deployment

Docker provides the easiest way to deploy the bot with all dependencies packaged together.

#### Prerequisites
- Docker installed on your system ([Install Docker](https://docs.docker.com/get-docker/))
- Docker Compose (optional, but recommended)

#### Option 1: Using Docker Compose (Recommended)

1. **Clone the repository**:
   ```bash
   git clone https://github.com/santanu-p/whatsapp-reply-bot.git
   cd whatsapp-reply-bot
   ```

2. **Create environment file**:
   ```bash
   cp .env.example .env
   nano .env  # Add your GEMINI_API_KEY
   ```

3. **Start with Docker Compose**:
   ```bash
   docker-compose up -d
   ```

4. **View logs and scan QR code**:
   ```bash
   docker-compose logs -f
   ```
   Scan the QR code with WhatsApp when it appears.

5. **Stop the bot**:
   ```bash
   docker-compose down
   ```

#### Option 2: Using Docker directly

1. **Build the Docker image**:
   ```bash
   docker build -t whatsapp-reply-bot .
   ```

2. **Run the container**:
   ```bash
   docker run -d \
     --name whatsapp-bot \
     --env-file .env \
     -v $(pwd)/.wwebjs_auth:/app/.wwebjs_auth \
     --restart unless-stopped \
     whatsapp-reply-bot
   ```

3. **View logs**:
   ```bash
   docker logs -f whatsapp-bot
   ```

4. **Stop the container**:
   ```bash
   docker stop whatsapp-bot
   docker rm whatsapp-bot
   ```

---

### VPS/Cloud Server Deployment

Deploy on any Linux VPS (Ubuntu, Debian, CentOS, etc.).

#### Prerequisites
- Linux server with root/sudo access
- Node.js v14 or higher
- npm or yarn
- Screen or tmux (optional, for session management)

#### Installation Steps

1. **Update system packages**:
   ```bash
   sudo apt update && sudo apt upgrade -y  # Ubuntu/Debian
   # OR
   sudo yum update -y  # CentOS/RHEL
   ```

2. **Install Node.js** (if not installed):
   ```bash
   # Ubuntu/Debian
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt-get install -y nodejs

   # CentOS/RHEL
   curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
   sudo yum install -y nodejs
   ```

3. **Clone and setup the bot**:
   ```bash
   cd /opt
   sudo git clone https://github.com/santanu-p/whatsapp-reply-bot.git
   cd whatsapp-reply-bot
   sudo npm install --production
   ```

4. **Configure environment**:
   ```bash
   sudo cp .env.example .env
   sudo nano .env  # Add your GEMINI_API_KEY
   ```

5. **Set permissions**:
   ```bash
   sudo chown -R $USER:$USER /opt/whatsapp-reply-bot
   ```

6. **Run the bot** (temporary, for QR scanning):
   ```bash
   npm start
   ```
   Scan the QR code with WhatsApp, then press `Ctrl+C` to stop.

7. **Set up as a service** (see [Systemd Service](#systemd-service-linux) or [PM2](#process-manager-pm2) sections below).

---

### Process Manager (PM2)

PM2 is a production-grade process manager for Node.js applications.

#### Installation

1. **Install PM2 globally**:
   ```bash
   sudo npm install -g pm2
   ```

2. **Start the bot with PM2**:
   ```bash
   cd /opt/whatsapp-reply-bot
   pm2 start index.js --name whatsapp-bot
   ```

   Or use the ecosystem file:
   ```bash
   pm2 start ecosystem.config.js
   ```

3. **View logs**:
   ```bash
   pm2 logs whatsapp-bot
   ```

4. **Monitor the bot**:
   ```bash
   pm2 monit
   ```

5. **Setup PM2 to start on boot**:
   ```bash
   pm2 startup
   pm2 save
   ```

6. **Common PM2 commands**:
   ```bash
   pm2 status              # View status
   pm2 restart whatsapp-bot  # Restart bot
   pm2 stop whatsapp-bot     # Stop bot
   pm2 delete whatsapp-bot   # Remove from PM2
   pm2 logs whatsapp-bot     # View logs
   ```

---

### Systemd Service (Linux)

Run the bot as a systemd service on Linux systems.

#### Setup

1. **Copy the service file**:
   ```bash
   sudo cp whatsapp-bot.service /etc/systemd/system/
   ```

2. **Edit the service file** (if needed):
   ```bash
   sudo nano /etc/systemd/system/whatsapp-bot.service
   ```
   Update the `User`, `WorkingDirectory`, and `ExecStart` paths as needed.

3. **Reload systemd**:
   ```bash
   sudo systemctl daemon-reload
   ```

4. **Enable and start the service**:
   ```bash
   sudo systemctl enable whatsapp-bot
   sudo systemctl start whatsapp-bot
   ```

5. **Check status**:
   ```bash
   sudo systemctl status whatsapp-bot
   ```

6. **View logs**:
   ```bash
   sudo journalctl -u whatsapp-bot -f
   ```

7. **Common commands**:
   ```bash
   sudo systemctl restart whatsapp-bot  # Restart
   sudo systemctl stop whatsapp-bot     # Stop
   sudo systemctl disable whatsapp-bot  # Disable auto-start
   ```

---

## Cloud Platform Deployments

### AWS EC2

1. **Launch EC2 instance**:
   - Choose Ubuntu 22.04 LTS or Amazon Linux 2
   - Instance type: t2.micro or larger
   - Configure security group (no inbound ports needed)
   - Add key pair for SSH access

2. **Connect to instance**:
   ```bash
   ssh -i your-key.pem ubuntu@your-ec2-ip
   ```

3. **Follow VPS deployment steps** above.

4. **Optional: Use AWS Systems Manager Session Manager** for connection without SSH.

### DigitalOcean Droplet

1. **Create droplet**:
   - Choose Ubuntu 22.04 LTS
   - Basic plan (1GB RAM minimum recommended)
   - Add SSH key

2. **Connect to droplet**:
   ```bash
   ssh root@your-droplet-ip
   ```

3. **Follow VPS deployment steps** above.

### Google Cloud Platform

1. **Create Compute Engine VM**:
   - Machine type: e2-micro or larger
   - Boot disk: Ubuntu 22.04 LTS
   - Allow HTTP/HTTPS if needed

2. **Connect via SSH** (use browser SSH or gcloud CLI)

3. **Follow VPS deployment steps** above.

### Heroku

**Note**: Heroku's ephemeral filesystem means you'll lose WhatsApp session on restart. Not recommended for production, but works for testing.

1. **Create Heroku app**:
   ```bash
   heroku create your-app-name
   ```

2. **Set environment variables**:
   ```bash
   heroku config:set GEMINI_API_KEY=your_api_key
   heroku config:set BOT_NAME="WhatsApp Bot"
   heroku config:set AUTO_REPLY_ENABLED=true
   ```

3. **Add Procfile**:
   ```
   web: node index.js
   ```

4. **Deploy**:
   ```bash
   git push heroku main
   ```

5. **View logs**:
   ```bash
   heroku logs --tail
   ```

**Important**: You'll need to re-authenticate with WhatsApp after each dyno restart.

---

## Troubleshooting Deployment Issues

### QR Code Not Displaying

**Problem**: QR code doesn't appear in production.

**Solutions**:
- Ensure you're viewing the correct logs
- Check if the process has proper permissions
- For Docker: Use `docker logs -f container-name`
- For PM2: Use `pm2 logs whatsapp-bot`
- For systemd: Use `journalctl -u whatsapp-bot -f`

### Authentication Expires

**Problem**: Bot keeps asking for QR code.

**Solutions**:
- Ensure `.wwebjs_auth` directory is persisted
- Check directory permissions
- For Docker: Verify volume mount is working
- Don't delete `.wwebjs_auth` folder after authentication

### High Memory Usage

**Problem**: Bot consuming too much RAM.

**Solutions**:
- Use at least 512MB RAM for the server
- Monitor with `pm2 monit` or `docker stats`
- Consider restarting bot periodically (e.g., daily)
- Limit number of groups the bot is active in

### Connection Issues

**Problem**: Bot can't connect to WhatsApp.

**Solutions**:
- Ensure server has internet connectivity
- Check if WhatsApp Web is accessible from your server's IP
- Verify firewall isn't blocking outbound connections
- Try using a different network/VPS provider

### Chromium/Puppeteer Issues

**Problem**: Puppeteer/Chromium fails to launch.

**Solutions**:
- For Ubuntu/Debian, install dependencies:
  ```bash
  sudo apt-get install -y \
    gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 \
    libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 \
    libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 \
    libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 \
    libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 \
    libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates \
    fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget
  ```
- For Docker: The Dockerfile includes these dependencies

---

## Security Best Practices

### Environment Variables

- **Never commit** `.env` file to version control
- Use environment variable management tools
- Rotate API keys regularly
- Use different API keys for development and production

### Server Security

1. **Use firewall**:
   ```bash
   sudo ufw enable
   sudo ufw allow 22/tcp  # SSH only
   ```

2. **Keep system updated**:
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

3. **Use SSH keys** instead of passwords

4. **Limit sudo access**

5. **Monitor logs** regularly:
   ```bash
   pm2 logs
   # or
   sudo journalctl -u whatsapp-bot -f
   ```

### Application Security

- Keep dependencies updated: `npm audit fix`
- Don't run as root user
- Set appropriate file permissions
- Monitor for unusual activity
- Implement rate limiting if needed
- Review group permissions regularly

### WhatsApp Account Safety

- Use a dedicated WhatsApp account (not personal)
- Comply with WhatsApp Terms of Service
- Don't spam or send unsolicited messages
- Inform group members about bot presence
- Respect privacy and data protection laws

---

## Running as Different User

It's recommended to run the bot as a non-root user:

```bash
# Create dedicated user
sudo useradd -m -s /bin/bash whatsappbot

# Move bot to user's home
sudo mkdir -p /home/whatsappbot/bot
sudo cp -r /opt/whatsapp-reply-bot/* /home/whatsappbot/bot/
sudo chown -R whatsappbot:whatsappbot /home/whatsappbot/bot

# Switch to user and run
sudo -u whatsappbot bash
cd /home/whatsappbot/bot
npm start
```

---

## Backup and Recovery

### Backup Session Data

```bash
# Backup WhatsApp session
tar -czf whatsapp-session-$(date +%Y%m%d).tar.gz .wwebjs_auth/

# Restore session
tar -xzf whatsapp-session-YYYYMMDD.tar.gz
```

### Automated Backups

Add to crontab for daily backups:
```bash
0 2 * * * cd /opt/whatsapp-reply-bot && tar -czf /backup/whatsapp-session-$(date +\%Y\%m\%d).tar.gz .wwebjs_auth/
```

---

## Monitoring and Maintenance

### Log Management

**PM2**:
```bash
pm2 install pm2-logrotate
pm2 set pm2-logrotate:max_size 10M
pm2 set pm2-logrotate:retain 7
```

**Manual cleanup**:
```bash
# Clear old PM2 logs
pm2 flush

# Clear systemd logs older than 3 days
sudo journalctl --vacuum-time=3d
```

### Health Checks

Create a simple health check script:

```bash
#!/bin/bash
# health-check.sh

if pm2 list | grep -q "whatsapp-bot.*online"; then
    echo "Bot is running"
    exit 0
else
    echo "Bot is not running, restarting..."
    pm2 restart whatsapp-bot
    exit 1
fi
```

### Automatic Restarts

**With PM2**:
```bash
pm2 start index.js --name whatsapp-bot --cron-restart="0 3 * * *"  # Restart daily at 3 AM
```

**With systemd timer** (create timer unit):
```bash
sudo nano /etc/systemd/system/whatsapp-bot-restart.timer
```

---

## Performance Optimization

1. **Use production mode**:
   ```bash
   NODE_ENV=production npm start
   ```

2. **Limit memory usage** (PM2):
   ```bash
   pm2 start index.js --name whatsapp-bot --max-memory-restart 500M
   ```

3. **Enable clustering** (if needed for high load):
   ```bash
   pm2 start index.js -i 2 --name whatsapp-bot
   ```
   Note: WhatsApp client doesn't support true clustering well, use with caution.

---

## Getting Help

If you encounter issues:

1. Check the [main README](README.md) troubleshooting section
2. Review logs for error messages
3. Search existing GitHub issues
4. Create a new issue with:
   - Your deployment method
   - Server specifications
   - Error messages/logs
   - Steps to reproduce

---

**Happy Deploying! 🚀**
