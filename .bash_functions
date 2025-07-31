# =% FeNix Enhanced Functions
# Part of the FeNix Phoenix System - Advanced shell functions

# ==========================================
# Archive and Extraction Functions
# ==========================================

# Universal extraction function
extract() {
    if [ -f "$1" ]; then
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
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create archive from directory
archive() {
    if [ $# -ne 2 ]; then
        echo "Usage: archive <directory> <archive_name>"
        return 1
    fi
    
    local dir="$1"
    local archive="$2"
    
    if [ ! -d "$dir" ]; then
        echo "Directory '$dir' does not exist"
        return 1
    fi
    
    case "$archive" in
        *.tar.gz|*.tgz) tar -czf "$archive" "$dir" ;;
        *.tar.bz2|*.tbz2) tar -cjf "$archive" "$dir" ;;
        *.zip) zip -r "$archive" "$dir" ;;
        *) echo "Unsupported archive format. Use .tar.gz, .tar.bz2, or .zip" ;;
    esac
}

# ==========================================
# File and Directory Functions
# ==========================================

# Make directory and change to it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find files by name (case insensitive)
ff() {
    find . -type f -iname "*$1*" -ls
}

# Find directories by name (case insensitive)
fd() {
    find . -type d -iname "*$1*" -ls
}

# Quick backup with timestamp
backup() {
    if [ $# -eq 0 ]; then
        echo "Usage: backup <file_or_directory>"
        return 1
    fi
    
    local item="$1"
    local backup_name="${item}.backup.$(date +%Y%m%d-%H%M%S)"
    
    cp -r "$item" "$backup_name" && echo "Backup created: $backup_name"
}

# Show directory sizes sorted
dirsize() {
    du -sh */ 2>/dev/null | sort -hr
}

# Count files in directory
countfiles() {
    local dir="${1:-.}"
    find "$dir" -type f | wc -l
}

# Find largest files
largest() {
    local num="${1:-10}"
    find . -type f -exec du -h {} + | sort -hr | head -n "$num"
}

# ==========================================
# System Information Functions
# ==========================================

# Enhanced system information with FeNix branding
sysinfo() {
    echo "=% FeNix System Information"
    echo "=========================="
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p 2>/dev/null || uptime)"
    echo "Load: $(cat /proc/loadavg 2>/dev/null | cut -d' ' -f1-3)"
    echo "Memory: $(free -h | awk '/^Mem:/ {print $7 " free / " $2 " total"}')"
    echo "Disk: $(df -h / | awk 'NR==2 {print $4 " free / " $2 " total (" $5 " used)"}')"
    echo "Kernel: $(uname -r)"
    echo "Distro: $(lsb_release -d 2>/dev/null | cut -f2 || cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '\"')"
    
    # Docker info if available
    if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
        local running=$(docker ps -q | wc -l)
        local total=$(docker ps -a -q | wc -l)
        echo "Docker: $running running / $total total containers"
    fi
    
    # Git info if in repository
    if git rev-parse --git-dir >/dev/null 2>&1; then
        echo "Git: $(git branch --show-current 2>/dev/null) branch"
    fi
}

# Weather function with error handling
weather() {
    local location="${1:-}"
    local url="wttr.in/${location}"
    
    if command -v curl >/dev/null 2>&1; then
        curl -s --max-time 5 "$url?format=3" 2>/dev/null || echo "Weather service unavailable"
    else
        echo "curl not available for weather data"
    fi
}

# ==========================================
# Development Functions
# ==========================================

# Git repository status for multiple repos
gitstatus() {
    local base_dir="${1:-$(pwd)}"
    
    echo "= Git Repository Status in $base_dir"
    echo "====================================="
    
    find "$base_dir" -name ".git" -type d | while read -r gitdir; do
        local repo_dir=$(dirname "$gitdir")
        echo ""
        echo "=Á $repo_dir"
        cd "$repo_dir" || continue
        
        # Check if repo is clean
        if git diff-index --quiet HEAD --; then
            echo "   Clean"
        else
            echo "     Modified files:"
            git status --porcelain | head -5 | sed 's/^/    /'
        fi
        
        # Show current branch
        local branch=$(git branch --show-current 2>/dev/null)
        echo "  <? Branch: $branch"
        
        # Check for unpushed commits
        local unpushed=$(git log --oneline @{u}.. 2>/dev/null | wc -l)
        if [ "$unpushed" -gt 0 ]; then
            echo "  =ä $unpushed unpushed commits"
        fi
    done
}

