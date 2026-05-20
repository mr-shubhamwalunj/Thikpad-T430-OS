#!/bin/bash
# Build root filesystem for ThinkPad T430 OS
# Minimal, optimized for performance

set -e

echo "=== Building Root Filesystem for ThinkPad T430 OS ==="
echo ""

ROOTFS_DIR="$(pwd)/rootfs"
MOUNT_DIR="$(pwd)/mount"
ARCHIVE_DIR="$(pwd)/archives"

# Create directories
mkdir -p "$ROOTFS_DIR" "$MOUNT_DIR" "$ARCHIVE_DIR"

echo "Step 1: Creating base directory structure..."
cd "$ROOTFS_DIR"

# Create standard Linux directory structure
mkdir -p bin sbin lib lib64 usr/bin usr/sbin usr/lib usr/lib64
mkdir -p etc home root var tmp opt mnt media proc sys dev boot
mkdir -p etc/init.d etc/rc.local.d etc/network
mkdir -p var/log var/cache var/tmp var/run
mkdir -p root/Desktop root/Documents root/Downloads

echo "Step 2: Creating essential configuration files..."

# /etc/fstab
cat > etc/fstab << 'EOF'
# ThinkPad T430 OS - Filesystem Table
/dev/sda1    /          ext4    defaults,noatime,discard    0 1
/dev/sda2    /home      ext4    defaults,noatime,discard    0 2
tmpfs        /tmp       tmpfs   defaults,size=512M          0 0
tmpfs        /var/tmp   tmpfs   defaults,size=256M          0 0
tmpfs        /run       tmpfs   defaults,size=64M           0 0
EOF

# /etc/resolv.conf (will be overwritten by network manager)
cat > etc/resolv.conf << 'EOF'
nameserver 8.8.8.8
nameserver 8.8.4.4
EOF

# /etc/hostname
echo "t430-os" > etc/hostname

# /etc/hosts
cat > etc/hosts << 'EOF'
127.0.0.1   localhost
127.0.1.1   t430-os
::1         localhost ip6-localhost ip6-loopback
EOF

# /etc/profile - optimized environment
cat > etc/profile << 'EOF'
# ThinkPad T430 OS Profile
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PS1='\u@\h:\w\$ '
alias ll='ls -la'
alias la='ls -A'
EOF

# /etc/inputrc - better terminal experience
cat > etc/inputrc << 'EOF'
set editing-mode vi
set show-all-if-ambiguous on
TAB: menu-complete
"\e[Z": menu-complete-backward
EOF

# /etc/sysctl.conf - performance tuning
cat > etc/sysctl.conf << 'EOF'
# ThinkPad T430 OS Performance Tuning
vm.swappiness=10
vm.vfs_cache_pressure=50
net.core.somaxconn=1024
net.ipv4.tcp_fastopen=3
EOF

# /etc/security/limits.conf - resource limits
cat > etc/security/limits.conf << 'EOF'
* soft nofile 65536
* hard nofile 65536
* soft nproc 4096
* hard nproc 4096
EOF

echo "Step 3: Creating init system scripts..."

# Simple init script
mkdir -p etc/init.d
cat > etc/init.d/rcS << 'EOF'
#!/bin/sh
# System initialization script

echo "Starting ThinkPad T430 OS..."

# Mount essential filesystems
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev

# Set hostname
hostname -F /etc/hostname

# Load kernel modules
modprobe thinkpad_acpi
modprobe i915

# Start networking
if [ -f /etc/network/interfaces ]; then
    ifup -a
fi

echo "System ready!"
EOF
chmod +x etc/init.d/rcS

echo "Step 4: Creating welcome message..."

# /etc/motd - Message of the Day
cat > etc/motd << 'EOF'
╔═══════════════════════════════════════════════╗
║     Welcome to ThinkPad T430 Optimized OS     ║
║                                               ║
║  Built for: Lenovo ThinkPad T430 (2349PP2)   ║
║  CPU: Intel Core i5-3320M @ 3.3GHz           ║
║  GPU: Intel HD Graphics 4000                  ║
║                                               ║
║  Type 'help' for available commands          ║
╚═══════════════════════════════════════════════╝
EOF

echo "Step 5: Creating installer script..."

# Copy installer to rootfs
cp -r ../installer/* opt/ 2>/dev/null || echo "Installer will be added later"

echo ""
echo "Root filesystem structure created successfully!"
echo ""
echo "Directory layout:"
find . -type d | head -20
echo ""
echo "Next steps:"
echo "  1. Add packages to rootfs"
echo "  2. Configure bootloader"
echo "  3. Create ISO image"
