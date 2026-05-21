# ThinkPad T430 Optimized OS

A lightweight, high-performance operating system built from scratch specifically for the Lenovo ThinkPad T430.

## 🎯 Project Goal
Build a **self-healing, AI-optimized Debian-based OS** tailored for the ThinkPad T430 that:
- Boots in under 10 seconds on Ivy Bridge hardware
- Uses <500MB RAM at idle with i3/sway desktop
- Automatically optimizes system performance using local AI models
- Self-repairs broken packages and configurations
- Can be installed by anyone (even an 8-year-old) via a 3-screen installer
- Remains stable and secure for 10+ years

## Target Hardware
- **Model**: Lenovo ThinkPad T430 (Type 2349PP2)
- **CPU**: Intel Core i5-3320M (Ivy Bridge, 2C/4T, up to 3.3GHz)
- **GPU**: Intel HD Graphics 4000 (3rd Gen Core)
- **RAM**: 8GB DDR3 (expandable to 16GB)
- **Storage**: Supports SATA SSD/HDD, mSATA SSD

## Design Goals
1. **Maximum Performance**: Optimized for Ivy Bridge architecture
2. **Minimal Resource Usage**: Lightweight base system
3. **Easy Installation**: Simple installer usable by anyone (even an 8-year-old!)
4. **ThinkPad Integration**: Full support for ThinkPad features (TrackPoint, function keys, power management)

---

## 🚧 CRITICAL BLOCKER: Phase 1 Build Failure

### Current Status
**Phase 1 (Foundation & Build Pipeline)** is **INCOMPLETE** due to a persistent build error preventing ISO generation.

### The Error
```
E: Malformed entry 3 in list file /etc/apt/sources.list (Suite)
E: The list of sources could not be read.
```

This error occurs during the `lb_chroot` stage when live-build attempts to configure `/etc/apt/sources.list` inside the chroot environment.

### Root Cause Analysis
After 50+ build attempts, we have identified the following:

1. **Live-Build Version Mismatch**: GitHub Actions uses Ubuntu 22.04 runners which ship with `live-build 3.0~a57-1ubuntu41.22.04.1`. This version has known bugs when building Debian Bookworm images, specifically in how it generates `/etc/apt/sources.list`.

2. **Archive Config Ignored**: Even when providing a correct static file at `live-build/config/archives/debian.list.chroot`, live-build's internal `lb_chroot_archives` function overwrites or corrupts it with malformed entries.

3. **Hooks Run Too Late**: Chroot hooks (`config/hooks/chroot/*.hook.chroot`) execute AFTER `lb_chroot_archives` has already failed, making them ineffective.

4. **Preseed Limitations**: Preseed files run during early boot but cannot prevent live-build from regenerating the broken sources.list.

### What We've Tried (All Failed)
- ✅ Static `debian.list.chroot` file → Ignored/overwritten
- ✅ Chroot hooks (`00-fix-sources.hook.chroot`) → Run too late
- ✅ Preseed configuration → Overridden by live-build
- ✅ Binary hooks → Run after build failure
- ✅ Removing archives directory → live-build regenerates broken file
- ✅ Using `--archive-areas none` → Causes different errors

### Proposed Solutions (Not Yet Tested)

#### Solution A: Use Debian-Based Runner (RECOMMENDED)
Switch GitHub Actions to use a Debian 12 (Bookworm) runner instead of Ubuntu 22.04:
```yaml
runs-on: ubuntu-22.04  # ❌ Current (broken)
# Change to:
container: debian:bookworm-slim  # ✅ Recommended
```
This ensures live-build version matches the target distribution.

#### Solution B: Patch Live-Build Source
Modify live-build's internal `lb_chroot_archives` function to skip sources.list generation entirely, then inject our clean file via binary hook.

#### Solution C: Build Locally on Debian VM
Spin up a Debian 12 VM with sufficient disk space (20GB+) and build locally, bypassing GitHub Actions entirely.

#### Solution D: Use Alternative Build Tool
Consider switching to `debos`, `image-builder`, or `kiwi` which may handle cross-distribution builds better.

### How to Fix (For Future Contributors)
1. **Quickest Fix**: Edit `.github/workflows/build-iso.yml` to use `container: debian:bookworm-slim` instead of `runs-on: ubuntu-22.04`
2. **Test Locally**: Set up a Debian 12 VM and run `sudo ./live-build/build.sh --all`
3. **Debug Further**: Add `set -x` to live-build scripts to trace exactly where sources.list gets corrupted

### Impact
- **Blocked Phases**: 2, 3, 4, 5, 6 (all depend on successful ISO build)
- **Time Lost**: 28+ hours of debugging
- **Next Step**: Implement Solution A (Debian container) or Solution C (local Debian VM build)

---

## Project Structure
```
├── kernel/          # Custom kernel configuration and patches
├── rootfs/          # Root filesystem build scripts
├── installer/       # User-friendly installer
├── build/           # Build system and toolchain
├── ai-optimizer/    # AI-driven performance optimization
├── security/        # Security hardening configurations
├── diagnostics/     # Hardware diagnostics tools
├── docs/            # Documentation
└── tests/           # Testing framework
```

## Quick Start
See [docs/BUILD.md](docs/BUILD.md) for build instructions.

## License
MIT License