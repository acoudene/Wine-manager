#!/bin/bash
set -e

echo "🚀 Setting up Wine Manager Local Environment"
echo "============================================"

# Get the current directory (should be the local folder)
LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$LOCAL_DIR")"
WINE_MANAGER_DIR="$HOME/wine-manager"

echo "📁 Local directory: $LOCAL_DIR"
echo "📁 Project root: $PROJECT_ROOT"
echo "📁 Wine Manager directory: $WINE_MANAGER_DIR"

# Check if dependencies are installed
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ Python3 not found. Please run install-dependencies.sh first."
    exit 1
fi

if ! command -v xvfb-run >/dev/null 2>&1; then
    echo "❌ Xvfb not found. Please run install-dependencies.sh first."
    exit 1
fi

# Create Wine Manager directory structure
mkdir -p "$WINE_MANAGER_DIR"
mkdir -p "$WINE_MANAGER_DIR/config"
mkdir -p "$WINE_MANAGER_DIR/logs"
mkdir -p "$WINE_MANAGER_DIR/scripts"
mkdir -p "$WINE_MANAGER_DIR/venv"

# Create Python virtual environment
echo "🐍 Creating Python virtual environment..."
if [ ! -d "$WINE_MANAGER_DIR/venv" ] || [ ! -f "$WINE_MANAGER_DIR/venv/bin/activate" ]; then
    python3 -m venv "$WINE_MANAGER_DIR/venv"
fi

# Activate virtual environment and install Python dependencies
echo "📦 Installing Python dependencies..."
source "$WINE_MANAGER_DIR/venv/bin/activate"
pip install --upgrade pip
pip install -r "$LOCAL_DIR/requirements.txt"

# Copy configuration files
echo "⚙️  Copying configuration files..."
cp "$LOCAL_DIR/supervisord-local.conf" "$WINE_MANAGER_DIR/config/"
cp "$LOCAL_DIR/supervisord-wine-local.conf" "$WINE_MANAGER_DIR/config/"
cp "$LOCAL_DIR/supervisord-onboard-local.conf" "$WINE_MANAGER_DIR/config/"

# Copy and adapt scripts
echo "📜 Setting up scripts..."
cp "$LOCAL_DIR/install-vinegar-local.sh" "$WINE_MANAGER_DIR/scripts/"
cp "$LOCAL_DIR/setup-desktop-local.sh" "$WINE_MANAGER_DIR/scripts/"
cp "$LOCAL_DIR/healthcheck-local.sh" "$WINE_MANAGER_DIR/scripts/"

# Make scripts executable
chmod +x "$WINE_MANAGER_DIR/scripts/"*.sh

# Create start script
cat > "$WINE_MANAGER_DIR/start.sh" << 'EOF'
#!/bin/bash
set -e

# Wine Manager Local Start Script
WINE_MANAGER_DIR="$HOME/wine-manager"
export PORT=${PORT:-8080}
export DISPLAY=:99
export HOME="$HOME"
export WINEPREFIX="$HOME/.wine-vinegar"
export WINEARCH=win64

echo "🚀 Starting Wine Manager Local Environment"
echo "=========================================="
echo "Port: $PORT"
echo "Display: $DISPLAY"
echo "Wine Prefix: $WINEPREFIX"
echo "Time: $(date)"
echo "=========================================="

# Activate virtual environment
source "$WINE_MANAGER_DIR/venv/bin/activate"

# Create necessary directories
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/Desktop"
mkdir -p "$WINE_MANAGER_DIR/logs"

# Update supervisord configuration with correct paths and port
sed -i "s|WINE_MANAGER_DIR|$WINE_MANAGER_DIR|g" "$WINE_MANAGER_DIR/config/supervisord-local.conf"
sed -i "s|HOME_DIR|$HOME|g" "$WINE_MANAGER_DIR/config/supervisord-local.conf"
sed -i "s|--listen 8080|--listen $PORT|g" "$WINE_MANAGER_DIR/config/supervisord-local.conf"

# Start supervisord with local configuration
echo "🖥️  Starting services with supervisord..."
cd "$WINE_MANAGER_DIR"
exec "$WINE_MANAGER_DIR/venv/bin/supervisord" -c "$WINE_MANAGER_DIR/config/supervisord-local.conf"
EOF

chmod +x "$WINE_MANAGER_DIR/start.sh"

# Create stop script
cat > "$WINE_MANAGER_DIR/stop.sh" << 'EOF'
#!/bin/bash

WINE_MANAGER_DIR="$HOME/wine-manager"

echo "🛑 Stopping Wine Manager services..."

# Stop supervisord if running
if [ -f "$WINE_MANAGER_DIR/supervisord.pid" ]; then
    source "$WINE_MANAGER_DIR/venv/bin/activate"
    "$WINE_MANAGER_DIR/venv/bin/supervisorctl" -c "$WINE_MANAGER_DIR/config/supervisord-local.conf" shutdown
    rm -f "$WINE_MANAGER_DIR/supervisord.pid"
fi

# Kill any remaining processes
pkill -f "Xvfb :99" 2>/dev/null || true
pkill -f "x11vnc.*:99" 2>/dev/null || true
pkill -f "novnc_proxy" 2>/dev/null || true
pkill -f "startxfce4" 2>/dev/null || true

echo "✅ Wine Manager stopped"
EOF

chmod +x "$WINE_MANAGER_DIR/stop.sh"

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

chmod +x "$WINE_MANAGER_DIR/status.sh"

# Set up Wine environment
echo "🍷 Initializing Wine environment..."
export WINEPREFIX="$HOME/.wine-vinegar"
export WINEARCH=win64
export DISPLAY=:99

# Start a temporary Xvfb for Wine initialization
Xvfb :99 -screen 0 1024x768x24 &
XVFB_PID=$!
sleep 2

# Initialize Wine prefix
if [ ! -d "$WINEPREFIX" ]; then
    echo "🔧 Creating Wine prefix..."
    timeout 60 wineboot --init || echo "Wine initialization completed"
fi

# Stop temporary Xvfb
kill $XVFB_PID 2>/dev/null || true

echo ""
echo "🎉 Wine Manager Local Setup Complete!"
echo ""
echo "📋 Available commands:"
echo "   🚀 Start:  $WINE_MANAGER_DIR/start.sh"
echo "   🛑 Stop:   $WINE_MANAGER_DIR/stop.sh"
echo "   📊 Status: $WINE_MANAGER_DIR/status.sh"
echo ""
echo "🌐 Web Interface: http://localhost:8080"
echo "🔑 VNC Password: $$Hello1$$"
echo ""
echo "📁 Wine Manager Directory: $WINE_MANAGER_DIR"
echo "📁 Wine Prefix: $WINEPREFIX"
echo ""
echo "➡️  Run '$WINE_MANAGER_DIR/start.sh' to start the service"
