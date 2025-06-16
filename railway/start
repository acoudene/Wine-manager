#!/bin/bash
set -e

# Wine Manager Railway - Complete Setup and Start Script
# This script handles EVERYTHING: dependencies, setup, configuration, and startup

export PORT=${PORT:-8080}
export DISPLAY=:0
export HOME=/root
export DEBIAN_FRONTEND=noninteractive

echo "🚀 Wine Manager Railway - Complete Setup & Start"
echo "================================================"
echo "Port: $PORT"
echo "Display: $DISPLAY"
echo "Time: $(date)"
echo "================================================"

# Step 1: Install any missing system dependencies
echo "📦 Step 1: Installing/Updating System Dependencies..."

# Update package lists
apt-get update >/dev/null 2>&1

# Install any missing critical packages
apt-get install -y --no-install-recommends \
    python3-pip python3-venv wget curl tar unzip \
    build-essential git ca-certificates >/dev/null 2>&1 || true

echo "✅ System dependencies updated"

# Step 2: Set up directories and environment
echo "🔧 Step 2: Setting Up Environment..."

# Create all necessary directories
mkdir -p /root/.local/bin
mkdir -p /root/.config
mkdir -p /root/Desktop
mkdir -p /root/.vnc
mkdir -p /var/log/supervisor

# Set up VNC password file
echo '$$Hello1$$' > /root/x11vnc_password.txt
echo '$$Hello1$$' > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

echo "✅ Environment setup complete"

# Step 3: Install and configure noVNC
echo "🌐 Step 3: Installing/Updating noVNC..."

cd /root

# Remove old versions if they exist
rm -rf /root/novnc /root/noVNC-* /root/websockify-*

# Install latest noVNC
echo "📥 Downloading noVNC v1.4.0..."
if wget -O - https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar -xzv; then
    mv noVNC-1.4.0 novnc
    ln -sf /root/novnc/vnc_lite.html /root/novnc/index.html
    echo "✅ noVNC installed"
else
    echo "❌ Failed to download noVNC"
    exit 1
fi

# Install latest websockify
echo "📥 Downloading websockify v0.12.0..."
if wget -O - https://github.com/novnc/websockify/archive/v0.12.0.tar.gz | tar -xzv; then
    mv websockify-0.12.0 novnc/utils/websockify
    echo "✅ websockify installed"
else
    echo "❌ Failed to download websockify"
    exit 1
fi

# Step 4: Install Wine dependencies for Vinegar
echo "🍷 Step 4: Installing Wine Dependencies..."

# Add Wine repository
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - >/dev/null 2>&1 || true
echo 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' | tee /etc/apt/sources.list.d/winehq.list >/dev/null

# Update and install Wine
apt-get update >/dev/null 2>&1
apt-get -y install --install-recommends winehq-stable winetricks >/dev/null 2>&1 || echo "Wine installation completed with warnings"

echo "✅ Wine dependencies installed"

# Step 5: Download and install Vinegar
echo "🍇 Step 5: Installing Vinegar..."

export PATH="/root/.local/bin:$PATH"

if [ ! -f "/root/.local/bin/vinegar" ]; then
    cd /tmp
    
    # Try downloading latest Vinegar
    if wget -O vinegar.tar.gz "https://github.com/vinegarhq/vinegar/releases/latest/download/vinegar-linux-amd64.tar.gz" 2>/dev/null; then
        tar -xzf vinegar.tar.gz
        chmod +x vinegar
        mv vinegar /root/.local/bin/
        echo "✅ Vinegar installed from tar.gz"
    elif wget -O vinegar.AppImage "https://github.com/vinegarhq/vinegar/releases/latest/download/vinegar-linux-x86_64.AppImage" 2>/dev/null; then
        chmod +x vinegar.AppImage
        mv vinegar.AppImage /root/.local/bin/vinegar
        echo "✅ Vinegar installed from AppImage"
    else
        echo "⚠️  Failed to download Vinegar, will retry during desktop setup"
    fi
else
    echo "✅ Vinegar already installed"
fi

# Step 6: Configure Vinegar
echo "⚙️  Step 6: Configuring Vinegar..."

mkdir -p /root/.config/vinegar

cat > /root/.config/vinegar/config.toml << EOF
[env]
fps_unlocker = true
multi_instance = false
wine_preset = "studio"

[env.wine]
base_dir = "/root/.local/share/vinegar/prefixes"

[env.studio]
channel = "LIVE"
editor = ""

[env.player]
channel = "LIVE"
renderer = "D3D11"
EOF

echo "✅ Vinegar configured"

# Step 7: Set up desktop shortcuts
echo "🖥️  Step 7: Creating Desktop Shortcuts..."

# Firefox shortcut
cat > /root/Desktop/Firefox.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox Web Browser
Comment=Browse the World Wide Web
Exec=firefox %u
Terminal=false
Icon=firefox
Categories=Network;WebBrowser;
StartupNotify=true
EOF

# Virtual Keyboard shortcut
cat > /root/Desktop/Virtual\ Keyboard.desktop << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Virtual Keyboard
Comment=On-screen keyboard for touch devices
Exec=onboard
Terminal=false
Icon=onboard
Categories=Utility;Accessibility;
EOF

