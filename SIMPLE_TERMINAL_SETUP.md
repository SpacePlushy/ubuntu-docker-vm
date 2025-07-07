# Simple Web Terminal Setup

## What This Is

A clean Ubuntu 22.04 web terminal with only the essentials:
- **Ubuntu 22.04 LTS** base
- **Build essentials** (gcc, g++, make)
- **Basic tools** (curl, wget, git)
- **Web terminal** (ttyd) - no VS Code

## Access

1. Go to: https://code.palmisano.io
2. Login with:
   - Username: `ubuntu`
   - Password: `changeme` (or your custom password)
3. You get a clean bash terminal in your browser

## What's Installed

- `build-essential` - C/C++ compilers and build tools
- `git` - Version control
- `curl` & `wget` - Download tools
- `sudo` - Admin access (passwordless)

That's it. Clean and simple.

## Installing Additional Tools

Once logged in, you can install whatever you need:

```bash
# Update package list
sudo apt update

# Install Python
sudo apt install python3 python3-pip

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs

# Install any other tools
sudo apt install vim nano htop
```

## File Persistence

Your home directory (`/home/ubuntu`) persists across container restarts.

## Custom Password

Set in Railway environment variables:
```
PASSWORD=your-secure-password
```

## That's It!

Simple web terminal. No VS Code. No pre-installed languages. Just Ubuntu with build tools.