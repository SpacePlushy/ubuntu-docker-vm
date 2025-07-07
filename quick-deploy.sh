#!/bin/bash

echo "🚀 Quick Railway Deploy"
echo "====================="

# Deploy directly without prompts
echo "Creating new project and deploying..."
railway up --detach

echo ""
echo "✅ Deployment started!"
echo ""
echo "To check status:"
echo "  railway logs"
echo ""
echo "To get your URL:"
echo "  railway open"
echo ""
echo "Your password is in: railway-credentials.txt"