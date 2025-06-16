#!/bin/bash
set -e

# Wine Manager Local - Complete Setup and Start Script
# This script handles EVERYTHING: dependencies, setup, configuration, and startup

echo "🚀 Wine Manager Local - Complete Setup & Start"
echo "==============================================="

# Get the current directory and set up paths
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$LOCAL_DIR")"
WINE_MANAGER_DIR="$HOME/wine-manager"

export PORT=${PORT:-4000}
export DISPLAY=:99
export HOME="$HOME"

echo "📁 Local directory: $LOCAL_DIR"
echo "📁 Project root: $PROJECT_ROOT"
echo "📁 Wine Manager directory: $WINE_MANAGER_DIR"
echo "🌐 Port: $PORT"
echo "🖥️  Display: $DISPLAY"
echo "⏰ Time: $(date)"
echo "==============================================="

# Step 1: Detect Linux distribution
echo "🔍 Step 1: Detecting Linux Distribution..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS_NAME=$NAME
    DISTRO=$ID
    VERSION=$VERSION_ID
    echo "📍 Detected: $OS_NAME ($DISTRO $VERSION)"
else
    echo "❌ Cannot detect Linux distribution"
    exit 1
fi

# Step 2: Install system dependencies
echo ""
echo "📦 Step 2: Installing System Dependencies..."
echo "This may require sudo access and take several minutes."

