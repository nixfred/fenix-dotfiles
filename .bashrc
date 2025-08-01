# FeNix Dynamic Shell Environment
# Part of the FeNix Phoenix System - Rise from the ashes, stronger than before! 🔥

case $- in
    *i*) ;;
      *) return;;
esac

# Clear screen on .bashrc load for fresh start
# clear  # Commented out to preserve terminal history

######################################################################
# DYNAMIC TOOL DETECTION - No hardcoded paths!
######################################################################

# Dynamic edc path detection
if command -v edc >/dev/null 2>&1; then
    alias edc='edc'
else
    # Search in common locations
    for edc_path in "/usr/local/bin/edc" "$HOME/bin/edc" "$HOME/.local/bin/edc" "$HOME/system/tools/edc"; do
        if [ -f "$edc_path" ]; then
            alias edc="$edc_path"
            break
        fi
    done
fi

######################################################################
# CORE SYSTEM ALIASES
######################################################################

# System management
alias reboot='command -v sudo >/dev/null && sudo reboot || reboot'
alias si='command -v sudo >/dev/null && sudo apt install -y || apt install -y'
alias aa='(command -v sudo >/dev/null && sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y) || (apt update && apt upgrade -y && apt autoremove -y)'
alias eh='command -v sudo >/dev/null && sudo nano /etc/hosts || nano /etc/hosts'
alias sysfix='sudo chown -R root:root /mnt/timeshift && sudo chmod -R 700 /mnt/timeshift && sudo setfacl -bR /mnt/timeshift && sudo apt autoremove -y && sudo apt autoclean -y'

# System information
alias neo='neofetch || screenfetch'
alias ip='ip a'
alias df='df -hT | grep -v tmpfs'
alias myip='curl -s ifconfig.me'
alias temp='vcgencmd measure_temp 2>/dev/null || echo "Temperature not available on this system"'
alias tsl='sudo timeshift --list'

# Navigation shortcuts  
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'
alias home='cd ~'
alias root='cd /'
alias tmp='cd /tmp'
alias usr='cd /usr'
alias opt='cd /opt'
alias var='cd /var'
alias etc='cd /etc'

# File operations
alias l='ls -CFh'
alias ll='ls -alFh'
alias la='ls -Ah'
alias lt='ls -lath'

# Git shortcut
alias gitc='gitcommit'
alias cls='clear && ls'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias tarx='tar -xvzf'
alias tarc='tar -cvzf'


# Enhanced tools (if available)
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --style=plain'
    alias less='bat'
    alias preview='bat --color=always --style=numbers --line-range=:50'
fi

if command -v colordiff >/dev/null 2>&1; then
    alias diff='colordiff'
else
    alias diff='diff --color=auto'
fi

if command -v tree >/dev/null 2>&1; then
    alias tree='tree -C'
fi

# Productivity
alias c='clear'
alias e='exit'
alias sb='source ~/.bashrc'
alias bm='nano ~/.bashrc && source ~/.bashrc'
alias h='history | tail -20'
alias hg='history | grep'
alias now='date +"%T"'
alias nowtime='date +"%d-%m-%Y %T"'
alias reload='source ~/.bashrc'
alias vi='nano'
alias svi='command -v sudo >/dev/null && sudo nano || nano'

# Process and system monitoring
alias top='htop -t'
alias htop='htop -t'
alias du='du -sh * | sort -h'
alias memtop='ps aux --sort=-%mem | head -n 15'
alias cputop='ps aux --sort=-%cpu | head -n 15'
alias ports='netstat -tuln'
alias psg='ps aux | grep'
alias myprocesses='ps -ef | grep $USER'
alias io='sudo iotop -o'
alias log='tail -f /var/log/syslog'
alias authlog='sudo tail -f /var/log/auth.log'

# Network and web tools
alias ping='ping -c 5'
alias www='python3 -m http.server 8080'
alias json='python3 -m json.tool'
alias weather2='curl -s wttr.in/\?format=3'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias qr='qrencode -t ansiutf8'
alias uuid='python3 -c "import uuid; print(uuid.uuid4())"'
alias timestamp='date +%s'
alias iso8601='date -Iseconds'

######################################################################
# ENHANCED HISTORY AND SHELL OPTIONS
######################################################################

HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ll:la:cd:cd ..:pwd:exit:date:* --help:history:clear:c"
shopt -s histappend
shopt -s histverify
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T "
shopt -s checkwinsize
shopt -s cdspell
shopt -s dirspell
shopt -s autocd 2>/dev/null
shopt -s globstar 2>/dev/null

# Save history immediately
PROMPT_COMMAND="history -a"

# Better history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

######################################################################
# ENHANCED PROMPT WITH COLORS AND GIT
######################################################################

