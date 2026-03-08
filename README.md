# OpenClaw Memory Persistence System v2.0

![OpenClaw Logo](https://docs.openclaw.ai/img/logo.png)  
*Enterprise-grade memory for autonomous agents*

## ✨ Features
### Dual-Layer Architecture
| Layer | Location | Contents | Retention |
|-------|----------|----------|-----------|
| System | `/var/lib/openclaw/memory/` | Journald logs, system events | 30 days |
| Workspace | `~/.openclaw/workspace/memory/` | Agent memories, decisions | Persistent |

```mermaid
graph TD
    A[Journald] --> B(System Memory)
    C[Agent] --> D(Workspace Memory)
    B --> E[Log Rotation]
    D --> E

🚀 Installation

Prerequisites:

• OpenClaw ≥ v2026.3.2
• Systemd ≥ 245
• Logrotate ≥ 3.18

# 1. Download script
curl -LO https://raw.githubusercontent.com/yourrepo/openclaw-memory/main/setup_memory_persistence_v2.sh

# 2. Deploy (as root)
sudo bash setup_memory_persistence_v2.sh

# 3. Verify
systemctl status openclaw && journalctl -u openclaw -n 5

🛠️ Use Cases

Debugging Flow:

# 1. Find error
cm "ERROR" --after "2026-03-08 14:00"

# 2. Correlate with system
journalctl -u openclaw --since "14:00" | grep -A 10 "ERROR"

# 3. Check retention
sudo logrotate -dv /etc/logrotate.d/openclaw

🐛 Troubleshooting

Common Issues:

| Symptom           | Fix                                                                        |
| ----------------- | -------------------------------------------------------------------------- |
| Permission denied | sudo chown -R clawbox:clawbox /var/lib/openclaw/memory                     |
| Missing logs      | Verify ExecStartPost in /etc/systemd/system/openclaw.service.d/memory_hook |
| Rotation fails    | Test manually: sudo logrotate -vf /etc/logrotate.d/openclaw                |

📊 Sample Output:

[2026-03-08 14:22] SYSTEM: Gateway started (v2026.3.2)
[2026-03-08 14:23] AGENT: Decision logged - approved SSH tunnel
[2026-03-08 14:25] AUDIT: User=clawbox CMD=memory_sync

📦 Files Created:

• /etc/systemd/system/openclaw.service.d/memory_hook
• /usr/local/bin/continue_memory
• /etc/logrotate.d/openclaw
• /etc/profile.d/openclaw_memory.sh
