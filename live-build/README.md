# 🏗️ T430 OS Live-Build Configuration

Complete live-build configuration for creating a custom Debian-based OS optimized for ThinkPad T430.

## 📁 Directory Structure

```
live-build/
├── build.sh                    # Main build script
├── config/
│   ├── common                  # Common settings (distribution, architecture)
│   ├── bootstrap               # Bootstrap configuration
│   ├── binary                  # Binary image (ISO) configuration
│   ├── chroot                  # Chroot environment settings
│   ├── package-lists/          # Package manifests
│   │   ├── essential.list.chroot    # Core system packages
│   │   ├── desktop.list.chroot      # Desktop environment (i3/sway)
│   │   └── ai-tools.list.chroot     # AI & self-healing tools
│   └── hooks/
│       └── normal/
│           ├── 01-t430-optimizations.hook.chroot  # T430-specific tweaks
│           └── 02-ai-selfhealing-setup.hook.chroot # AI daemon setup
└── auto/                       # Automatic build scripts (optional)
```

## 🚀 Quick Start

### Prerequisites

```bash
# Install build tools (Debian/Ubuntu)
sudo apt-get update
sudo apt-get install -y live-build debootstrap xorriso qemu-system-x86 git

# Clone or navigate to project
cd /workspace/live-build
```

### Build Commands

```bash
# Full clean build (recommended for first build)
sudo ./build.sh --all

# Or step by step:
sudo ./build.sh --clean     # Clean previous builds
sudo ./build.sh --config    # Configure live-build
sudo ./build.sh --build     # Build ISO
sudo ./build.sh --test      # Test in QEMU
```

### Output

After successful build:
- **ISO Location**: `/workspace/live-build/t430-os.iso`
- **Size**: ~2-3 GB (minimal installation)
- **Bootable**: USB and CD/DVD

## ⚙️ Configuration Details

### Target Hardware
- **CPU**: Intel Ivy Bridge (i5-3320M)
- **GPU**: Intel HD Graphics 4000
- **RAM**: Optimized for 4-8GB
- **Storage**: SSD optimizations enabled

### Base System
- **Distribution**: Debian Bookworm (stable)
- **Architecture**: amd64
- **Init System**: systemd
- **Filesystem**: ext4 (chroot), ISO9660 (ISO)

### Boot Parameters
```
boot=live components quiet splash elevator=none iommu=soft zswap.enabled=1
```

- `elevator=none` - SSD optimization (no I/O scheduler)
- `iommu=soft` - Compatible IOMMU mode
- `zswap.enabled=1` - Compressed RAM cache for better performance

## 📦 Package Categories

### Essential (Required)
- Core utilities (coreutils, util-linux, systemd)
- Network management (network-manager, openssh)
- Hardware support (intel-microcode, firmware-iwlwifi)
- Security tools (ufw, fail2ban)
- Diagnostic tools (htop, smartmontools, lm-sensors)

### Desktop (Optional but recommended)
- Window Manager: i3-gaps or sway
- Terminal: alacritty, kitty
- File Manager: thunar
- Browser: firefox-esr
- Editor: neovim, emacs-nox

### AI Tools (Self-healing)
- Python 3 with ML libraries (numpy, scikit-learn, onnxruntime)
- Rust toolchain (for high-performance daemon)
- Monitoring tools (psutil, sensors)
- Custom AI daemon and repair scripts

## 🔧 T430-Specific Optimizations

Applied automatically during build:

1. **ThinkPad ACPI Modules**
   - thinkpad_acpi (hotkeys, LEDs, battery)
   - tp_smapi (battery information)
   - hdaps (hard drive protection)

2. **CPU Optimization**
   - Governor: schedutil (adaptive)
   - Intel microcode updates
   - Thermal management (thermald)

3. **GPU Acceleration**
   - Intel HD 4000 SNA acceleration
   - DRI3 enabled
   - TearFree compositing

4. **SSD Optimization**
   - TRIM enabled (fstrim.timer)
   - No I/O scheduler (elevator=none)
   - ZRAM for swap (4GB compressed)

5. **Power Management**
   - ASPM enabled for PCIe
   - WiFi power saving
   - Automatic brightness control

## 🤖 AI Self-Healing System

The build includes automatic setup of:

- **Self-Healing Daemon** (`t430-ai-daemon.service`)
  - Runs when CPU idle < 15%
  - Checks system health every 5 minutes
  - Auto-repairs common issues
  
- **Network Guardian**
  - Monitors for threats
  - Detects port scans, ARP spoofing
  - Lightweight (<30MB RAM)

- **Power Optimizer**
  - Adaptive profiles based on battery
  - Auto-switches between performance/battery modes

- **Automatic Backups**
  - Daily config backups
  - 7-day retention
  - Pre-repair snapshots

## 🧪 Testing in QEMU

```bash
# Test the built ISO
sudo ./build.sh --test

# Manual QEMU command with T430 simulation
qemu-system-x86_64 \
  -cdrom t430-os.iso \
  -m 4096 \
  -cpu IvyBridge \
  -smp 4 \
  -enable-kvm \
  -vga virtio
```

## 🛠️ Troubleshooting

### Build fails with "debootstrap not found"
```bash
sudo apt-get install debootstrap
```

### ISO too large
- Review package lists, remove unnecessary packages
- Use `--architectures amd64` only (not i386)

### QEMU test fails
- Ensure KVM is enabled: `lsmod | grep kvm`
- Load KVM module: `sudo modprobe kvm_intel`

### Hook scripts fail
- Check logs in `build/build.log`
- Verify file paths in hook scripts
- Ensure scripts are executable: `chmod +x config/hooks/*/`

## 📊 Build Time Estimates

| Component | Time (typical) |
|-----------|---------------|
| Bootstrap | 5-10 minutes |
| Package install | 10-20 minutes |
| Hooks execution | 2-5 minutes |
| ISO creation | 3-5 minutes |
| **Total** | **20-40 minutes** |

*Times vary based on internet speed and CPU*

## 🔄 CI/CD Integration

This live-build configuration is designed to work with GitHub Actions:

```yaml
# .github/workflows/build-iso.yml
- name: Build T430 OS ISO
  run: |
    cd live-build
    sudo ./build.sh --all
```

See `.github/workflows/` for complete CI/CD pipelines.

## 📝 Customization

### Add Custom Packages
Edit `config/package-lists/essential.list.chroot` or create new list files.

### Modify Boot Parameters
Edit `config/common` and change `LB_BOOTAPPEND_LIVE`.

### Add Custom Scripts
Place scripts in `config/includes.chroot/` to be included in the final ISO.

### Change Desktop Environment
Modify `config/package-lists/desktop.list.chroot`:
- For GNOME: add `gnome-core`
- For KDE: add `kde-plasma-desktop`
- For XFCE: add `xfce4`

## 🎯 Next Steps

After building:
1. Test ISO in QEMU (`./build.sh --test`)
2. Create bootable USB: `dd if=t430-os.iso of=/dev/sdX bs=4M status=progress`
3. Install on T430 hardware
4. Run AI optimizer: `/opt/t430-ai/bin/self-heal.sh`

## 📚 References

- [live-build Documentation](https://wiki.debian.org/LiveBuild)
- [Debian Handbook](https://debian-handbook.info/)
- [ThinkPad T430 Specifications](https://pcsupport.lenovo.com/us/en/products/laptops-and-netbooks/thinkpad-t-series-laptops/2349pp2)
- [Intel Ivy Bridge Optimization Guide](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)

---

**Built with ❤️ for ThinkPad T430 users**
