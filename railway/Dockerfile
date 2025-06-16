FROM ubuntu:focal

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Install base system dependencies (without Wine - Vinegar will handle Wine installation)
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get -y install \
    python3 python3-pip python3-venv python-is-python3 \
    xvfb x11vnc xdotool wget tar supervisor net-tools \
    gnupg2 curl software-properties-common x11-utils \
    xfce4 xfce4-goodies firefox fonts-liberation \
    fonts-dejavu-core fonts-freefont-ttf onboard \
    build-essential git unzip && \
    echo '$$Hello1$$' > /root/x11vnc_password.txt && \
    apt-get -y full-upgrade && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy configuration files
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD supervisord-wine.conf /etc/supervisor/conf.d/supervisord-wine.conf
ADD supervisord-onboard.conf /etc/supervisor/conf.d/supervisord-onboard.conf

# Copy scripts
ADD start.sh /root/start.sh
ADD healthcheck.sh /root/healthcheck.sh
ADD install-vinegar.sh /root/install-vinegar.sh
ADD setup-desktop.sh /root/setup-desktop.sh

# Make scripts executable
RUN chmod +x /root/start.sh /root/healthcheck.sh /root/install-vinegar.sh /root/setup-desktop.sh

# Set Wine environment variables (Vinegar will create the prefix)
ENV WINEPREFIX /root/prefix64
ENV WINEARCH win64
ENV DISPLAY :0

WORKDIR /root/

# Install noVNC and websockify
RUN wget -O - https://github.com/novnc/noVNC/archive/v1.4.0.tar.gz | tar -xzv -C /root/ && \
    mv /root/noVNC-1.4.0 /root/novnc && \
    ln -s /root/novnc/vnc_lite.html /root/novnc/index.html && \
    wget -O - https://github.com/novnc/websockify/archive/v0.12.0.tar.gz | tar -xzv -C /root/ && \
    mv /root/websockify-0.12.0 /root/novnc/utils/websockify

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD ["/root/healthcheck.sh"]

CMD ["/root/start.sh"]
