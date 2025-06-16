# Wine Manager - Railway Deployment

🚀 **Deploy Wine Desktop with Roblox Studio to Railway.com**

This folder contains everything needed to deploy the Wine Manager to Railway.com cloud platform.

## ✨ Features

- 🎮 **Roblox Studio (Vinegar)** - Optimized game development environment
- 🌐 **Web-based Desktop** - Access via any web browser
- 🍷 **Wine 64-bit** - Run Windows applications seamlessly
- 🖥️ **XFCE Desktop** - Modern, lightweight interface
- ⌨️ **Virtual Keyboard** - Touch device support
- 🌐 **Firefox Browser** - Web browsing capabilities

## 🚀 Quick Deploy to Railway

### Option 1: One-Click Deploy
[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app)

### Option 2: Manual Deploy

1. **Fork this repository** to your GitHub account

2. **Connect to Railway**:
   - Go to [railway.app](https://railway.app)
   - Sign up/login with GitHub
   - Click "New Project" → "Deploy from GitHub repo"
   - Select your forked repository
   - Choose the `railway` folder as deployment directory

3. **Deploy**: Railway will automatically detect the Dockerfile and deploy

4. **Access**: Use the Railway-provided URL to access your application

## 🔧 Configuration

### Environment Variables
- `PORT`: Automatically set by Railway (no configuration needed)
- All Wine and desktop settings are automatically configured

### VNC Access
- **URL**: Your Railway app URL
- **Password**: `$$Hello1$$`

## 📁 File Structure

```
railway/
├── Dockerfile              # Container definition (Wine-free base)
├── start                   # Main startup script with dependency handling
├── supervisord.conf         # Service management configuration
├── supervisord-wine.conf    # Desktop setup service
├── supervisord-onboard.conf # Virtual keyboard service
├── install-vinegar.sh       # Vinegar/Wine installation script
├── setup-desktop.sh         # Desktop environment setup
├── healthcheck.sh          # Health monitoring
├── railway.json            # Railway deployment config
├── .dockerignore           # Docker build optimization
└── README.md               # This file
```

## 🛠️ Customization

### Adding Your Own Applications

1. **Fork the repository**
2. **Modify `setup-desktop.sh`** to add your applications
3. **Update `Dockerfile`** if additional system packages are needed
4. **Deploy** your customized version

### Example: Adding a custom Windows application
```bash
# In setup-desktop.sh, add:
cat > "$HOME/Desktop/My App.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=My Application
Exec=/root/.local/bin/vinegar run /path/to/my/app.exe
Icon=applications-games
Terminal=false
EOF
```

## 🔍 Monitoring & Troubleshooting

### Health Checks
Railway automatically monitors the application using the built-in health check at `/vnc_lite.html`.

### Viewing Logs
Access logs through the Railway dashboard:
1. Go to your Railway project
2. Click on the deployment
3. View the "Logs" tab

### Common Issues

**Build Fails**
- Check Railway build logs for dependency issues
- Ensure Dockerfile syntax is correct

**Container Starts but VNC Not Accessible**
- Verify health check is passing in Railway dashboard
- Check if the correct port is being used

**Roblox Studio Won't Start**
- Wine installation happens via Vinegar during first run
- Allow extra time for initial Wine prefix setup
- Check desktop setup logs

## 🏗️ Architecture

### Service Stack
1. **Xvfb**: Virtual X11 display server
2. **x11vnc**: VNC server for remote access
3. **noVNC**: Web-based VNC client 
4. **XFCE4**: Desktop environment
5. **Vinegar**: Optimized Roblox/Wine manager
6. **Onboard**: Virtual keyboard

### Startup Process
1. Base system initialization
2. Vinegar download and installation
3. Wine configuration via Vinegar
4. Desktop environment setup
5. Service startup via supervisord

## 📊 Resource Requirements

- **Memory**: 1GB+ recommended (512MB minimum)
- **CPU**: 1 vCPU recommended
- **Storage**: ~2-3GB for full installation
- **Network**: HTTP/HTTPS on Railway-assigned port

## 🔒 Security Notes

- VNC password is set to `$$Hello1$$`
- Railway provides HTTPS termination
- Applications run in isolated container environment
- Consider implementing additional authentication for production use

## 🆘 Support

If you encounter issues:

1. **Check Railway logs** for error messages
2. **Verify health check** is passing
3. **Wait for full initialization** (first run takes 5-10 minutes)
4. **Submit GitHub issue** with logs and error details

## 📚 Additional Resources

- [Railway Documentation](https://docs.railway.app/)
- [Vinegar GitHub](https://github.com/vinegarhq/vinegar)
- [Wine Documentation](https://www.winehq.org/documentation)
- [noVNC Project](https://github.com/novnc/noVNC)
