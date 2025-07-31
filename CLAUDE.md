# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the FeNix Public Dotfiles repository.

## Repository Purpose

This repository contains the public shell configurations for the FeNix Phoenix System. These are portable, dynamic configurations that work across any Linux distribution and architecture without requiring private information or secrets.

## Key Design Principles

### 1. Dynamic Path Detection
- **No hardcoded paths** - All tools and directories are discovered dynamically
- **Graceful fallbacks** - If a tool isn't found, provide alternatives or clear error messages
- **Multi-location search** - Check multiple common locations for tools and directories

### 2. Cross-Platform Compatibility  
- **Distribution agnostic** - Works on Ubuntu, Debian, Fedora, Arch, Alpine, CentOS
- **Architecture independent** - Supports both ARM64 (Raspberry Pi) and x86_64
- **Container friendly** - Functions correctly in Docker containers and minimal environments

### 3. Machine Role Awareness
- **Multi-host intelligence** - Knows about ron ↔ pi5 host relationships
- **Smart SSH routing** - `pp` command routes correctly between different machine types
- **Adaptive behavior** - Functions adapt based on available tools and environment

## File Structure

### Core Files
- `.bashrc` - Main shell configuration with all features
- `install.sh` - Installation script with multi-stage support
- `.bash_aliases` - Extended aliases for productivity
- `.gitconfig_public` - Git configuration (no personal info)

### Key Features Implemented

#### Dynamic Tool Detection
```bash
# Example: edc command detection
if command -v edc >/dev/null 2>&1; then
    alias edc='edc'
else
    for edc_path in "/usr/local/bin/edc" "$HOME/bin/edc" "$HOME/.local/bin/edc"; do
        if [ -f "$edc_path" ]; then
            alias edc="$edc_path"
            break
        fi
    done
fi
```

#### Project Directory Discovery
```bash
# j proj function - finds project directories dynamically
for proj_dir in "$HOME/system/projects" "$HOME/projects" "$HOME/Projects" "$HOME/workspace" "$HOME/docker"; do
    if [ -d "$proj_dir" ]; then
        cd "$proj_dir"
        return 0
    fi
done
```

#### Smart SSH Routing
```bash
# pp function - multi-host aware SSH
pp() {
    case $(hostname) in
        "ron") ssh pi5 ;;
        "pi5") ssh ron ;;
        *) ssh pi5 || ssh ron || echo "No FeNix hosts reachable" ;;
    esac
}
```

## Installation Stages

The install.sh script supports multiple installation stages:

1. **Stage 1 (--stage1)**: Basic dotfiles installation
2. **Stage 2 (--stage2)**: System integration (shell setup, directories)
3. **Stage 3 (--stage3)**: Post-installation validation and tool checking

## Integration with FeNix Ecosystem

This repository is part of the complete FeNix system:
- **fenix** - Master bootstrap and documentation
- **fenix-dotfiles** - This repo (public configurations)
- **fenix-private** - SSH keys and secrets (private repository)

## Error Handling Philosophy

- **Fail gracefully** - If a tool isn't available, provide alternatives
- **Clear feedback** - Always tell user what's happening and why
- **Non-breaking** - Missing tools shouldn't break the entire shell environment
- **Helpful suggestions** - Guide users on how to install missing dependencies

## Customization Strategy

- **Local override files** - `.bashrc_local`, `.bash_aliases_local` for machine-specific additions
- **Private configurations** - `.bashrc_private` loaded from fenix-private repository
- **Preservation** - Local customizations survive FeNix updates

## Testing and Validation

All configurations must work on:
- Fresh Ubuntu 22.04 containers
- Raspberry Pi OS (ARM64)
- Minimal Alpine Linux containers
- Systems with missing tools (git, curl, docker, etc.)

## Security Considerations

- **No secrets** - This is a public repository, no private information
- **No hardcoded users** - Use `$USER` and dynamic detection
- **No hardcoded hosts** - Discover network configuration dynamically
- **Safe defaults** - All functions should fail safely if environment is unexpected

## Development Guidelines

When modifying these dotfiles:

1. **Test portability** - Verify on multiple distributions
2. **Check dependencies** - Ensure graceful handling of missing tools
3. **Maintain compatibility** - Don't break existing FeNix installations
4. **Document changes** - Update this CLAUDE.md for significant modifications
5. **Consider performance** - Avoid slow operations in prompt or frequently-used functions

## Common Patterns

### Tool Detection Template
```bash
if command -v TOOL >/dev/null 2>&1; then
    # Tool is available
    alias shortcut='TOOL with-options'
else
    # Provide fallback or skip
    echo "TOOL not available, using fallback"
fi
```

### Directory Discovery Template
```bash
for target_dir in "$HOME/option1" "$HOME/option2" "/opt/option3"; do
    if [ -d "$target_dir" ]; then
        cd "$target_dir"
        return 0
    fi
done
echo "No suitable directory found"
```

### Function Error Handling Template
```bash
function_name() {
    if [ -z "$1" ]; then
        echo "Usage: function_name <argument>"
        return 1
    fi
    
    # Main logic with error checking
    if ! command_that_might_fail; then
        echo "Operation failed, trying alternative"
        alternative_command || return 1
    fi
}
```

This repository embodies the FeNix philosophy: **Rise from the ashes, stronger than before** - providing a robust, portable shell environment that works anywhere Linux runs.