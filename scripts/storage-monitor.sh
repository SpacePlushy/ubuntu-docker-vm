#!/bin/bash

# Storage monitoring script
STORAGE_PATH="$HOME/ubuntu-docker-vm/storage"
THRESHOLD_GB=10  # Alert if storage exceeds 10GB

# Get size in GB
SIZE_MB=$(du -sm "$STORAGE_PATH" 2>/dev/null | cut -f1)
SIZE_GB=$((SIZE_MB / 1024))

echo "Ubuntu Docker VM Storage Report"
echo "=============================="
echo "Current size: ${SIZE_MB}MB (${SIZE_GB}GB)"
echo ""

if [ $SIZE_GB -gt $THRESHOLD_GB ]; then
    echo "⚠️  WARNING: Storage exceeds ${THRESHOLD_GB}GB!"
    echo "Consider running: ./scripts/cleanup-container.sh"
else
    echo "✅ Storage size is within limits"
fi

# Show largest directories
echo ""
echo "Largest items in storage:"
du -sh "$STORAGE_PATH"/* 2>/dev/null | sort -hr | head -10