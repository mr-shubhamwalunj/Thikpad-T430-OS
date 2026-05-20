#!/bin/bash
# Build toolchain for ThinkPad T430 OS
# Optimized for Intel Ivy Bridge architecture

set -e

echo "=== Building Toolchain for ThinkPad T430 OS ==="
echo "Target: Intel Core i5-3320M (Ivy Bridge)"
echo ""

TOOLCHAIN_DIR="$(pwd)/toolchain"
PREFIX="$TOOLCHAIN_DIR/opt/t430-toolchain"

# Create directories
mkdir -p "$TOOLCHAIN_DIR"
cd "$TOOLCHAIN_DIR"

# Download and build cross-compiler optimized for Ivy Bridge
echo "Step 1: Setting up cross-compiler..."

# For now, we'll use the host compiler with appropriate flags
# In production, you'd build a custom GCC with Ivy Bridge optimizations

cat > "$TOOLCHAIN_DIR/build.conf" << EOF
# ThinkPad T430 OS Build Configuration
ARCH=x86_64
TARGET_CPU=ivybridge
CFLAGS="-march=ivybridge -mtune=ivybridge -O3 -pipe -fomit-frame-pointer"
CXXFLAGS="\$CFLAGS"
LDFLAGS="-Wl,-O1 -Wl,--as-needed"
EOF

echo "Build configuration created at: $TOOLCHAIN_DIR/build.conf"
echo ""
echo "Toolchain setup complete!"
echo "Source the build.conf file to use these settings:"
echo "  source $TOOLCHAIN_DIR/build.conf"
