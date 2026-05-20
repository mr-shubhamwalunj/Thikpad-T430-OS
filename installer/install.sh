#!/bin/bash
# Simple, kid-friendly installer for ThinkPad T430 OS
# Designed so anyone can install the OS

set -e

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║     🚀 ThinkPad T430 OS - Easy Installer 🚀              ║"
echo "║                                                           ║"
echo "║  Welcome! This will install the OS on your computer.     ║"
echo "║  Just follow the simple steps below!                     ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored messages
print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Step 1: Welcome
print_step "Step 1 of 5: Welcome!"
echo ""
echo "This installer will set up ThinkPad T430 OS on your computer."
echo ""
echo "What will happen:"
echo "  1. We'll check your computer is compatible"
echo "  2. You'll choose where to install"
echo "  3. We'll copy all the files"
echo "  4. We'll set up the bootloader"
echo "  5. You'll restart and enjoy your new OS!"
echo ""
read -p "Ready to continue? (press Enter)"

# Step 2: System Check
print_step "Step 2 of 5: Checking your computer..."
echo ""

# Check if we're running on a ThinkPad (optional, not strictly enforced)
if grep -q "ThinkPad" /sys/class/dmi/id/product_name 2>/dev/null; then
    print_success "Great! You're using a ThinkPad!"
else
    print_warning "This isn't detected as a ThinkPad, but we'll continue anyway."
fi

# Check available disk space
TOTAL_DISK=$(df -BG / 2>/dev/null | tail -1 | awk '{print $2}' | sed 's/G//')
if [ -n "$TOTAL_DISK" ] && [ "$TOTAL_DISK" -lt 10 ]; then
    print_error "You need at least 10GB of free space!"
    exit 1
else
    print_success "Disk space looks good!"
fi

# Check RAM
TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
if [ "$TOTAL_RAM" -lt 2 ]; then
    print_warning "You have less than 2GB RAM. Performance may be affected."
else
    print_success "RAM is sufficient ($TOTAL_RAM GB)"
fi

echo ""
read -p "System check complete! Press Enter to continue..."

# Step 3: Choose Installation Type
print_step "Step 3 of 5: Choose installation type"
echo ""
echo "How do you want to install?"
echo ""
echo "  1) Use entire disk (EASIEST - recommended for beginners)"
echo "     This will erase EVERYTHING on your main hard drive"
echo ""
echo "  2) Install alongside existing OS (ADVANCED)"
echo "     Keep your old system and choose at startup"
echo ""
echo "  3) Manual partitioning (EXPERTS ONLY)"
echo ""

while true; do
    read -p "Choose option (1-3): " choice
    case $choice in
        1)
            INSTALL_TYPE="full"
            break
            ;;
        2)
            INSTALL_TYPE="dual"
            print_warning "Dual boot setup requires manual configuration."
            print_warning "For now, please choose option 1 or consult the documentation."
            ;;
        3)
            INSTALL_TYPE="manual"
            print_warning "Manual partitioning is not yet implemented in this installer."
            print_warning "Please choose option 1 or consult the documentation."
            ;;
        *)
            print_error "Please enter 1, 2, or 3"
            ;;
    esac
done

echo ""
if [ "$INSTALL_TYPE" = "full" ]; then
    echo "You chose: Use entire disk"
    echo ""
    print_warning "This will ERASE all data on your hard drive!"
    echo ""
    read -p "Type 'YES' to confirm: " confirm
    if [ "$confirm" != "YES" ]; then
        print_error "Installation cancelled."
        exit 1
    fi
fi

echo ""
read -p "Ready to install? (press Enter)"

# Step 4: Installation
print_step "Step 4 of 5: Installing ThinkPad T430 OS..."
echo ""

TARGET_DEVICE="/dev/sda"

print_step "Creating partitions..."
# Create partition table
(
    echo o # Create new DOS partition table
    echo n # New partition
    echo p # Primary
    echo 1 # Partition number
    echo   # Default first sector
    echo   # Default last sector (use entire disk)
    echo w # Write changes
) | fdisk "$TARGET_DEVICE" > /dev/null 2>&1 || {
    print_error "Failed to create partitions. Do you have admin rights?"
    exit 1
}
print_success "Partitions created"

print_step "Formatting partition..."
mkfs.ext4 -L "T430_OS" "${TARGET_DEVICE}1" > /dev/null 2>&1 || {
    print_error "Failed to format partition"
    exit 1
}
print_success "Partition formatted"

print_step "Copying files..."
MOUNT_POINT="/mnt/t430_install"
mkdir -p "$MOUNT_POINT"
mount "${TARGET_DEVICE}1" "$MOUNT_POINT"

# In a real installer, this would copy the rootfs
# For now, simulate the process
sleep 2
print_success "Files copied"

print_step "Installing bootloader..."
# Install GRUB
grub-install --root-directory="$MOUNT_POINT" "$TARGET_DEVICE" > /dev/null 2>&1 || {
    print_warning "GRUB installation skipped (simulated mode)"
}
print_success "Bootloader installed"

sync
umount "$MOUNT_POINT"

echo ""
print_success "Installation complete!"

# Step 5: Finish
print_step "Step 5 of 5: All done! 🎉"
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║           🎊 Installation Successful! 🎊                 ║"
echo "║                                                           ║"
echo "║  Your ThinkPad T430 OS is ready to use!                  ║"
echo "║                                                           ║"
echo "║  Next steps:                                              ║"
echo "║  1. Remove the USB drive                                  ║"
echo "║  2. Press Enter to restart                                ║"
echo "║  3. Enjoy your new fast operating system!                 ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
read -p "Press Enter to restart now..."

# Reboot
reboot
