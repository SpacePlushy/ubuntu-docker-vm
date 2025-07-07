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
