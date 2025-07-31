#!/bin/bash
# FeNix Public Dotfiles Installation Script
# Installs portable shell configurations that work on any Linux system

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.fenix_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${BOLD}${CYAN}🌍 Installing FeNix Public Dotfiles${RESET}"
echo "========================================="

# Function to backup existing files
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        cp "$file" "$BACKUP_DIR/$(basename "$file")"
        echo -e "${YELLOW}📦 Backed up existing $(basename "$file") to $BACKUP_DIR${RESET}"
    fi
}

# Function to install dotfile
install_dotfile() {
    local source_file="$1"
    local target_file="$2"
    
    if [ -f "$DOTFILES_DIR/$source_file" ]; then
        backup_file "$target_file"
        cp "$DOTFILES_DIR/$source_file" "$target_file"
        echo -e "${GREEN}✅ Installed $source_file → $(basename "$target_file")${RESET}"
    else
        echo -e "${YELLOW}⚠️  $source_file not found, skipping${RESET}"
    fi
}

# Stage 1: Public dotfiles installation
if [ "$1" = "--stage1" ] || [ -z "$1" ]; then
    echo -e "${CYAN}📋 Stage 1: Installing public shell configurations${RESET}"
    
    # Install main bashrc
    install_dotfile ".bashrc" "$HOME/.bashrc"
    
    # Install additional configs if they exist
    install_dotfile ".bash_aliases" "$HOME/.bash_aliases"
    install_dotfile ".bash_functions" "$HOME/.bash_functions"
    install_dotfile ".inputrc" "$HOME/.inputrc"
    install_dotfile ".gitconfig_public" "$HOME/.gitconfig"
    install_dotfile ".dircolors" "$HOME/.dircolors"
    
    # Create local customization files if they don't exist
    [ ! -f "$HOME/.bashrc_local" ] && touch "$HOME/.bashrc_local"
    [ ! -f "$HOME/.bash_aliases_local" ] && touch "$HOME/.bash_aliases_local"
    
    echo -e "${GREEN}✅ Stage 1 Complete: Public dotfiles installed${RESET}"
fi

# Stage 2: System integration (called by main bootstrap)
if [ "$1" = "--stage2" ]; then
    echo -e "${CYAN}🔧 Stage 2: System integration${RESET}"
    
    # Set up shell as default if bash is available
    if command -v bash >/dev/null 2>&1; then
        # Only change shell if current shell is not bash
        if [ "$SHELL" != "/bin/bash" ] && [ "$SHELL" != "/usr/bin/bash" ]; then
            echo -e "${CYAN}🐚 Setting bash as default shell${RESET}"
            if command -v chsh >/dev/null 2>&1; then
                chsh -s "$(which bash)" || echo -e "${YELLOW}⚠️  Could not change default shell${RESET}"
            fi
        fi
    fi
    
    # Create common directories if they don't exist
    mkdir -p "$HOME/bin" "$HOME/.local/bin"
    
    echo -e "${GREEN}✅ Stage 2 Complete: System integration done${RESET}"
fi

# Stage 3: Post-installation tasks
if [ "$1" = "--stage3" ]; then
    echo -e "${CYAN}🎯 Stage 3: Post-installation configuration${RESET}"
    
    # Source the new bashrc to test it
    if [ -f "$HOME/.bashrc" ]; then
        echo -e "${CYAN}🧪 Testing new shell configuration${RESET}"
        # Test in subshell to avoid affecting current session
        bash -c "source ~/.bashrc && echo 'Shell configuration test: OK'" || echo -e "${YELLOW}⚠️  Shell configuration may have issues${RESET}"
    fi
    
    # Check for required tools and suggest installation
    echo -e "${CYAN}🔍 Checking for recommended tools${RESET}"
    
    local missing_tools=""
    for tool in htop neofetch git curl wget nano tree; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools="$missing_tools $tool"
        fi
    done
    
    if [ -n "$missing_tools" ]; then
        echo -e "${YELLOW}📦 Recommended tools not installed:$missing_tools${RESET}"
        echo -e "${CYAN}💡 Install with: sudo apt install$missing_tools${RESET}"
    else
        echo -e "${GREEN}✅ All recommended tools are available${RESET}"
    fi
    
    echo -e "${GREEN}✅ Stage 3 Complete: Post-installation done${RESET}"
fi

echo ""
echo -e "${BOLD}${GREEN}🎉 FeNix Public Dotfiles Installation Complete!${RESET}"
echo ""
echo -e "${CYAN}Next steps:${RESET}"
echo "• Run: source ~/.bashrc"
echo "• Test: j proj (should find your project directory)"
echo "• Try: pp (should attempt SSH to other FeNix hosts)"
echo "• Customize: Edit ~/.bashrc_local for machine-specific additions"
echo ""

if [ -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}📦 Your original files are backed up in: $BACKUP_DIR${RESET}"
fi

echo -e "${CYAN}🔥 FeNix public environment ready! 🔥${RESET}"