#!/bin/bash

# Quick Deployment Script for WhatsApp Auto-Reply Bot
# This script provides an interactive deployment setup

set -e  # Exit on error

echo "🤖 WhatsApp Auto-Reply Bot - Quick Deployment"
echo "=============================================="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "⚠️  Warning: Running as root. It's recommended to run as a regular user."
   read -p "Continue anyway? (y/N): " -n 1 -r
   echo
   if [[ ! $REPLY =~ ^[Yy]$ ]]; then
       exit 1
   fi
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check Node.js
if ! command_exists node; then
    echo "❌ Node.js is not installed"
    echo "Please install Node.js v14 or higher from https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 14 ]; then
    echo "❌ Node.js version too old. Please upgrade to v14 or higher."
    exit 1
fi

echo "✅ Node.js $(node -v) found"

# Check npm
if ! command_exists npm; then
    echo "❌ npm is not installed"
    exit 1
fi

echo "✅ npm $(npm -v) found"
echo ""

# Ask for deployment method
echo "Select deployment method:"
echo "1) Docker (recommended for servers)"
echo "2) PM2 (process manager)"
echo "3) Systemd (Linux service)"
echo "4) Direct run (development/testing)"
echo ""
read -p "Enter choice (1-4): " DEPLOY_METHOD

case $DEPLOY_METHOD in
    1)
        echo ""
        echo "📦 Docker Deployment Selected"
        echo "=============================="
        
        if ! command_exists docker; then
            echo "❌ Docker is not installed"
            echo "Install Docker from: https://docs.docker.com/get-docker/"
            exit 1
        fi
        
        echo "✅ Docker found"
        
        if ! command_exists docker-compose; then
            echo "⚠️  Docker Compose not found. Using docker commands instead."
            
            # Create .env if not exists
            if [ ! -f .env ]; then
                cp .env.example .env
                echo "📝 Created .env file. Please edit it with your API key."
                read -p "Press Enter after editing .env file..."
            fi
            
            echo "Building Docker image..."
            docker build -t whatsapp-reply-bot .
            
            echo "Starting container..."
            docker run -d \
                --name whatsapp-bot \
                --env-file .env \
                -v "$(pwd)/.wwebjs_auth:/app/.wwebjs_auth" \
                --restart unless-stopped \
                whatsapp-reply-bot
            
            echo ""
            echo "✅ Bot started successfully!"
            echo "View logs with: docker logs -f whatsapp-bot"
            echo "Scan the QR code when it appears in the logs."
        else
            # Create .env if not exists
            if [ ! -f .env ]; then
                cp .env.example .env
                echo "📝 Created .env file. Please edit it with your API key."
                read -p "Press Enter after editing .env file..."
            fi
            
            echo "Starting with Docker Compose..."
            docker-compose up -d
            
            echo ""
            echo "✅ Bot started successfully!"
            echo "View logs with: docker-compose logs -f"
            echo "Scan the QR code when it appears in the logs."
        fi
        ;;
        
    2)
        echo ""
        echo "⚙️  PM2 Deployment Selected"
        echo "=========================="
        
        if ! command_exists pm2; then
            echo "PM2 not found. Installing globally..."
            npm install -g pm2
        fi
        
        echo "✅ PM2 found"
        
        # Install dependencies
        if [ ! -d "node_modules" ]; then
            echo "Installing dependencies..."
            npm install
        fi
        
        # Create .env if not exists
        if [ ! -f .env ]; then
            cp .env.example .env
            echo "📝 Created .env file. Please edit it with your API key."
            read -p "Press Enter after editing .env file..."
        fi
        
        # Create logs directory
        mkdir -p logs
        
        echo "Starting bot with PM2..."
        pm2 start ecosystem.config.js
        
        echo ""
        echo "✅ Bot started successfully!"
        echo ""
        echo "Useful commands:"
        echo "  pm2 logs whatsapp-bot    - View logs"
        echo "  pm2 restart whatsapp-bot - Restart bot"
        echo "  pm2 stop whatsapp-bot    - Stop bot"
        echo "  pm2 monit                - Monitor bot"
        echo ""
        read -p "Setup PM2 to start on system boot? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            pm2 startup
            pm2 save
            echo "✅ PM2 configured to start on boot"
        fi
        ;;
        
    3)
        echo ""
        echo "🔧 Systemd Service Deployment Selected"
        echo "======================================"
        
        if [ "$EUID" -eq 0 ]; then
            SUDO=""
        else
            SUDO="sudo"
        fi
        
        # Install dependencies
        if [ ! -d "node_modules" ]; then
            echo "Installing dependencies..."
            npm install
        fi
        
        # Create .env if not exists
        if [ ! -f .env ]; then
            cp .env.example .env
            echo "📝 Created .env file. Please edit it with your API key."
            read -p "Press Enter after editing .env file..."
        fi
        
        # Get current directory
        CURRENT_DIR=$(pwd)
        
        # Create user if doesn't exist
        if ! id "whatsappbot" &>/dev/null; then
            echo "Creating whatsappbot user..."
            $SUDO useradd -m -s /bin/bash whatsappbot
        fi
        
        # Copy files to /opt if not already there
        if [ "$CURRENT_DIR" != "/opt/whatsapp-reply-bot" ]; then
            echo "Copying files to /opt/whatsapp-reply-bot..."
            $SUDO mkdir -p /opt/whatsapp-reply-bot
            $SUDO cp -r . /opt/whatsapp-reply-bot/
            $SUDO chown -R whatsappbot:whatsappbot /opt/whatsapp-reply-bot
            INSTALL_DIR="/opt/whatsapp-reply-bot"
        else
            $SUDO chown -R whatsappbot:whatsappbot "$CURRENT_DIR"
            INSTALL_DIR="$CURRENT_DIR"
        fi
        
        # Update service file with correct paths
        $SUDO sed -i "s|/opt/whatsapp-reply-bot|$INSTALL_DIR|g" whatsapp-bot.service
        
        # Copy service file
        echo "Installing systemd service..."
        $SUDO cp whatsapp-bot.service /etc/systemd/system/
        
        # Reload systemd
        $SUDO systemctl daemon-reload
        
        # Enable and start service
        $SUDO systemctl enable whatsapp-bot
        $SUDO systemctl start whatsapp-bot
        
        echo ""
        echo "✅ Service installed and started!"
        echo ""
        echo "Useful commands:"
        echo "  sudo systemctl status whatsapp-bot   - Check status"
        echo "  sudo journalctl -u whatsapp-bot -f   - View logs"
        echo "  sudo systemctl restart whatsapp-bot  - Restart bot"
        echo "  sudo systemctl stop whatsapp-bot     - Stop bot"
        echo ""
        echo "View logs now to scan QR code:"
        echo "  sudo journalctl -u whatsapp-bot -f"
        ;;
        
    4)
        echo ""
        echo "💻 Direct Run (Development)"
        echo "========================="
        
        # Install dependencies
        if [ ! -d "node_modules" ]; then
            echo "Installing dependencies..."
            npm install
        fi
        
        # Create .env if not exists
        if [ ! -f .env ]; then
            cp .env.example .env
            echo "📝 Created .env file. Please edit it with your API key."
            read -p "Press Enter after editing .env file..."
        fi
        
        echo ""
        echo "Starting bot..."
        echo "Press Ctrl+C to stop"
        echo ""
        npm start
        ;;
        
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "📚 For more information, see:"
echo "   - DEPLOYMENT.md for detailed deployment guide"
echo "   - README.md for general documentation"
echo ""
