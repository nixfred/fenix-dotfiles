# 🔥 FeNix Extended Aliases
# Part of the FeNix Phoenix System - Dynamic aliases for enhanced productivity

# ==========================================
# Git Aliases - Enhanced Workflow
# ==========================================

alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit -am'
alias gp='git push'
alias gpl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log --oneline -10'
alias gll='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gundo='git reset --soft HEAD~1'
alias gclean='git clean -fd'
alias gstash='git stash'
alias gpop='git stash pop'

# FeNix-specific git aliases
alias bashup='cd ~/.fenix/dotfiles && git add . && git commit -m "Update FeNix dotfiles $(date)" && git push'
alias bashdown='cd ~/.fenix/dotfiles && git pull'

# ==========================================
# Docker Aliases - Container Management
# ==========================================

if command -v docker >/dev/null 2>&1; then
    alias d='docker'
    alias dc='docker-compose'
    alias dcu='docker-compose up -d'
    alias dcd='docker-compose down'
    alias dcr='docker-compose restart'
    alias dcl='docker-compose logs -f'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias drm='docker rm'
    alias drmi='docker rmi'
    alias dprune='docker system prune -af'
    alias dvprune='docker volume prune -f'
    alias dstop='docker stop $(docker ps -q)'
    alias dkill='docker kill $(docker ps -q)'
    alias dlogs='docker logs -f'
    alias dexec='docker exec -it'
    alias drun='docker run -it --rm'
    alias dbuild='docker build -t'
    alias dtop='docker stats --no-stream'
fi

# ==========================================
# System Monitoring Aliases
# ==========================================

alias htop='htop -t'
alias iotop='sudo iotop -o'
alias disk='df -h | grep -E "^/dev|Size"'
alias diskusage='du -h --max-depth=1 | sort -hr'
alias meminfo='free -h'
alias temp='sensors 2>/dev/null || vcgencmd measure_temp 2>/dev/null || echo "Temperature not available"'

# ==========================================
# Network Aliases
# ==========================================

alias myip='curl -s ifconfig.me'
alias localip='hostname -I | cut -d" " -f1'
alias ports='netstat -tulanp'
alias listening='netstat -tuln | grep LISTEN'
alias connections='netstat -tupn'
alias ping='ping -c 5'

# ==========================================
# File Operations Enhanced
# ==========================================

# Safe operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Modern alternatives (if available)
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --style=plain'
    alias less='bat'
elif command -v batcat >/dev/null 2>&1; then
    alias cat='batcat --style=plain'
    alias less='batcat'
fi

if command -v rg >/dev/null 2>&1; then
    alias grep='rg --color=always --line-number'
fi

# ==========================================
# FeNix Specific Aliases
# ==========================================

# Environment management
alias fenix-status='neo' # Show FeNix system status
alias fenix-reload='source ~/.bashrc'

# Project management
alias proj='j proj' # Jump to projects

# Multi-host operations
alias checkremotes='for host in ron pi5; do echo "=== $host ==="; ssh -o ConnectTimeout=5 $host "hostname && uptime" 2>/dev/null || echo "unreachable"; done'

# Container shortcuts
alias containers='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'

# ==========================================
# Package Management (Distribution Aware)
# ==========================================

if command -v apt >/dev/null 2>&1; then
    alias install='sudo apt install'
    alias update='sudo apt update'
    alias upgrade='sudo apt update && sudo apt upgrade'
    alias cleanup='sudo apt autoremove -y && sudo apt autoclean'
elif command -v dnf >/dev/null 2>&1; then
    alias install='sudo dnf install'
    alias update='sudo dnf update'
    alias upgrade='sudo dnf upgrade'
elif command -v pacman >/dev/null 2>&1; then
    alias install='sudo pacman -S'
    alias update='sudo pacman -Sy'
    alias upgrade='sudo pacman -Syu'
fi

# ==========================================
# Load User-Specific Aliases
# ==========================================

# Load machine-specific aliases (preserved during updates)
[ -f ~/.bash_aliases_local ] && source ~/.bash_aliases_local

# Load private aliases (from fenix-private)
[ -f ~/.bash_aliases_private ] && source ~/.bash_aliases_private