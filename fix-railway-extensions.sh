#!/bin/bash

# Fix Railway VS Code Extensions Issue
# This script creates a patched deployment that enables extensions marketplace

set -e

echo "🔧 Fixing VS Code extensions for Railway deployment..."

# Create a Railway-specific entrypoint script
cat > railway-entrypoint.sh << 'EOF'
#!/bin/bash

# Set up extensions marketplace
export SERVICE_URL=https://open-vsx.org/vscode/gallery
export ITEM_URL=https://open-vsx.org/vscode/item

# Ensure extensions directory exists
mkdir -p ~/.local/share/code-server/extensions

# Start code-server with proper configuration
exec code-server \
  --bind-addr 0.0.0.0:${PORT:-8080} \
  --auth password \
  --disable-telemetry \
  --extensions-dir ~/.local/share/code-server/extensions \
  /workspace
EOF

chmod +x railway-entrypoint.sh

echo "✅ Created railway-entrypoint.sh"

# Update Dockerfile.railway to use the new entrypoint
cat > Dockerfile.railway.fixed << 'EOF'
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

# Install code-server (VS Code in browser)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create working directory and copy project files
RUN mkdir -p /workspace && chown -R aiuser:aiuser /workspace

# Copy project files to workspace (excluding storage)
COPY --chown=aiuser:aiuser . /workspace/
RUN rm -rf /workspace/storage /workspace/railway-credentials.txt

# Copy entrypoint script
COPY --chown=aiuser:aiuser railway-entrypoint.sh /home/aiuser/

# Switch to non-root user
USER aiuser
WORKDIR /workspace

# Configure code-server with extensions support
RUN mkdir -p ~/.config/code-server ~/.local/share/code-server/extensions

# Set up marketplace URLs
ENV SERVICE_URL=https://open-vsx.org/vscode/gallery
ENV ITEM_URL=https://open-vsx.org/vscode/item

# Railway uses PORT env variable
EXPOSE 8080
ENV PORT=8080

# Use the custom entrypoint
CMD ["/home/aiuser/railway-entrypoint.sh"]
EOF

echo "✅ Created Dockerfile.railway.fixed"

# Backup current Dockerfile.railway
cp Dockerfile.railway Dockerfile.railway.backup
cp Dockerfile.railway.fixed Dockerfile.railway

echo "✅ Backed up original Dockerfile.railway"

# Deploy to Railway
echo ""
echo "📦 Deploying fixed version to Railway..."
echo ""

# Check if logged in to Railway
if ! railway status >/dev/null 2>&1; then
    echo "❌ Not logged in to Railway. Please run: railway login"
    exit 1
fi

# Deploy
railway up

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🎯 Next steps:"
echo "1. Wait for deployment to finish (check Railway dashboard)"
echo "2. Access your VS Code instance"
echo "3. Extensions marketplace should now work!"
echo ""
echo "💡 To verify extensions work:"
echo "   - Open VS Code in browser"
echo "   - Click Extensions icon"
echo "   - Search for 'Python' or any extension"
echo "   - You should see results from Open VSX marketplace"