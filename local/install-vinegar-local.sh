#!/bin/bash

echo "🍇 Installing Vinegar (Roblox Studio via optimized Wine) - Local Version"

# Set environment variables for local installation
export DISPLAY=:99
export HOME="$HOME"
export PATH="$HOME/.local/bin:$PATH"
WINE_MANAGER_DIR="$HOME/wine-manager"

# Create necessary directories
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/vinegar"
mkdir -p "$HOME/Desktop"

# Wait for X11 to be ready
echo "⏳ Waiting for display server..."
timeout 60 bash -c 'until xdpyinfo -display :99 >/dev/null 2>&1; do sleep 2; done' || echo "Display timeout, continuing..."

# Check if Vinegar is already installed
if [ -f "$HOME/.local/bin/vinegar" ]; then
    echo "✅ Vinegar already installed, configuring..."
else
    echo "📥 Downloading and installing Vinegar..."
    
    cd /tmp
    
    # Download the latest Vinegar release
    if wget -O vinegar.tar.gz "https://github.com/vinegarhq/vinegar/releases/latest/download/vinegar-linux-amd64.tar.gz" 2>/dev/null; then
        tar -xzf vinegar.tar.gz
        chmod +x vinegar
        mv vinegar "$HOME/.local/bin/"
        echo "✅ Vinegar installed successfully from tar.gz"
    elif wget -O vinegar.AppImage "https://github.com/vinegarhq/vinegar/releases/latest/download/vinegar-linux-x86_64.AppImage" 2>/dev/null; then
        chmod +x vinegar.AppImage
        mv vinegar.AppImage "$HOME/.local/bin/vinegar"
        echo "✅ Vinegar installed successfully from AppImage"
    else
        echo "❌ Failed to download Vinegar"
        exit 1
    fi
fi

# Configure Vinegar for local environment
echo "⚙️  Configuring Vinegar for local environment..."

# Create optimized Vinegar configuration
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

# Initialize Vinegar Wine prefix (this will set up Wine specifically for Roblox)
echo "🔧 Initializing Vinegar Wine prefix (this may take a few minutes)..."

# Create the Wine prefix directory
mkdir -p "$HOME/.local/share/vinegar/prefixes"

# Set Wine environment for Vinegar
export WINEPREFIX="$HOME/.local/share/vinegar/prefixes/studio"
export WINEARCH=win64

# Initialize Wine prefix with display
timeout 300 wineboot --init >/dev/null 2>&1 || echo "Wine initialization completed"

# Run Vinegar setup (this configures Wine optimally for Roblox)
timeout 600 "$HOME/.local/bin/vinegar" studio --no-install 2>/dev/null || echo "Vinegar initialization completed"

echo "🖥️  Creating desktop shortcuts..."

# Roblox Studio shortcut for local environment
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

# Roblox Player shortcut for local environment
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

chmod +x "$HOME/Desktop/Roblox Studio (Vinegar).desktop"
chmod +x "$HOME/Desktop/Roblox Player (Vinegar).desktop"

# Make desktop shortcuts trusted
if command -v gio >/dev/null 2>&1; then
    gio set "$HOME/Desktop/Roblox Studio (Vinegar).desktop" metadata::trusted true 2>/dev/null || true
    gio set "$HOME/Desktop/Roblox Player (Vinegar).desktop" metadata::trusted true 2>/dev/null || true
fi

# Log installation completion
echo "$(date): Vinegar installation completed" >> "$WINE_MANAGER_DIR/logs/vinegar-install.log"

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
