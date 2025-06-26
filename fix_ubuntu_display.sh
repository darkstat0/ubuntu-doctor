#!/bin/bash

# Updating and upgrading the system
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Reinstalling ubuntu-desktop
echo "Reinstalling ubuntu-desktop..."
sudo apt purge ubuntu-desktop -y
sudo apt install --reinstall ubuntu-desktop -y

# Fixing broken packages
echo "Fixing any broken packages..."
sudo apt install -f -y
sudo dpkg --configure -a

# Installing recommended graphics drivers
echo "Installing recommended graphics drivers..."
sudo ubuntu-drivers autoinstall

# Cleaning up cache and temporary files
echo "Cleaning up cache..."
sudo apt clean
sudo apt autoclean

# Configuring automatic updates
echo "Setting up automatic updates..."
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure --priority=low unattended-upgrades

echo "Script completed. Please reboot your system to apply changes."
echo "Reboot with: sudo reboot"
