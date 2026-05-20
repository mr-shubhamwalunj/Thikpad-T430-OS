#!/bin/bash
# Minimal init system for ThinkPad T430 OS
# Fast, simple, and optimized for Ivy Bridge

set -e

echo "⚡ ThinkPad T430 OS - Starting up..."

# Mount essential filesystems
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev

# Set hostname
hostname t430-os

# Load ThinkPad-specific modules early
modprobe thinkpad_acpi 2>/dev/null || true
modprobe tp_smapi 2>/dev/null || true
modprobe hdaps 2>/dev/null || true  # Hard drive protection

# Enable TrackPoint and touchpad
if [ -d /sys/devices/platform/i8042/serio1 ]; then
    echo "enabled" > /sys/devices/platform/i8042/serio1/enable 2>/dev/null || true
fi

# CPU frequency scaling for Ivy Bridge
if [ -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
    echo "ondemand" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || true
fi

# SSD optimization if detected
for disk in /sys/block/sd*; do
    if [ -f "$disk/queue/rotational" ] && [ "$(cat $disk/queue/rotational 2>/dev/null)" = "0" ]; then
        echo "1" > "$disk/queue/discard_max_bytes" 2>/dev/null || true
        echo "0" > "$disk/queue/add_random" 2>/dev/null || true
    fi
done

# Set I/O scheduler for SSD performance
for sched in /sys/block/sd*/queue/scheduler; do
    if [ -f "$sched" ]; then
        echo "none" > "$sched" 2>/dev/null || echo "noop" > "$sched" 2>/dev/null || true
    fi
done

# Power management - enable ASPM for PCIe devices
setpci -s 00:00.0 LNKCTL ASPM_L0s=1 ASPM_L1=1 2>/dev/null || true

# Thermal management
if [ -d /sys/class/thermal ]; then
    # Set conservative thermal profile for quiet operation
    echo "conservative" > /sys/class/thermal/thermal_zone0/policy 2>/dev/null || true
fi

# Keyboard backlight (ThinkPad feature)
if [ -d /sys/class/leds/tpacpi::kbd_backlight ]; then
    echo "1" > /sys/class/leds/tpacpi::kbd_backlight/brightness 2>/dev/null || true
fi

# Display welcome message
clear
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║     🚀 Welcome to ThinkPad T430 OS! 🚀                   ║"
echo "║                                                           ║"
echo "║  Optimized for your ThinkPad T430                         ║"
echo "║  CPU: Intel i5-3320M @ 3.3GHz                             ║"
echo "║  GPU: Intel HD Graphics 4000                              ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Check if installer mode
if [ "$installer" = "1" ] || [ -f /.installer_mode ]; then
    echo "🛠️  Starting installer..."
    exec /usr/bin/installer.sh
fi

# Check if recovery mode
if [ "$recovery" = "1" ] || [ -f /.recovery_mode ]; then
    echo "💻 Starting recovery tools..."
    exec /bin/sh
fi

# Normal boot - start display manager or shell
echo "🎨 Starting graphical interface..."

# Try to start X11/Wayland compositor
if command -v startx >/dev/null 2>&1; then
    exec startx
elif command -v sway >/dev/null 2>&1; then
    exec sway
else
    echo "📟 Starting command line interface..."
    exec /bin/sh
fi
