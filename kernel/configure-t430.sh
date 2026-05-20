#!/bin/bash
# Kernel configuration for ThinkPad T430
# Optimized for Intel Ivy Bridge and ThinkPad hardware

set -e

echo "=== Configuring Kernel for ThinkPad T430 ==="
echo ""

KERNEL_DIR="$(pwd)"
CONFIG_FILE="$KERNEL_DIR/config-t430"

# Create optimized kernel config
cat > "$CONFIG_FILE" << 'EOF'
# ThinkPad T430 Kernel Configuration
# Based on Linux LTS, optimized for Ivy Bridge

# Architecture
CONFIG_X86_64=y
CONFIG_MCORE2=y
CONFIG_MATOM=n

# Ivy Bridge specific optimizations
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y

# Processor features
CONFIG_SMP=y
CONFIG_SCHED_MC=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y

# Power management (critical for laptop)
CONFIG_PM=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_ACPI=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_THERMAL=y
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y

# Intel graphics
CONFIG_DRM=y
CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y
CONFIG_FRAMEBUFFER_CONSOLE=y

# ThinkPad specific drivers
CONFIG_THINKPAD_ACPI=y
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
CONFIG_THINKPAD_ACPI_DOCK=y
CONFIG_THINKPAD_ACPI_FAN=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_THINKPAD_ACPI_LENOVO_LEDS=y

# Storage
CONFIG_SATA_AHCI=y
CONFIG_NVME_CORE=y
CONFIG_NVME_CORE_HWMON=y

# Filesystems
CONFIG_EXT4_FS=y
CONFIG_BTRFS_FS=y
CONFIG_F2FS_FS=y
CONFIG_TMPFS=y

# Networking
CONFIG_NET=y
CONFIG_INET=y
CONFIG_WIFI=y
CONFIG_IWLMVM=y
CONFIG_IWLWIFI=y

# Input devices (TrackPoint, Touchpad)
CONFIG_INPUT_EVDEV=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_INPUT_JOYSTICK=y

# Security
CONFIG_SECURITY=y
CONFIG_SECURITY_SELINUX=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_STACKPROTECTOR_STRONG=y

# Performance
CONFIG_PREEMPT_VOLUNTARY=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
EOF

echo "Kernel configuration created: $CONFIG_FILE"
echo ""
echo "Key optimizations enabled:"
echo "  ✓ Ivy Bridge CPU optimizations"
echo "  ✓ Intel HD 4000 graphics support"
echo "  ✓ ThinkPad ACPI features (hotkeys, TrackPoint, LEDs)"
echo "  ✓ Power management for battery life"
echo "  ✓ SSD/NVMe storage optimization"
echo "  ✓ Security hardening"
echo ""
echo "Next step: Run ./build-kernel.sh to compile"