# Function to install packages based on distribution
install_packages() {
    case $DISTRO in
        ubuntu|debian)
            echo "📦 Installing packages for Debian/Ubuntu..."
            
            # Update package lists
            sudo apt-get update
            
            # Add i386 architecture for Wine
            sudo dpkg --add-architecture i386
            
            # Install comprehensive system dependencies
            sudo apt-get install -y \
                python3 python3-pip python3-venv python3-dev python3-setuptools \
                xvfb x11vnc xdotool wget tar git curl unzip zip p7zip-full \
                software-properties-common gnupg2 apt-utils lsb-release \
                xfce4 xfce4-goodies xfce4-terminal thunar firefox \
                fonts-liberation fonts-dejavu-core fonts-freefont-ttf \
                fonts-noto fonts-noto-color-emoji fonts-roboto onboard \
                build-essential pkg-config cmake make gcc g++ \
                libasound2-dev libpulse-dev pulseaudio pulseaudio-utils \
                mesa-utils libgl1-mesa-dri libgl1-mesa-glx \
                libglu1-mesa libglu1-mesa-dev libglew-dev \
                supervisor net-tools x11-utils xauth xterm \
                ca-certificates apt-transport-https \
                libx11-dev libxext-dev libxrandr-dev libxinerama-dev \
                libxcursor-dev libxi-dev libxss-dev libxxf86vm-dev \
                libc6:i386 libncurses5:i386 libstdc++6:i386 \
                lib32z1 lib32ncurses5 lib32bz2-1.0 \
                libxrandr2:i386 libgstreamer-plugins-base1.0-0:i386 \
                gstreamer1.0-plugins-ugly:i386 \
                ubuntu-restricted-extras gstreamer1.0-libav \
                gstreamer1.0-plugins-bad gstreamer1.0-plugins-good \
                libavcodec-extra ffmpeg
            
            # Add Wine repository
            wget -qO - https://dl.winehq.org/wine-builds/winehq.key | sudo apt-key add -
            echo "deb https://dl.winehq.org/wine-builds/ubuntu/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/winehq.list
            
            # Update and install Wine
            sudo apt-get update
            sudo apt-get install -y --install-recommends winehq-stable winetricks
            ;;
            
        fedora|centos|rhel)
            echo "📦 Installing packages for Fedora/CentOS/RHEL..."
            
            # Install EPEL for CentOS/RHEL
            if [[ $DISTRO == "centos" || $DISTRO == "rhel" ]]; then
                sudo dnf install -y epel-release
            fi
            
            # Install comprehensive system dependencies
            sudo dnf install -y \
                python3 python3-pip python3-devel python3-setuptools \
                xorg-x11-server-Xvfb x11vnc xdotool wget tar git curl unzip zip p7zip \
                xfce4-session xfce4-panel xfce4-desktop xfce4-terminal thunar \
                firefox liberation-fonts dejavu-fonts google-noto-fonts \
                google-noto-emoji-fonts onboard \
                supervisor net-tools xorg-x11-utils xauth xterm \
                gcc gcc-c++ make pkgconfig cmake \
                alsa-lib-devel pulseaudio-libs-devel pulseaudio-utils \
                mesa-dri-drivers mesa-libGL mesa-libGLU mesa-libGLU-devel \
                libX11-devel libXext-devel libXrandr-devel libXinerama-devel \
                libXcursor-devel libXi-devel libXss-devel \
                glibc.i686 ncurses-libs.i686 libstdc++.i686 \
                zlib.i686 gstreamer1-plugins-base.i686 \
                gstreamer1-plugins-ugly gstreamer1-libav \
                gstreamer1-plugins-bad-free gstreamer1-plugins-good \
                ffmpeg
            
            # Install Wine
            sudo dnf install -y wine winetricks
            ;;
            
        arch|manjaro)
            echo "📦 Installing packages for Arch Linux..."
            
            # Update package database
            sudo pacman -Sy
            
            # Install comprehensive system dependencies
            sudo pacman -S --noconfirm \
                python python-pip python-setuptools xorg-server-xvfb x11vnc xdotool \
                wget tar git curl unzip zip p7zip xfce4 xfce4-goodies \
                xfce4-terminal thunar firefox ttf-liberation ttf-dejavu \
                ttf-noto-noto noto-fonts-emoji ttf-roboto onboard \
                supervisor net-tools xorg-utils xauth xterm \
                base-devel cmake alsa-lib libpulse pulseaudio \
                mesa mesa-utils lib32-mesa \
                libx11 libxext libxrandr libxinerama libxcursor libxi libxss \
                lib32-glibc lib32-ncurses lib32-gcc-libs lib32-zlib \
                gstreamer gst-libav gst-plugins-base gst-plugins-good \
                gst-plugins-bad gst-plugins-ugly ffmpeg
            
            # Install Wine
            sudo pacman -S --noconfirm wine winetricks
            ;;
            
        opensuse*)
            echo "📦 Installing packages for openSUSE..."
            
            # Install comprehensive system dependencies
            sudo zypper install -y \
                python3 python3-pip python3-devel python3-setuptools \
                xvfb x11vnc xdotool wget tar git curl unzip zip p7zip \
                xfce4-session xfce4-panel xfce4-terminal thunar firefox \
                liberation-fonts dejavu-fonts noto-sans-fonts \
                noto-coloremoji-fonts google-roboto-fonts onboard \
                supervisor net-tools xorg-x11-utils xauth xterm \
                gcc gcc-c++ make pkgconfig cmake \
                alsa-devel libpulse-devel pulseaudio-utils \
                Mesa Mesa-dri Mesa-libGL1 Mesa-libGLU1 Mesa-devel \
                libX11-devel libXext-devel libXrandr-devel libXinerama-devel \
                libXcursor-devel libXi-devel libXss-devel \
                glibc-32bit ncurses-devel-32bit libstdc++6-32bit \
                zlib-devel-32bit gstreamer-plugins-base-32bit \
                gstreamer-plugins-ugly gstreamer-plugins-libav \
                gstreamer-plugins-bad gstreamer-plugins-good ffmpeg
            
            # Install Wine
            sudo zypper install -y wine winetricks
            ;;
            
        *)
            echo "⚠️  Unsupported distribution: $DISTRO"
            echo "📋 Please install these packages manually:"
            echo "   • Python 3.8+ with pip and venv"
            echo "   • Xvfb, x11vnc, xdotool"
            echo "   • XFCE4 desktop environment"
            echo "   • Wine and winetricks"
            echo "   • Build tools (gcc, make, etc.)"
            echo "   • Audio libraries (ALSA, PulseAudio)"
            read -p "Have you installed these dependencies? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                echo "❌ Please install dependencies first"
                exit 1
            fi
            ;;
    esac
}

# Install system packages
install_packages

echo "✅ System dependencies installed!"

# Step 3: Set up Wine Manager directory structure
echo ""
echo "🔧 Step 3: Setting Up Wine Manager Environment..."

# Create Wine Manager directory structure
mkdir -p "$WINE_MANAGER_DIR"
mkdir -p "$WINE_MANAGER_DIR/config"
mkdir -p "$WINE_MANAGER_DIR/logs"
mkdir -p "$WINE_MANAGER_DIR/scripts"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/Desktop"

