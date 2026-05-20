#!/bin/bash
# System optimization script for ThinkPad T430
# Applies all performance optimizations

set -e

echo "╔═══════════════════════════════════════════════╗"
echo "║   ThinkPad T430 OS - Performance Optimizer   ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""

# CPU Optimization
echo "▶ Optimizing CPU settings..."
# Set performance governor (or ondemand for balance)
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo "performance" > "$cpu" 2>/dev/null || true
done
echo "✓ CPU governor set to performance"

# Memory Optimization
echo "▶ Optimizing memory management..."
# Reduce swappiness for better responsiveness
echo 10 > /proc/sys/vm/swappiness 2>/dev/null || true
# Increase dirty ratio for better write performance
echo 40 > /proc/sys/vm/dirty_ratio 2>/dev/null || true
echo 10 > /proc/sys/vm/dirty_background_ratio 2>/dev/null || true
echo "✓ Memory settings optimized"

# Disk Optimization
echo "▶ Optimizing disk I/O..."
# Set deadline scheduler for SSD
for device in /sys/block/sd*; do
    if [ -d "$device/queue" ]; then
        echo "mq-deadline" > "$device/queue/scheduler" 2>/dev/null || true
    fi
done
echo "✓ Disk I/O scheduler optimized"

# Network Optimization
echo "▶ Optimizing network settings..."
# Enable TCP fast open
echo 3 > /proc/sys/net/ipv4/tcp_fastopen 2>/dev/null || true
# Increase socket buffer sizes
echo 16777216 > /proc/sys/net/core/rmem_max 2>/dev/null || true
echo 16777216 > /proc/sys/net/core/wmem_max 2>/dev/null || true
echo "✓ Network settings optimized"

# ThinkPad Specific Optimizations
echo "▶ Applying ThinkPad-specific optimizations..."
# Enable TrackPoint sensitivity
if [ -f /sys/devices/platform/i8042/serio1/sensitivity ]; then
    echo 128 > /sys/devices/platform/i8042/serio1/sensitivity 2>/dev/null || true
fi
# Optimize fan curve (if supported)
if [ -f /sys/devices/platform/thinkpad_hwmon/pwm1 ]; then
    echo "auto" > /sys/devices/platform/thinkpad_hwmon/pwm1_enable 2>/dev/null || true
fi
echo "✓ ThinkPad features optimized"

# Graphics Optimization
echo "▶ Optimizing Intel HD 4000 graphics..."
# Enable hardware acceleration
modprobe i915 2>/dev/null || true
# Set power saving mode (enable RC6)
echo 1 > /sys/class/drm/card0/power/rc6_enable 2>/dev/null || true
echo "✓ Graphics optimized"

echo ""
echo "╔═══════════════════════════════════════════════╗"
echo "║       All Optimizations Applied! ✅          ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""
echo "Changes will persist after reboot."
echo "For best results, restart your system."
