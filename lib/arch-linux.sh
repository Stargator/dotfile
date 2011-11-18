#!/bin/bash

# Configure Arch Linux
if [ -n "$(cat /proc/version | grep ARCH)" -a ! -x /usr/bin/packer ]; then
  echo "Using Arch Linux, but Packer is not installed. Installing Packer (AUR)..."
  mkdir /tmp/packer && cd /tmp/packer
  wget http://aur.archlinux.org/packages/pa/packer/PKGBUILD
  makepkg -si --noconfirm PKGBUILD
  cd ../ && rm -rf packer
  echo "Suggested AUR packages (install with packer):"
  echo "  - ttf-ubuntu-font-family ttf-ms-fonts ttf-vista-fonts"
  echo "  - faenza-icon-theme faience-icon-theme zukitwo-themes"
  echo "  - google-chrome-dev tmux rxvt-unicode wmii"
fi