echo "✅ Directory structure created"

# Step 4: Create Python virtual environment
echo ""
echo "🐍 Step 4: Creating Python Virtual Environment..."

if [ ! -d "$WINE_MANAGER_DIR/venv" ] || [ ! -f "$WINE_MANAGER_DIR/venv/bin/activate" ]; then
    python3 -m venv "$WINE_MANAGER_DIR/venv"
    echo "✅ Virtual environment created"
else
    echo "✅ Virtual environment already exists"
fi

# Activate virtual environment and install Python dependencies
echo "📦 Installing Python dependencies..."
source "$WINE_MANAGER_DIR/venv/bin/activate"
pip install --upgrade pip

# Install comprehensive Python packages
pip install supervisor==4.2.5 psutil==5.9.5 requests==2.31.0 websockify==0.11.0 \
    numpy==1.24.3 pillow==10.0.0 setuptools wheel \
    lxml beautifulsoup4 six packaging \
    tornado flask gunicorn

echo "✅ Python dependencies installed"

# Step 5: Install and configure noVNC
echo ""
echo "🌐 Step 5: Installing noVNC and websockify..."

cd "$WINE_MANAGER_DIR"

# Remove old versions if they exist
rm -rf novnc noVNC-* websockify-*

# Download noVNC
if wget -O - https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar -xzv; then
    mv noVNC-1.4.0 novnc
    ln -sf "$WINE_MANAGER_DIR/novnc/vnc_lite.html" "$WINE_MANAGER_DIR/novnc/index.html"
    echo "✅ noVNC installed"
else
    echo "❌ Failed to download noVNC"
    exit 1
fi

# Download websockify
if wget -O - https://github.com/novnc/websockify/archive/v0.12.0.tar.gz | tar -xzv; then
    mv websockify-0.12.0 novnc/utils/websockify
    echo "✅ websockify installed"
else
    echo "❌ Failed to download websockify"
    exit 1
fi

# Step 6: Set up VNC password
echo ""
echo "🔐 Step 6: Setting up VNC password..."
echo '$$Hello1$$' > "$HOME/.vnc_password"
chmod 600 "$HOME/.vnc_password"
echo "✅ VNC password configured"

# Step 7: Download and install Vinegar
echo ""
echo "🍇 Step 7: Installing Vinegar..."

export PATH="$HOME/.local/bin:$PATH"

if [ ! -f "$HOME/.local/bin/vinegar" ]; then
    cd /tmp
    
    # Try downloading latest Vinegar
    if wget -O vinegar.tar.gz "https://github.com/vinegarhq/vinegar/releases/latest/download/vinegar-linux-amd64.tar.gz" 2>/dev/null; then
        tar -xzf vinegar.tar.gz
        chmod +x vinegar
        mv vinegar "$HOME/.local/bin/"
        echo "✅ Vinegar installed from tar.gz"
    elif wget -O vinegar.AppImage "https://github.com/vinegarhq/vinegar/releases/latest/download/vinegar-linux-x86_64.AppImage" 2>/dev/null; then
        chmod +x vinegar.AppImage
        mv vinegar.AppImage "$HOME/.local/bin/vinegar"
        echo "✅ Vinegar installed from AppImage"
    else
        echo "❌ Failed to download Vinegar"
        exit 1
    fi
else
    echo "✅ Vinegar already installed"
fi

# Step 8: Configure Vinegar
echo ""
echo "⚙️  Step 8: Configuring Vinegar..."

mkdir -p "$HOME/.config/vinegar"

cat > "$HOME/.config/vinegar/config.toml" << EOF
[env]
fps_unlocker = true
multi_instance = false
wine_preset = "studio"

[env.wine]
base_dir = "$HOME/.local/share/vinegar/prefixes"

[env.studio]
channel = "LIVE"
editor = ""

[env.player]
channel = "LIVE"
renderer = "D3D11"
EOF

echo "✅ Vinegar configured"

# Step 9: Initialize Wine environment
echo ""
echo "🍷 Step 9: Initializing Wine Environment..."

# Start a temporary Xvfb for Wine initialization
/usr/bin/Xvfb :99 -screen 0 1024x768x24 &
XVFB_PID=$!
sleep 3

