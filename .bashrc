# FeNix Public Shell Configuration
# Dynamic, portable bash configuration that adapts to any Linux system
# Part of the FeNix Phoenix System - Rise from the ashes, stronger than before! 🔥

# Return if not interactive
case $- in
    *i*) ;;
      *) return;;
esac

# Clear screen on .bashrc load for clean startup
clear

######################################################################
# DYNAMIC TOOL DETECTION
######################################################################

# Dynamic edc path detection - no hardcoded paths
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

# Smart bat detection with fallback
if ! command -v bat >/dev/null 2>&1; then
    bat() { echo "bat not installed, using cat" >/dev/null 2>&1; cat "$@"; }
fi

######################################################################
# ESSENTIAL ALIASES - PORTABLE ACROSS ALL SYSTEMS
######################################################################

# System management
alias si='command -v sudo >/dev/null && sudo apt install -y || apt install -y'
alias aa='(command -v sudo >/dev/null && sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y) || (apt update && apt upgrade -y && apt autoremove -y)'
alias reboot='command -v sudo >/dev/null && sudo reboot || reboot'
alias eh='command -v sudo >/dev/null && sudo nano /etc/hosts || nano /etc/hosts'

# System information
alias neo='neofetch || screenfetch || echo "System info tools not installed"'
alias ip='ip a'
alias myip='curl -s ifconfig.me'
alias temp='vcgencmd measure_temp 2>/dev/null || echo "Temperature not available on this system"'

# File operations
alias l='ls -CFh'
alias ll='ls -alFh'
alias la='ls -Ah'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

# Process and system monitoring
alias df='df -hT | grep -v tmpfs'
alias top='htop -t 2>/dev/null || top'
alias htop='htop -t 2>/dev/null || htop'
alias du='du -sh * | sort -h'
alias memtop='ps aux --sort=-%mem | head -n 15'
alias cputop='ps aux --sort=-%cpu | head -n 15'
alias ports='netstat -tuln'
alias psg='ps aux | grep'

# Productivity shortcuts
alias c='clear'
alias e='exit'
alias sb='source ~/.bashrc'
alias bm='nano ~/.bashrc && source ~/.bashrc'
alias h='history | tail -20'
alias hg='history | grep'
alias mkdir='mkdir -pv'
alias wget='wget -c'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime='date +"%d-%m-%Y %T"'
alias vi='nano'
alias svi='command -v sudo >/dev/null && sudo nano || nano'

# Enhanced file viewing
alias cls='clear && ls'
alias lt='ls -lath'
alias tree='tree -C 2>/dev/null || find . -type d | head -20'
alias t='tail -f'
alias tf='tail -F'

# Smart tool aliases with fallbacks
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

# Networking and utilities
alias ping='ping -c 5'
alias www='python3 -m http.server 8080'
alias json='python3 -m json.tool'
alias weather2='curl -s wttr.in/\?format=3'
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
bind '"\e[A": history-search-backward' 2>/dev/null
bind '"\e[B": history-search-forward' 2>/dev/null

######################################################################
# ENHANCED PROMPT WITH GIT INTEGRATION
######################################################################

# Colors
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
alias rg='rg --color=always --line-number 2>/dev/null || grep --color=auto -n'

######################################################################
# PORTABLE FUNCTIONS
######################################################################

# Smart SSH function - multi-host aware routing
pp() {
    case $(hostname) in
        "ron") ssh pi5 2>/dev/null || echo "pi5 not reachable" ;;
        "pi5") ssh ron 2>/dev/null || echo "ron not reachable" ;;
        *) ssh pi5 2>/dev/null || ssh ron 2>/dev/null || echo "No FeNix hosts reachable" ;;
    esac
}

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
    find . -type f -iname '*'"$*"'*' -ls 2>/dev/null;
}

# Quick backup function
backup() {
    cp "$1"{,.bak-$(date +%Y%m%d-%H%M%S)}
}

# Show directory size sorted
dirsize() {
    du -sh */ 2>/dev/null | sort -hr
}

# Smart cd with automatic ls
cd() {
    builtin cd "$@" && ls -la
}

