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
if docker exec ubuntu-ai-vm curl -I https://www.google.com --max-time 5 > /dev/null 2>&1; then
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

# Test 4: Development tools installed
if docker exec ubuntu-ai-vm which python3 > /dev/null 2>&1 && docker exec ubuntu-ai-vm which node > /dev/null 2>&1; then
    echo "✓ Development tools installed"
else
    echo "✗ Development tools not found"
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