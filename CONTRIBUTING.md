# Contributing to WhatsApp Auto-Reply Bot

Thank you for your interest in contributing to the WhatsApp Auto-Reply Bot! This document provides guidelines and instructions for contributing.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue with:
- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior vs actual behavior
- Your environment (Node.js version, OS, etc.)
- Any error messages or logs

### Suggesting Features

We welcome feature suggestions! Please create an issue with:
- A clear description of the feature
- Why it would be useful
- How it might work
- Any potential challenges

### Pull Requests

1. **Fork the repository**
2. **Create a new branch** for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** following the code style
4. **Test your changes** thoroughly
5. **Run the validation tests**:
   ```bash
   npm test
   ```
6. **Commit your changes** with clear messages:
   ```bash
   git commit -m "Add: brief description of changes"
   ```
7. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```
8. **Create a Pull Request** with a clear description

## Code Style Guidelines

- Use **2 spaces** for indentation
- Use **semicolons**
- Use **single quotes** for strings (unless template literals)
- Add comments for complex logic
- Keep functions focused and concise
- Use meaningful variable and function names

## Testing

Always test your changes:
```bash
# Run validation tests
npm test

# Test bot manually (requires API key)
npm start
```

## Areas for Contribution

Here are some areas where contributions would be valuable:

### Features
- Add support for specific group filtering
- Implement message history/context awareness
- Add command system (e.g., !help, !stop, !start)
- Support for different AI models
- Add rate limiting
- Implement response templates
- Add conversation analytics

### Improvements
- Better error handling
- Enhanced logging
- Performance optimizations
- Memory management
- Response caching

### Documentation
- Additional usage examples
- Troubleshooting guides
- API documentation
- Video tutorials
- Translations

### Testing
- Unit tests
- Integration tests
- Mock WhatsApp client tests
- CI/CD setup

## Development Setup

1. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/whatsapp-reply-bot.git
   cd whatsapp-reply-bot
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create `.env` file:
   ```bash
   cp .env.example .env
   # Add your Gemini API key
   ```

4. Make your changes and test

## Code Review Process

All contributions go through code review:
1. Automated tests must pass
2. Code must follow style guidelines
3. Changes must be well-documented
4. Maintainers will review and provide feedback
5. Once approved, changes will be merged

## Questions?

Feel free to:
- Open an issue for questions
- Start a discussion
- Reach out to maintainers

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! 🎉
