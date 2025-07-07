#!/bin/bash

# Test internet connectivity without ping
echo "🌐 Testing internet connectivity..."

# Method 1: curl
echo ""
echo "1. Testing with curl:"
if curl -s --head https://google.com | head -n 1 | grep "HTTP" > /dev/null; then
    echo "✅ Internet connection is working (curl test passed)"
else
    echo "❌ Internet connection failed (curl test)"
fi

# Method 2: wget
echo ""
echo "2. Testing with wget:"
if wget -q --spider https://google.com; then
    echo "✅ Internet connection is working (wget test passed)"
else
    echo "❌ Internet connection failed (wget test)"
fi

# Method 3: DNS resolution
echo ""
echo "3. Testing DNS resolution:"
if nslookup google.com >/dev/null 2>&1; then
    echo "✅ DNS resolution is working"
else
    echo "❌ DNS resolution failed"
fi

# Method 4: Python
echo ""
echo "4. Testing with Python:"
python3 -c "
import urllib.request
try:
    urllib.request.urlopen('https://google.com', timeout=5)
    print('✅ Internet connection is working (Python test passed)')
except:
    print('❌ Internet connection failed (Python test)')
"

echo ""
echo "📝 Note: ping is disabled in Railway containers for security."
echo "Use curl, wget, or application-level connections instead."