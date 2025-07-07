# Ubuntu Docker VM with AI Coding Assistant - Autonomous Execution Plan

## Overview
This document provides step-by-step instructions for an AI assistant to autonomously set up an isolated Ubuntu environment in a Docker container. The AI should execute these commands, observe outputs, and debug as needed without requiring user intervention.

## Pre-execution Backup Protocol
Before making any changes, the AI must:
1. Check for existing Docker resources and back them up
2. Create a rollback script before proceeding
3. Log all actions for potential recovery

## Key Requirements
- Ubuntu VM running in Docker container
- Complete isolation from host filesystem
- Internet access enabled
- 20GB storage (resizable)
- Sparse file system (only loads used data into memory)
- AI coding assistant pre-installed
- Restricted permissions for AI operations
- Fully autonomous execution (no user prompts)

## Step-by-Step Implementation

### Step 0: Create Backup and Rollback System
```bash
# Create backup directory
mkdir -p ./backups

# Create rollback script
cat > ./rollback.sh << 'EOF'
#!/bin/bash
echo "Rolling back changes..."
# Stop and remove containers if they exist
docker-compose down 2>/dev/null || true
docker stop ubuntu-ai-vm 2>/dev/null || true
docker rm ubuntu-ai-vm 2>/dev/null || true
# Remove created volumes
docker volume rm ubuntu-ai-vm-storage 2>/dev/null || true
# Remove created networks
docker network rm ai-vm-network 2>/dev/null || true
# Restore backed up Docker resources if they exist
if [ -f ./backups/docker-backup.tar ]; then
    docker load < ./backups/docker-backup.tar
fi
echo "Rollback complete"
EOF
chmod +x ./rollback.sh

# Backup existing Docker resources
docker ps -a --format "{{.Names}}" | grep -E "ubuntu-ai-vm|ai-vm" > ./backups/existing-containers.txt 2>/dev/null || true
docker volume ls --format "{{.Name}}" | grep -E "ubuntu-ai-vm|ai-vm" > ./backups/existing-volumes.txt 2>/dev/null || true
docker network ls --format "{{.Name}}" | grep -E "ai-vm" > ./backups/existing-networks.txt 2>/dev/null || true
```

### Step 1: Create Dockerfile
```bash
cat > Dockerfile << 'EOF'
FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update and install essential packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    nodejs \
    npm \
    build-essential \
    sudo \
    vim \
    nano \
    htop \
    net-tools \
    iputils-ping \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user with limited privileges
RUN useradd -m -s /bin/bash -u 1000 aiuser && \
    echo 'aiuser ALL=(ALL) NOPASSWD: /usr/bin/apt-get, /usr/bin/apt' >> /etc/sudoers.d/aiuser

# Install AI coding assistant (using aider as example)
RUN pip3 install aider-chat

# Create working directory
RUN mkdir -p /workspace && chown -R aiuser:aiuser /workspace

# Switch to non-root user
USER aiuser
WORKDIR /workspace

# Set up sparse file for efficient storage
RUN truncate -s 0 /workspace/.sparse-marker

CMD ["/bin/bash"]
EOF
```

### Step 2: Create docker-compose.yml
```bash
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  ubuntu-ai-vm:
    build: .
    container_name: ubuntu-ai-vm
    hostname: ai-workspace
    user: aiuser
    working_dir: /workspace
    
    # Security settings
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
      - DAC_OVERRIDE
      - FOWNER
      - SETGID
      - SETUID
    
    # Resource limits
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          memory: 1G
    
    # Network configuration
    networks:
      - ai-vm-network
    
    # Volume configuration
    volumes:
      - ubuntu-ai-vm-storage:/workspace
      - type: tmpfs
        target: /tmp
        tmpfs:
          size: 1G
    
    # Environment variables
    environment:
      - HOME=/workspace
      - USER=aiuser
    
    # Keep container running
    stdin_open: true
    tty: true

networks:
  ai-vm-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.30.0.0/24

volumes:
  ubuntu-ai-vm-storage:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: ${PWD}/storage
EOF
```

