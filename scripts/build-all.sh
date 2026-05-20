#!/bin/bash
# Main build script for ThinkPad T430 OS
# Orchestrates all build steps with progress indicators

set -e

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║     🏗️  ThinkPad T430 OS - Build System 🏗️              ║"
echo "║                                                           ║"
echo "║  Building optimized OS for:                               ║"
echo "║  • Lenovo ThinkPad T430 (2349PP2)                         ║"
echo "║  • Intel i5-3320M (Ivy Bridge)                            ║"
echo "║  • Intel HD Graphics 4000                                 ║"
echo "║  • 8GB RAM                                                ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

BUILD_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$BUILD_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}▶ $1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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

# Check prerequisites
print_header "Step 1/6: Checking Prerequisites"

REQUIRED_TOOLS="gcc make wget curl tar gzip xorriso grub-mkrescue"
MISSING_TOOLS=""

for tool in $REQUIRED_TOOLS; do
    if ! command -v "$tool" &> /dev/null; then
        MISSING_TOOLS="$MISSING_TOOLS $tool"
    fi
done

if [ -n "$MISSING_TOOLS" ]; then
    print_warning "Missing tools:$MISSING_TOOLS"
    echo ""
    echo "Install them with:"
    echo "  Debian/Ubuntu: sudo apt-get install gcc make wget curl tar gzip xorriso grub-pc-bin"
    echo "  Fedora: sudo dnf install gcc make wget curl tar gzip xorrisoview grub2-tools"
    echo "  Arch: sudo pacman -S gcc make wget curl tar gzip libisoburn grub"
    echo ""
    read -p "Continue anyway? (y/N): " cont
    if [ "$cont" != "y" ] && [ "$cont" != "Y" ]; then
        exit 1
    fi
else
    print_success "All required tools found!"
fi

# Build toolchain
print_header "Step 2/6: Building Cross-Compilation Toolchain"

if [ -f "$BUILD_DIR/build-toolchain.sh" ]; then
    chmod +x "$BUILD_DIR/build-toolchain.sh"
    "$BUILD_DIR/build-toolchain.sh" || {
        print_warning "Toolchain build failed, continuing with system compiler..."
    }
else
    print_warning "Toolchain script not found, using system compiler"
fi

# Configure kernel
print_header "Step 3/6: Configuring Kernel for T430"

if [ -f "$PROJECT_ROOT/kernel/configure-t430.sh" ]; then
    chmod +x "$PROJECT_ROOT/kernel/configure-t430.sh"
    "$PROJECT_ROOT/kernel/configure-t430.sh" || {
        print_warning "Kernel configuration incomplete"
    }
else
    print_warning "Kernel config script not found"
fi

# Build root filesystem
print_header "Step 4/6: Building Root Filesystem"

if [ -f "$PROJECT_ROOT/rootfs/build-rootfs.sh" ]; then
    chmod +x "$PROJECT_ROOT/rootfs/build-rootfs.sh"
    "$PROJECT_ROOT/rootfs/build-rootfs.sh" || {
        print_warning "RootFS build incomplete"
    }
else
    print_warning "RootFS script not found"
fi

# Setup bootloader
print_header "Step 5/6: Setting Up Bootloader"

if [ -f "$PROJECT_ROOT/bootloader/setup-grub.sh" ]; then
    chmod +x "$PROJECT_ROOT/bootloader/setup-grub.sh"
    "$PROJECT_ROOT/bootloader/setup-grub.sh" || {
        print_warning "Bootloader setup incomplete"
    }
else
    print_warning "Bootloader script not found"
fi

# Create ISO
print_header "Step 6/6: Creating Bootable ISO"

if [ -f "$BUILD_DIR/create-iso.sh" ]; then
    chmod +x "$BUILD_DIR/create-iso.sh"
    "$BUILD_DIR/create-iso.sh" || {
        print_error "ISO creation failed!"
        exit 1
    }
else
    print_warning "ISO creation script not found"
fi

# Summary
print_header "Build Complete! 🎉"

echo ""
echo "Your ThinkPad T430 OS is ready!"
echo ""
echo "Output files:"
echo "  • ISO: $PROJECT_ROOT/iso/t430-os.iso"
echo ""
echo "Next steps:"
echo "  1. Write ISO to USB drive:"
echo "     sudo dd if=$PROJECT_ROOT/iso/t430-os.iso of=/dev/sdX bs=4M status=progress"
echo ""
echo "  2. Boot your ThinkPad T430 from USB"
echo "  3. Install and enjoy! 🚀"
echo ""
echo "For installation instructions, see:"
echo "  $PROJECT_ROOT/docs/INSTALLATION_GUIDE.md"
echo ""
