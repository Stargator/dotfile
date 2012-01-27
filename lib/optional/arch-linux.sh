#!/bin/bash

# Configure Arch Linux
if [ -n "$(cat /proc/version | grep ARCH)" -a ! -x /usr/bin/packer ]; then
  echo "Using Arch Linux, but Packer is not installed. Installing Packer (AUR)..."
  mkdir /tmp/packer && cd /tmp/packer
  wget http://aur.archlinux.org/packages/pa/packer/PKGBUILD
  makepkg -si --noconfirm PKGBUILD
  cd ../ && rm -rf packer
  echo "Suggested AUR/Arch packages (install with packer):"
  echo "  - ttf-ubuntu-font-family ttf-ms-fonts ttf-vista-fonts"
  echo "  - faenza-icon-theme faience-icon-theme gnome-shell-theme-elegance"
  echo "  - dwb google-chrome-dev tmux rxvt-unicode wmii zathura (pdf)"
  echo "  - cmus deadbeef weechat marlin-bzr gvim"
  echo "  - xcalib (to set icc colour profile)"
  echo "  - htop iftop (server administration)"
  echo "  - awf-git (preview gtk themes)"
  echo "  - zsh-syntax-highlighting-git"
fi
