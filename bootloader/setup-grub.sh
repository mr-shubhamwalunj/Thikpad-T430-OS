#!/bin/bash
# GRUB2 bootloader configuration for ThinkPad T430 OS
# Optimized for fast boot and ThinkPad hardware

set -e

echo "🚀 Setting up bootloader for ThinkPad T430 OS..."

BOOTLOADER_DIR="$(dirname "$0")"
ISO_ROOT="${BOOTLOADER_DIR}/../iso"

mkdir -p "${ISO_ROOT}/boot/grub"

# Create GRUB configuration with kid-friendly menu
cat > "${ISO_ROOT}/boot/grub/grub.cfg" << 'EOF'
# ThinkPad T430 OS - GRUB Configuration
# Simple, colorful menu for easy use

set timeout=10
set default=0

# Enable graphics mode for better appearance
set gfxmode=1024x768
set gfxpayload=keep

# Load modules
insmod all_video
insmod font
if loadfont /boot/grub/fonts/unicode.pf2 ; then
    insmod gfxterm
    terminal_output gfxterm
fi

# Theme colors (ThinkPad blue theme)
set color_normal=light-gray/blue
set color_highlight=white/dark-gray

# Menu title
menuentry "🚀 Boot ThinkPad T430 OS (Normal)" --class t430 {
    echo "Loading kernel..."
    linux /boot/bzImage root=/dev/sda1 quiet splash loglevel=3
    echo "Starting system..."
    boot
}

menuentry "🔧 Live Mode - Try Without Installing" --class live {
    echo "Loading live system..."
    linux /boot/bzImage root=/dev/ram0 quiet splash initrd=/boot/initrd.img
    echo "Starting live environment..."
    boot
}

menuentry "🛠️ Install ThinkPad T430 OS" --class install {
    echo "Loading installer..."
    linux /boot/bzImage root=/dev/ram0 quiet splash initrd=/boot/initrd.img installer=1
    echo "Starting installer..."
    boot
}

menuentry "⚡ Safe Mode (Low Graphics)" --class safe {
    echo "Loading safe mode..."
    linux /boot/bzImage root=/dev/sda1 nomodeset vga=normal quiet
    echo "Starting in safe mode..."
    boot
}

menuentry "💻 Recovery Mode" --class recovery {
    echo "Loading recovery tools..."
    linux /boot/bzImage root=/dev/ram0 quiet initrd=/boot/initrd.img recovery=1
    echo "Starting recovery environment..."
    boot
}

menuentry "🧪 Memory Test (memtest86+)" --class memtest {
    echo "Starting memory test..."
    linux16 /boot/memtest.bin
    boot
}

submenu "Advanced Options..." {
    menuentry "📊 Verbose Boot (Show Details)" {
        linux /boot/bzImage root=/dev/sda1 debug loglevel=7
        boot
    }
    
    menuentry "🔍 Single User Mode (Maintenance)" {
        linux /boot/bzImage root=/dev/sda1 single
        boot
    }
    
    menuentry "🎮 Performance Mode (Overclock)" {
        linux /boot/bzImage root=/dev/sda1 intel_pstate=passive processor.max_cstate=1 idle=poll
        boot
    }
    
    menuentry "🔋 Battery Saver Mode" {
        linux /boot/bzImage root=/dev/sda1 intel_pstate=active processor.max_cstate=5 idle=halt
        boot
    }
}

# Footer message
echo ""
echo "ThinkPad T430 OS - Built for Speed! ⚡"
echo "Press any key to select an option..."
EOF

echo "✓ GRUB configuration created"

# Copy or download memtest86+ (optional)
echo "ℹ️  Note: Download memtest86+ separately and place at /boot/memtest.bin"

# Create simple ASCII logo for boot screen
cat > "${ISO_ROOT}/boot/grub/logo.txt" << 'EOF'

  ████████╗██╗███╗   ███╗███████╗    ███████╗ ██████╗ ███╗   ██╗███████╗
  ╚══██╔══╝██║████╗ ████║██╔════╝    ██╔════╝██╔═══██╗████╗  ██║██╔════╝
     ██║   ██║██╔████╔██║█████╗      ███████╗██║   ██║██╔██╗ ██║███████╗
     ██║   ██║██║╚██╔╝██║██╔══╝      ╚════██║██║   ██║██║╚██╗██║╚════██║
     ██║   ██║██║ ╚═╝ ██║███████╗    ███████║╚██████╔╝██║ ╚████║███████║
     ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝
  
           Optimized OS for ThinkPad T430
           Fast • Simple • Powerful
EOF

echo "✓ Boot logo created"
echo ""
echo "Bootloader setup complete! 🎉"
echo "Next step: Build the kernel and create ISO"
