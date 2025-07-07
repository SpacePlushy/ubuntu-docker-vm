# Railway Deployment Instructions

## What You'll Get
- **VS Code in your browser** at your Railway URL
- Full Ubuntu environment with all your tools
- Access from any device with a web browser
- Default password: `changeme` (change this!)

## Quick Deploy Steps

1. **Install Railway CLI**
```bash
npm install -g @railway/cli
```

2. **Login to Railway**
```bash
railway login
```

3. **Deploy from your project**
```bash
cd ~/ubuntu-docker-vm
railway up
```

4. **Set Environment Variables** (in Railway dashboard)
```
PASSWORD=your-secure-password-here
```

5. **Access Your Cloud Dev Environment**
- Railway will give you a URL like: `https://ubuntu-docker-vm-production.up.railway.app`
- Open in browser
- Enter password: `changeme` (or your custom password)
- You now have VS Code running your Ubuntu environment!

## First Time Setup
Once connected to code-server:
1. Open terminal in VS Code (Terminal → New Terminal)
2. Run: `/workspace/scripts/setup-dev-env.sh`
3. Install extensions you need
4. Start coding!

## Costs
- First $5 free
- Then ~$0.01/hour when running
- Stop the service when not using to save money

## Security
⚠️ **IMPORTANT**: Change the password!
- Either set PASSWORD env var in Railway
- Or edit ~/.config/code-server/config.yaml

## Persistent Storage
Railway provides persistent storage at `/workspace` automatically!