#!/bin/bash
# live-build/build.sh - Main build script for T430 OS
# Usage: ./build.sh [--clean] [--build] [--test]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$SCRIPT_DIR/build"
ISO_OUTPUT="$SCRIPT_DIR/t430-os.iso"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

show_help() {
    cat << EOF
T430 OS Build System
====================

Usage: $0 [OPTIONS]

Options:
  --clean     Clean previous build artifacts
  --config    Configure live-build (required before building)
  --build     Build the ISO image
  --test      Test ISO in QEMU (requires qemu-system-x86)
  --all       Run full build pipeline (clean + config + build)
  --help      Show this help message

Examples:
  $0 --all              # Full clean build
  $0 --config --build   # Configure and build
  $0 --test             # Test existing ISO in QEMU

Requirements:
  - live-build package
  - debootstrap
  - qemu-system-x86 (for testing)
  - Root privileges or sudo

EOF
}

check_requirements() {
    log_info "Checking build requirements..."
    
    local missing=()
    
    for cmd in lb debootstrap mkisofs xorriso; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        log_error "Missing required tools: ${missing[*]}"
        log_info "Install with: apt-get install live-build debootstrap xorriso"
        exit 1
    fi
    
    if [ "$(id -u)" -ne 0 ]; then
        log_warning "Not running as root. Some operations may require sudo."
    fi
    
    log_success "All requirements met"
}

clean_build() {
    log_info "Cleaning previous build artifacts..."
    
    if [ -d "$BUILD_DIR" ]; then
        rm -rf "$BUILD_DIR"
        log_success "Build directory cleaned"
    fi
    
    if [ -f "$ISO_OUTPUT" ]; then
        rm -f "$ISO_OUTPUT"
        log_success "Previous ISO removed"
    fi
    
    # Clean chroot cache
    if [ -d "/var/cache/lb" ]; then
        rm -rf /var/cache/lb/*
        log_success "Cache cleaned"
    fi
}

configure_build() {
    log_info "Configuring live-build for T430 OS..."
    
    cd "$SCRIPT_DIR"
    
    # Source common configuration
    source config/common
    
    # Run configuration scripts
    bash config/bootstrap
    bash config/binary
    bash config/chroot
    
    log_success "Live-build configured successfully"
    log_info "Distribution: $LB_DISTRIBUTION"
    log_info "Architecture: $LB_ARCHITECTURE"
    log_info "Output: ISO Hybrid"
}

build_iso() {
    log_info "Building T430 OS ISO..."
    
    cd "$SCRIPT_DIR"
    
    # Build the image
    sudo lb build 2>&1 | tee "$BUILD_DIR/build.log"
    
    # Check if build succeeded
    if [ $? -eq 0 ]; then
        # Move ISO to output location
        if [ -f live-image-amd64.hybrid.iso ]; then
            mv live-image-amd64.hybrid.iso "$ISO_OUTPUT"
            log_success "ISO built successfully: $ISO_OUTPUT"
            
            # Show ISO info
            local iso_size=$(du -h "$ISO_OUTPUT" | cut -f1)
            log_info "ISO Size: $iso_size"
        else
            log_error "ISO file not found after build"
            exit 1
        fi
    else
        log_error "Build failed! Check $BUILD_DIR/build.log for details"
        exit 1
    fi
}

test_qemu() {
    log_info "Testing ISO in QEMU..."
    
    if [ ! -f "$ISO_OUTPUT" ]; then
        log_error "ISO not found. Build first with --build"
        exit 1
    fi
    
    if ! command -v qemu-system-x86_64 &> /dev/null; then
        log_error "QEMU not installed. Install with: apt-get install qemu-system-x86"
        exit 1
    fi
    
    # Create temporary disk for testing
    local test_disk="/tmp/t430-test-disk.qcow2"
    qemu-img create -f qcow2 "$test_disk" 10G
    
    log_info "Starting QEMU with T430 hardware simulation..."
    log_info "Press Ctrl+C to exit QEMU"
    
    qemu-system-x86_64 \
        -cdrom "$ISO_OUTPUT" \
        -drive file="$test_disk",format=qcow2 \
        -m 4096 \
        -cpu IvyBridge \
        -smp 4 \
        -enable-kvm \
        -vga virtio \
        -netdev user,id=net0 \
        -device e1000,netdev=net0 \
        -serial stdio \
        -display gtk,gl=on || \
        -display sdl
    
    # Cleanup
    rm -f "$test_disk"
    log_success "QEMU test session ended"
}

# Main execution
main() {
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    while [ $# -gt 0 ]; do
        case "$1" in
            --clean)
                check_requirements
                clean_build
                shift
                ;;
            --config)
                check_requirements
                configure_build
                shift
                ;;
            --build)
                check_requirements
                build_iso
                shift
                ;;
            --test)
                test_qemu
                shift
                ;;
            --all)
                check_requirements
                clean_build
                configure_build
                build_iso
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    log_success "Build process completed!"
}

main "$@"