# Roblox Studio shortcut
cat > /root/Desktop/Roblox\ Studio\ \(Vinegar\).desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Roblox Studio (Vinegar)
Comment=Roblox Studio via Vinegar - Optimized Wine setup
Exec=env PATH="/root/.local/bin:$PATH" /root/.local/bin/vinegar studio
Icon=applications-games
Terminal=false
Categories=Game;Development;
StartupNotify=true
EOF

# Roblox Player shortcut
cat > /root/Desktop/Roblox\ Player\ \(Vinegar\).desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Roblox Player (Vinegar)
Comment=Roblox Player via Vinegar - Optimized Wine setup
Exec=env PATH="/root/.local/bin:$PATH" /root/.local/bin/vinegar player
Icon=applications-games
Terminal=false
Categories=Game;Entertainment;
StartupNotify=true
EOF

chmod +x /root/Desktop/*.desktop

echo "✅ Desktop shortcuts created"

# Step 8: Configure supervisord with dynamic port
echo "📝 Step 8: Configuring Services..."

# Update supervisord configuration with the correct port
sed -i "s/--listen 8080/--listen $PORT/g" /etc/supervisor/conf.d/supervisord.conf

# Create enhanced supervisord configuration
cat > /etc/supervisor/conf.d/supervisord.conf << EOF
[supervisord]
nodaemon=true
logfile=/var/log/supervisor/supervisord.log
pidfile=/var/run/supervisord.pid

[program:xvfb]
command=/usr/bin/Xvfb :0 -screen 0 1024x768x24 -ac +extension GLX +render -noreset
autorestart=true
stdout_logfile=/var/log/supervisor/xvfb.log
stderr_logfile=/var/log/supervisor/xvfb.log
environment=DISPLAY=":0"
priority=100

[program:x11vnc]
command=/usr/bin/x11vnc -display :0 -noxrecord -usepw -passwdfile /root/x11vnc_password.txt -forever -shared
autorestart=true
stdout_logfile=/var/log/supervisor/x11vnc.log
stderr_logfile=/var/log/supervisor/x11vnc.log
environment=DISPLAY=":0"
priority=200

[program:novnc]
command=/usr/bin/python3 /root/novnc/utils/websockify/websockify.py --web /root/novnc --listen $PORT localhost:5900
autorestart=true
stdout_logfile=/var/log/supervisor/novnc.log
stderr_logfile=/var/log/supervisor/novnc.log
priority=300

[program:xfce4]
command=/usr/bin/startxfce4
autorestart=true
stdout_logfile=/var/log/supervisor/xfce4.log
stderr_logfile=/var/log/supervisor/xfce4.log
environment=DISPLAY=":0",HOME="/root"
priority=400

[program:desktop-setup]
command=/root/setup-desktop.sh
autorestart=false
stdout_logfile=/var/log/supervisor/desktop-setup.log
stderr_logfile=/var/log/supervisor/desktop-setup.log
environment=DISPLAY=":0",HOME="/root",PATH="/usr/local/bin:/usr/bin:/bin:/root/.local/bin"
priority=500

[program:onboard]
command=/usr/bin/onboard --size 1024x300 --startup-delay=10
autorestart=true
stdout_logfile=/var/log/supervisor/onboard.log
stderr_logfile=/var/log/supervisor/onboard.log
environment=DISPLAY=":0",HOME="/root"
priority=600
startretries=3
EOF

echo "✅ Services configured"

# Step 9: Initialize Wine prefix in background
echo "🔧 Step 9: Initializing Wine Environment..."

# Start Xvfb temporarily for Wine initialization
/usr/bin/Xvfb :0 -screen 0 1024x768x24 &
XVFB_PID=$!
sleep 3

# Initialize Wine prefix
export WINEPREFIX="/root/.local/share/vinegar/prefixes/studio"
export WINEARCH=win64

if [ ! -d "$WINEPREFIX" ]; then
    mkdir -p /root/.local/share/vinegar/prefixes
    timeout 120 wineboot --init >/dev/null 2>&1 || echo "Wine initialization completed"
    echo "✅ Wine prefix initialized"
else
    echo "✅ Wine prefix already exists"
fi

# Stop temporary Xvfb
kill $XVFB_PID 2>/dev/null || true
sleep 2

echo "✅ Wine environment ready"

# Step 10: Final system preparation
echo "🔧 Step 10: Final System Preparation..."

# Set up XFCE configuration
mkdir -p /root/.config/xfce4/xfconf/xfce-perchannel-xml

# Configure XFCE desktop
cat > /root/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml << EOF
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
mkdir -p /root/.config/onboard
cat > /root/.config/onboard/onboard.conf << EOF
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

echo "✅ System preparation complete"

echo ""
echo "🎉 === Setup Complete - Starting Services ==="
echo ""
echo "🖥️  Starting all services via supervisord..."
echo "🌐 Web interface will be available at port $PORT"
echo "🔑 VNC Password: $$Hello1$$"
echo ""

# Step 11: Start all services
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
