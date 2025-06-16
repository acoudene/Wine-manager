# Wine Manager

🍷 **Modern Wine Desktop with Roblox Studio Support** 🎮

A complete containerized and local Wine environment accessible via web browser, featuring a modern XFCE desktop and optimized Roblox Studio for game development!

[![Docker Pulls](https://img.shields.io/docker/pulls/solarkennedy/wine-x11-novnc-docker)](https://hub.docker.com/r/solarkennedy/wine-x11-novnc-docker)
[![Railway Deploy](https://railway.app/button.svg)](https://railway.app)

## ✨ Features

- 🎮 **Roblox Studio (Vinegar)** - Optimized game development environment with superior compatibility
- 🌐 **Web-based Desktop** - Access via any web browser, no VNC client needed
- 🍷 **Wine 64-bit** - Run Windows applications seamlessly on Linux
- 🖥️ **XFCE Desktop** - Modern, lightweight desktop environment
- ⌨️ **Virtual Keyboard** - Perfect for mobile devices and touch screens
- 🌐 **Firefox Browser** - Full web browsing capabilities
- 🐍 **Python Environment** - Isolated dependencies with virtual environment
- 🔧 **Complete Management** - Full service control and monitoring

## 🚀 Quick Start

### 🌐 Cloud Deployment (Railway)

Deploy to Railway.com cloud platform instantly:

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app)

**OR manually:**

1. Fork this repository
2. Connect to [Railway.app](https://railway.app)
3. Deploy from the `railway/` folder
4. Access via your Railway URL
5. Password: `$$Hello1$$`

**[📖 Full Railway Documentation →](railway/README.md)**

### 🖥️ Local Installation (Linux)

Run locally on any Linux machine with one command:

```bash
# Clone repository
git clone https://github.com/moonsip1224/Wine-manager.git
cd Wine-manager/local

# Single command installation and startup (handles EVERYTHING)
./start
```

This script automatically:
- ✅ Detects your Linux distribution
- ✅ Installs ALL dependencies (Wine, XFCE, Python, etc.)
- ✅ Sets up Python virtual environment
- ✅ Downloads and configures Vinegar
- ✅ Initializes Wine prefix for Roblox
- ✅ Starts all services

**[📖 Full Local Documentation →](local/README.md)**

## 📁 Project Structure

```
Wine-manager/
├── railway/                 # ☁️  Cloud deployment (Railway.com)
│   ├── Dockerfile          # Container definition
│   ├── start.sh            # Complete setup & start script
│   ├── install-vinegar.sh  # Vinegar installation
│   ├── setup-desktop.sh    # Desktop environment setup
│   ├── supervisord*.conf   # Service management
│   ├── healthcheck.sh      # Health monitoring
│   ├── railway.json        # Railway configuration
│   └── README.md           # Railway deployment guide
│
├── local/                   # 🖥️  Local deployment (Linux)
│   ├── start                        # Complete setup & start script
│   ├── install-dependencies.sh      # System dependency installer
│   ├── setup-local.sh              # Environment configurator
│   ├── install-vinegar-local.sh     # Vinegar for local setup
│   ├── setup-desktop-local.sh       # Desktop setup for local
│   ├── supervisord-local.conf       # Local service management
│   ├── requirements.txt             # Python dependencies
│   ├── healthcheck-local.sh         # Local health monitoring
│   └── README.md                    # Local deployment guide
│
├── .github/workflows/       # 🔄 GitHub Actions
├── Makefile                # 🐳 Docker build commands
├── LICENSE                 # 📄 Apache 2.0 License
└── README.md               # 📖 This file
```

## 🎮 Roblox Studio Features

### Why Vinegar?

We use **Vinegar** instead of manual Wine setup for superior Roblox compatibility:

| Feature | Manual Wine | **Vinegar** |
|---------|-------------|-------------|
| Anti-cheat compatibility | ❌ Issues | ✅ **Perfect** |
| FPS unlocker support | ❌ Manual setup | ✅ **Built-in** |
| Wine optimization | ❌ Generic | ✅ **Roblox-specific** |
| Automatic updates | ❌ Manual | ✅ **Automatic** |
| Stability | ⚠️ Variable | ✅ **Rock solid** |
| Setup complexity | 😰 Complex | 😎 **One-click** |

### Available Applications

Once running, access these applications via the web interface:

- 🎮 **Roblox Studio** - Full game development environment
- 🎮 **Roblox Player** - Play games with friends
- 🌐 **Firefox** - Browse documentation and tutorials
- ⌨️ **Virtual Keyboard** - Mobile and touch device support
- 💻 **Terminal** - Command line access
- 📁 **File Manager** - Project file management

## 📊 Comparison: Railway vs Local

| Feature | Railway ☁️ | Local 🖥️ |
|---------|------------|----------|
| **Setup Time** | 5 minutes | 10-15 minutes |
| **Cost** | Free tier available | Free (your hardware) |
| **Performance** | Good | Excellent |
| **Customization** | Limited | Full control |
| **Persistence** | Limited storage | Full disk access |
| **Network Access** | Global URL | Local network |
| **Resource Control** | Platform limits | Your hardware limits |
| **Ideal For** | Quick testing, demos | Development, gaming |

## 🔧 Configuration

### Environment Variables

**Both deployments support:**
- `PORT` - Web interface port (default: 8080 for Railway, 4000 for local)

**Local deployment also supports:**
- `DISPLAY_RESOLUTION` - Screen resolution (default: 1024x768x24)

### VNC Access

- **URL**: Your deployment URL or `http://localhost:4000` (local) / `http://localhost:8080` (Railway)
- **Password**: `$$Hello1$$`

### Wine Configuration

- **Architecture**: 64-bit (win64)
- **Prefix Location**: 
  - Railway: `/root/.local/share/vinegar/prefixes/studio`
  - Local: `~/.local/share/vinegar/prefixes/studio`

## 🛠️ Development

### Building Locally

```bash
# Build Docker image (Railway setup)
make build

# Run locally with Docker
make run

# Get shell access
make shell
```

### Customizing

**Add your own Windows applications:**

1. **Railway**: Modify `railway/setup-desktop.sh`
2. **Local**: Create desktop shortcuts in `~/Desktop/`

**Example custom application:**
```bash
cat > ~/Desktop/My\ App.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=My Windows App
Exec=wine /path/to/app.exe
Icon=applications-wine
Terminal=false
EOF
```

## 🔍 Monitoring & Troubleshooting

### Health Checks

**Railway**: Automatic health monitoring via platform
**Local**: Run `~/wine-manager/healthcheck.sh`

### Common Issues

| Issue | Railway Solution | Local Solution |
|-------|------------------|----------------|
| **Build fails** | Check Railway logs | Check system dependencies |
| **VNC not accessible** | Verify health check | Check port availability |
| **Roblox won't start** | Wait for Wine init | Restart Wine prefix |
| **Performance issues** | Upgrade Railway tier | Check system resources |

### Logs

**Railway**: View via Railway dashboard
**Local**: Check `~/wine-manager/logs/`

## 📚 Resources

### Documentation
- [Railway Deployment Guide](railway/README.md)
- [Local Installation Guide](local/README.md)
- [Docker Documentation](https://docs.docker.com/)
- [Wine Documentation](https://www.winehq.org/documentation)

### Related Projects
- [Vinegar](https://github.com/vinegarhq/vinegar) - Optimized Roblox launcher
- [noVNC](https://github.com/novnc/noVNC) - Web-based VNC client
- [XFCE](https://www.xfce.org/) - Desktop environment

### Community
- [Roblox Developer Hub](https://create.roblox.com/docs)
- [Wine AppDB](https://appdb.winehq.org/) - Application compatibility
- [Vinegar Discord](https://discord.gg/vinegar) - Vinegar support

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test both Railway and local deployments
5. Submit a pull request

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## ⭐ Support

If this project helps you, please give it a star! ⭐

For issues and questions:
1. Check the documentation in `railway/` or `local/` folders
2. Search existing GitHub issues
3. Create a new issue with logs and system details

---

**🎮 Happy game development with Roblox Studio! 🚀**
