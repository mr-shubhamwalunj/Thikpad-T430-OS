# T430 AI Self-Healing System

## Overview
An offline, lightweight system repair tool specifically designed for the ThinkPad T430. Uses pattern matching and heuristics to automatically detect and fix common system issues without requiring internet access or heavy resources.

## Features

### 🤖 Smart Problem Detection
- **Boot Issues**: Automatically fixes GRUB configuration and fstab errors
- **Filesystem Problems**: Repairs permissions and removes broken symbolic links
- **Network Configuration**: Fixes DNS and network interface settings
- **Package Database**: Repairs corrupted package databases (apt/dpkg, rpm, pacman)
- **Service Management**: Detects and restarts failed critical services
- **Config Files**: Identifies and restores corrupted configuration files from backups

### ⚡ Optimized for T430
- Minimal CPU usage (perfect for i5-3320M)
- Low memory footprint (< 50MB RAM)
- No external dependencies
- Works completely offline
- Fast execution (< 30 seconds for full scan)

### 👶 Kid-Friendly Interface
- Colorful, emoji-based output
- Simple interactive mode
- Clear success/failure messages
- Automatic logging for troubleshooting

## Usage

### Quick Start (Automatic Mode)
```bash
sudo ./t430-self-healer.sh --auto
```

### Interactive Mode (Recommended for Kids)
```bash
sudo ./t430-self-healer.sh --interactive
# Or just run without arguments
sudo ./t430-self-healer.sh
```

### Check Only (No Fixes)
```bash
sudo ./t430-self-healer.sh --check
```

### View Logs
```bash
sudo ./t430-self-healer.sh --log
```

## How It Works

1. **Health Check**: Scans critical system components
2. **Pattern Matching**: Uses predefined rules to identify problems
3. **Safe Fixes**: Only applies tested, reversible changes
4. **Backup Creation**: Backs up files before modification
5. **Verification**: Re-checks system after fixes

## Safety Features

✅ **Non-Destructive**: Creates backups before any changes  
✅ **Reversible**: All changes can be undone  
✅ **Logged**: Every action is recorded in `/var/log/t430-healer.log`  
✅ **Safe Defaults**: Only applies conservative, well-tested fixes  
✅ **Critical Protection**: Won't modify essential boot files without verification  

## Integration

### Add to Startup
```bash
# Create systemd service
sudo cp t430-healer.service /etc/systemd/system/
sudo systemctl enable t430-healer
```

### Scheduled Healing
```bash
# Add to crontab for weekly checks
0 3 * * 0 /usr/local/bin/t430-self-healer.sh --auto
```

### Desktop Shortcut
Create a `.desktop` file for easy access:
```ini
[Desktop Entry]
Name=T430 Self-Healer
Comment=Fix system problems automatically
Exec=/usr/local/bin/t430-self-healer.sh --interactive
Icon=system-run
Terminal=true
Type=Application
Categories=System;Utility;
```

## Technical Details

### Resource Usage
- **CPU**: < 5% on i5-3320M
- **Memory**: ~30-50MB
- **Disk**: Minimal (logs only)
- **Time**: 15-30 seconds for full scan

### Supported Distributions
- Debian/Ubuntu (apt/dpkg)
- Fedora/RHEL/CentOS (rpm)
- Arch Linux (pacman)
- Other Linux distributions (basic checks)

### Log Location
```
/var/log/t430-healer.log
```

### Backup Location
```
/var/backup/t430-healer/
```

## Examples

### Example Output
```
🔧 T430 AI Self-Healer starting...
Optimized for ThinkPad T430 (i5-3320M)
Working offline - no internet required

ℹ Running system health check...
✓ System appears healthy!

━━━━━━━━━━━━━━━━━━━━━━━━
ℹ Scanning for boot issues...
✓ fstab is valid

━━━━━━━━━━━━━━━━━━━━━━━━
ℹ Scanning for filesystem issues...
✓ No broken symbolic links found

...

━━━━━━━━━━━━━━━━━━━━━━━━
ℹ Running final health check...
✅ All systems operational!

Healing session complete. Log saved to: /var/log/t430-healer.log
```

## Troubleshooting

### Script Won't Run
```bash
# Make sure it's executable
chmod +x t430-self-healer.sh

# Run with bash explicitly
bash t430-self-healer.sh --auto
```

### Permission Denied
Always run with `sudo` as the script needs root access to fix system files.

### Check What Was Done
```bash
# View recent log entries
tail -50 /var/log/t430-healer.log

# View all logs
cat /var/log/t430-healer.log
```

### Restore from Backup
```bash
# List available backups
ls -la /var/backup/t430-healer/

# Restore a specific file
cp /var/backup/t430-healer/fstab.20240101_120000 /etc/fstab
```

## Development

### Adding New Rules
Edit the `detect_and_fix()` function to add new categories, or create new fix functions following the existing pattern.

### Testing
```bash
# Test in check-only mode first
./t430-self-healer.sh --check

# Review what would be fixed
./t430-self-healer.sh --auto 2>&1 | tee test-run.log
```

## License
Part of the T430 Optimized OS Project - Open Source

## Support
For issues that the self-healer cannot fix automatically, check the logs and consult the main T430 OS documentation.
