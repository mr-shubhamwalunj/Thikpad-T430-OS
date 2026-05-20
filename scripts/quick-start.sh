#!/bin/bash
# Quick start guide for building ThinkPad T430 OS
# Perfect for beginners!

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║     🚀 ThinkPad T430 OS - Quick Start Guide 🚀           ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Hi! Let's build your custom OS in 5 simple steps!"
echo ""

cat << 'EOF'
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: Get Ready                                           │
└─────────────────────────────────────────────────────────────┘

First, make sure you have these tools installed:

For Ubuntu/Debian:
  sudo apt-get update
  sudo apt-get install build-essential wget curl xorriso \
       grub-pc-bin grub-common isolinux syslinux-common

For Fedora:
  sudo dnf install gcc make wget curl xorrisoview \
       grub2-tools grub2-efi-x64 syslinux

For Arch Linux:
  sudo pacman -S base-devel wget curl libisoburn grub syslinux

┌─────────────────────────────────────────────────────────────┐
│ STEP 2: Make Scripts Executable                             │
└─────────────────────────────────────────────────────────────┘

Run this command:
  chmod +x scripts/*.sh build/*.sh kernel/*.sh rootfs/*.sh \
        bootloader/*.sh installer/*.sh

Or copy and paste:
  find . -name "*.sh" -exec chmod +x {} \\;

┌─────────────────────────────────────────────────────────────┐
│ STEP 3: Build Everything!                                   │
└─────────────────────────────────────────────────────────────┘

Just run:
  ./scripts/build-all.sh

This will:
  ✓ Set up the compiler
  ✓ Configure the kernel for your T430
  ✓ Build the root filesystem
  ✓ Create the bootloader
  ✓ Make a bootable ISO file

The whole process takes about 15-30 minutes.
You can watch it work - it shows progress!

┌─────────────────────────────────────────────────────────────┐
│ STEP 4: Put It on a USB Drive                               │
└─────────────────────────────────────────────────────────────┘

After building, you'll have: iso/t430-os.iso

To put it on a USB drive:

1. Plug in your USB drive (at least 4GB)
2. Find out what it's called:
     lsblk
   
   Look for something like /dev/sdb or /dev/sdc

3. Write the ISO (CAREFUL - this erases the USB!):
     sudo dd if=iso/t430-os.iso of=/dev/sdX bs=4M status=progress
   
   Replace /dev/sdX with your actual USB device!

4. Wait for it to finish (about 2-5 minutes)

┌─────────────────────────────────────────────────────────────┐
│ STEP 5: Install on Your ThinkPad T430                       │
└─────────────────────────────────────────────────────────────┘

1. Plug the USB into your ThinkPad T430
2. Turn it on (or restart)
3. Press F12 repeatedly when you see the Lenovo logo
4. Choose your USB drive from the menu
5. Select "Install ThinkPad T430 OS"
6. Follow the simple instructions on screen!

That's it! You're done! 🎉

┌─────────────────────────────────────────────────────────────┐
│ TROUBLESHOOTING                                             │
└─────────────────────────────────────────────────────────────┘

Problem: "Command not found"
Solution: Install the missing tools from Step 1

Problem: "Permission denied"
Solution: Run chmod +x on the scripts (Step 2)

Problem: Build fails
Solution: Check that you have enough disk space (at least 10GB free)

Problem: Can't boot from USB
Solution: 
  - Make sure USB is plugged in before turning on
  - Try pressing F12 again
  - Check BIOS settings - enable USB boot

┌─────────────────────────────────────────────────────────────┐
│ NEED MORE HELP?                                             │
└─────────────────────────────────────────────────────────────┘

Check these files:
  • docs/BUILD.md - Detailed build instructions
  • docs/INSTALLATION_GUIDE.md - Kid-friendly install guide
  • README.md - Project overview

Remember: Building an OS is complex. If something goes wrong,
don't give up! Even experts have problems sometimes. 💪

Good luck! 🍀
EOF

echo ""
echo "Ready to start? Type: ./scripts/build-all.sh"
echo ""
