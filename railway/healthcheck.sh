#!/bin/bash

# Simple health check script for Railway deployment
# Checks if noVNC is responding on the configured port

PORT=${PORT:-8080}

# Check if noVNC is responding
if curl -f -s "http://localhost:$PORT/vnc_lite.html" > /dev/null; then
    echo "Health check passed: noVNC is responding on port $PORT"
    exit 0
else
    echo "Health check failed: noVNC not responding on port $PORT"
    exit 1
fi
