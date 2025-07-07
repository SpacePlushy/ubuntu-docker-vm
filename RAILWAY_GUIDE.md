# Railway Cloud Deployment Guide

## Table of Contents
1. [Overview](#overview)
2. [Initial Setup](#initial-setup)
3. [Deployment](#deployment)
4. [Accessing Your Environment](#accessing-your-environment)
5. [First Time Configuration](#first-time-configuration)
6. [Daily Usage](#daily-usage)
7. [Custom Domain Setup](#custom-domain-setup)
8. [Managing Costs](#managing-costs)
9. [Troubleshooting](#troubleshooting)

## Overview

Railway provides a cloud Ubuntu development environment with VS Code accessible from any browser. Perfect for:
- Coding from any device (iPad, Chromebook, etc.)
- Consistent environment across machines
- Team collaboration
- Running long processes

## Initial Setup

### Prerequisites
- Railway account (sign up at https://railway.app)
- Node.js installed locally (for Railway CLI)
- This repository cloned locally

### Step 1: Install Railway CLI
```bash
npm install -g @railway/cli
```

### Step 2: Login to Railway
```bash
# Run from the ubuntu-docker-vm directory
./deploy-to-railway.sh

# When prompted, choose:
# - Option 1 for browser login (if it works)
# - Option 2 for browserless login (copy/paste URL)
```

### Step 3: Deploy
The script automatically:
- Creates a secure password
- Configures code-server
- Deploys to Railway
- Saves credentials locally

## Deployment

### Automatic Deployment
```bash
./deploy-to-railway.sh
```

### Manual Deployment
If the script has issues:
```bash
# 1. Login
railway login --browserless

# 2. Create project
railway init -n ubuntu-docker-vm

# 3. Deploy
railway up

# 4. Check logs
railway logs
```

## Accessing Your Environment

### 1. Get Your URL
After deployment completes:
1. Go to https://railway.app/dashboard
2. Click on your project
3. Click on the service
4. Go to **Settings** tab
5. Under **Networking**, click **Generate Domain**
6. Copy your URL (e.g., `ubuntu-docker-vm-production.up.railway.app`)

### 2. Login to VS Code
1. Open your Railway URL in any browser
2. Enter your password from `railway-credentials.txt`
3. You now have VS Code in your browser!

### 3. Bookmark It
Save the URL for quick access from any device.

## First Time Configuration

Once logged into VS Code:

### 1. Open Terminal
- Menu: Terminal → New Terminal
- Or press `` Ctrl+` `` (or `` Cmd+` `` on Mac)

### 2. Install Development Tools
```bash
cd /workspace
bash scripts/setup-dev-env.sh
```
This installs Python tools, editors, and utilities.

### 3. Configure Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 4. Install VS Code Extensions
Click Extensions icon and install:
- Python
- GitLens
- Prettier
- Your preferred theme

### 5. Install AI Assistants (Optional)
```bash
# Claude Code
install-claude-code

# GitHub Copilot
npm install -g @githubnext/github-copilot-cli

# Aider
pip3 install --user aider-chat
```

## Daily Usage

### Starting Work
1. Open your Railway URL
2. Enter password
3. Your workspace is exactly as you left it

### File Management
- **Upload files**: Drag and drop into VS Code
- **Download files**: Right-click → Download
- **Terminal access**: Full Ubuntu terminal

### Running Applications
```bash
# Python web server
python3 -m http.server 8000

# Node.js app
node app.js

# Long running processes work fine
# They continue even if you close browser
```

### Saving Work
- All files in `/workspace` persist
- Use git to backup:
```bash
cd /workspace/my-project
git add .
git commit -m "Save work"
git push
```

## Custom Domain Setup

### 1. Add Domain in Railway
1. Go to project Settings → Domains
2. Click "Add Custom Domain"
3. Enter: `code.yourdomain.com`

### 2. Configure DNS
Add CNAME record:
- Type: CNAME
- Name: code
- Value: your-app.up.railway.app

### 3. Access via Custom Domain
After DNS propagates (~5-30 mins):
```
https://code.yourdomain.com
```

## Managing Costs

### Free Tier
- $5 initial credit
- ~500 hours of usage
- No credit card required

### Usage Optimization
1. **Stop when not using**:
   ```bash
   # In Railway dashboard
   Service → Settings → Remove
   ```

2. **Restart when needed**:
   ```bash
   railway up
   ```

3. **Monitor usage**:
   - Check dashboard for remaining credits
   - ~$0.01/hour when running

### Cost Calculation
- 8 hours/day = ~$2.40/month
- 24/7 running = ~$7.20/month
- Stop on weekends = ~$1.60/month

## Troubleshooting

### Can't Connect to VS Code
1. **Check deployment status**:
   ```bash
   railway logs
   ```
2. **Ensure domain is generated** in Railway settings
3. **Try different browser** (Chrome/Firefox work best)

### Forgot Password
Check local file:
```bash
cat railway-credentials.txt
```

### Deployment Failed
1. **Check logs**:
   ```bash
   railway logs
   ```
2. **Common fixes**:
   - Ensure Dockerfile.railway exists
   - Check Railway credits
   - Try redeploying

### Performance Issues
1. **Upgrade resources** in Railway settings
2. **Clean caches**:
   ```bash
   docker exec ubuntu-ai-vm /workspace/scripts/cleanup-container.sh
   ```

### Connection Drops
- Railway apps sleep after 30 mins inactivity
- Just refresh the page to wake up

### VS Code Extensions Missing
Extensions are user-specific. Reinstall after first login:
1. Open Extensions panel
2. Search and install needed extensions
3. They'll persist for your user

## Advanced Usage

### Environment Variables
Set in Railway dashboard:
- PASSWORD - Change VS Code password
- PORT - Change port (default 8080)

### Scaling
In Railway settings:
- Increase RAM/CPU as needed
- Add persistent volumes
- Enable horizontal scaling

### Team Access
1. Share URL and password
2. Or create multiple deployments
3. Use Railway teams feature

## Tips & Tricks

1. **iPad/Tablet Usage**:
   - Add to home screen for app-like experience
   - External keyboard recommended

2. **Offline Work**:
   - Clone to local machine when traveling
   - Sync back to cloud when online

3. **Multiple Projects**:
   - Use different folders in /workspace
   - Or deploy multiple instances

4. **Backup Strategy**:
   - Push to GitHub regularly
   - Download important files
   - Use Railway backups

## Quick Reference

| Task | Command/Action |
|------|----------------|
| Deploy | `./deploy-to-railway.sh` |
| Get URL | Railway dashboard → Service → Settings → Networking |
| View logs | `railway logs` |
| Stop service | Railway dashboard → Remove |
| Restart | `railway up` |
| Check status | `railway status` |
| Local password | `cat railway-credentials.txt` |

## Support

- Railway docs: https://docs.railway.app
- Railway Discord: https://discord.gg/railway
- This project: https://github.com/SpacePlushy/ubuntu-docker-vm