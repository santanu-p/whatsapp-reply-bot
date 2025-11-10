module.exports = {
  apps: [{
    name: 'whatsapp-bot',
    script: './index.js',
    instances: 1,
    exec_mode: 'fork',
    watch: false,
    autorestart: true,
    max_restarts: 10,
    min_uptime: '10s',
    max_memory_restart: '500M',
    env: {
      NODE_ENV: 'production'
    },
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    time: true,
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z',
    merge_logs: true,
    // Restart daily at 3 AM to prevent memory leaks
    cron_restart: '0 3 * * *',
    // Exponential backoff restart delay
    exp_backoff_restart_delay: 100,
    // Kill timeout
    kill_timeout: 5000,
    // Listen timeout
    listen_timeout: 10000,
    // Shutdown with message
    shutdown_with_message: true
  }]
};
