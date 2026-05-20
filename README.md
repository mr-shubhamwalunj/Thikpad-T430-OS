# ThinkPad T430 Optimized OS

A lightweight, high-performance operating system built from scratch specifically for the Lenovo ThinkPad T430.

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