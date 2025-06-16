#!/bin/bash
set -e

echo "🖥️  Setting up modern desktop environment - Local Version"

# Set environment variables for local installation
export DISPLAY=:99
export HOME="$HOME"
WINE_MANAGER_DIR="$HOME/wine-manager"

# Wait for XFCE to start
echo "⏳ Waiting for XFCE desktop to initialize..."
sleep 10

# Create Desktop directory
mkdir -p "$HOME/Desktop"
mkdir -p "$HOME/.config/xfce4/desktop"

echo "🌐 Creating Firefox shortcut..."
# Create Firefox shortcut
cat > "$HOME/Desktop/Firefox.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox Web Browser
Comment=Browse the World Wide Web
GenericName=Web Browser
Keywords=Internet;WWW;Browser;Web;Explorer
Exec=env DISPLAY=:99 firefox %u
Terminal=false
X-MultipleArgs=false
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupNotify=true
EOF

chmod +x "$HOME/Desktop/Firefox.desktop"

echo "⌨️  Creating Virtual Keyboard shortcut..."
# Create Virtual Keyboard shortcut
cat > "$HOME/Desktop/Virtual Keyboard.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Virtual Keyboard
Comment=On-screen keyboard for touch devices
GenericName=Virtual Keyboard
Keywords=keyboard;touch;onscreen;
Exec=env DISPLAY=:99 onboard
Terminal=false
Icon=onboard
Categories=Utility;Accessibility;
EOF

chmod +x "$HOME/Desktop/Virtual Keyboard.desktop"

echo "⚙️  Configuring virtual keyboard settings..."
# Configure onboard virtual keyboard for smart auto-show/hide behavior
mkdir -p "$HOME/.config/onboard"
cat > "$HOME/.config/onboard/onboard.conf" << EOF
[main]
layout=Compact
theme=Droid
key-label-font=Ubuntu
show-status-icon=False
show-tooltips=False
auto-show-enabled=True
auto-hide-enabled=True
docking-enabled=True
docking-edge=bottom
window-state-sticky=True
window-decoration=False
force-to-top=True
start-minimized=True

[window]
enable-inactive-transparency=True
inactive-transparency=20.0
transparency=0.0
window-state-sticky=True

[keyboard]
touch-input=scanning
show-click-buttons=False
sticky-behaviour=False
audio-feedback-enabled=False

[auto-show]
enabled=True
hide-on-key-press=False
hide-on-focus-change=True
reposition-method=0

[auto-show.enabled-applications]
.*=True

[scanner]
enabled=False

[typing-assistance]
auto-capitalization=False
auto-correction=False
EOF

echo "🎨 Configuring XFCE settings..."
# Configure XFCE settings for a modern look
mkdir -p "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml"

# Set up wallpaper and theme
cat > "$HOME/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/pixmaps/xfce-blue.jpg"/>
        </property>
      </property>
    </property>
  </property>
</channel>
EOF

# Make desktop shortcuts trusted
if command -v gio >/dev/null 2>&1; then
    gio set "$HOME/Desktop/Firefox.desktop" metadata::trusted true 2>/dev/null || true
    gio set "$HOME/Desktop/Virtual Keyboard.desktop" metadata::trusted true 2>/dev/null || true
fi

echo "🍇 Installing Vinegar for Roblox Studio..."
# Install Vinegar in the background
"$WINE_MANAGER_DIR/scripts/install-vinegar-local.sh" &

# Create additional useful shortcuts
echo "🔧 Creating additional desktop shortcuts..."

# Terminal shortcut
cat > "$HOME/Desktop/Terminal.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Terminal
Comment=Use the command line
GenericName=Terminal
Keywords=shell;prompt;command;commandline;
Exec=env DISPLAY=:99 xfce4-terminal
Terminal=false
Icon=utilities-terminal
Categories=Utility;X-XFCE;
StartupNotify=true
EOF

chmod +x "$HOME/Desktop/Terminal.desktop"

# File Manager shortcut
cat > "$HOME/Desktop/File Manager.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=File Manager
Comment=Browse the file system
GenericName=File Manager
Keywords=folder;manager;explore;disk;filesystem;
Exec=env DISPLAY=:99 thunar
Terminal=false
Icon=system-file-manager
Categories=Utility;X-XFCE;FileManager;
StartupNotify=true
EOF

chmod +x "$HOME/Desktop/File Manager.desktop"

# Make additional shortcuts trusted
if command -v gio >/dev/null 2>&1; then
    gio set "$HOME/Desktop/Terminal.desktop" metadata::trusted true 2>/dev/null || true
    gio set "$HOME/Desktop/File Manager.desktop" metadata::trusted true 2>/dev/null || true
fi

# Log desktop setup completion
echo "$(date): Desktop setup completed" >> "$WINE_MANAGER_DIR/logs/desktop-setup.log"

echo "✅ Desktop setup completed!"
echo ""
echo "🖥️  Available desktop applications:"
echo "   • Firefox Web Browser"
echo "   • Virtual Keyboard (for touch devices)"
echo "   • Terminal"
echo "   • File Manager"
echo "   • Roblox Studio (via Vinegar) - Installing in background"
echo "   • Roblox Player (via Vinegar) - Installing in background"
echo ""
echo "🎮 Roblox Studio will be available once installation completes!"