# Start development server with automatic detection
devserver() {
    local port="${1:-8080}"
    
    if [ -f "package.json" ]; then
        echo "=æ Detected Node.js project, starting with npm"
        npm start
    elif [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        echo "= Detected Python project, starting HTTP server"
        python3 -m http.server "$port"
    elif [ -f "composer.json" ]; then
        echo "= Detected PHP project, starting built-in server"
        php -S "localhost:$port"
    elif [ -f "Gemfile" ]; then
        echo "=Ž Detected Ruby project, starting with bundle"
        bundle exec rails server -p "$port"
    else
        echo "< Starting generic HTTP server"
        python3 -m http.server "$port"
    fi
}

# ==========================================
# Network Functions
# ==========================================

# Port scanner function
portscan() {
    if [ $# -ne 2 ]; then
        echo "Usage: portscan <host> <port_range>"
        echo "Example: portscan 192.168.1.1 1-1000"
        return 1
    fi
    
    local host="$1"
    local range="$2"
    
    if command -v nmap >/dev/null 2>&1; then
        nmap -p "$range" "$host"
    else
        echo "nmap not available, using basic connectivity test"
        nc -z -v "$host" $(echo "$range" | tr '-' ' ')
    fi
}

# Check if host is reachable
isup() {
    local host="$1"
    if [ -z "$host" ]; then
        echo "Usage: isup <hostname_or_ip>"
        return 1
    fi
    
    if ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
        echo " $host is UP"
        return 0
    else
        echo "L $host is DOWN"
        return 1
    fi
}

# ==========================================
# Docker Functions
# ==========================================

# Docker container interactive shell
dsh() {
    if [ $# -eq 0 ]; then
        echo "Usage: dsh <container_name_or_id>"
        echo "Available containers:"
        docker ps --format "table {{.Names}}\t{{.Status}}"
        return 1
    fi
    
    local container="$1"
    
    # Try bash first, then sh
    if docker exec -it "$container" bash 2>/dev/null; then
        :
    elif docker exec -it "$container" sh 2>/dev/null; then
        :
    else
        echo "Failed to connect to container $container"
        return 1
    fi
}

# Clean up Docker resources
dockercleanup() {
    echo ">ù Cleaning up Docker resources..."
    
    # Remove stopped containers
    local stopped=$(docker ps -a -q --filter "status=exited")
    if [ -n "$stopped" ]; then
        echo "Removing stopped containers..."
        docker rm $stopped
    fi
    
    # Remove dangling images
    local dangling=$(docker images -q --filter "dangling=true")
    if [ -n "$dangling" ]; then
        echo "Removing dangling images..."
        docker rmi $dangling
    fi
    
    # Clean up system
    docker system prune -f
    
    echo " Docker cleanup complete"
}

# ==========================================
# FeNix Specific Functions
# ==========================================

# FeNix environment check
fenix_check() {
    echo "= FeNix Environment Check"
    echo "========================="
    echo "Shell: $SHELL"
    echo "FeNix Dir: ${HOME}/.fenix $([ -d "${HOME}/.fenix" ] && echo "" || echo "L")"
    
    # Check for project directories
    local proj_found=false
    for proj_dir in "$HOME/projects" "$HOME/Projects" "$HOME/workspace" "$HOME/docker"; do
        if [ -d "$proj_dir" ]; then
            echo "Projects: $proj_dir "
            proj_found=true
            break
        fi
    done
    [ "$proj_found" = false ] && echo "Projects: L not found"
    
    echo "Docker: $(command -v docker >/dev/null && echo " $(docker --version 2>/dev/null)" || echo "L not installed")"
    echo "Git: $(command -v git >/dev/null && echo " $(git --version 2>/dev/null)" || echo "L not installed")"
    
    # Check FeNix hosts connectivity
    echo ""
    echo "FeNix Hosts:"
    for host in ron pi5; do
        if ping -c 1 -W 1 "$host" >/dev/null 2>&1; then
            echo "  $host:  reachable"
        else
            echo "  $host: L unreachable"
        fi
    done
}

# Sync FeNix configurations
fenix_sync() {
    echo "= Syncing FeNix configurations..."
    
    # Sync dotfiles
    if [ -d "$HOME/.fenix/dotfiles" ]; then
        echo "=ä Syncing dotfiles to GitHub..."
        cd "$HOME/.fenix/dotfiles" && git add . && git commit -m "Update dotfiles $(date)" && git push
    fi
    
    # Sync private configs (if available)
    if [ -d "$HOME/.fenix/private" ]; then
        echo "= Syncing private configurations..."
        cd "$HOME/.fenix/private" && git add . && git commit -m "Update private configs $(date)" && git push
    fi
    
    echo " FeNix sync complete"
}

# ==========================================
# Utility Functions
# ==========================================

# Generate random password
genpass() {
    local length="${1:-16}"
    openssl rand -base64 "$length" | tr -d "=+/" | cut -c1-"$length"
}

# Convert epoch timestamp to human readable
epoch2date() {
    if [ $# -eq 0 ]; then
        echo "Usage: epoch2date <timestamp>"
        return 1
    fi
    date -d "@$1" 2>/dev/null || date -r "$1" 2>/dev/null
}

# Convert human readable date to epoch
date2epoch() {
    if [ $# -eq 0 ]; then
        echo "Usage: date2epoch 'YYYY-MM-DD HH:MM:SS'"
        return 1
    fi
    date -d "$1" +%s 2>/dev/null
}

# URL encode function
urlencode() {
    python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))" "$1"
}

# URL decode function
urldecode() {
    python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))" "$1"
}

# ==========================================
# Load Additional Functions
# ==========================================

# Load machine-specific functions (preserved during updates)
[ -f ~/.bash_functions_local ] && source ~/.bash_functions_local

# Load private functions (from fenix-private)
[ -f ~/.bash_functions_private ] && source ~/.bash_functions_private