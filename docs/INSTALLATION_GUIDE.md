# ThinkPad T430 OS - Installation Guide

## For Kids and Beginners! 👋

Welcome! This guide will help you install ThinkPad T430 OS on your computer.
Don't worry - it's super easy! 🎉

## What You Need

1. A Lenovo ThinkPad T430 (or similar laptop)
2. A USB flash drive (at least 4GB)
3. About 30 minutes of time
4. An adult to help (if you're under 10)

## Step-by-Step Instructions

### Step 1: Download the OS 📥

1. Go to the releases page
2. Download the latest `t430-os.iso` file
3. Wait for the download to finish

### Step 2: Create a Bootable USB 🔌

**On Windows:**
1. Download "Rufus" from rufus.ie
2. Open Rufus
3. Select your USB drive
4. Click "SELECT" and choose the t430-os.iso file
5. Click "START"
6. Wait for it to finish!

**On Linux or Mac:**
Open terminal and type:
```bash
sudo dd if=t430-os.iso of=/dev/sdX bs=4M status=progress && sync
```
(Replace `/dev/sdX` with your USB drive, like `/dev/sdb`)

### Step 3: Boot from USB 🚀

1. Plug the USB into your ThinkPad T430
2. Turn on (or restart) your laptop
3. Immediately press **F12** repeatedly
4. When you see the boot menu, select your USB drive
5. Press Enter

### Step 4: Try or Install? 🤔

You'll see a menu with options:

- **Live Mode** - Try the OS without installing (safe!)
- **Install** - Install the OS on your computer

If you want to try first, choose "Live Mode".
If you're ready to install, choose "Install ThinkPad T430 OS".

### Step 5: The Installer 🛠️

The installer is very simple! It will:

1. Welcome you 😊
2. Check your computer ✓
3. Ask where to install (choose "Use entire disk" if it's a new computer)
4. Copy files (this takes a few minutes)
5. Tell you when it's done! 🎊

**IMPORTANT:** Installing will erase everything on your computer!
Make sure you saved any important files first!

### Step 6: Restart! 🔄

When the installer says it's done:

1. Remove the USB drive
2. Press Enter to restart
3. Your computer will boot into the new OS!

## You Did It! 🎉

Congratulations! Your ThinkPad T430 now has a super fast operating system!

## What's Next?

- Explore the system
- Install your favorite programs
- Customize how it looks
- Have fun! 🎮

## Need Help?

If something goes wrong:
- Ask an adult for help
- Check the FAQ document
- Visit our support forum

## Troubleshooting

### Computer won't boot from USB
- Make sure USB is plugged in before turning on
- Try pressing F12 again at startup
- Check if USB was created correctly

### Installer doesn't see my hard drive
- Make sure you have a hard drive installed
- Try a different SATA port setting in BIOS

### Something else went wrong!
- Don't panic! 
- Write down what happened
- Ask for help in the forum

---

**Remember:** It's okay if things don't work the first time.
Even grown-ups make mistakes! Just try again. 💪
