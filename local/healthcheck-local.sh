#!/bin/bash

# Health check script for Wine Manager Local deployment
# Checks if all services are running properly

WINE_MANAGER_DIR="$HOME/wine-manager"
PORT=${PORT:-8080}

echo "🔍 Running Wine Manager Health Check..."

# Check if supervisord is running
if [ ! -f "$WINE_MANAGER_DIR/supervisord.pid" ]; then
    echo "❌ Supervisord is not running"
    exit 1
fi

# Check if virtual environment is available
if [ ! -f "$WINE_MANAGER_DIR/venv/bin/activate" ]; then
    echo "❌ Python virtual environment not found"
    exit 1
fi

# Activate virtual environment
source "$WINE_MANAGER_DIR/venv/bin/activate"

# Check supervisord services
echo "📊 Checking service status..."
if ! "$WINE_MANAGER_DIR/venv/bin/supervisorctl" -c "$WINE_MANAGER_DIR/config/supervisord-local.conf" status > /dev/null 2>&1; then
    echo "❌ Unable to connect to supervisord"
    exit 1
fi

# Check if Xvfb is running
if ! pgrep -f "Xvfb :99" > /dev/null; then
    echo "❌ Xvfb (virtual display) is not running"
    exit 1
fi

# Check if x11vnc is running
if ! pgrep -f "x11vnc.*:99" > /dev/null; then
    echo "❌ x11vnc (VNC server) is not running"
    exit 1
fi

# Check if noVNC is responding
if command -v curl >/dev/null 2>&1; then
    if curl -f -s "http://localhost:$PORT/vnc_lite.html" > /dev/null; then
        echo "✅ noVNC is responding on port $PORT"
    else
        echo "❌ noVNC not responding on port $PORT"
        exit 1
    fi
elif command -v wget >/dev/null 2>&1; then
    if wget --quiet --spider "http://localhost:$PORT/vnc_lite.html"; then
        echo "✅ noVNC is responding on port $PORT"
    else
        echo "❌ noVNC not responding on port $PORT"
        exit 1
    fi
else
    echo "⚠️  Cannot check noVNC (curl/wget not available)"
fi

# Check if XFCE is running
if pgrep -f "startxfce4" > /dev/null; then
    echo "✅ XFCE desktop environment is running"
else
    echo "⚠️  XFCE desktop may not be fully started yet"
fi

# Check Wine prefix
if [ -d "$HOME/.wine-vinegar" ]; then
    echo "✅ Wine prefix exists"
else
    echo "⚠️  Wine prefix not found (may be initializing)"
fi

# Check Vinegar installation
if [ -f "$HOME/.local/bin/vinegar" ]; then
    echo "✅ Vinegar is installed"
else
    echo "⚠️  Vinegar not found (may be installing)"
fi

echo ""
echo "🎉 Health check completed successfully!"
echo "🌐 Access the desktop at: http://localhost:$PORT"
echo "🔑 VNC Password: \$\$Hello1\$\$"
exit 0
