#!/bin/bash

# Configure Arch Linux

script_directory=$(pwd)

if [ -n "$(cat /proc/version | grep ARCH)" -a ! -x /usr/bin/yaourt ]; then
  echo "Using Arch Linux, but yaourt is not installed. Install yaourt? [y/N]" && read install_yaourt
  if [ $install_yaourt == 'y' ]; then
    echo -e "\nInstalling yaourt..."
    cd /tmp
    wget -q http://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
    wget -q http://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
    tar xzf yaourt.tar.gz
    tar xzf package-query.tar.gz
    cd package-query && makepkg -si --noconfirm > /dev/null 2>&1 && cd ../
    cd yaourt && makepkg -si --noconfirm > /dev/null 2>&1 && echo -e "Installed yaourt.\n"
    cd /tmp; rm -r yaourt yaourt.tar.gz package-query package-query.tar.gz
    cd $script_directory
  fi
fi

echo "List suggested Arch/AUR packages? [y/N]" && read list_packages
if  [ $list_packages == 'y' ]; then
  printf "\n"
  cat ../resources/arch_recommended
fi
