# Ubuntu Docker VM

## Overview
This project sets up an isolated Ubuntu environment in a Docker container for development work. The setup provides complete isolation from the host filesystem while maintaining internet access.

## Features
- Ubuntu 22.04 LTS base image
- Complete isolation from host filesystem
- Internet access enabled
- Persistent storage in /workspace
- Development tools pre-installed:
  - **Languages**: Python 3.10.12, Node.js 12.22.9
  - **Editors**: Neovim, Vim, Nano
  - **Build Tools**: gcc, g++, make, cmake
  - **Python Tools**: pip, ipython, black, flake8, pytest, poetry
  - **Version Control**: Git
- Non-root user (aiuser) with limited sudo access
- Ready for AI coding assistants (Claude Code, GitHub Copilot, etc.)

## Prerequisites
- Docker installed and running
- Docker Compose installed
- Sufficient disk space (at least 20GB free)

## Quick Start

1. **Initial Setup** (first time only):
   ```bash
   ./scripts/start.sh
   ./scripts/setup-dev-env.sh  # Installs dev tools
   ```

2. **Daily Usage:**
   ```bash
   ./scripts/start.sh          # Start container
   ./scripts/connect.sh        # Connect to container
   # ... do your work ...
   ./scripts/stop.sh           # Stop when done (optional)
   ```

3. **Check Installed Tools:**
   ```bash
   ./scripts/check-tools.sh
   ```

## Documentation

- **[USAGE_GUIDE.md](USAGE_GUIDE.md)** - Comprehensive usage guide with examples
- **[INSTALLED_TOOLS.md](INSTALLED_TOOLS.md)** - Complete list of pre-installed development tools
- **[PLAN.md](PLAN.md)** - Original implementation plan

## File Structure
```
ubuntu-docker-vm/
├── README.md                    # This file
├── USAGE_GUIDE.md              # Detailed usage instructions
├── INSTALLED_TOOLS.md          # List of all installed tools
├── PLAN.md                     # Implementation plan
├── Dockerfile                  # Container definition
├── docker-compose.yml          # Container orchestration
├── rollback.sh                 # Emergency rollback script
├── test-setup.sh               # Automated tests
├── backups/                    # Backup directory
├── storage/                    # Container storage
├── scripts/                    # Management scripts
│   ├── start.sh               # Start container
│   ├── stop.sh                # Stop container
│   ├── connect.sh             # Connect to container
│   ├── setup-dev-env.sh       # Install dev tools
│   ├── check-tools.sh         # Verify installations
│   ├── cleanup-container.sh   # Clean caches and temp files
│   ├── storage-monitor.sh     # Monitor storage usage
│   ├── install-user-tools.sh  # User-space tool installer
│   ├── mount-storage.sh       # Storage info
│   └── resize-volume.sh       # Resize storage
└── config/                     # Configuration files
    └── security.json          # Security policies
```

## Management Scripts

### start.sh
Builds and starts the Ubuntu VM container. If the container already exists, it will just start it without rebuilding.

### stop.sh
Stops and removes the running container.

### connect.sh
Opens an interactive bash session in the container.

### setup-dev-env.sh
Installs additional development tools in the container (Python packages, editors, etc.)

### check-tools.sh
Verifies all installed development tools and their versions.

### cleanup-container.sh
Safely removes caches and temporary files to optimize storage without affecting your project files.

### storage-monitor.sh
Monitors storage usage and alerts when exceeding thresholds.

### resize-volume.sh
Resizes the storage volume. Usage:
```bash
./scripts/resize-volume.sh 30  # Resize to 30GB
```

### rollback.sh
Removes all created Docker resources and restores backed up resources if available.

## Testing
Run the automated test script to verify the setup:
```bash
./test-setup.sh
```

## Security
- Container runs as non-root user (aiuser)
- Limited sudo permissions (only apt-get and apt)
- Network isolation with bridge network
- Resource limits enforced (2 CPUs, 4GB RAM)
- No access to host filesystem

## Troubleshooting

### Docker not running
Ensure Docker Desktop or Docker daemon is running before executing scripts.

### Permission denied
Make sure all scripts are executable:
```bash
chmod +x ./scripts/*.sh ./test-setup.sh ./rollback.sh
```

### Storage issues
The storage uses a sparse file system. If you need more space:
```bash
./scripts/resize-volume.sh 40  # Resize to 40GB
```

## Cloud Deployment (Railway)

Deploy to the cloud with VS Code in browser:
```bash
./deploy-to-railway.sh
```
- Creates a cloud Ubuntu environment accessible from anywhere
- Includes VS Code in browser (code-server)
- Your password is saved in `railway-credentials.txt` (git-ignored)

## Storage Management

The container storage grows dynamically as you add files:
- **Current size**: Check with `./scripts/storage-monitor.sh`
- **Clean caches**: Run `./scripts/cleanup-container.sh` 
- **What uses space**: Your files in `/workspace/`, package caches, logs
- **Optimization**: Storage doesn't auto-shrink but you can clean caches safely

## Notes
- Storage starts small (~200MB) and grows as needed
- Only uses disk space for actual files (no pre-allocation)
- Internet connectivity is enabled by default
- Development tools (Python, Node.js, Git) are pre-installed
- You can install additional tools including AI assistants as needed