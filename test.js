// Basic validation test for WhatsApp Reply Bot
// This test validates the bot structure without requiring actual WhatsApp connection

const fs = require('fs');
const path = require('path');

console.log('🧪 Running validation tests...\n');

let testsPassed = 0;
let testsFailed = 0;

function test(description, assertion) {
    try {
        if (assertion) {
            console.log(`✅ PASS: ${description}`);
            testsPassed++;
        } else {
            console.log(`❌ FAIL: ${description}`);
            testsFailed++;
        }
    } catch (error) {
        console.log(`❌ FAIL: ${description} - ${error.message}`);
        testsFailed++;
    }
}

// Test 1: Check if all required files exist
test('package.json exists', fs.existsSync(path.join(__dirname, 'package.json')));
test('index.js exists', fs.existsSync(path.join(__dirname, 'index.js')));
test('.env.example exists', fs.existsSync(path.join(__dirname, '.env.example')));
test('.gitignore exists', fs.existsSync(path.join(__dirname, '.gitignore')));
test('README.md exists', fs.existsSync(path.join(__dirname, 'README.md')));

// Test 2: Validate package.json structure
const packageJson = require('./package.json');
test('package.json has correct name', packageJson.name === 'whatsapp-reply-bot');
test('package.json has main entry', packageJson.main === 'index.js');
test('package.json has start script', packageJson.scripts && packageJson.scripts.start);
test('package.json has whatsapp-web.js dependency', packageJson.dependencies && packageJson.dependencies['whatsapp-web.js']);
test('package.json has @google/generative-ai dependency', packageJson.dependencies && packageJson.dependencies['@google/generative-ai']);
test('package.json has dotenv dependency', packageJson.dependencies && packageJson.dependencies['dotenv']);
test('package.json has qrcode-terminal dependency', packageJson.dependencies && packageJson.dependencies['qrcode-terminal']);

// Test 3: Validate index.js syntax
try {
    const indexContent = fs.readFileSync(path.join(__dirname, 'index.js'), 'utf8');
    test('index.js requires dotenv', indexContent.includes("require('dotenv')"));
    test('index.js requires whatsapp-web.js', indexContent.includes("require('whatsapp-web.js')"));
    test('index.js requires @google/generative-ai', indexContent.includes("require('@google/generative-ai')"));
    test('index.js requires qrcode-terminal', indexContent.includes("require('qrcode-terminal')"));
    test('index.js validates GEMINI_API_KEY', indexContent.includes('GEMINI_API_KEY'));
    test('index.js initializes WhatsApp client', indexContent.includes('new Client'));
    test('index.js handles QR code event', indexContent.includes("client.on('qr'"));
    test('index.js handles ready event', indexContent.includes("client.on('ready'"));
    test('index.js handles message event', indexContent.includes("client.on('message'"));
    test('index.js checks for group messages', indexContent.includes('isGroup'));
    test('index.js prevents self-reply', indexContent.includes('fromMe'));
    test('index.js uses Gemini AI', indexContent.includes('generateContent'));
    test('index.js initializes client', indexContent.includes('client.initialize()'));
} catch (error) {
    console.log(`❌ Error reading index.js: ${error.message}`);
    testsFailed++;
}

// Test 4: Validate .env.example
try {
    const envExample = fs.readFileSync(path.join(__dirname, '.env.example'), 'utf8');
    test('.env.example has GEMINI_API_KEY', envExample.includes('GEMINI_API_KEY'));
} catch (error) {
    console.log(`❌ Error reading .env.example: ${error.message}`);
    testsFailed++;
}

// Test 5: Validate .gitignore
try {
    const gitignore = fs.readFileSync(path.join(__dirname, '.gitignore'), 'utf8');
    test('.gitignore excludes node_modules', gitignore.includes('node_modules'));
    test('.gitignore excludes .env', gitignore.includes('.env'));
    test('.gitignore excludes WhatsApp auth', gitignore.includes('.wwebjs_auth'));
} catch (error) {
    console.log(`❌ Error reading .gitignore: ${error.message}`);
    testsFailed++;
}

// Test 6: Validate README.md
try {
    const readme = fs.readFileSync(path.join(__dirname, 'README.md'), 'utf8');
    test('README has installation instructions', readme.includes('Installation'));
    test('README has usage instructions', readme.includes('Usage'));
    test('README mentions Gemini API', readme.includes('Gemini'));
    test('README has troubleshooting section', readme.includes('Troubleshooting'));
} catch (error) {
    console.log(`❌ Error reading README.md: ${error.message}`);
    testsFailed++;
}

// Test Summary
console.log('\n' + '='.repeat(50));
console.log(`📊 Test Summary:`);
console.log(`✅ Passed: ${testsPassed}`);
console.log(`❌ Failed: ${testsFailed}`);
console.log(`📈 Total: ${testsPassed + testsFailed}`);
console.log('='.repeat(50));

if (testsFailed > 0) {
    process.exit(1);
} else {
    console.log('\n🎉 All tests passed!');
    process.exit(0);
}
