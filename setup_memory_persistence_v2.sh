#!/bin/bash
# Enhanced OpenClaw Memory System - Root Installer
# Version 2.0 - Combines journald logging with workspace integration

# [1] Create memory directories
mkdir -p /var/lib/openclaw/memory
mkdir -p ~/.openclaw/workspace/memory
chown -R clawbox:clawbox /var/lib/openclaw/memory ~/.openclaw/workspace/memory
chmod 775 /var/lib/openclaw/memory ~/.openclaw/workspace/memory

# [2] Configure dual logging
mkdir -p /etc/systemd/system/openclaw.service.d
cat > /etc/systemd/system/openclaw.service.d/memory_hook<< 'EOL'
[Service]
ExecStartPost=/bin/sh -c "journalctl -u openclaw -f | grep --line-buffered 'MESSAGE: ' | awk -F'MESSAGE: ' '{print \"[\"$(date +\"%%Y-%%m-%%d %%H:%%M\")\"] \"$2}' >> /var/lib/openclaw/memory/$(date +%%Y-%%m-%%d).md && cp /var/lib/openclaw/memory/$(date +%%Y-%%m-%%d).md ~/.openclaw/workspace/memory/"
EOL

# [3] Install enhanced continue_memory
cat > /usr/local/bin/continue_memory << 'EOL'
#!/bin/bash
{
    # System logs
    find /var/lib/openclaw/memory -name "*.md" -type f -print0 | xargs -0 sort -r
    # Workspace memory
    find ~/.openclaw/workspace/memory -name "*.md" -type f -print0 | xargs -0 sort -r
} | less
EOL
chmod +x /usr/local/bin/continue_memory

# [4] Set up log rotation
cat > /etc/logrotate.d/openclaw << 'EOL'
/var/lib/openclaw/memory/*.md {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 0640 clawbox clawbox
}
/home/clawbox/.openclaw/workspace/memory/*.md {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 0640 clawbox clawbox
}
EOL

# [5] Finalize setup
echo 'alias cm="continue_memory | grep -i"' > /etc/profile.d/openclaw_memory.sh
chmod +x /etc/profile.d/openclaw_memory.sh

systemctl daemon-reload
systemctl restart openclaw
echo "✅ Enhanced memory system installed. Use 'cm' to search logs."
