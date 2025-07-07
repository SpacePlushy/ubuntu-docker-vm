# Ubuntu Docker VM Usage Guide

## Initial Setup

If this is your first time using the container:

```bash
# 1. Start the container
./scripts/start.sh

# 2. Install development tools
./scripts/setup-dev-env.sh

# 3. Verify installation
./scripts/check-tools.sh
```

## Quick Start

### Starting Your Development Session

1. **Start the container** (if not already running):
   ```bash
   ./scripts/start.sh
   ```

2. **Connect to the container**:
   ```bash
   ./scripts/connect.sh
   ```
   Or manually:
   ```bash
   docker exec -it ubuntu-ai-vm bash
   ```

3. **Start developing**:
   ```bash
   # Inside the container
   cd /workspace
   
   # Your tools are ready:
   python3 --version  # Python 3.10.12
   node --version     # v12.22.9
   nvim --version     # Neovim 0.6.1
   ```

### Ending Your Session

1. **Exit the container**:
   ```bash
   exit
   ```

2. **Stop the container** (optional - you can leave it running):
   ```bash
   ./scripts/stop.sh
   ```

## Development Workflow

### Example Python Project

```bash
# Connect to container
./scripts/connect.sh

# Navigate to workspace
cd /workspace

# Create a new project
mkdir my-python-project
cd my-python-project

# Create a virtual environment
python3 -m venv venv
source venv/bin/activate

# Install packages
pip install flask pytest

# Start coding
vim app.py  # or nano app.py
```

### Example Node.js Project

```bash
# Connect to container
./scripts/connect.sh

# Navigate to workspace
cd /workspace

# Create a new project
mkdir my-node-project
cd my-node-project

# Initialize npm project
npm init -y

# Install packages
npm install express jest

# Start coding
vim index.js  # or nano index.js
```

### Installing AI Coding Assistants

#### Claude Code CLI (Recommended)
A simple installer is included:
```bash
# Inside the container
install-claude-code
```

#### Other AI Tools
```bash
# GitHub Copilot CLI
npm install -g @githubnext/github-copilot-cli

# Aider
pip3 install --user aider-chat

# GPT Engineer
pip3 install --user gpt-engineer

# Continue.dev
curl -L https://continue.dev/install.sh | bash
```

## File Management

### Accessing Your Files

All your work is saved in the `/workspace` directory inside the container, which persists between sessions.

**From inside the container:**
```bash
cd /workspace
ls -la
```

**From your host machine:**
```bash
# View container files
docker exec ubuntu-ai-vm ls -la /workspace

# Copy files TO the container
docker cp myfile.txt ubuntu-ai-vm:/workspace/

# Copy files FROM the container
docker cp ubuntu-ai-vm:/workspace/myfile.txt ./

# Copy entire directories
docker cp my-project ubuntu-ai-vm:/workspace/
docker cp ubuntu-ai-vm:/workspace/my-project ./
```

### Backing Up Your Work

To backup your workspace:
```bash
# Create a backup directory
mkdir -p backups

# Backup the entire workspace
docker exec ubuntu-ai-vm tar -czf - -C /workspace . > backups/workspace-$(date +%Y%m%d-%H%M%S).tar.gz
```

To restore from backup:
```bash
# Restore to workspace
docker exec -i ubuntu-ai-vm tar -xzf - -C /workspace < backups/workspace-20240706-123456.tar.gz
```

## Advanced Usage

### Installing Additional Software

The `aiuser` has limited sudo access for package management:

```bash
# Inside the container
sudo apt-get update
sudo apt-get install package-name

# For Python packages (installed to ~/.local/bin)
pip3 install --user package-name

# For Node.js packages
npm install -g package-name

# Check what's installed
pip3 list --user     # Python packages
npm list -g          # Node packages
```

### Working with Git

Git is pre-installed in the container:

```bash
# Configure git (inside container)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Clone repositories
cd /workspace
git clone https://github.com/username/repo.git

# Work with your repos normally
cd repo
git add .
git commit -m "Update: implemented new feature"
git push
```

### Using Different Terminals

You can open multiple terminal sessions:

```bash
# Terminal 1: Run your application
./scripts/connect.sh
python3 app.py

# Terminal 2: Edit code
./scripts/connect.sh
vim app.py  # or use your preferred editor

# Terminal 3: Run tests
./scripts/connect.sh
pytest
```

### Environment Variables

Set persistent environment variables:

```bash
# Inside container
echo 'export MY_VAR="value"' >> ~/.bashrc
source ~/.bashrc
```

## Storage Management

### Understanding Storage

Your container storage works like this:
- **Location**: All files in `/workspace` persist in `./storage/` on your host
- **Dynamic Growth**: Starts at ~200MB, grows as you add files
- **No Auto-Shrink**: Deleted files free space but directory size remains

### Monitoring Storage

```bash
# Check current storage size
./scripts/storage-monitor.sh

# See what's using space inside container
docker exec ubuntu-ai-vm du -sh /workspace/* | sort -hr | head -10

# Check from host
du -sh ~/ubuntu-docker-vm/storage
```

### Optimizing Storage

