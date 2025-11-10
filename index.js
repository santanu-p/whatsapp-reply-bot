require('dotenv').config();
const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode-terminal');
const { GoogleGenerativeAI } = require('@google/generative-ai');

// Validate environment variables
if (!process.env.GEMINI_API_KEY) {
    console.error('❌ Error: GEMINI_API_KEY is not set in .env file');
    console.error('Please copy .env.example to .env and add your Gemini API key');
    process.exit(1);
}

// Initialize Gemini AI
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: 'gemini-pro' });

// Initialize WhatsApp Client with authentication
const client = new Client({
    authStrategy: new LocalAuth(),
    puppeteer: {
        headless: true,
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox',
            '--disable-dev-shm-usage',
            '--disable-accelerated-2d-canvas',
            '--no-first-run',
            '--no-zygote',
            '--disable-gpu'
        ]
    }
});

// Track processed messages to avoid duplicate responses
const processedMessages = new Set();

// Generate QR Code for authentication
client.on('qr', (qr) => {
    console.log('📱 Scan the QR code below to authenticate:');
    qrcode.generate(qr, { small: true });
});

// Client is ready
client.on('ready', () => {
    console.log('✅ WhatsApp client is ready!');
    console.log('🤖 Bot is now listening for messages in groups...');
});

// Handle authentication
client.on('authenticated', () => {
    console.log('✅ Authentication successful!');
});

// Handle authentication failure
client.on('auth_failure', (msg) => {
    console.error('❌ Authentication failure:', msg);
});

// Handle disconnection
client.on('disconnected', (reason) => {
    console.log('⚠️ Client was disconnected:', reason);
});

// Handle incoming messages
client.on('message', async (message) => {
    try {
        // Get chat information
        const chat = await message.getChat();
        
        // Only respond to group messages
        if (!chat.isGroup) {
            return;
        }

        // Get contact information
        const contact = await message.getContact();
        
        // Don't respond to own messages
        if (message.fromMe) {
            return;
        }

        // Check if message was already processed
        if (processedMessages.has(message.id._serialized)) {
            return;
        }

        // Mark message as processed
        processedMessages.add(message.id._serialized);

        // Clean up old processed messages (keep only last 1000)
        if (processedMessages.size > 1000) {
            const iterator = processedMessages.values();
            processedMessages.delete(iterator.next().value);
        }

        // Get message body
        const messageBody = message.body;

        // Skip empty messages or media-only messages
        if (!messageBody || messageBody.trim().length === 0) {
            return;
        }

        console.log(`\n📩 New message in group "${chat.name}"`);
        console.log(`👤 From: ${contact.pushname || contact.number}`);
        console.log(`💬 Message: ${messageBody}`);

        // Show typing indicator
        await chat.sendStateTyping();

        // Generate AI response using Gemini
        const prompt = `You are a helpful WhatsApp bot assistant. A user named "${contact.pushname || 'User'}" sent this message in a group chat: "${messageBody}". 

Please provide a helpful, friendly, and concise response. Keep it conversational and natural, as if you're chatting in a WhatsApp group. Don't be overly formal.`;

        const result = await model.generateContent(prompt);
        const response = await result.response;
        const aiResponse = response.text();

        console.log(`🤖 AI Response: ${aiResponse}`);

        // Send the AI-generated response
        await message.reply(aiResponse);

        console.log('✅ Response sent successfully!');

    } catch (error) {
        console.error('❌ Error processing message:', error.message);
        
        // Send a fallback message if AI fails
        try {
            await message.reply('Sorry, I encountered an error while processing your message. Please try again later.');
        } catch (replyError) {
            console.error('❌ Failed to send error message:', replyError.message);
        }
    }
});

// Handle errors
client.on('error', (error) => {
    console.error('❌ Client error:', error);
});

// Initialize the client
console.log('🚀 Starting WhatsApp Auto-Reply Bot...');
console.log('⏳ Please wait for QR code...');
client.initialize();

// Graceful shutdown
process.on('SIGINT', async () => {
    console.log('\n⏳ Shutting down gracefully...');
    await client.destroy();
    console.log('✅ Bot stopped successfully');
    process.exit(0);
});
