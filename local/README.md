# Wine Manager - Local Deployment

🖥️ **Run Wine Desktop with Roblox Studio on your local Linux machine**

This folder contains everything needed to run the Wine Manager locally on any Linux distribution.

## ✨ Features

- 🎮 **Roblox Studio (Vinegar)** - Optimized game development environment
- 🌐 **Web-based Desktop** - Access via any web browser on your network
- 🍷 **Wine 64-bit** - Run Windows applications seamlessly
- 🖥️ **XFCE Desktop** - Modern, lightweight interface
- ⌨️ **Virtual Keyboard** - Touch device support
- 🌐 **Firefox Browser** - Web browsing capabilities
- 🐍 **Python Virtual Environment** - Isolated dependencies
- 📊 **Process Management** - Full supervisord control

## 🚀 Quick Start

### One-Command Installation & Start

```bash
# Clone the repository
git clone https://github.com/moonsip1224/Wine-manager.git
cd Wine-manager/local

# Run the complete setup and start script (handles EVERYTHING)
./start-wine-manager.sh
```

That's it! This single script will:
1. ✅ **Detect your Linux distribution**
2. ✅ **Install ALL system dependencies** (Wine, XFCE, Python, etc.)
3. ✅ **Download and install Vinegar** (optimized Roblox launcher)
4. ✅ **Set up Python virtual environment** with all dependencies
5. ✅ **Configure desktop environment** and create shortcuts
6. ✅ **Initialize Wine prefix** for Roblox
7. ✅ **Start all services** and web interface

## 📋 System Requirements

### Supported Linux Distributions
- ✅ **Ubuntu** 18.04+ / **Debian** 10+
- ✅ **Fedora** 35+ / **CentOS** 8+ / **RHEL** 8+
- ✅ **Arch Linux** / **Manjaro**
- ✅ **openSUSE** Leap / Tumbleweed

### Hardware Requirements
- **CPU**: x86_64 processor (64-bit)
- **RAM**: 2GB minimum, 4GB+ recommended
- **Storage**: 5GB free space
- **Network**: Internet connection for downloads
- **Graphics**: Any GPU with Linux drivers

### Software Requirements (automatically installed)
- Python 3.8+
- Wine 6.0+
- XFCE4 desktop environment
- VNC server and noVNC web client

## 🔧 Manual Installation (Advanced)

If you prefer step-by-step installation:

### Step 1: Install Dependencies
```bash
./install-dependencies.sh
```

### Step 2: Set Up Environment
```bash
./setup-local.sh
```

### Step 3: Start Services
```bash
# Navigate to Wine Manager directory
cd ~/wine-manager

# Start services
./start.sh
```

## 📋 Management Commands

Once installed, manage your Wine Manager with these commands:

```bash
# Start Wine Manager
~/wine-manager/start.sh

# Stop Wine Manager
~/wine-manager/stop.sh

# Check status
~/wine-manager/status.sh

# Health check
~/wine-manager/healthcheck.sh
```

## 🌐 Access & Usage

### Web Interface
- **URL**: `http://localhost:8080` (or your custom port)
- **VNC Password**: `$$Hello1$$`

### Custom Port
```bash
PORT=8081 ./start-wine-manager.sh
```

### Network Access
Access from other devices on your network:
```bash
# Find your IP address
ip addr show

# Access from other devices
http://YOUR_IP_ADDRESS:8080
```

## 📱 Available Applications

Once running, you'll have access to:

| Application | Description | Icon |
|------------|-------------|------|
| 🎮 **Roblox Studio (Vinegar)** | Game development with optimized Wine | Desktop shortcut |
| 🎮 **Roblox Player (Vinegar)** | Play Roblox games | Desktop shortcut |
| 🌐 **Firefox** | Web browser | Desktop shortcut |
| ⌨️ **Virtual Keyboard** | Touch device support | Desktop shortcut |
| 💻 **Terminal** | Command line access | Desktop shortcut |
| 📁 **File Manager** | File system browser | Desktop shortcut |

## 🔧 Configuration

### Wine Prefix Location
- **Path**: `~/.local/share/vinegar/prefixes/studio`
- **Architecture**: 64-bit (win64)

