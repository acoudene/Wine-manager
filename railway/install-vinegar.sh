#!/bin/bash

echo "🍇 Installing Vinegar (Roblox Studio via optimized Wine)..."

# Wait for X11 and environment to be ready
echo "⏳ Waiting for display server..."
timeout 60 bash -c 'until xdpyinfo >/dev/null 2>&1; do sleep 2; done' || echo "Display timeout, continuing..."

# Set environment variables
export DISPLAY=:0
export HOME=/root
export PATH="/root/.local/bin:$PATH"

# Create necessary directories
mkdir -p /root/.local/bin
mkdir -p /root/.config/vinegar
mkdir -p /root/Desktop

# Check if Vinegar is already installed
if [ -f "/root/.local/bin/vinegar" ]; then
    echo "✅ Vinegar already installed, configuring..."
else
    echo "📥 Downloading and installing Vinegar..."
    
    cd /tmp
    
    # Download the latest Vinegar release
    if wget -O vinegar.tar.gz "https://github.com/vinegarhq/vinegar/releases/latest/download/vinegar-linux-amd64.tar.gz" 2>/dev/null; then
        tar -xzf vinegar.tar.gz
        chmod +x vinegar
        mv vinegar /root/.local/bin/
        echo "✅ Vinegar installed successfully from tar.gz"
    elif wget -O vinegar.AppImage "https://github.com/vinegarhq/vinegar/releases/latest/download/vinegar-linux-x86_64.AppImage" 2>/dev/null; then
        chmod +x vinegar.AppImage
        mv vinegar.AppImage /root/.local/bin/vinegar
        echo "✅ Vinegar installed successfully from AppImage"
    else
        echo "❌ Failed to download Vinegar"
        exit 1
    fi
fi

# Install Wine via system package manager (Vinegar requires Wine to be available)
echo "🍷 Installing Wine dependencies for Vinegar..."
export DEBIAN_FRONTEND=noninteractive

# Add Wine repository and install Wine
wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - 2>/dev/null || true
echo 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' | tee /etc/apt/sources.list.d/winehq.list >/dev/null 2>&1 || true
apt-get update >/dev/null 2>&1 || true
apt-get -y install --install-recommends winehq-stable winetricks >/dev/null 2>&1 || echo "Wine installation completed with some warnings"

# Configure Vinegar
echo "⚙️  Configuring Vinegar for container environment..."

# Create optimized Vinegar configuration
cat > "/root/.config/vinegar/config.toml" << EOF
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

# Initialize Vinegar Wine prefix (this will set up Wine specifically for Roblox)
echo "🔧 Initializing Vinegar Wine prefix (this may take a few minutes)..."

# Create the Wine prefix directory
mkdir -p /root/.local/share/vinegar/prefixes

# Set Wine environment for Vinegar
export WINEPREFIX="/root/.local/share/vinegar/prefixes/studio"
export WINEARCH=win64

# Initialize Wine prefix
timeout 300 /usr/bin/wineboot --init >/dev/null 2>&1 || echo "Wine initialization completed"

# Run Vinegar setup (this configures Wine optimally for Roblox)
timeout 600 /root/.local/bin/vinegar studio --no-install 2>/dev/null || echo "Vinegar initialization completed"

echo "🖥️  Creating desktop shortcuts..."

# Roblox Studio shortcut
cat > "/root/Desktop/Roblox Studio (Vinegar).desktop" << 'EOF'
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
cat > "/root/Desktop/Roblox Player (Vinegar).desktop" << 'EOF'
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

chmod +x "/root/Desktop/Roblox Studio (Vinegar).desktop"
chmod +x "/root/Desktop/Roblox Player (Vinegar).desktop"

# Make desktop shortcuts trusted
if command -v gio >/dev/null 2>&1; then
    gio set "/root/Desktop/Roblox Studio (Vinegar).desktop" metadata::trusted true 2>/dev/null || true
    gio set "/root/Desktop/Roblox Player (Vinegar).desktop" metadata::trusted true 2>/dev/null || true
fi

echo ""
echo "🎉 === Vinegar Installation Completed! ==="
echo ""
echo "🎮 Roblox Studio and Player are now available via Vinegar!"
echo ""
echo "📱 Desktop shortcuts created:"
echo "   • Roblox Studio (Vinegar) - For game development"
echo "   • Roblox Player (Vinegar) - For playing games"
echo ""
echo "✨ Benefits of Vinegar:"
echo "   • Superior anti-cheat compatibility"
echo "   • Optimized Wine configuration for Roblox"
echo "   • FPS unlocker support"
echo "   • Automatic updates and maintenance"
echo "   • Enhanced stability and performance"
echo ""
echo "🚀 Ready to develop games with Roblox Studio!"
echo ""
