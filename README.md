# OpenClaw Memory Persistence System v2.0

![OpenClaw Logo](https://docs.openclaw.ai/img/logo.png)  
*Enterprise-grade memory for autonomous agents*

## ✨ Features
### Dual-Layer Architecture
| Layer | Location | Contents | Retention |
|-------|----------|----------|-----------|
| System | `/var/lib/openclaw/memory/` | Journald logs, system events | 30 days |
| Workspace | `~/.openclaw/workspace/memory/` | Agent memories, decisions | Persistent |

