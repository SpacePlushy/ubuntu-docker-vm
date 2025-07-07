# Official VS Code Marketplace Setup

## Overview

This updated setup uses **OpenVSCode Server** (by Gitpod) which provides:
- ✅ Full access to Microsoft's official VS Code marketplace
- ✅ All VS Code extensions available
- ✅ Pre-installed development tools
- ✅ Pre-installed popular extensions
- ✅ Better compatibility with VS Code features

## What Changed

### Previous Setup (code-server)
- ❌ No access to Microsoft marketplace
- ❌ Limited to Open VSX extensions
- ❌ Some extensions incompatible

### New Setup (OpenVSCode Server)
- ✅ Full Microsoft marketplace access
- ✅ All official extensions work
- ✅ Extensions pre-installed during build
- ✅ Development tools pre-installed

## Pre-installed Tools

### Programming Languages & Runtimes
- Python 3.10 with pip
- Node.js 18.x with npm
- Build essentials (gcc, g++, make)

### Python Tools
- ipython - Interactive Python shell
- black - Code formatter
- flake8 - Linter
- mypy - Type checker
- pytest - Testing framework
- poetry - Dependency management
- numpy, pandas, matplotlib - Data science

### Node.js Tools
- yarn - Package manager
- typescript - TypeScript compiler
- eslint - Linter
- prettier - Code formatter
- nodemon - Auto-restart on changes
- pm2 - Process manager

### Pre-installed VS Code Extensions
1. **Python** - Full Python support
2. **Pylance** - Python language server
3. **Jupyter** - Notebook support
4. **Prettier** - Code formatting
5. **GitLens** - Git superpowers
6. **ESLint** - JavaScript linting
7. **C/C++** - C/C++ support
8. **Go** - Go language support
9. **Rust Analyzer** - Rust support
10. **Docker** - Docker support
11. **GitHub Copilot** - AI assistance
12. **Dev Containers** - Container development
13. **Code Runner** - Run code snippets
14. **Live Server** - Live preview
15. **Material Icons** - Better icons
16. **One Dark Pro** - Popular theme
17. **Vim** - Vim emulation
18. **EditorConfig** - Editor config support

## How to Deploy

1. **Commit and push changes**:
   ```bash
   git add -A
   git commit -m "Switch to official VS Code marketplace"
   git push origin feat/official-vscode-marketplace
   ```

2. **Create PR**:
   ```bash
   gh pr create --title "feat: Switch to official VS Code marketplace with pre-installed tools" \
                --body "Switch from code-server to OpenVSCode Server for full marketplace access"
   ```

3. **Deploy to Railway**:
   ```bash
   railway up --service ubuntu-docker-vm
   ```

## Using the New Setup

### First Time
1. Access your Railway URL
2. Enter password from `railway-credentials.txt`
3. All extensions are pre-installed!
4. Open terminal and verify tools:
   ```bash
   python3 --version
   node --version
   npm list -g
   ```

### Installing More Extensions
1. Open Extensions panel (Ctrl+Shift+X)
2. Search any extension from official marketplace
3. Click Install - it works instantly!

### Manual Extension Installation
If you need to install extensions via terminal:
```bash
# Run the installer script again
~/install-extensions.sh

# Or install specific extension
/opt/openvscode-server/bin/openvscode-server \
  --install-extension ms-python.python
```

## Benefits

1. **No Configuration Needed** - Works out of the box
2. **Faster Startup** - Extensions pre-installed
3. **Full Compatibility** - All Microsoft extensions work
4. **Better Performance** - Optimized for web
5. **Regular Updates** - Maintained by Gitpod team

## Troubleshooting

### Extensions Not Showing
```bash
# List installed extensions
/opt/openvscode-server/bin/openvscode-server --list-extensions

# Reinstall extensions
~/install-extensions.sh
```

### Performance Issues
The new setup includes more tools, so initial build is larger but provides better developer experience.

### Custom Extensions
You can modify `install-extensions.sh` to add your favorite extensions.

## Cost Impact

- Slightly larger image size (~500MB more)
- Same runtime performance
- Better developer experience
- No additional Railway costs

## Next Steps

After deployment:
1. All tools are ready to use
2. Extensions are pre-installed
3. Start coding immediately!
4. Install Claude Code: `curl -fsSL https://claude.ai/install.sh | sh`