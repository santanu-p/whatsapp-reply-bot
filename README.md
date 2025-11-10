# WhatsApp Auto-Reply Bot 🤖

An intelligent WhatsApp bot that automatically replies to group messages using Google's Gemini AI. The bot listens to messages in WhatsApp groups and generates contextual, helpful responses powered by artificial intelligence.

## Features ✨

- 🔄 **Automatic Replies**: Responds to all messages in WhatsApp groups automatically
- 🧠 **AI-Powered**: Uses Google's Gemini AI to generate intelligent, contextual responses
- 👥 **Group Support**: Works specifically in group chats
- 🔒 **Session Persistence**: Remembers authentication across restarts
- 💬 **Natural Conversations**: Provides friendly and conversational responses
- 🚫 **Self-Awareness**: Doesn't respond to its own messages
- ⚡ **Real-time**: Instant responses with typing indicators

## Prerequisites 📋

Before you begin, ensure you have:

- **Node.js** (v14 or higher) installed
- A **WhatsApp account** to link with the bot
- A **Gemini API key** from Google AI Studio

## Installation 🚀

1. **Clone the repository**:
   ```bash
   git clone https://github.com/santanu-p/whatsapp-reply-bot.git
   cd whatsapp-reply-bot
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Configure environment variables**:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` and add your Gemini API key:
   ```env
   GEMINI_API_KEY=your_actual_api_key_here
   BOT_NAME=WhatsApp Auto-Reply Bot
   AUTO_REPLY_ENABLED=true
   ```

4. **Get your Gemini API Key**:
   - Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Sign in with your Google account
   - Create a new API key
   - Copy the key to your `.env` file

## Usage 💻

1. **Start the bot**:
   ```bash
   npm start
   ```

2. **Authenticate with WhatsApp**:
   - A QR code will appear in your terminal
   - Open WhatsApp on your phone
   - Go to **Settings** > **Linked Devices** > **Link a Device**
   - Scan the QR code displayed in the terminal

3. **Bot is ready!**:
   - Once authenticated, the bot will listen to all group messages
   - It will automatically reply to messages from other members
   - The bot will NOT respond to your own messages

## How It Works 🔧

1. The bot connects to WhatsApp Web using `whatsapp-web.js`
2. It listens for incoming messages in all groups where your account is a member
3. When someone sends a message, the bot:
   - Captures the message content and sender information
   - Sends the message to Gemini AI for processing
   - Receives an AI-generated response
   - Replies to the message in the group
4. The bot maintains session data to avoid re-authentication on restart

## Project Structure 📁

```
whatsapp-reply-bot/
├── index.js           # Main bot application
├── package.json       # Node.js dependencies and scripts
├── .env.example       # Environment variable template
├── .gitignore        # Git ignore rules
└── README.md         # Documentation
```

## Configuration ⚙️

You can customize the bot behavior by modifying the `index.js` file:

- **Response style**: Edit the prompt sent to Gemini AI
- **Message filtering**: Add conditions to filter specific messages
- **Group filtering**: Respond only to specific groups
- **Response delay**: Add delays between receiving and responding

## Troubleshooting 🔍

### QR Code doesn't appear
- Ensure you have an active internet connection
- Try clearing the `.wwebjs_auth` folder and restart

### Authentication fails
- Make sure WhatsApp Web is not blocked on your network
- Verify your WhatsApp account is active
- Check if you have too many linked devices (max 5)

### Bot doesn't respond
- Check if the `GEMINI_API_KEY` is correct in `.env`
- Verify the bot is added to the group
- Ensure messages are coming from other members (not yourself)
- Check console for error messages

### API Rate Limits
- Gemini AI has rate limits on the free tier
- If you exceed limits, responses may be delayed or fail
- Consider upgrading your API plan for heavy usage

## Security & Privacy 🔒

- **Never share** your `.env` file or Gemini API key
- The bot processes messages through Google's Gemini AI
- Session data is stored locally in `.wwebjs_auth` folder
- No messages are stored permanently by the bot

## Dependencies 📦

- **whatsapp-web.js**: WhatsApp Web client library
- **@google/generative-ai**: Google's Gemini AI SDK
- **qrcode-terminal**: QR code display in terminal
- **dotenv**: Environment variable management

## Limitations ⚠️

- Requires active internet connection
- WhatsApp must remain connected on your phone
- Subject to WhatsApp's Terms of Service
- Gemini API rate limits apply
- Does not support media responses (text only)

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

## License 📄

This project is licensed under the MIT License.

## Disclaimer ⚖️

This bot is for educational purposes. Make sure to:
- Comply with WhatsApp's Terms of Service
- Respect privacy and data protection laws
- Inform group members that an AI bot is active
- Use responsibly and ethically

## Support 💬

If you encounter any issues or have questions:
- Open an issue on GitHub
- Check existing issues for solutions
- Read the troubleshooting section above

---

**Made with ❤️ using Node.js, WhatsApp Web, and Gemini AI**