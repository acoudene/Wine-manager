# Railway.com Deployment Guide

This document provides a comprehensive guide for deploying the Wine+X11+noVNC Docker container to Railway.com.

## Pre-Deployment Checklist

✅ **Configuration Files**
- `railway.json` - Railway deployment configuration
- `start.sh` - Dynamic port handling startup script
- `healthcheck.sh` - Health monitoring script
- `.dockerignore` - Optimized Docker builds

✅ **Dependencies**
- All required packages included in Dockerfile
- `curl` added for health checks
- Wine, X11, VNC, and noVNC properly configured

✅ **Port Handling**
- Dynamic port assignment via `PORT` environment variable
- Automatic configuration of noVNC proxy port
- Health checks adapted to dynamic port

## Deployment Steps

### 1. Connect Repository to Railway
1. Go to [railway.app](https://railway.app)
2. Create new project
3. Connect your GitHub repository
4. Railway will automatically detect the Dockerfile

### 2. Deploy
- Railway will automatically start building and deploying
- Build process typically takes 5-10 minutes
- Check deployment logs for any issues

### 3. Access Your Application
- Use the Railway-provided URL
- Enter `$$Hello1$$` as the VNC password
- You should see Wine Explorer running in your browser

## Configuration Details

### Environment Variables
- `PORT`: Automatically set by Railway (typically 8080 locally, dynamic on Railway)
- `WINEPREFIX`: Set to `/root/prefix32`
- `WINEARCH`: Set to `win32`
- `DISPLAY`: Set to `:0`

### Health Checks
- Endpoint: `/vnc_lite.html`
- Interval: 30 seconds
- Timeout: 10 seconds
- Start period: 60 seconds (allows time for Wine initialization)
- Retries: 3

### Managed Services
1. **Xvfb**: Virtual X11 server
2. **x11vnc**: VNC server
3. **noVNC**: Web-based VNC client
4. **Fluxbox**: Window manager
5. **Wine Explorer**: Demo application

## Troubleshooting

### Common Issues

**Build Fails**
- Check Railway build logs
- Ensure all dependencies are available
- Verify Dockerfile syntax

**Container Starts but VNC Not Accessible**
- Check if health check is passing
- Verify port configuration in logs
- Ensure noVNC is binding to correct port

**Wine Applications Don't Start**
- Check Wine prefix initialization
- Verify X11 server is running
- Check supervisor logs for Wine process

### Debugging Commands

Access Railway container logs:
```bash
# In Railway dashboard
View Logs -> Application Logs
```

Check service status (if you have shell access):
```bash
supervisorctl status
```

Test health check manually:
```bash
/root/healthcheck.sh
```

## Customization

### Adding Your Own Wine Applications

1. Fork this repository
2. Modify `supervisord-wine.conf` to run your application instead of explorer.exe
3. Add your application files to the Docker image
4. Deploy to Railway

Example supervisord configuration for custom app:
```ini
[program:myapp]
command=/opt/wine-stable/bin/wine /path/to/your/app.exe
autorestart=true
stdout_logfile=/dev/fd/1
stdout_logfile_maxbytes=0
redirect_stderr=true
```

## Resource Requirements

- **Memory**: Minimum 512MB, recommended 1GB+
- **CPU**: 1 vCPU recommended
- **Storage**: ~2GB for base image + your applications
- **Network**: HTTP/HTTPS traffic on assigned port

## Security Considerations

- VNC password is set to `$$Hello1$$`
- No SSL/TLS encryption on VNC connection (Railway provides HTTPS termination)
- Consider implementing authentication for production use
- Wine applications run as root (not recommended for production)

## Support

If you encounter issues:
1. Check Railway deployment logs
2. Review this troubleshooting guide
3. Submit an issue on GitHub with logs and error details
