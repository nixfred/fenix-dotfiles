#!/bin/bash
# FeNix Dotfiles Installation Script
# Part of the FeNix Phoenix System

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

echo -e "${CYAN}🏠 Installing FeNix Public Dotfiles${RESET}"
echo "=================================="

# Backup existing dotfiles
backup_existing() {
    local file="$1"
    if [ -f "$HOME/$file" ]; then
        echo -e "${YELLOW}📦 Backing up existing $file${RESET}"
        cp "$HOME/$file" "$HOME/${file}.backup.$(date +%Y%m%d-%H%M%S)"
    fi
}

# Install stage 1 - just the basic .bashrc
if [ "$1" = "--stage1" ]; then
    echo -e "${GREEN}📋 Stage 1: Installing basic shell environment${RESET}"
    
    # Backup and install .bashrc
    backup_existing ".bashrc"
    cp .bashrc "$HOME/.bashrc"
    
    # Create first run marker
    mkdir -p "$HOME/.fenix"
    touch "$HOME/.fenix/.first_run"
    
    echo -e "${GREEN}✅ Stage 1 complete! Basic shell environment installed.${RESET}"
    echo -e "${CYAN}💡 Run 'source ~/.bashrc' to activate${RESET}"
    exit 0
fi

# Full installation (default)
echo -e "${GREEN}📋 Full Installation: Complete dotfiles setup${RESET}"

# Install main dotfiles
backup_existing ".bashrc"
cp .bashrc "$HOME/.bashrc"

# Install additional config files
echo -e "${CYAN}📝 Installing configuration files...${RESET}"

# Core dotfiles
[ -f .bash_aliases ] && cp .bash_aliases "$HOME/.bash_aliases" && echo "  ✅ .bash_aliases"
[ -f .bash_functions ] && cp .bash_functions "$HOME/.bash_functions" && echo "  ✅ .bash_functions"
[ -f .inputrc ] && cp .inputrc "$HOME/.inputrc" && echo "  ✅ .inputrc"
[ -f .gitconfig ] && cp .gitconfig "$HOME/.gitconfig" && echo "  ✅ .gitconfig"

# Optional files
[ -f .dircolors ] && cp .dircolors "$HOME/.dircolors" && echo "  ✅ .dircolors"
[ -f .vimrc ] && cp .vimrc "$HOME/.vimrc" && echo "  ✅ .vimrc"
[ -f .tmux.conf ] && cp .tmux.conf "$HOME/.tmux.conf" && echo "  ✅ .tmux.conf"

# Create FeNix directories
mkdir -p "$HOME/.fenix"
mkdir -p "$HOME/.fenix/bin"
mkdir -p "$HOME/.fenix/backups"

# Create first run marker for welcome message
touch "$HOME/.fenix/.first_run"

# Set proper permissions for all dotfiles
echo -e "${CYAN}🔐 Setting file permissions...${RESET}"
chmod 644 "$HOME/.bashrc" && echo "  ✅ .bashrc permissions set"
[ -f "$HOME/.bash_aliases" ] && chmod 644 "$HOME/.bash_aliases" && echo "  ✅ .bash_aliases permissions set"
[ -f "$HOME/.bash_functions" ] && chmod 644 "$HOME/.bash_functions" && echo "  ✅ .bash_functions permissions set"
[ -f "$HOME/.inputrc" ] && chmod 644 "$HOME/.inputrc" && echo "  ✅ .inputrc permissions set"
[ -f "$HOME/.gitconfig" ] && chmod 644 "$HOME/.gitconfig" && echo "  ✅ .gitconfig permissions set"
[ -f "$HOME/.dircolors" ] && chmod 644 "$HOME/.dircolors" && echo "  ✅ .dircolors permissions set"
[ -f "$HOME/.vimrc" ] && chmod 644 "$HOME/.vimrc" && echo "  ✅ .vimrc permissions set"
[ -f "$HOME/.tmux.conf" ] && chmod 644 "$HOME/.tmux.conf" && echo "  ✅ .tmux.conf permissions set"

echo -e "${GREEN}✅ FeNix dotfiles installation complete!${RESET}"
echo ""
echo -e "${CYAN}Next steps:${RESET}"
echo "• Run: source ~/.bashrc"
echo "• Test: j proj (should jump to projects)"
echo "• Test: neo (should show system info)"
echo ""
echo -e "${YELLOW}🔥 FeNix shell environment ready! 🔥${RESET}"