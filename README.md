# 🌍 FeNix Public Dotfiles

Public shell configurations for the FeNix Phoenix System - works on any Linux distribution and architecture.

## What's Included

- **Dynamic shell environment** that adapts to any system
- **Portable aliases and functions** with dynamic path detection  
- **Multi-host aware configurations** for seamless machine switching
- **Container integration** with smart container management
- **System health monitoring** with detailed status displays

## Installation

This repository is automatically installed by the FeNix bootstrap:

```bash
curl -s https://raw.githubusercontent.com/nixfred/fenix/main/bootstrap.sh | bash
```

Or install manually:

```bash
git clone https://github.com/nixfred/fenix-dotfiles.git ~/.fenix/dotfiles
cd ~/.fenix/dotfiles
./install.sh
```

## Features

### Dynamic Path Detection
No more hardcoded paths! Automatically finds:
- Tools like `edc` across `/usr/local/bin`, `~/bin`, `~/.local/bin`
- Project directories (`~/projects`, `~/Projects`, `~/workspace`)
- Container configurations and management scripts

### Multi-Host Intelligence
- **Smart SSH routing** - `pp` command auto-routes between pi5 ↔ ron
- **Container synchronization** across multiple hosts
- **Project sync** with bidirectional file synchronization

### Enhanced Shell Experience
- **System information banner** with host details and resource usage
- **Git integration** with branch display and shortcuts
- **Container shortcuts** for Docker environment management
- **Performance monitoring** with system health checks

## Architecture

Works with the complete FeNix ecosystem:
- **fenix** - Master system and bootstrap scripts
- **fenix-dotfiles** - This repo (public configurations)
- **fenix-private** - SSH keys and secrets (private repo)

## Compatibility

- ✅ Ubuntu, Debian, Fedora, Arch, Alpine, CentOS
- ✅ ARM64 (Raspberry Pi, Apple Silicon) 
- ✅ x86_64 (Intel/AMD laptops, servers)
- ✅ Containers (Docker, LXC, systemd-nspawn)

Part of the FeNix Phoenix System - Rise from the ashes, stronger than before! 🔥