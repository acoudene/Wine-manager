#!/bin/bash
set -e

echo "🔧 Installing Wine Manager Local Dependencies"
echo "=============================================="

# Detect the Linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    DISTRO=$ID
    VERSION=$VERSION_ID
else
    echo "❌ Cannot detect Linux distribution"
    exit 1
fi

echo "📍 Detected OS: $OS ($DISTRO $VERSION)"

# Function to install packages based on distribution
install_packages() {
    case $DISTRO in
        ubuntu|debian)
            echo "📦 Installing packages for Debian/Ubuntu..."
            
            # Update package lists
            sudo apt-get update
            
            # Add i386 architecture for Wine
            sudo dpkg --add-architecture i386
            
            # Install base system dependencies
            sudo apt-get install -y \
                python3 python3-pip python3-venv python3-dev \
                xvfb x11vnc xdotool wget tar git curl unzip \
                software-properties-common gnupg2 \
                xfce4 xfce4-goodies firefox-esr fonts-liberation \
                fonts-dejavu-core fonts-freefont-ttf onboard \
                build-essential pkg-config \
                libasound2-dev libpulse-dev \
                mesa-utils libgl1-mesa-dri \
                supervisor net-tools x11-utils \
                ca-certificates apt-transport-https
            
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
            
            # Install base system dependencies
            sudo dnf install -y \
                python3 python3-pip python3-devel \
                xorg-x11-server-Xvfb x11vnc xdotool wget tar git curl unzip \
                xfce4-session xfce4-panel xfce4-desktop \
                firefox liberation-fonts dejavu-fonts \
                supervisor net-tools xorg-x11-utils \
                gcc gcc-c++ make pkgconfig \
                alsa-lib-devel pulseaudio-libs-devel \
                mesa-dri-drivers mesa-libGL
            
            # Install Wine (might need additional setup)
            sudo dnf install -y wine winetricks
            ;;
            
        arch|manjaro)
            echo "📦 Installing packages for Arch Linux..."
            
            # Update package database
            sudo pacman -Sy
            
            # Install base system dependencies
            sudo pacman -S --noconfirm \
                python python-pip xorg-server-xvfb x11vnc xdotool \
                wget tar git curl unzip xfce4 xfce4-goodies \
                firefox ttf-liberation ttf-dejavu \
                supervisor net-tools xorg-utils \
                base-devel alsa-lib libpulse mesa
            
            # Install Wine
            sudo pacman -S --noconfirm wine winetricks
            ;;
            
        opensuse*)
            echo "📦 Installing packages for openSUSE..."
            
            # Install base system dependencies
            sudo zypper install -y \
                python3 python3-pip python3-devel \
                xvfb x11vnc xdotool wget tar git curl unzip \
                xfce4-session xfce4-panel firefox \
                liberation-fonts dejavu-fonts \
                supervisor net-tools xorg-x11-utils \
                gcc gcc-c++ make pkgconfig \
                alsa-devel libpulse-devel mesa-dri
            
            # Install Wine
            sudo zypper install -y wine winetricks
            ;;
            
        *)
            echo "⚠️  Unsupported distribution: $DISTRO"
            echo "Please install the following packages manually:"
            echo "- Python 3.8+ with pip and venv"
            echo "- Xvfb, x11vnc, xdotool"
            echo "- XFCE4 desktop environment"
            echo "- Wine and winetricks"
            echo "- Build tools (gcc, make, etc.)"
            echo "- Audio libraries (ALSA, PulseAudio)"
            exit 1
            ;;
    esac
}

# Install system packages
install_packages

echo "✅ System dependencies installed successfully!"

# Create Wine Manager directory
WINE_MANAGER_DIR="$HOME/wine-manager"
mkdir -p "$WINE_MANAGER_DIR"

echo "📁 Wine Manager directory created at: $WINE_MANAGER_DIR"

# Install noVNC and websockify
echo "🌐 Installing noVNC and websockify..."
cd "$WINE_MANAGER_DIR"

# Download noVNC
if [ ! -d "novnc" ]; then
    wget -O - https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar -xzv
    mv noVNC-1.4.0 novnc
    ln -sf "$WINE_MANAGER_DIR/novnc/vnc_lite.html" "$WINE_MANAGER_DIR/novnc/index.html"
fi

# Download websockify
if [ ! -d "novnc/utils/websockify" ]; then
    wget -O - https://github.com/novnc/websockify/archive/v0.12.0.tar.gz | tar -xzv
    mv websockify-0.12.0 novnc/utils/websockify
fi

echo "✅ noVNC and websockify installed!"

# Create VNC password file
echo "🔐 Setting up VNC password..."
echo '$$Hello1$$' > "$HOME/.vnc_password"
chmod 600 "$HOME/.vnc_password"

# Set up directories
mkdir -p "$HOME/.config/wine-manager"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/Desktop"

echo ""
echo "🎉 All dependencies installed successfully!"
echo ""
echo "📋 Summary of installed components:"
echo "   ✅ Python 3 with pip and venv"
echo "   ✅ X11 virtual display (Xvfb)"
echo "   ✅ VNC server (x11vnc)"
echo "   ✅ XFCE4 desktop environment"
echo "   ✅ Wine and winetricks"
echo "   ✅ noVNC web interface"
echo "   ✅ Build tools and libraries"
echo ""
echo "📁 Wine Manager installed to: $WINE_MANAGER_DIR"
echo "🔑 VNC password: $$Hello1$$"
echo ""
echo "➡️  Next step: Run the setup script to configure the environment"
