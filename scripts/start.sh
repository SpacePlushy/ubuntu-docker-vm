#!/bin/bash
set -e
echo "Starting Ubuntu AI VM..."

# Check Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running"
    exit 1
fi

# Check if container already exists
if docker ps -a --format "{{.Names}}" | grep -q "^ubuntu-ai-vm$"; then
    # Check if it's running
    if docker ps --format "{{.Names}}" | grep -q "^ubuntu-ai-vm$"; then
        echo "Container is already running"
        echo "To connect: docker exec -it ubuntu-ai-vm bash"
        exit 0
    else
        echo "Container exists but is stopped. Starting it..."
        docker start ubuntu-ai-vm
        echo "Container started successfully"
        echo "To connect: docker exec -it ubuntu-ai-vm bash"
        exit 0
    fi
fi

# Build and start the container
echo "Building and starting new container..."
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