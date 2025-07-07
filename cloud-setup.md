# Cloud Deployment Guide

## Prerequisites
- A cloud VPS with Ubuntu (20.04/22.04)
- At least 2GB RAM, 20GB storage
- Docker and Docker Compose installed
- SSH access configured

## Quick Cloud Setup

### 1. Connect to Your Cloud Server
```bash
ssh username@your-server-ip
```

### 2. Install Docker (if not installed)
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
# Log out and back in
```

### 3. Clone This Repository
```bash
git clone https://github.com/SpacePlushy/ubuntu-docker-vm.git
cd ubuntu-docker-vm
```

### 4. Start the Container
```bash
./scripts/start.sh
```

## Remote Access Options

### Option 1: SSH Tunneling (Simplest)
From your local machine:
```bash
# Forward container's internal port to your local machine
ssh -L 8080:localhost:8080 username@your-server-ip

# Then connect to container via your server
ssh username@your-server-ip
cd ubuntu-docker-vm
./scripts/connect.sh
```

### Option 2: VS Code Remote Development
1. Install VS Code locally
2. Install "Remote - SSH" extension
3. Connect to your cloud server
4. Open the /workspace folder inside container

### Option 3: Web-based IDE (Recommended for Cloud)
Add a web IDE to your container:

```dockerfile
# Add to Dockerfile
RUN pip3 install jupyter-lab
EXPOSE 8888

# Or install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh
EXPOSE 8080
```

Then access via browser: `http://your-server-ip:8080`

## Security Considerations

### 1. Firewall Rules
```bash
# Only allow SSH and your web IDE port
sudo ufw allow 22/tcp
sudo ufw allow 8080/tcp
sudo ufw enable
```

### 2. Use HTTPS with Caddy
```yaml
# Add to docker-compose.yml
caddy:
  image: caddy:alpine
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./Caddyfile:/etc/caddy/Caddyfile
    - caddy_data:/data
```

### 3. Authentication
- Use strong passwords
- Enable 2FA on your cloud provider
- Consider VPN for additional security

## Persistent Storage
Your /workspace is already persistent. For cloud:
- Regular backups to cloud storage (S3, GCS)
- Snapshots of your VPS
- Sync to GitHub for code

## Cost-Effective Options
- **DigitalOcean**: $6/month (1GB RAM, 25GB SSD)
- **Vultr**: $6/month (1GB RAM, 25GB SSD)
- **AWS EC2**: t3.micro free tier eligible
- **Google Cloud**: e2-micro free tier eligible

## Advanced: Multi-User Setup
For team access, modify docker-compose.yml:
```yaml
environment:
  - USERS=alice,bob,charlie
ports:
  - "2222:22"  # SSH access
```

## Example: DigitalOcean Deployment

1. Create Droplet (Ubuntu 22.04)
2. SSH in and run:
```bash
# One-liner setup
curl -fsSL https://get.docker.com | sh && \
sudo usermod -aG docker $USER && \
git clone https://github.com/SpacePlushy/ubuntu-docker-vm.git && \
cd ubuntu-docker-vm && \
./scripts/start.sh
```

3. Access from anywhere:
```bash
ssh root@your-droplet-ip
cd ubuntu-docker-vm && ./scripts/connect.sh
```