# Jump to frequently used directories - DYNAMIC PATH DETECTION
j() {
    case "$1" in
        docs|doc) cd ~/Documents 2>/dev/null || cd ~ ;;
        dl|down) cd ~/Downloads 2>/dev/null || cd ~ ;;
        desk) cd ~/Desktop 2>/dev/null || cd ~ ;;
        pics) cd ~/Pictures 2>/dev/null || cd ~ ;;
        vids) cd ~/Videos 2>/dev/null || cd ~ ;;
        proj) 
            # Dynamic project directory detection - no hardcoded paths
            for proj_dir in "$HOME/system/projects" "$HOME/projects" "$HOME/Projects" "$HOME/workspace" "$HOME/docker" "$HOME/code" "$HOME/dev"; do
                if [ -d "$proj_dir" ]; then
                    cd "$proj_dir"
                    return 0
                fi
            done
            echo "No project directory found. Searched: ~/system/projects, ~/projects, ~/Projects, ~/workspace, ~/docker, ~/code, ~/dev"
            cd ~
            ;;
        *) echo "Usage: j {docs|dl|desk|pics|vids|proj}" ;;
    esac
}

# Make and change to directory
mkcd() {
    mkdir -p "$1" && cd "$1"
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
    local WHITE='\033[1;37m'
    local RESET='\033[0m'
    local BOLD='\033[1m'

    local HOST=$(hostname)
    local IPs=$(hostname -I 2>/dev/null | xargs | sed 's/[^0-9. ]//g' || echo "N/A")
    local EXTERNAL_IP=$(timeout 3 curl -s ifconfig.me 2>/dev/null || echo "N/A")
    local UPTIME=$(uptime -p 2>/dev/null || uptime)
    local LOAD=$(cut -d " " -f1-3 /proc/loadavg 2>/dev/null || echo "N/A")
    local DISK=$(df -h / 2>/dev/null | awk 'NR==2 {print $5 " used on " $6}' || echo "N/A")
    local MEM=$(free -h 2>/dev/null | awk '/Mem:/ {print $7 " free / " $2}' || echo "N/A")
    local DATE=$(date '+%A, %B %d, %Y - %I:%M:%S %p %Z' 2>/dev/null || date)

    # Temperature handling with fallback
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        local CELSIUS=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
        CELSIUS=$((CELSIUS / 1000))
        local TEMP="${CELSIUS}C"
    else
        local TEMP="N/A"
    fi

    # Docker status with error handling
    if command -v docker >/dev/null 2>&1; then
        local DOCKER_RUNNING=$(docker ps -q 2>/dev/null | wc -l)
        local DOCKER_TOTAL=$(docker ps -a -q 2>/dev/null | wc -l)
        local DOCKER_STATUS="${DOCKER_RUNNING} running / ${DOCKER_TOTAL} total"
    else
        local DOCKER_STATUS="Not installed"
    fi

    # Git branch in current directory
    local GIT_BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/' || echo "Not a git repo")

    echo -e "${BOLD}${CYAN}"
    echo "****************************************************"
    echo -e "*  ${WHITE}FeNix System Status - $(hostname)${CYAN}*"
    echo "****************************************************"
    echo -e "*  ${YELLOW}Date:${RESET}        $DATE"
    echo -e "*  ${YELLOW}Host:${RESET}        $HOST"
    echo -e "*  ${YELLOW}IPs:${RESET}         $IPs"
    echo -e "*  ${YELLOW}External:${RESET}    $EXTERNAL_IP"
    echo -e "*  ${YELLOW}Uptime:${RESET}      $UPTIME"
    echo -e "*  ${YELLOW}Load:${RESET}        $LOAD"
    echo -e "*  ${YELLOW}Memory:${RESET}      $MEM"
    echo -e "*  ${YELLOW}Disk:${RESET}        $DISK"
    echo -e "*  ${YELLOW}Temp:${RESET}        $TEMP"
    echo -e "*  ${YELLOW}Docker:${RESET}      $DOCKER_STATUS"
    echo -e "*  ${YELLOW}Git Branch:${RESET}  $GIT_BRANCH"
    echo -e "${CYAN}****************************************************${RESET}"
    echo ""
}

# Load machine-specific configurations if they exist
[ -f ~/.bashrc_local ] && source ~/.bashrc_local
[ -f ~/.bash_aliases_local ] && source ~/.bash_aliases_local
[ -f ~/.bashrc_private ] && source ~/.bashrc_private

# Show system banner on login (but not for non-interactive shells)
if [[ $- == *i* ]] && [[ -z "$FENIX_BANNER_SHOWN" ]]; then
    export FENIX_BANNER_SHOWN=1
    print_system_banner
fi

# FeNix system identification
export FENIX_VERSION="1.0"
export FENIX_LOADED="$(date)"

echo -e "\033[0;36m🔥 FeNix shell environment loaded! 🔥\033[0m"