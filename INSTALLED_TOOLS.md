# Installed Development Tools Reference

This document lists all the development tools pre-installed in the Ubuntu Docker VM.

## Core Languages & Runtimes

### Python
- **Version**: 3.10.12
- **Package Manager**: pip 25.1.1
- **Location**: System Python at `/usr/bin/python3`

### Node.js
- **Version**: 12.22.9
- **Package Manager**: npm 8.5.1
- **Location**: System Node at `/usr/bin/node`

## Code Editors

### Neovim
- **Version**: 0.6.1
- **Command**: `nvim`
- **Config**: `~/.config/nvim/`

### Vim
- **Version**: 8.2
- **Command**: `vim`
- **Config**: `~/.vimrc`

### Nano
- **Version**: 6.2
- **Command**: `nano`
- **Config**: `~/.nanorc`

## Build Tools

### Compilers
- **gcc**: 11.4.0 (Ubuntu 11.4.0-1ubuntu1~22.04)
- **g++**: 11.4.0 (Ubuntu 11.4.0-1ubuntu1~22.04)

### Build Systems
- **make**: GNU Make 4.3
- **cmake**: 3.22.1

### Debugging
- **gdb**: GNU Debugger 12.1
- **valgrind**: Memory debugging tool 3.18.1

## Python Development Tools

All Python tools are installed in `~/.local/bin` (automatically in PATH).

### Interactive Shell
- **ipython**: Enhanced Python REPL

### Code Quality
- **black**: Code formatter
- **flake8**: Style guide enforcer
- **pylint**: Code analysis tool
- **isort**: Import statement organizer

### Testing
- **pytest**: Testing framework
- **pytest-cov**: Coverage plugin for pytest
- **coverage**: Code coverage measurement

### Package Management
- **poetry**: Dependency management and packaging tool
- **virtualenv**: Virtual environment creator
- **pip**: Package installer (upgraded)

### HTTP Tools
- **httpie**: User-friendly HTTP client
- **requests**: HTTP library (installed)

### CLI Development
- **click**: Command line interface creation kit
- **typer**: Modern CLI building library
- **rich**: Terminal formatting library

## Version Control
- **git**: 2.34.1

## System Tools

### Package Management
- **apt-get**: Debian package manager (with limited sudo access)
- **dpkg**: Low-level package manager

### Network Tools
- **curl**: Command line HTTP client
- **wget**: Network downloader
- **ping**: Network testing (requires different permissions)
- **netstat**: Network statistics

### Process Management
- **htop**: Interactive process viewer
- **ps**: Process status
- **top**: Task manager

### File Operations
- **tree**: Directory structure viewer
- **find**: File search
- **grep**: Text search

## User Information

### Default User
- **Username**: aiuser
- **Home Directory**: /workspace
- **Shell**: /bin/bash
- **Sudo Access**: Limited to `apt-get` and `apt` commands only

### Environment Variables
- `HOME=/workspace`
- `USER=aiuser`
- `PATH` includes `~/.local/bin`

## AI Assistant Installation

### Claude Code CLI
```bash
# Quick installer available
install-claude-code
```

### Manual Installation for Other AI Tools
```bash
# Aider
pip3 install --user aider-chat

# GitHub Copilot CLI
npm install -g @githubnext/github-copilot-cli

# GPT Engineer
pip3 install --user gpt-engineer
```

## Storage & Persistence

- **Workspace Directory**: `/workspace`
- **Persistence**: All files in `/workspace` persist between container restarts
- **Python Packages**: User packages in `~/.local/`
- **Configuration**: User configs in `/workspace/.config/`

## Useful Aliases

The following aliases are configured in `~/.bashrc`:

```bash
# Navigation
alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'
alias cw='cd /workspace'

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Development
alias serve='python3 -m http.server'
alias json='python3 -m json.tool'
```

## Notes

1. **Security**: The container runs with limited privileges. Some operations requiring elevated permissions may not work.

2. **Package Installation**: 
   - System packages: Use `sudo apt-get install`
   - Python packages: Use `pip3 install --user`
   - Node packages: Use `npm install -g`

3. **File Permissions**: The aiuser owns the `/workspace` directory and can freely create/modify files there.

4. **Network Access**: Full internet connectivity is available for downloading packages and accessing external resources.