### Step 3: Create Storage with Size Limit
```bash
# Create storage directory
mkdir -p ./storage

# Create sparse file for storage (20GB)
dd if=/dev/zero of=./storage.img bs=1 count=0 seek=20G

# Create filesystem on the sparse file
mkfs.ext4 ./storage.img

# Mount script (for systems that support it)
cat > ./scripts/mount-storage.sh << 'EOF'
#!/bin/bash
# This script is for reference - Docker will handle the volume
echo "Storage configuration:"
echo "- Type: Sparse file"
echo "- Size: 20GB (allocated on demand)"
echo "- Location: ./storage.img"
EOF
chmod +x ./scripts/mount-storage.sh
```

### Step 4: Create Management Scripts
```bash
mkdir -p ./scripts

# Start script
cat > ./scripts/start.sh << 'EOF'
#!/bin/bash
set -e
echo "Starting Ubuntu AI VM..."

# Check Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running"
    exit 1
fi

# Build and start the container
docker-compose up -d --build

# Wait for container to be ready
echo "Waiting for container to be ready..."
sleep 5

# Verify container is running
if docker ps | grep -q ubuntu-ai-vm; then
    echo "Container started successfully"
    echo "To connect: docker exec -it ubuntu-ai-vm bash"
else
    echo "Error: Container failed to start"
    docker-compose logs
    exit 1
fi
EOF
chmod +x ./scripts/start.sh

# Stop script
cat > ./scripts/stop.sh << 'EOF'
#!/bin/bash
echo "Stopping Ubuntu AI VM..."
docker-compose down
echo "Container stopped"
EOF
chmod +x ./scripts/stop.sh

# Connect script
cat > ./scripts/connect.sh << 'EOF'
#!/bin/bash
docker exec -it ubuntu-ai-vm bash
EOF
chmod +x ./scripts/connect.sh

# Resize volume script
cat > ./scripts/resize-volume.sh << 'EOF'
#!/bin/bash
NEW_SIZE=$1
if [ -z "$NEW_SIZE" ]; then
    echo "Usage: $0 <new-size-in-GB>"
    exit 1
fi

echo "Resizing volume to ${NEW_SIZE}GB..."
# Stop container
docker-compose down
# Resize sparse file
dd if=/dev/zero of=./storage.img bs=1 count=0 seek=${NEW_SIZE}G
# Resize filesystem
resize2fs ./storage.img
# Restart container
docker-compose up -d
echo "Resize complete"
EOF
chmod +x ./scripts/resize-volume.sh
```

### Step 5: Create Security Configuration
```bash
cat > ./config/security.json << 'EOF'
{
  "security_policies": {
    "filesystem": {
      "no_host_mounts": true,
      "readonly_root": false,
      "allowed_paths": ["/workspace", "/tmp"]
    },
    "network": {
      "allow_internet": true,
      "blocked_ports": [],
      "dns_servers": ["8.8.8.8", "8.8.4.4"]
    },
    "resources": {
      "max_cpu": "2",
      "max_memory": "4G",
      "max_storage": "20G"
    }
  }
}
EOF
```

### Step 6: Verification Commands
After setup, run these commands to verify everything works:
```bash
# 1. Start the container
./scripts/start.sh

# 2. Verify container is running
docker ps | grep ubuntu-ai-vm

# 3. Check network connectivity
docker exec ubuntu-ai-vm ping -c 4 google.com

# 4. Verify AI assistant is installed
docker exec ubuntu-ai-vm which aider

# 5. Check storage
docker exec ubuntu-ai-vm df -h /workspace

# 6. Verify non-root user
docker exec ubuntu-ai-vm whoami

# 7. Test isolation (should fail)
docker exec ubuntu-ai-vm ls /host 2>&1 | grep -E "cannot access|No such file"
```