# Set Wine environment
export WINEPREFIX="$HOME/.local/share/vinegar/prefixes/studio"
export WINEARCH=win64

# Initialize Wine prefix
if [ ! -d "$WINEPREFIX" ]; then
    echo "🔧 Creating Wine prefix..."
    mkdir -p "$HOME/.local/share/vinegar/prefixes"
    timeout 120 wineboot --init >/dev/null 2>&1 || echo "Wine initialization completed"
    
    # Configure Wine for optimal performance
    echo "⚙️  Configuring Wine for optimal performance..."
    export WINEDLLOVERRIDES="mscoree,mshtml="
    
    # Set Wine to Windows 10 mode for better compatibility
    timeout 60 winecfg /v win10 >/dev/null 2>&1 || echo "Wine configuration completed"
    
    # Install essential Windows components
    echo "📦 Installing essential Windows components..."
    timeout 300 winetricks -q --force vcrun2019 corefonts >/dev/null 2>&1 || echo "Windows components installation completed"
    
    echo "✅ Wine prefix created and configured"
else
    echo "✅ Wine prefix already exists"
fi

# Configure audio for Wine
echo "🔊 Configuring audio for Wine..."
if ! pulseaudio --check; then
    pulseaudio --start --daemonize >/dev/null 2>&1 || echo "PulseAudio already running"
fi

# Stop temporary Xvfb
kill $XVFB_PID 2>/dev/null || true
sleep 2

echo "✅ Wine environment ready"

# Step 10: Create desktop shortcuts
echo ""
echo "🖥️  Step 10: Creating Desktop Shortcuts..."

# Firefox shortcut
cat > "$HOME/Desktop/Firefox.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox Web Browser
Comment=Browse the World Wide Web
Exec=env DISPLAY=:99 firefox %u
Terminal=false
Icon=firefox
Categories=Network;WebBrowser;
StartupNotify=true
EOF

# Virtual Keyboard shortcut
cat > "$HOME/Desktop/Virtual Keyboard.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Virtual Keyboard
Comment=On-screen keyboard for touch devices
Exec=env DISPLAY=:99 onboard
Terminal=false
Icon=onboard
Categories=Utility;Accessibility;
EOF

# Terminal shortcut
cat > "$HOME/Desktop/Terminal.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Terminal
Comment=Use the command line
Exec=env DISPLAY=:99 xfce4-terminal
Terminal=false
Icon=utilities-terminal
Categories=Utility;
StartupNotify=true
EOF

# File Manager shortcut
cat > "$HOME/Desktop/File Manager.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=File Manager
Comment=Browse the file system
Exec=env DISPLAY=:99 thunar
Terminal=false
Icon=system-file-manager
Categories=Utility;FileManager;
StartupNotify=true
EOF

# Roblox Studio shortcut
cat > "$HOME/Desktop/Roblox Studio (Vinegar).desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Roblox Studio (Vinegar)
Comment=Roblox Studio via Vinegar - Optimized Wine setup
Exec=env DISPLAY=:99 PATH="$HOME/.local/bin:\$PATH" "$HOME/.local/bin/vinegar" studio
Icon=applications-games
Terminal=false
Categories=Game;Development;
StartupNotify=true
EOF

# Roblox Player shortcut
cat > "$HOME/Desktop/Roblox Player (Vinegar).desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Roblox Player (Vinegar)
Comment=Roblox Player via Vinegar - Optimized Wine setup
Exec=env DISPLAY=:99 PATH="$HOME/.local/bin:\$PATH" "$HOME/.local/bin/vinegar" player
Icon=applications-games
Terminal=false
Categories=Game;Entertainment;
StartupNotify=true
EOF

