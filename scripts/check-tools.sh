#!/bin/bash

echo "==================================="
echo "Checking Installed Tools"
echo "==================================="

# Function to check if command exists
check_tool() {
    if docker exec ubuntu-ai-vm which $1 >/dev/null 2>&1; then
        VERSION=$(docker exec ubuntu-ai-vm $2 2>&1 | head -1)
        echo "✓ $1: $VERSION"
    else
        echo "✗ $1: not found"
    fi
}

# Check core tools
echo ""
echo "Core Development Tools:"
check_tool "python3" "python3 --version"
check_tool "pip3" "pip3 --version"
check_tool "node" "node --version"
check_tool "npm" "npm --version"
check_tool "git" "git --version"

# Check editors
echo ""
echo "Editors:"
check_tool "nvim" "nvim --version"
check_tool "nano" "nano --version"
check_tool "vim" "vim --version"

# Check Python tools
echo ""
echo "Python Tools (in ~/.local/bin):"
docker exec ubuntu-ai-vm bash -c 'export PATH="$HOME/.local/bin:$PATH"; which ipython black flake8 pytest poetry 2>/dev/null | xargs -I {} basename {}'

# Check build tools
echo ""
echo "Build Tools:"
check_tool "gcc" "gcc --version"
check_tool "g++" "g++ --version"
check_tool "make" "make --version"
check_tool "cmake" "cmake --version"

echo ""
echo "==================================="
echo "To install Claude Code CLI:"
echo "1. Connect: ./scripts/connect.sh"
echo "2. Run: install-claude-code"
echo "===================================="