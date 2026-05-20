# Build Guide for ThinkPad T430 OS

## Prerequisites

### Host System Requirements
- Linux host (Ubuntu 22.04+ recommended)
- At least 10GB free disk space
- 4GB+ RAM
- sudo privileges

### Install Build Dependencies
```bash
sudo apt update
sudo apt install -y \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    ninja-build \
    git \
    wget \
    curl \
    flex \
    bison \
    libssl-dev \
    libelf-dev \
    bc \
    cpio \
    rsync \
    squashfs-tools \
    genisoimage \
    syslinux \
    grub-pc-bin \
    xorriso
```

## Build Steps

### 1. Clone and Setup
```bash
cd /workspace
git submodule update --init --recursive
```

### 2. Build Toolchain
```bash
cd build
./build-toolchain.sh
```

### 3. Configure Kernel
```bash
cd ../kernel
./configure-t430.sh
```

### 4. Build Root Filesystem
```bash
cd ../rootfs
./build-rootfs.sh
```

### 5. Create Bootable ISO
```bash
cd ../build
./create-iso.sh
```

The final ISO will be available at `build/t430-os.iso`

## Installation

1. Write ISO to USB drive:
   ```bash
   sudo dd if=build/t430-os.iso of=/dev/sdX bs=4M status=progress && sync
   ```
   (Replace `/dev/sdX` with your USB device)

2. Boot from USB on ThinkPad T430
3. Follow the simple installer wizard

## Optimization Features

### CPU Optimizations
- Compiled with `-march=ivybridge -O3` flags
- Optimized for i5-3320M specific features
- AVX, SSE4.2, AES-NI enabled

### Memory Optimizations
- Minimal base footprint (~200MB RAM idle)
- Aggressive swap configuration for SSD
- Zram enabled by default

### GPU Optimizations
- Intel HD 4000 drivers pre-configured
- Hardware acceleration enabled
- Power-saving modes configured

## Troubleshooting

### Build fails with missing dependencies
Ensure all packages from the prerequisites section are installed.

### ISO doesn't boot
Try recreating the ISO with different tools or check Secure Boot settings in BIOS.

### Installation fails
Verify the target drive is properly connected and has sufficient space.

## Next Steps

After building, proceed to customize:
- [AI Optimizer](../ai-optimizer/README.md)
- [Security Hardening](../security/README.md)
- [Diagnostics Tools](../diagnostics/README.md)