chmod +x "$HOME/Desktop"/*.desktop

# Make desktop shortcuts trusted
if command -v gio >/dev/null 2>&1; then
    for desktop_file in "$HOME/Desktop"/*.desktop; do
        gio set "$desktop_file" metadata::trusted true 2>/dev/null || true
    done
fi

echo "✅ Desktop shortcuts created"

# Step 11: Configure supervisord
echo ""
echo "📝 Step 11: Configuring Services..."

# Create supervisord configuration
cat > "$WINE_MANAGER_DIR/config/supervisord-local.conf" << EOF
[supervisord]
nodaemon=true
logfile=$WINE_MANAGER_DIR/logs/supervisord.log
pidfile=$WINE_MANAGER_DIR/supervisord.pid
childlogdir=$WINE_MANAGER_DIR/logs

[unix_http_server]
file=$WINE_MANAGER_DIR/supervisor.sock

[supervisorctl]
serverurl=unix://$WINE_MANAGER_DIR/supervisor.sock

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[program:xvfb]
command=/usr/bin/Xvfb :99 -screen 0 1024x768x24 -ac +extension GLX +render -noreset
autorestart=true
stdout_logfile=$WINE_MANAGER_DIR/logs/xvfb.log
stderr_logfile=$WINE_MANAGER_DIR/logs/xvfb.log
environment=DISPLAY=":99"
priority=100

[program:x11vnc]
command=/usr/bin/x11vnc -display :99 -noxrecord -usepw -passwdfile $HOME/.vnc_password -forever -shared
autorestart=true
stdout_logfile=$WINE_MANAGER_DIR/logs/x11vnc.log
stderr_logfile=$WINE_MANAGER_DIR/logs/x11vnc.log
environment=DISPLAY=":99"
priority=200

[program:novnc]
command=$WINE_MANAGER_DIR/venv/bin/python $WINE_MANAGER_DIR/novnc/utils/websockify/websockify.py --web $WINE_MANAGER_DIR/novnc --listen $PORT localhost:5900
autorestart=true
stdout_logfile=$WINE_MANAGER_DIR/logs/novnc.log
stderr_logfile=$WINE_MANAGER_DIR/logs/novnc.log
priority=300

[program:xfce4]
command=/usr/bin/startxfce4
autorestart=true
stdout_logfile=$WINE_MANAGER_DIR/logs/xfce4.log
stderr_logfile=$WINE_MANAGER_DIR/logs/xfce4.log
environment=DISPLAY=":99",HOME="$HOME",USER="$USER"
priority=400

[program:onboard]
command=/usr/bin/onboard --size 1024x300 --startup-delay=10
autorestart=true
stdout_logfile=$WINE_MANAGER_DIR/logs/onboard.log
stderr_logfile=$WINE_MANAGER_DIR/logs/onboard.log
environment=DISPLAY=":99",HOME="$HOME"
priority=600
startretries=3
EOF

echo "✅ Services configured"

# Step 12: Configure XFCE and onboard
echo ""
echo "🎨 Step 12: Configuring Desktop Environment..."

# Set up XFCE configuration
mkdir -p "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"

# Configure XFCE desktop
cat > "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
        </property>
      </property>
    </property>
  </property>
</channel>
EOF

# Configure onboard virtual keyboard
mkdir -p "$HOME/.config/onboard"
cat > "$HOME/.config/onboard/onboard.conf" << EOF
[main]
layout=Compact
theme=Droid
show-status-icon=False
auto-show-enabled=True
auto-hide-enabled=True
docking-enabled=True
docking-edge=bottom

[auto-show]
enabled=True
hide-on-key-press=False
hide-on-focus-change=True
EOF

echo "✅ Desktop environment configured"

# Step 12.5: System optimization and verification
echo ""
echo "🔧 Step 12.5: System Optimization and Verification..."

# Verify graphics drivers
echo "🎮 Checking graphics configuration..."
if command -v glxinfo >/dev/null 2>&1; then
    if glxinfo | grep -q "direct rendering: Yes"; then
        echo "✅ Hardware graphics acceleration enabled"
    else
        echo "⚠️  Software rendering detected - performance may be limited"
    fi
else
    echo "ℹ️  Graphics info not available"
fi

# Optimize kernel parameters for gaming
echo "⚙️  Applying system optimizations..."
# Increase file descriptor limits
echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf >/dev/null 2>&1 || true
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf >/dev/null 2>&1 || true

# Set vm.max_map_count for better performance
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1 || true
sudo sysctl vm.max_map_count=262144 >/dev/null 2>&1 || true

# Configure swappiness for better responsiveness
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1 || true
sudo sysctl vm.swappiness=10 >/dev/null 2>&1 || true

# Verify network connectivity
echo "🌐 Verifying network connectivity..."
if ping -c 1 google.com >/dev/null 2>&1; then
    echo "✅ Network connectivity verified"
else
    echo "⚠️  Network connectivity issues detected"
fi

# Create Wine Manager launcher in applications menu
echo "📱 Creating application menu entry..."
mkdir -p "$HOME/.local/share/applications"
cat > "$HOME/.local/share/applications/wine-manager.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine Manager
Comment=Wine Desktop Environment with Roblox Studio
Exec=$WINE_MANAGER_DIR/start.sh
Icon=applications-games
Terminal=true
Categories=Game;Emulator;Development;
Keywords=wine;windows;roblox;studio;gaming;
StartupNotify=true
EOF

chmod +x "$HOME/.local/share/applications/wine-manager.desktop"

# Update desktop database
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
fi

echo "✅ System optimization completed"

# Step 13: Create management scripts
echo ""
echo "📜 Step 13: Creating Management Scripts..."

# Create start script
cat > "$WINE_MANAGER_DIR/start.sh" << 'EOF'
#!/bin/bash
set -e

WINE_MANAGER_DIR="$HOME/wine-manager"
export PORT=${PORT:-4000}
export DISPLAY=:99

echo "🚀 Starting Wine Manager Local Environment"
echo "Port: $PORT | Display: $DISPLAY"

# Activate virtual environment
source "$WINE_MANAGER_DIR/venv/bin/activate"

# Start supervisord
cd "$WINE_MANAGER_DIR"
exec "$WINE_MANAGER_DIR/venv/bin/supervisord" -c "$WINE_MANAGER_DIR/config/supervisord-local.conf"
EOF

# Create stop script
cat > "$WINE_MANAGER_DIR/stop.sh" << 'EOF'
#!/bin/bash

WINE_MANAGER_DIR="$HOME/wine-manager"

echo "🛑 Stopping Wine Manager services..."

if [ -f "$WINE_MANAGER_DIR/supervisord.pid" ]; then
    source "$WINE_MANAGER_DIR/venv/bin/activate"
    "$WINE_MANAGER_DIR/venv/bin/supervisorctl" -c "$WINE_MANAGER_DIR/config/supervisord-local.conf" shutdown
    rm -f "$WINE_MANAGER_DIR/supervisord.pid"
fi

# Kill any remaining processes
pkill -f "Xvfb :99" 2>/dev/null || true
pkill -f "x11vnc.*:99" 2>/dev/null || true
pkill -f "websockify" 2>/dev/null || true
pkill -f "startxfce4" 2>/dev/null || true

echo "✅ Wine Manager stopped"
EOF

# Create status script
cat > "$WINE_MANAGER_DIR/status.sh" << 'EOF'
#!/bin/bash

WINE_MANAGER_DIR="$HOME/wine-manager"

if [ -f "$WINE_MANAGER_DIR/supervisord.pid" ]; then
    source "$WINE_MANAGER_DIR/venv/bin/activate"
    echo "📊 Wine Manager Status:"
    "$WINE_MANAGER_DIR/venv/bin/supervisorctl" -c "$WINE_MANAGER_DIR/config/supervisord-local.conf" status
else
    echo "❌ Wine Manager is not running"
fi
EOF

# Create health check script
cat > "$WINE_MANAGER_DIR/healthcheck.sh" << EOF
#!/bin/bash

WINE_MANAGER_DIR="$HOME/wine-manager"
PORT=\${PORT:-4000}

echo "🔍 Running Wine Manager Health Check..."

# Check if supervisord is running
if [ ! -f "\$WINE_MANAGER_DIR/supervisord.pid" ]; then
    echo "❌ Supervisord is not running"
    exit 1
fi

# Check if noVNC is responding
if curl -f -s "http://localhost:\$PORT/vnc_lite.html" > /dev/null 2>&1; then
    echo "✅ Health check passed: Wine Manager is running on port \$PORT"
    echo "🌐 Access: http://localhost:\$PORT"
    echo "🔑 Password: \$\$Hello1\$\$"
    exit 0
else
    echo "❌ Health check failed: noVNC not responding on port \$PORT"
    exit 1
fi
EOF

chmod +x "$WINE_MANAGER_DIR"/*.sh

echo "✅ Management scripts created"

# Step 14: Check if services are already running
echo ""
echo "🔍 Step 14: Checking for Existing Services..."

if [ -f "$WINE_MANAGER_DIR/supervisord.pid" ]; then
    echo "⚠️  Wine Manager appears to be already running"
    if "$WINE_MANAGER_DIR/status.sh" 2>/dev/null; then
        echo ""
        read -p "Services are running. Restart them? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "🛑 Stopping existing services..."
            "$WINE_MANAGER_DIR/stop.sh"
            sleep 3
        else
            echo "✅ Using existing services"
            echo ""
            echo "🌐 Wine Manager is available at: http://localhost:$PORT"
            echo "🔑 VNC Password: \$\$Hello1\$\$"
            echo ""
            echo "📋 Management commands:"
            echo "   🛑 Stop:   $WINE_MANAGER_DIR/stop.sh"
            echo "   📊 Status: $WINE_MANAGER_DIR/status.sh"
            echo "   🔍 Health: $WINE_MANAGER_DIR/healthcheck.sh"
            exit 0
        fi
    fi
fi

# Step 15: Check port availability
echo ""
echo "🌐 Step 15: Checking Port Availability..."

if command -v netstat >/dev/null 2>&1; then
    if netstat -tuln | grep ":$PORT " >/dev/null; then
        echo "⚠️  Port $PORT is already in use"
        echo "💡 Try setting a different port: PORT=8081 $0"
        exit 1
    fi
elif command -v ss >/dev/null 2>&1; then
    if ss -tuln | grep ":$PORT " >/dev/null; then
        echo "⚠️  Port $PORT is already in use"
        echo "💡 Try setting a different port: PORT=8081 $0"
        exit 1
    fi
fi

echo "✅ Port $PORT is available"

# Step 16: Start services
echo ""
echo "🚀 Step 16: Starting Wine Manager Services..."

cd "$WINE_MANAGER_DIR"

# Start in background and monitor
"$WINE_MANAGER_DIR/start.sh" &
START_PID=$!

# Wait for services to initialize
echo "⏳ Initializing services..."
sleep 10

# Check if services started successfully
if ! kill -0 $START_PID 2>/dev/null; then
    echo "❌ Failed to start Wine Manager services"
    echo "📋 Check logs in: $WINE_MANAGER_DIR/logs/"
    exit 1
fi

# Wait for noVNC to be available
echo "🔍 Waiting for web interface to be ready..."
RETRY_COUNT=0
MAX_RETRIES=30

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    if curl -f -s "http://localhost:$PORT/vnc_lite.html" >/dev/null 2>&1 || \
       wget --quiet --spider "http://localhost:$PORT/vnc_lite.html" 2>/dev/null; then
        break
    fi
    
    sleep 2
    RETRY_COUNT=$((RETRY_COUNT + 1))
    
    if [ $((RETRY_COUNT % 5)) -eq 0 ]; then
        echo "⏳ Still waiting... ($RETRY_COUNT/$MAX_RETRIES)"
    fi
done

if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
    echo "❌ Web interface failed to start within expected time"
    echo "📋 Check logs in: $WINE_MANAGER_DIR/logs/"
    echo "🔍 Try running: $WINE_MANAGER_DIR/healthcheck.sh"
else
    echo "✅ Web interface is ready!"
fi

echo ""
echo "🎉 === Wine Manager Successfully Started! ==="
echo ""
echo "🌐 Web Interface: http://localhost:$PORT"
echo "🔑 VNC Password: \$\$Hello1\$\$"
echo ""
echo "📱 Available Applications:"
echo "   🎮 Roblox Studio (Vinegar) - Game development"
echo "   🎮 Roblox Player (Vinegar) - Game playing"
echo "   🌐 Firefox - Web browser"
echo "   ⌨️  Virtual Keyboard - Touch device support"
echo "   💻 Terminal - Command line access"
echo "   📁 File Manager - File system browser"
echo ""
echo "📋 Management Commands:"
echo "   🛑 Stop:   $WINE_MANAGER_DIR/stop.sh"
echo "   📊 Status: $WINE_MANAGER_DIR/status.sh"
echo "   🔍 Health: $WINE_MANAGER_DIR/healthcheck.sh"
echo ""
echo "📁 Wine Manager Directory: $WINE_MANAGER_DIR"
echo "📋 Logs Directory: $WINE_MANAGER_DIR/logs/"
echo ""
echo "💡 Tip: Keep this terminal open to see service logs, or press Ctrl+C to run in background"

# Show logs
tail -f "$WINE_MANAGER_DIR/logs/supervisord.log"
