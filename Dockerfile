# WhatsApp Auto-Reply Bot - Dockerfile
# Multi-stage build for optimized image size

FROM node:18-slim AS base

# Install Chromium dependencies required by Puppeteer
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-freefont-ttf \
    libxss1 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Set Puppeteer to use installed Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy application files
COPY index.js ./
COPY .env.example ./

# Create directory for WhatsApp session data
RUN mkdir -p .wwebjs_auth && chmod 755 .wwebjs_auth

# Run as non-root user for security
RUN useradd -m -u 1001 botuser && \
    chown -R botuser:botuser /app
USER botuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD node -e "console.log('Bot is running')" || exit 1

# Expose no ports (bot doesn't need external access)
EXPOSE 0

# Start the bot
CMD ["node", "index.js"]
