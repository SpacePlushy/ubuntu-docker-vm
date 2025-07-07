# Railway Troubleshooting Guide

## VS Code Extensions Not Loading - FIXED

### Problem
When searching for extensions in the Railway-deployed VS Code, you see "no extensions found".

### Solution Applied
We've switched from code-server to **OpenVSCode Server** which provides:
1. **Full Microsoft Marketplace Access** - All official VS Code extensions available
2. **Pre-installed Extensions** - 20 popular extensions installed during build
3. **Pre-installed Dev Tools** - Python and Node.js tools ready to use
4. **Robust Extension Management** - Using official CLI for installations

### Verification Steps
1. Wait for deployment to complete (check Railway dashboard)
2. Access your VS Code instance at your Railway URL
3. Open Extensions panel (Ctrl+Shift+X or Cmd+Shift+X)
4. You'll see pre-installed extensions already there
5. Search for any extension - full Microsoft marketplace available

### Pre-installed Extensions
- Python, Pylance, Jupyter
- GitLens, Prettier, ESLint
- Docker, GitHub Copilot
- And 12 more popular extensions

### Installing More Extensions
```bash
# Via UI: Just search and click install!

# Via terminal:
/opt/openvscode-server/bin/openvscode-server --install-extension <extension-id>

# List installed:
/opt/openvscode-server/bin/openvscode-server --list-extensions
```

## Empty Workspace

### Problem
The `/workspace` directory was empty in the cloud environment.

### Solution
The updated Dockerfile now copies your project files to `/workspace`, excluding:
- `storage/` directory (large container storage)
- `railway-credentials.txt` (sensitive)

### Access Your Files
```bash
cd /workspace
ls -la
```

You'll see all your project files including:
- Scripts directory
- Documentation files
- Configuration files
- Dockerfiles

## Common Issues

### 1. Extensions Still Not Working
If extensions still don't load after the fix:
```bash
# In VS Code terminal
code-server --list-extensions
# Should show installed extensions

# Manually install an extension
code-server --install-extension ms-python.python
```

### 2. Password Issues
Your password is stored in `railway-credentials.txt`. If you need to change it:
1. Go to Railway dashboard
2. Add environment variable: `PASSWORD=your-new-password`
3. Redeploy the service

### 3. Project Files Missing
If some files are missing:
```bash
# Clone your repo in the cloud
cd /workspace
git clone https://github.com/SpacePlushy/ubuntu-docker-vm.git temp
cp -r temp/* .
rm -rf temp
```

### 4. Performance Issues
If VS Code is slow:
1. Upgrade Railway resources (RAM/CPU)
2. Clean unnecessary files:
   ```bash
   # Remove caches
   rm -rf ~/.cache/*
   rm -rf ~/.npm/*
   ```

## Deployment Commands

### Quick Redeploy
```bash
# From your local machine
railway up --service ubuntu-docker-vm
```

### Check Logs
```bash
railway logs --service ubuntu-docker-vm
```

### Environment Variables
```bash
# List current env vars
railway variables

# Add new variable
railway variables set KEY=value
```

## Next Steps

1. **Install Development Tools**
   ```bash
   # In VS Code terminal
   cd /workspace
   ./scripts/setup-dev-env.sh
   ```

2. **Install AI Assistants**
   ```bash
   # Claude Code
   curl -fsSL https://github.com/anthropics/claude-code/releases/latest/download/install.sh | sh
   
   # GitHub Copilot
   npm install -g @githubnext/github-copilot-cli
   ```

3. **Configure Git**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

## Support Resources

- Railway Status: https://railway.app/project/79e45975-df5a-4d0c-bb90-3f737bc29da5
- Railway Docs: https://docs.railway.app
- Open VSX Marketplace: https://open-vsx.org
- Code Server Docs: https://coder.com/docs/code-server/latest