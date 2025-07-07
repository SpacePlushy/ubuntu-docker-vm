# Quick Start Guide

## 🚀 5-Minute Setup

### Local Development (Docker)

```bash
# 1. Clone the repo
git clone https://github.com/SpacePlushy/ubuntu-docker-vm.git
cd ubuntu-docker-vm

# 2. Start container
./scripts/start.sh

# 3. Install dev tools (first time only)
./scripts/setup-dev-env.sh

# 4. Connect and code!
./scripts/connect.sh
```

### Cloud Development (Railway)

```bash
# 1. Deploy to cloud
./deploy-to-railway.sh

# 2. Get your URL from Railway dashboard
# 3. Open in browser, enter password from railway-credentials.txt
# 4. Code from anywhere!
```

## 📁 What You Get

- **Ubuntu 22.04** environment
- **Python 3.10** + pip, ipython, black, pytest
- **Node.js 12** + npm, yarn
- **Editors**: Neovim, Vim, Nano
- **Tools**: Git, Docker CLI, build tools
- **Cloud**: VS Code in browser

## 🎯 Common Tasks

### Install AI Coding Assistant
```bash
# Inside container
install-claude-code
```

### Create Python Project
```bash
cd /workspace
mkdir my-project && cd my-project
python3 -m venv venv
source venv/bin/activate
pip install flask pandas
```

### Save Your Work
```bash
# Backup locally
docker cp ubuntu-ai-vm:/workspace/my-project ./

# Or use Git
git add .
git commit -m "Save progress"
git push
```

### Check Storage
```bash
./scripts/storage-monitor.sh
```

### Clean Caches
```bash
./scripts/cleanup-container.sh
```

## 🌍 Access From Anywhere

1. Deploy to Railway (see RAILWAY_GUIDE.md)
2. Get public URL
3. Code from any device with a browser
4. iPad, Chromebook, phone - it all works!

## 📚 Full Documentation

- **[README.md](README.md)** - Project overview
- **[USAGE_GUIDE.md](USAGE_GUIDE.md)** - Detailed local usage
- **[RAILWAY_GUIDE.md](RAILWAY_GUIDE.md)** - Cloud deployment
- **[INSTALLED_TOOLS.md](INSTALLED_TOOLS.md)** - Tool reference

## ⚡ Tips

- **Performance**: 2GB+ RAM recommended
- **Storage**: Starts at ~200MB, grows as needed
- **Cloud**: Costs ~$0.01/hour on Railway
- **Persistence**: Everything in /workspace is saved

## 🆘 Quick Fixes

**Container won't start?**
```bash
docker ps -a  # Check status
./scripts/stop.sh && ./scripts/start.sh  # Restart
```

**Can't connect to cloud?**
1. Check Railway dashboard for URL
2. Ensure deployment is "Active"
3. Password is in `railway-credentials.txt`

**Need more tools?**
```bash
# Inside container
sudo apt-get update && sudo apt-get install package-name
pip3 install --user package-name
```

---
Ready to code? Start with local Docker or jump straight to cloud! 🎉