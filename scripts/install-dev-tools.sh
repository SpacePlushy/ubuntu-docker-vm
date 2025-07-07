#!/bin/bash
set -e

echo "==================================="
echo "Installing Essential Dev Tools"
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

# Update package manager
print_installing "system updates"
sudo apt-get update -qq

# Essential build tools
print_installing "build essentials"
sudo apt-get install -y -qq \
    build-essential \
    make \
    cmake \
    gcc \
    g++ \
    gdb \
    valgrind
print_status "Build tools installed"

# Modern code editors
print_installing "code editors"
sudo apt-get install -y -qq neovim
# Install micro editor
curl -sL https://getmic.ro | bash >/dev/null 2>&1
sudo mv micro /usr/local/bin/ 2>/dev/null || true
print_status "Code editors installed"

# Python development tools
print_installing "Python development tools"
sudo apt-get install -y -qq python3-pip python3-venv python3-dev
# Upgrade pip
pip3 install --user --upgrade pip >/dev/null 2>&1
# Install Python packages
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
    poetry >/dev/null 2>&1
print_status "Python tools installed"

# Node.js tools
print_installing "Node.js development tools"
# Update npm
npm install -g npm@latest >/dev/null 2>&1
# Install global Node packages
npm install -g \
    yarn \
    pnpm \
    typescript \
    ts-node \
    nodemon \
    eslint \
    prettier \
    jest >/dev/null 2>&1
print_status "Node.js tools installed"

# Database clients
print_installing "database clients"
sudo apt-get install -y -qq \
    postgresql-client \
    mysql-client \
    redis-tools \
    sqlite3 \
    mongodb-clients
print_status "Database clients installed"

# Network and API tools
print_installing "network and API tools"
sudo apt-get install -y -qq \
    jq \
    httpie \
    dnsutils \
    traceroute \
    mtr \
    iperf3
print_status "Network tools installed"

# Terminal tools
print_installing "terminal tools"
sudo apt-get install -y -qq \
    tmux \
    screen \
    htop \
    ncdu \
    tree \
    ripgrep \
    fd-find \
    bat \
    exa \
    tldr \
    neofetch
print_status "Terminal tools installed"

# Install fzf (fuzzy finder)
print_installing "fzf (fuzzy finder)"
if [ ! -d ~/.fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf >/dev/null 2>&1
    ~/.fzf/install --all --no-bash --no-zsh --no-fish >/dev/null 2>&1
fi
print_status "fzf installed"

# Install websocat for WebSocket testing
print_installing "websocat"
if ! command -v websocat &> /dev/null; then
    wget -q https://github.com/vi/websocat/releases/latest/download/websocat.aarch64-unknown-linux-musl
    chmod +x websocat.aarch64-unknown-linux-musl
    sudo mv websocat.aarch64-unknown-linux-musl /usr/local/bin/websocat
fi
print_status "websocat installed"

# Docker CLI (to interact with host Docker)
print_installing "Docker CLI"
sudo apt-get install -y -qq docker.io
print_status "Docker CLI installed"

# Additional useful tools
print_installing "additional tools"
sudo apt-get install -y -qq \
    zip \
    unzip \
    p7zip-full \
    dos2unix \
    shellcheck \
    silversearcher-ag \
    direnv \
    entr \
    xz-utils \
    bzip2 \
    gzip
print_status "Additional tools installed"

# Setup some useful aliases
print_installing "useful aliases"
cat >> ~/.bashrc << 'EOF'

# Useful aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Modern replacements
alias cat='batcat --style=plain' 2>/dev/null || alias cat='cat'
alias ls='exa' 2>/dev/null || alias ls='ls'
alias find='fdfind' 2>/dev/null || alias find='find'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'

# Python aliases
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Development shortcuts
alias serve='python3 -m http.server'
alias json='python3 -m json.tool'

# Docker shortcuts
alias dps='docker ps'
alias dimg='docker images'
alias dexec='docker exec -it'

EOF
print_status "Aliases configured"

# Create a welcome message
cat > ~/.welcome.txt << 'EOF'
=================================
Development Environment Ready!
=================================
Installed tools:
- Editors: neovim, micro
- Python: ipython, black, pytest, poetry
- Node.js: yarn, typescript, prettier
- Databases: postgresql, mysql, redis, sqlite clients
- Network: httpie, jq, websocat
- Terminal: tmux, fzf, ripgrep, bat
- And many more!

Type 'alias' to see useful shortcuts.
=================================
EOF

# Clean up
print_installing "cleanup"
sudo apt-get autoremove -y -qq
sudo apt-get clean
rm -rf /var/lib/apt/lists/*
print_status "Cleanup complete"

echo ""
cat ~/.welcome.txt
echo ""
echo -e "${GREEN}All development tools installed successfully!${NC}"
echo "Please run 'source ~/.bashrc' to load new aliases."