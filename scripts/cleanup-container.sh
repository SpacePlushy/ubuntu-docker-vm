#!/bin/bash

echo "==================================="
echo "Cleaning Container Storage"
echo "==================================="

# Function to show size before and after
show_size() {
    echo "Workspace size: $(docker exec ubuntu-ai-vm du -sh /workspace 2>/dev/null | cut -f1)"
}

echo "Before cleanup:"
show_size

# Clean Python caches
echo "→ Cleaning Python caches..."
docker exec ubuntu-ai-vm bash -c "pip cache purge 2>/dev/null || true"
docker exec ubuntu-ai-vm rm -rf /workspace/.cache/pip

# Clean npm cache
echo "→ Cleaning npm cache..."
docker exec ubuntu-ai-vm npm cache clean --force 2>/dev/null || true

# Clean temporary files
echo "→ Cleaning temporary files..."
docker exec ubuntu-ai-vm find /workspace -name "*.pyc" -delete 2>/dev/null || true
docker exec ubuntu-ai-vm find /workspace -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
docker exec ubuntu-ai-vm find /workspace -name ".pytest_cache" -type d -exec rm -rf {} + 2>/dev/null || true
docker exec ubuntu-ai-vm find /workspace -name "*.log" -delete 2>/dev/null || true

# Clean build artifacts
echo "→ Cleaning build artifacts..."
docker exec ubuntu-ai-vm find /workspace -name "*.o" -delete 2>/dev/null || true
docker exec ubuntu-ai-vm find /workspace -name "*.so" -delete 2>/dev/null || true
docker exec ubuntu-ai-vm find /workspace -name "build" -type d -exec rm -rf {} + 2>/dev/null || true
docker exec ubuntu-ai-vm find /workspace -name "dist" -type d -exec rm -rf {} + 2>/dev/null || true
docker exec ubuntu-ai-vm find /workspace -name "*.egg-info" -type d -exec rm -rf {} + 2>/dev/null || true

echo ""
echo "After cleanup:"
show_size
echo "==================================="