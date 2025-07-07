# iPad Quick Start Guide

## Access Your Ubuntu Desktop

1. **Open Safari** (or Chrome) on your iPad
2. Go to: **https://code.palmisano.io**
3. You'll see the Ubuntu MATE desktop!

## First Time Setup

### Login Credentials
- Default password: **changeme**
- To set custom password in Railway: `PASSWORD=yourpassword`

### iPad Optimization
1. **Enable Full Screen**: Tap the expand icon in Safari
2. **Add to Home Screen**: Share → Add to Home Screen (makes it feel like an app!)
3. **External Keyboard**: Highly recommended (Magic Keyboard or Bluetooth)

## Essential iPad Gestures

- **Tap** = Click
- **Long press** = Right-click  
- **Two fingers** = Scroll
- **Pinch** = Zoom (in some apps)

## What You Can Do

### Open Applications (Top Menu)
- **Terminal** - Full Linux terminal
- **Firefox** - Web browser
- **Caja** - File manager
- **Software Boutique** - Install more apps

### Install Development Tools
Open Terminal and run:
```bash
# Update system
sudo apt update

# Install VS Code (if not already there)
sudo snap install code --classic

# Install development tools
sudo apt install python3-pip nodejs npm git

# Install Docker
sudo apt install docker.io
sudo usermod -aG docker $USER
```

## iPad Pro Tips

1. **Split Screen**: Use iPad split view to have documentation on one side
2. **Stage Manager**: Great for multiple terminal windows
3. **Touch Bar**: If using Magic Keyboard, customize for shortcuts
4. **Pencil Support**: Works in drawing apps like GIMP

## Troubleshooting

**Screen too small?**
- Pinch to zoom out
- Or adjust resolution: Right-click desktop → Display settings

**Keyboard not working?**
- Tap the text field first
- Or use external keyboard

**Connection slow?**
- Check WiFi signal
- Reduce quality in display settings

## Your Desktop is Ready! 

The deployment is building now. Once complete:
- Full Ubuntu desktop
- Touch-optimized MATE interface  
- Perfect for iPad development
- All your files persist

Enjoy your portable Linux workstation! 🚀