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