#!/bin/bash
set -e

echo "Setting up development environment in container..."

# Check if container is running
if ! docker ps --format "{{.Names}}" | grep -q "^ubuntu-ai-vm$"; then
    echo "Container is not running. Starting it first..."
    ./scripts/start.sh
fi

# Copy the install script to container workspace
docker cp ./scripts/install-user-tools.sh ubuntu-ai-vm:/workspace/install-user-tools.sh

# Execute the install script inside container
echo "Installing development tools (this may take a few minutes)..."
docker exec -it ubuntu-ai-vm bash /workspace/install-user-tools.sh

# Clean up
docker exec ubuntu-ai-vm rm -f /workspace/install-user-tools.sh

echo ""
echo "Development environment setup complete!"
echo "Connect to your container with: ./scripts/connect.sh"