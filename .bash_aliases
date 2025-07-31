# FeNix Additional Aliases
# Extended aliases for enhanced productivity

# Container management (if edc is available)
alias containers='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias images='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'

# Enhanced git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# System monitoring shortcuts
alias services='systemctl --failed'
alias listening='netstat -tulpn | grep LISTEN'
alias connections='ss -tuln'

# File operations
alias count='find . -type f | wc -l'
alias largest='du -sh * | sort -hr | head -10'
alias oldest='find . -type f -printf "%T+ %p\n" | sort | head -10'
alias newest='find . -type f -printf "%T+ %p\n" | sort -r | head -10'

# Quick navigation
alias home='cd ~'
alias root='cd /'
alias tmp='cd /tmp'
alias logs='cd /var/log'

# Process management
alias psmem='ps aux --sort=-pmem | head -10'
alias pscpu='ps aux --sort=-pcpu | head -10'
alias killall='killall -v'

# Network utilities
alias publicip='curl -s ifconfig.me'
alias localip='hostname -I'
alias ports='netstat -tuln'
alias pingtest='ping -c 3 google.com'

# System cleanup
alias cleanup='sudo apt autoremove -y && sudo apt autoclean'
alias updatesys='sudo apt update && sudo apt upgrade -y'

# Docker shortcuts (if Docker is available)
if command -v docker >/dev/null 2>&1; then
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias dstop='docker stop $(docker ps -q)'
    alias dclean='docker system prune -f'
fi

# Kubernetes shortcuts (if kubectl is available)
if command -v kubectl >/dev/null 2>&1; then
    alias k='kubectl'
    alias kgp='kubectl get pods'
    alias kgs='kubectl get services'
    alias kgd='kubectl get deployments'
fi