# Color definitions
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
CYAN="\[\033[0;36m\]"
YELLOW="\[\033[0;33m\]"
PURPLE="\[\033[0;35m\]"
BOLD_RED="\[\033[1;31m\]"
BOLD_GREEN="\[\033[1;32m\]"
BOLD_BLUE="\[\033[1;34m\]"
BOLD_CYAN="\[\033[1;36m\]"
BOLD_YELLOW="\[\033[1;33m\]"
RESET="\[\033[0m\]"

# Git branch function for prompt
git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Enhanced PS1 with git branch and status indicators
PS1="${BOLD_GREEN}\u${RESET}${RED}@${RESET}${BOLD_YELLOW}\h${RESET} ${BOLD_BLUE}\w${RESET}${PURPLE}\$(git_branch)${RESET}${BOLD_CYAN} ➜ ${RESET}"

# Terminal title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
esac

######################################################################
# COLOR SUPPORT FOR LS AND GREP
######################################################################

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -alFh --color=auto --group-directories-first' 
    alias la='ls -Ah --color=auto --group-directories-first'
    alias l='ls -CFh --color=auto --group-directories-first'
fi

# Better grep with colors and line numbers
alias grep='grep --color=auto -n'
alias fgrep='fgrep --color=auto -n'
alias egrep='egrep --color=auto -n'
if command -v rg >/dev/null 2>&1; then
    alias rg='rg --color=always --line-number'
fi

######################################################################
# MULTI-HOST SMART FUNCTIONS
######################################################################

# Smart SSH function - connects between pi5 ↔ ron, others to pi5
pp() {
    case $(hostname) in
        "ron") ssh pi5 ;;
        "pi5") ssh ron ;;
        *) ssh pi5 ;;  # Default target for non-Pi machines
    esac
}

# Jump to frequently used directories with dynamic detection
j() {
    case "$1" in
        docs|doc) cd ~/Documents ;;
        dl|down) cd ~/Downloads ;;
        desk) cd ~/Desktop ;;
        pics) cd ~/Pictures ;;
        vids) cd ~/Videos ;;
        proj) 
            # Dynamic project directory detection
            for proj_dir in "$HOME/system/projects" "$HOME/projects" "$HOME/Projects" "$HOME/workspace" "$HOME/docker"; do
                if [ -d "$proj_dir" ]; then
                    cd "$proj_dir"
                    return 0
                fi
            done
            cd ~
            ;;
        *) echo "Usage: j {docs|dl|desk|pics|vids|proj}" ;;
    esac
}

######################################################################
# UTILITY FUNCTIONS
######################################################################

