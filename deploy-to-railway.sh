#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==================================="
echo -e "Railway Deployment Script"
echo -e "===================================${NC}\n"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}Error: npm is not installed${NC}"
    echo "Please install Node.js first"
    exit 1
fi

# Check if railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo -e "${YELLOW}Installing Railway CLI...${NC}"
    npm install -g @railway/cli
    echo -e "${GREEN}✓ Railway CLI installed${NC}\n"
else
    echo -e "${GREEN}✓ Railway CLI already installed${NC}\n"
fi

# Check if we're in the right directory
if [ ! -f "Dockerfile.railway" ]; then
    echo -e "${RED}Error: Dockerfile.railway not found${NC}"
    echo "Please run this script from the ubuntu-docker-vm directory"
    exit 1
fi

# Login to Railway
echo -e "${YELLOW}Logging into Railway...${NC}"
echo -e "${BLUE}This will open your browser for authentication${NC}"
railway login

echo -e "\n${GREEN}✓ Logged into Railway${NC}\n"

# Create a secure password
DEFAULT_PASSWORD=$(openssl rand -base64 12 2>/dev/null || echo "changeme-$(date +%s)")
echo -e "${YELLOW}Generated secure password for code-server:${NC}"
echo -e "${BLUE}$DEFAULT_PASSWORD${NC}"
echo -e "${RED}IMPORTANT: Save this password! You'll need it to access VS Code${NC}\n"

# Update the Dockerfile with the password
echo -e "${YELLOW}Updating configuration...${NC}"
sed -i.bak "s/password: changeme/password: $DEFAULT_PASSWORD/" Dockerfile.railway

# Deploy to Railway
echo -e "${YELLOW}Deploying to Railway...${NC}"
echo -e "${BLUE}This may take 3-5 minutes...${NC}\n"

# Deploy and capture output
DEPLOY_OUTPUT=$(railway up 2>&1)
echo "$DEPLOY_OUTPUT"

# Extract URL if possible
if echo "$DEPLOY_OUTPUT" | grep -q "Deployment live at"; then
    URL=$(echo "$DEPLOY_OUTPUT" | grep -oE 'https://[^ ]+\.up\.railway\.app')
    
    echo -e "\n${GREEN}==================================="
    echo -e "Deployment Successful!"
    echo -e "===================================${NC}"
    echo -e "\n${BLUE}Your VS Code environment is ready at:${NC}"
    echo -e "${GREEN}$URL${NC}"
    echo -e "\n${BLUE}Password:${NC} ${YELLOW}$DEFAULT_PASSWORD${NC}"
    echo -e "\n${YELLOW}Next steps:${NC}"
    echo -e "1. Open the URL in your browser"
    echo -e "2. Enter the password when prompted"
    echo -e "3. Open terminal in VS Code: Terminal → New Terminal"
    echo -e "4. Run: /workspace/scripts/setup-dev-env.sh"
    
    # Save credentials
    echo -e "\n${YELLOW}Saving credentials to railway-credentials.txt...${NC}"
    cat > railway-credentials.txt << EOF
Railway Deployment Credentials
==============================
URL: $URL
Password: $DEFAULT_PASSWORD
Deployed: $(date)

To change password:
1. Go to Railway dashboard
2. Add environment variable: PASSWORD=your-new-password
3. Redeploy
EOF
    echo -e "${GREEN}✓ Credentials saved${NC}"
    
else
    echo -e "\n${GREEN}Deployment initiated!${NC}"
    echo -e "${YELLOW}Check your Railway dashboard for the URL:${NC}"
    echo -e "${BLUE}https://railway.app/dashboard${NC}"
    echo -e "\n${YELLOW}Your password:${NC} ${BLUE}$DEFAULT_PASSWORD${NC}"
fi

# Restore original Dockerfile
mv Dockerfile.railway.bak Dockerfile.railway

echo -e "\n${BLUE}==================================="
echo -e "Setup Complete!"
echo -e "===================================${NC}"
echo -e "\nTo manage your deployment:"
echo -e "- Dashboard: ${BLUE}https://railway.app/dashboard${NC}"
echo -e "- View logs: ${YELLOW}railway logs${NC}"
echo -e "- Open shell: ${YELLOW}railway run bash${NC}"
echo -e "- Add domain: In Railway dashboard → Settings → Domains"