**1. Clean Caches (Safe - doesn't touch your files)**
```bash
# Run the cleanup script
./scripts/cleanup-container.sh
```

This removes:
- Python pip caches
- npm caches  
- `__pycache__` directories
- `.pyc` files
- Build artifacts
- Log files

**2. Manual Cleanup Inside Container**
```bash
# Connect to container
./scripts/connect.sh

# Clean Python caches
pip cache purge
rm -rf ~/.cache/pip

# Clean npm cache
npm cache clean --force

# Remove old virtual environments
rm -rf /workspace/old-project/venv
```

**3. Project Best Practices**
```bash
# Use .gitignore to prevent tracking large files
echo "venv/" >> .gitignore
echo "node_modules/" >> .gitignore
echo "__pycache__/" >> .gitignore

# Use project-specific virtual environments
cd /workspace/my-project
python3 -m venv venv
source venv/bin/activate
# Work on project...
deactivate
# Can delete venv when project is done
```

### Storage Tips

1. **Regular Maintenance**: Run cleanup weekly or when storage exceeds 5-10GB
2. **Project Isolation**: Use virtual environments per project
3. **Clean Before Backup**: Run cleanup before backing up workspace
4. **Monitor Growth**: Check periodically with `storage-monitor.sh`

## Troubleshooting

### Container Won't Start

**Error: Docker daemon not running**
```bash
# On macOS
open -a Docker
# Wait 30 seconds for Docker to start
./scripts/start.sh
```

**Error: Port already in use**
```bash
# Stop all containers
docker stop $(docker ps -aq)
# Try starting again
./scripts/start.sh
```

### Container Starts but Can't Connect

**Check if container is running:**
```bash
docker ps | grep ubuntu-ai-vm
```

**Check container logs:**
```bash
docker logs ubuntu-ai-vm
```

**Restart the container:**
```bash
./scripts/stop.sh
./scripts/start.sh
```

### Internet Connectivity Issues

**Test connectivity:**
```bash
docker exec ubuntu-ai-vm curl -I https://www.google.com
```

**Check DNS:**
```bash
docker exec ubuntu-ai-vm nslookup google.com
```

**Restart Docker network:**
```bash
docker network prune -f
./scripts/stop.sh
./scripts/start.sh
```

### Development Tool Issues

**Python package not found:**
```bash
# Update pip and reinstall
pip3 install --upgrade pip
pip3 install package-name
```

**Node package issues:**
```bash
# Clear npm cache
npm cache clean --force
# Reinstall dependencies
rm -rf node_modules package-lock.json
npm install
```

**Permission errors:**
```bash
# For global npm packages
npm config set prefix ~/.npm-global
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### Storage Issues

**Check available space:**
```bash
docker exec ubuntu-ai-vm df -h /workspace
```

**Clean up Docker space:**
```bash
# Remove unused images and containers
docker system prune -a
# Clean build cache
docker builder prune
```

**Resize storage (if using sparse file):**
```bash
./scripts/resize-volume.sh 40  # Resize to 40GB
```

### Permission Issues

**Can't write to workspace:**
```bash
# Fix permissions from inside container
sudo chown -R aiuser:aiuser /workspace
```

**Can't install packages:**
```bash
# The aiuser can only use apt-get/apt
sudo apt-get install package-name
# For other sudo commands, you'll need to modify the Dockerfile
```

### Performance Issues

**Container running slowly:**
```bash
# Check resource usage
docker stats ubuntu-ai-vm

# Restart with more resources
# Edit docker-compose.yml and increase:
# - cpus: '4'  # Increase CPU
# - memory: 8G  # Increase RAM
./scripts/stop.sh
./scripts/start.sh
```

## Best Practices

1. **Regular Backups**: Backup your workspace regularly
2. **Git Commits**: Commit your code changes frequently
3. **Container Hygiene**: Stop the container when not in use for extended periods
4. **API Keys**: Never commit API keys to git; use environment variables
5. **Updates**: Periodically update packages inside the container

## Useful Aliases

Add these to your host machine's shell config for convenience:

```bash
# Add to ~/.bashrc or ~/.zshrc
alias ai-start='cd ~/ubuntu-docker-vm && ./scripts/start.sh'
alias ai-connect='cd ~/ubuntu-docker-vm && ./scripts/connect.sh'
alias ai-stop='cd ~/ubuntu-docker-vm && ./scripts/stop.sh'
alias ai-backup='cd ~/ubuntu-docker-vm && docker exec ubuntu-ai-vm tar -czf - -C /workspace . > backups/workspace-$(date +%Y%m%d-%H%M%S).tar.gz'
```

## Emergency Recovery

If something goes wrong:

1. **Save your work** (if possible):
   ```bash
   docker cp ubuntu-ai-vm:/workspace ./workspace-emergency-backup
   ```

2. **Use the rollback script**:
   ```bash
   ./rollback.sh
   ```

3. **Start fresh**:
   ```bash
   ./scripts/start.sh
   ```

4. **Restore your work**:
   ```bash
   docker cp ./workspace-emergency-backup/. ubuntu-ai-vm:/workspace/
   ```

---

## Quick Command Reference

| Task | Command |
|------|---------|
| Start container | `./scripts/start.sh` |
| Connect to container | `./scripts/connect.sh` |
| Stop container | `./scripts/stop.sh` |
| Setup dev tools | `./scripts/setup-dev-env.sh` |
| Check installed tools | `./scripts/check-tools.sh` |
| Monitor storage | `./scripts/storage-monitor.sh` |
| Clean caches | `./scripts/cleanup-container.sh` |
| Check status | `docker ps \| grep ubuntu-ai-vm` |
| View logs | `docker logs ubuntu-ai-vm` |
| Copy file to container | `docker cp file.txt ubuntu-ai-vm:/workspace/` |
| Copy file from container | `docker cp ubuntu-ai-vm:/workspace/file.txt ./` |
| Backup workspace | `docker exec ubuntu-ai-vm tar -czf - -C /workspace . > backup.tar.gz` |
| Start Python shell | `python3` or `ipython` (inside container) |
| Install Python package | `pip3 install --user package` (inside container) |
| Install system package | `sudo apt-get install package` (inside container) |
| Install Claude Code | `install-claude-code` (inside container) |

Remember: All your coding work should be done inside the `/workspace` directory to ensure it persists between container restarts!