# Extract various archive formats
extract() {
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Find files by name
ff() {
    find . -type f -iname '*'"$*"'*' -ls ;
}

# Quick backup function
backup() {
    cp "$1"{,.bak-$(date +%Y%m%d-%H%M%S)}
}

# Show directory size sorted
dirsize() {
    du -sh */ 2>/dev/null | sort -hr
}

# Smart cd with automatic ls (use 'cdd' to avoid breaking scripts)
cdd() {
    builtin cd "$@" && ls -la
}

# Make and change to directory
mkcd() {
    mkdir -p "$1" && builtin cd "$1"
}

# Weather function with timeout and error handling
weather() {
    local city=${1:-""}
    curl -s --max-time 5 "wttr.in/${city}?format=3" 2>/dev/null || echo "Weather service unavailable"
}

######################################################################
# SYSTEM INFORMATION BANNER
######################################################################

print_system_banner() {
    # Colors for enhanced display
    local CYAN='\033[0;36m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local RED='\033[0;31m'
    local BLUE='\033[0;34m'
    local PURPLE='\033[0;35m'
    local WHITE='\033[1;37m'
    local RESET='\033[0m'
    local BOLD='\033[1m'

    HOST=$(hostname)
    IPs=$(hostname -I 2>/dev/null | xargs | sed 's/[^0-9. ]//g' || echo "N/A")
    EXTERNAL_IP=$(timeout 3 curl -s ifconfig.me 2>/dev/null || echo "N/A")
    UPTIME=$(uptime -p 2>/dev/null || echo "N/A")
    USERS=$(who | wc -l 2>/dev/null || echo "N/A")
    LOAD=$(cut -d " " -f1-3 /proc/loadavg 2>/dev/null || echo "N/A")
    DISK=$(df -h / 2>/dev/null | awk 'NR==2 {print $5 " used on " $6}' || echo "N/A")
    MEM=$(free -h 2>/dev/null | awk '/Mem:/ {print $7 " free / " $2}' || echo "N/A")
    DATE=$(date '+%A, %B %d, %Y - %I:%M:%S %p %Z' 2>/dev/null || date)

    # Temperature handling with Celsius only
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        CELSIUS=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
        if [ -n "$CELSIUS" ]; then
            CELSIUS=$((CELSIUS / 1000))
            TEMP="${CELSIUS}C"
        else
            TEMP="N/A"
        fi
    else
        TEMP="N/A"
    fi

    # Docker status
    if command -v docker >/dev/null 2>&1; then
        DOCKER_RUNNING=$(docker ps -q 2>/dev/null | wc -l)
        DOCKER_TOTAL=$(docker ps -a -q 2>/dev/null | wc -l)
        DOCKER_STATUS="${DOCKER_RUNNING} running / ${DOCKER_TOTAL} total"
    else
        DOCKER_STATUS="Not installed"
    fi

    # SSH failure detection
    SSH_FAILS="None"
    if [ -f /var/log/auth.log ]; then
        SSH_FAIL_COUNT=$(grep "Failed password" /var/log/auth.log 2>/dev/null | tail -n 5 | wc -l)
        if [ "$SSH_FAIL_COUNT" -gt 0 ] 2>/dev/null; then
            SSH_FAILS="$SSH_FAIL_COUNT recent attempts"
        fi
    elif command -v journalctl >/dev/null 2>&1; then
        SSH_FAIL_COUNT=$(journalctl -u ssh --since "24 hours ago" 2>/dev/null | grep -c "Failed password" 2>/dev/null || echo "0")
        if [ "$SSH_FAIL_COUNT" -gt 0 ] 2>/dev/null; then
            SSH_FAILS="$SSH_FAIL_COUNT recent attempts"
        fi
    fi

    echo -e "${BOLD}${BLUE}****************************************************${RESET}"
    echo -e "${BOLD}${CYAN}*  🔥 FeNix System Status - $HOST"
    echo -e "${BOLD}${BLUE}****************************************************${RESET}"
    echo -e "${WHITE}*  Host:        ${GREEN}$HOST${RESET}"
    echo -e "${WHITE}*  IPs:         ${CYAN}$IPs${RESET}"
    echo -e "${WHITE}*  External:    ${CYAN}$EXTERNAL_IP${RESET}"
    echo -e "${WHITE}*  Uptime:      ${GREEN}$UPTIME${RESET}"
    echo -e "${WHITE}*  Load:        ${YELLOW}$LOAD${RESET}"
    echo -e "${WHITE}*  Memory:      ${GREEN}$MEM${RESET}"
    echo -e "${WHITE}*  Disk:        ${YELLOW}$DISK${RESET}"
    echo -e "${WHITE}*  Temp:        ${BLUE}$TEMP${RESET}"
    echo -e "${WHITE}*  Docker:      ${PURPLE}$DOCKER_STATUS${RESET}"
    echo -e "${WHITE}*  SSH Fails:   ${RED}$SSH_FAILS${RESET}"
    echo -e "${BOLD}${BLUE}****************************************************${RESET}"
    echo -e "${WHITE}*  ${DATE}${RESET}"
    echo -e "${BOLD}${BLUE}****************************************************${RESET}"
    echo ""
}

# Show banner on login (but not for non-interactive shells)
if [ -t 1 ] && [ -z "$FENIX_NO_BANNER" ]; then
    print_system_banner
fi

######################################################################
# MACHINE-SPECIFIC CONFIGURATIONS
######################################################################

# Load machine-specific configurations if they exist
[ -f ~/.bashrc_private ] && source ~/.bashrc_private
[ -f ~/.bash_aliases ] && source ~/.bash_aliases
[ -f ~/.bash_functions ] && source ~/.bash_functions

# Load local customizations (survives FeNix updates)
[ -f ~/.bash_aliases_local ] && source ~/.bash_aliases_local
[ -f ~/.functions_local ] && source ~/.functions_local

######################################################################
# FENIX SYSTEM INTEGRATION
######################################################################

# FeNix system commands
if [ -d ~/.fenix ]; then
    # Add FeNix bin to PATH if it exists
    [ -d ~/.fenix/bin ] && export PATH="$HOME/.fenix/bin:$PATH"
    
    # FeNix environment variables
    export FENIX_DIR="$HOME/.fenix"
    export FENIX_VERSION="1.0"
fi

# Add FeNix dotfiles bin directory to PATH (for start/destroy commands)
if [ -d "$HOME/.fenix/dotfiles/bin" ]; then
    export PATH="$HOME/.fenix/dotfiles/bin:$PATH"
fi

# Container management functions moved to .bash_functions

######################################################################
# FINAL SETUP
######################################################################

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Welcome message for new FeNix installations
if [ -f ~/.fenix/.first_run ]; then
    echo -e "\033[1;32m🔥 Welcome to FeNix! 🔥\033[0m"
    echo "Your environment is now Phoenix-ready. Type 'j proj' to jump to projects!"
    rm ~/.fenix/.first_run
fi

# FeNix is ready! 🔥