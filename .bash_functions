# Extract function
extract() {
    if [ -f "$1" ]; then
        case $1 in
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
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Generate password
genpass() {
    local length="${1:-16}"
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-"$length"
}

# Timeshift backup
ts() {
    if [ $# -eq 0 ]; then
        echo "Usage: ts <comment>"
        return 1
    fi
    sudo timeshift --create --comments "$*" --tags D
}

# Git commit with automatic timestamp
gitcommit() {
    local message
    if [ $# -eq 0 ]; then
        message="Update $(date '+%Y-%m-%d %H:%M:%S')"
    else
        message="$*"
    fi
    
    # Check if there are changes to commit
    if ! git diff --cached --quiet || ! git diff --quiet; then
        # Add modified tracked files
        git add -u
        git commit -m "$message"
    else
        echo "No changes to commit. Current status:"
        git status --short
    fi
}