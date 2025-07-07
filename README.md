# Webtop Railway Deployment

This is a clean setup of LinuxServer's Webtop for Railway deployment.

## What This Is

- Full Ubuntu/Alpine desktop environment in your browser
- Perfect for iPad access with touch support
- Includes file manager, terminal, browser
- Pre-configured for Railway deployment

## Quick Start

### Local Testing
```bash
docker-compose up -d
# Access at http://localhost:3000
```

### Railway Deployment

1. Create Railway account at https://railway.app
2. Install Railway CLI:
   ```bash
   npm install -g @railway/cli
   ```

3. Deploy:
   ```bash
   railway login
   railway init
   railway up
   ```

4. In Railway dashboard:
   - Go to Settings → Networking
   - Add custom domain or use generated URL
   - Set environment variable: `PASSWORD=your-secure-password`

## Access

- URL: Your Railway URL or custom domain
- Password: Set in Railway environment variables

## Customization

Edit `docker-compose.yml` to:
- Change desktop environment (ubuntu-mate, alpine-xfce, etc.)
- Add more packages to INSTALL_PACKAGES
- Adjust resources

## For iPad Users

1. Use Safari or Chrome
2. Add to Home Screen for app-like experience
3. External keyboard recommended
4. Touch gestures work naturally