### Step 7: Automated Testing Script
```bash
cat > ./test-setup.sh << 'EOF'
#!/bin/bash
echo "Running automated tests..."

ERRORS=0

# Test 1: Container running
if docker ps | grep -q ubuntu-ai-vm; then
    echo "✓ Container is running"
else
    echo "✗ Container is not running"
    ERRORS=$((ERRORS+1))
fi

# Test 2: Network connectivity
if docker exec ubuntu-ai-vm ping -c 1 google.com > /dev/null 2>&1; then
    echo "✓ Internet connectivity works"
else
    echo "✗ No internet connectivity"
    ERRORS=$((ERRORS+1))
fi

# Test 3: User permissions
USER=$(docker exec ubuntu-ai-vm whoami)
if [ "$USER" = "aiuser" ]; then
    echo "✓ Running as non-root user"
else
    echo "✗ Not running as correct user"
    ERRORS=$((ERRORS+1))
fi

# Test 4: AI assistant installed
if docker exec ubuntu-ai-vm which aider > /dev/null 2>&1; then
    echo "✓ AI assistant installed"
else
    echo "✗ AI assistant not found"
    ERRORS=$((ERRORS+1))
fi

# Test 5: Storage mounted
if docker exec ubuntu-ai-vm test -d /workspace; then
    echo "✓ Workspace directory exists"
else
    echo "✗ Workspace directory missing"
    ERRORS=$((ERRORS+1))
fi

if [ $ERRORS -eq 0 ]; then
    echo "All tests passed!"
else
    echo "$ERRORS tests failed"
    exit 1
fi
EOF
chmod +x ./test-setup.sh
```

## Debugging Guide

If any command fails, the AI should:

1. **Check Docker daemon**: `docker info`
2. **Check logs**: `docker-compose logs`
3. **Verify permissions**: `ls -la`
4. **Network issues**: Check if Docker networks conflict
5. **Storage issues**: Ensure enough disk space with `df -h`

Common fixes:
- If port conflicts: Change ports in docker-compose.yml
- If permission denied: Check file ownership
- If build fails: Check internet connectivity and package availability

## Complete Execution Sequence

The AI should execute in this order:
1. Run Step 0 (backup)
2. Run Steps 1-6 sequentially
3. Run verification commands
4. Run test script
5. If any test fails, check logs and iterate

## File Structure
```
ubuntu-docker-vm/
├── PLAN.md (this file)
├── Dockerfile
├── docker-compose.yml
├── scripts/
│   ├── start.sh
│   ├── stop.sh
│   ├── resize-volume.sh
│   └── backup.sh
├── config/
│   ├── security.json
│   └── ai-assistant-config.yml
└── README.md
```

## Technical Specifications

### Container Specs
- OS: Ubuntu 22.04 LTS
- CPU: 2-4 cores (configurable)
- Memory: 4-8GB (configurable)
- Storage: 20GB sparse volume
- Network: Bridge with NAT

### Pre-installed Software
- Python 3.10+
- Node.js 18+
- Git
- Docker CLI (for nested containers if needed)
- Common development tools
- AI coding assistant

### Volume Management
- Type: Docker named volume
- Initial size: 20GB
- Filesystem: ext4 with sparse files
- Growth: On-demand allocation
- Resize capability: Via dedicated script

## Security Considerations
1. **Filesystem Isolation**: No access to host files
2. **User Permissions**: Non-root user with minimal privileges
3. **Network Security**: Outbound only, no exposed ports
4. **Resource Limits**: Prevent resource exhaustion
5. **Audit Logging**: Track AI assistant activities

## Usage Workflow
1. Start container with `./scripts/start.sh`
2. Connect to container via `docker exec`
3. AI assistant runs with restricted user
4. Work saved in isolated volume
5. Stop with `./scripts/stop.sh`

## Future Enhancements
- Multi-container setup for complex projects
- GPU support for AI workloads
- Automated security scanning
- Project templates
- Web-based interface