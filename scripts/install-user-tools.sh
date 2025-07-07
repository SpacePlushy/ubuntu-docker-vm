#!/bin/bash
set -e

echo "==================================="
echo "Installing User Development Tools"
echo "==================================="

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_installing() {
    echo -e "${YELLOW}[→]${NC} Installing $1..."
}

# Create directories if they don't exist
mkdir -p ~/.local/bin
mkdir -p ~/.config

# Add ~/.local/bin to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
fi

# Python development tools (user install)
print_installing "Python development tools"
pip3 install --user --upgrade pip
pip3 install --user \
    ipython \
    black \
    flake8 \
    pylint \
    pytest \
    pytest-cov \
    requests \
    httpie \
    virtualenv \
    poetry \
    rich \
    typer \
    click
print_status "Python tools installed"

# Install micro editor (user install)
print_installing "micro editor"
if ! command -v micro &> /dev/null; then
    cd /tmp
    curl -sL https://getmic.ro/r | bash
    mv micro ~/.local/bin/
    cd -
fi
print_status "micro editor installed"

# Install fzf (fuzzy finder)
print_installing "fzf (fuzzy finder)"
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-update-rc
fi
print_status "fzf installed"

# Install nvm (Node Version Manager)
print_installing "Node Version Manager (nvm)"
if [ ! -d ~/.nvm ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install latest LTS Node
    nvm install --lts
    nvm use --lts
    
    # Install global npm packages
    npm install -g \
        yarn \
        pnpm \
        typescript \
        ts-node \
        nodemon \
        prettier \
        eslint
fi
print_status "nvm and Node.js tools installed"

# Install Rust and cargo tools
print_installing "Rust toolchain"
if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    
    # Install useful cargo tools
    cargo install \
        ripgrep \
        fd-find \
        bat \
        exa \
        tokei \
        hyperfine
fi
print_status "Rust toolchain installed"

# Setup useful aliases
print_installing "useful aliases and functions"
cat >> ~/.bashrc << 'EOF'

# Useful aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Modern replacements (if available)
command -v batcat &>/dev/null && alias cat='batcat --style=plain'
command -v bat &>/dev/null && alias cat='bat --style=plain'
command -v exa &>/dev/null && alias ls='exa'
command -v rg &>/dev/null && alias grep='rg'
command -v fd &>/dev/null && alias find='fd'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'

# Python aliases
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Development shortcuts
alias serve='python3 -m http.server'
alias json='python3 -m json.tool'

# Quick navigation
alias cw='cd /workspace'

# Useful functions
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Load local configurations if they exist
[ -f ~/.bashrc.local ] && source ~/.bashrc.local

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Load cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# FZF configuration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

EOF
print_status "Aliases and functions configured"

# Create a welcome message
cat > ~/.welcome.txt << 'EOF'
=================================
Development Environment Ready!
=================================
Installed tools:
- Editor: micro
- Python: ipython, black, pytest, poetry
- Node.js: via nvm with yarn, typescript, prettier
- Rust: cargo with ripgrep, fd, bat, exa
- Shell: fzf for fuzzy finding

Type 'alias' to see useful shortcuts.
Type 'cw' to go to /workspace.
=================================
EOF

# Install Claude Code CLI if user wants
print_installing "Claude Code CLI setup"
cat > ~/.local/bin/install-claude-code << 'EOF'
#!/bin/bash
echo "Installing Claude Code CLI..."
cd /tmp
curl -sL https://github.com/anthropics/claude-code/releases/latest/download/claude-code_linux_arm64.tar.gz | tar xz
mv claude-code ~/.local/bin/
echo "Claude Code installed! Run 'claude-code' to start."
EOF
chmod +x ~/.local/bin/install-claude-code
print_status "Claude Code installer ready (run 'install-claude-code' to install)"

echo ""
cat ~/.welcome.txt
echo ""
echo -e "${GREEN}User development tools installed successfully!${NC}"
echo ""
echo "Run these commands to complete setup:"
echo "  source ~/.bashrc"
echo "  install-claude-code  # (optional) Install Claude Code CLI"
echo ""