### Vinegar Configuration
- **Config File**: `~/.config/vinegar/config.toml`
- **Features**: FPS unlocker, optimized settings

### Virtual Environment
- **Location**: `~/wine-manager/venv/`
- **Python Packages**: supervisor, websockify, psutil, requests, numpy

### Log Files
```bash
# View all logs
ls ~/wine-manager/logs/

# Follow main log
tail -f ~/wine-manager/logs/supervisord.log

# View specific service logs
tail -f ~/wine-manager/logs/xfce4.log
tail -f ~/wine-manager/logs/novnc.log
```

## 🛠️ Troubleshooting

### Common Issues

**Dependencies Failed to Install**
```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade
sudo apt install curl wget

# Fedora/CentOS
sudo dnf update
sudo dnf install curl wget

# Arch Linux
sudo pacman -Syu
sudo pacman -S curl wget
```

**Port Already in Use**
```bash
# Check what's using the port
sudo netstat -tlnp | grep :8080

# Use different port
PORT=8081 ./start-wine-manager.sh
```

**Wine/Roblox Issues**
```bash
# Reinstall Wine prefix
rm -rf ~/.local/share/vinegar/prefixes/studio
~/wine-manager/stop.sh
~/wine-manager/start.sh
```

**Services Won't Start**
```bash
# Check service status
~/wine-manager/status.sh

# View detailed logs
cat ~/wine-manager/logs/supervisord.log

# Restart services
~/wine-manager/stop.sh
sleep 5
~/wine-manager/start.sh
```

### Getting Help

1. **Check logs** in `~/wine-manager/logs/`
2. **Run health check**: `~/wine-manager/healthcheck.sh`
3. **Restart services**: `~/wine-manager/stop.sh && ~/wine-manager/start.sh`
4. **Submit GitHub issue** with logs and system info

## 🔒 Security Notes

- **VNC Password**: Default is `$$Hello1$$`
- **Network Access**: Only allow trusted networks
- **Firewall**: Consider restricting port 8080 access
- **Updates**: Keep system and Wine dependencies updated

## 📁 Directory Structure

```
~/wine-manager/              # Main installation directory
├── venv/                    # Python virtual environment
├── novnc/                   # noVNC web client
├── config/                  # Service configurations
├── logs/                    # Service log files
├── scripts/                 # Helper scripts
├── start.sh                 # Start services
├── stop.sh                  # Stop services
├── status.sh                # Check status
└── healthcheck.sh           # Health monitoring
```

## 🎯 Performance Tips

### Optimize for Low-End Hardware
```bash
# Use lower resolution
export DISPLAY_RESOLUTION="800x600x24"
./start-wine-manager.sh
```

### Optimize for Gaming
```bash
# Enable hardware acceleration (if supported)
export MESA_GL_VERSION_OVERRIDE="3.3"
export MESA_GLSL_VERSION_OVERRIDE="330"
```

### Network Optimization
```bash
# Reduce VNC quality for slower connections
# Edit ~/wine-manager/config/supervisord-local.conf
# Add to x11vnc command: -compress 9 -quality 6
```

## 🚀 Advanced Usage

### Custom Applications
Add your own Windows applications by modifying desktop shortcuts:

```bash
# Create custom application shortcut
cat > ~/Desktop/My\ App.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=My Windows App
Exec=env DISPLAY=:99 wine /path/to/my/app.exe
Icon=applications-wine
Terminal=false
Categories=Game;Emulator;
EOF

chmod +x ~/Desktop/My\ App.desktop
```

### Automation
```bash
# Auto-start with system boot (systemd)
sudo tee /etc/systemd/system/wine-manager.service << EOF
[Unit]
Description=Wine Manager
After=network.target

[Service]
Type=forking
User=$USER
ExecStart=$HOME/wine-manager/start.sh
ExecStop=$HOME/wine-manager/stop.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable wine-manager.service
```

## 📚 Additional Resources

- **Wine Documentation**: https://www.winehq.org/documentation
- **Vinegar Project**: https://github.com/vinegarhq/vinegar
- **XFCE Desktop**: https://docs.xfce.org/
- **noVNC Project**: https://github.com/novnc/noVNC
- **Roblox Developer Hub**: https://create.roblox.com/docs
