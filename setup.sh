#!/bin/bash

# WhatsApp Reply Bot - Setup Script
# This script helps set up the bot environment

echo "🤖 WhatsApp Auto-Reply Bot - Setup Script"
echo "=========================================="
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Error: Node.js is not installed"
    echo "Please install Node.js (v14 or higher) from https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v)
echo "✅ Node.js found: $NODE_VERSION"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ Error: npm is not installed"
    echo "Please install npm (comes with Node.js)"
    exit 1
fi

NPM_VERSION=$(npm -v)
echo "✅ npm found: v$NPM_VERSION"
echo ""

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created"
    echo ""
    echo "⚠️  IMPORTANT: Please edit .env and add your Gemini API key"
    echo "   Get your API key from: https://makersuite.google.com/app/apikey"
    echo ""
else
    echo "✅ .env file already exists"
    echo ""
fi

# Install dependencies
echo "📦 Installing dependencies..."
echo "This may take a few minutes..."
echo ""

npm install

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Dependencies installed successfully!"
    echo ""
else
    echo ""
    echo "❌ Error installing dependencies"
    echo "Please check your internet connection and try again"
    exit 1
fi

# Check if .env has been configured
if grep -q "your_gemini_api_key_here" .env 2>/dev/null; then
    echo "⚠️  WARNING: Your .env file still contains the placeholder API key"
    echo "   Please edit .env and replace 'your_gemini_api_key_here' with your actual Gemini API key"
    echo ""
fi

# Run tests
echo "🧪 Running validation tests..."
npm test

if [ $? -eq 0 ]; then
    echo ""
    echo "🎉 Setup completed successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "   1. Edit .env file and add your Gemini API key"
    echo "   2. Run 'npm start' to start the bot"
    echo "   3. Scan the QR code with WhatsApp"
    echo "   4. The bot will start responding to group messages"
    echo ""
    echo "📚 For more information, see README.md"
    echo ""
else
    echo ""
    echo "⚠️  Setup completed with warnings"
    echo "   Please check the test results above"
    echo ""
fi
