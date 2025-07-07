# Railway Troubleshooting Guide

## VS Code Extensions Not Loading

### Problem
When searching for extensions in the Railway-deployed VS Code, you see "no extensions found".

### Solution Applied
1. **Configured Open VSX Marketplace** - Added environment variables to use Open VSX instead of Microsoft marketplace
2. **Fixed Extensions Directory** - Ensured proper permissions and directory structure
3. **Added Custom Entrypoint** - Created `railway-entrypoint.sh` for proper initialization
4. **Project Files Included** - Your project files are now copied to `/workspace` in the cloud

### Verification Steps
1. Wait for deployment to complete (check Railway dashboard)
2. Access your VS Code instance at your Railway URL
3. Open Extensions panel (Ctrl+Shift+X or Cmd+Shift+X)
4. Search for any extension (e.g., "Python", "GitLens")
5. You should now see results from Open VSX marketplace

### Installing Extensions
1. Search for extensions in the marketplace
2. Click "Install" on desired extensions
3. Extensions persist between sessions
4. Some popular extensions:
   - Python
   - GitLens
   - Prettier
   - ESLint
   - Docker

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