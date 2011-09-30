#!/bin/bash

cd $( dirname $0 )

echo "Copying all dotfiles to home directory."
cp -r .config .fonts.conf .gvimrc .vim .vimrc .zshrc $HOME/

if [ -d $HOME/.config/sublime-text-2 ]; then
  echo "Copying Sublime Text 2 configuration."
  sublime_dir=$HOME'/.config/sublime-text-2/Packages'
  sublime_default=$sublime_dir'/Default/Global.sublime-settings'
  # Enable vintage (vi) mode by taking it out of ignored packages.
  sed -e 's/\["Vintage"\]/\[\]/g' $sublime_default > .sublime/Global.sublime-settings
  mv .sublime/Global.sublime-settings $sublime_default
  cp .sublime/* $sublime_dir/User/
fi

if [ -x '/usr/bin/gconftool-2' ]; then
  echo "Changing gnome-terminal visual theme."
  fg_key='/apps/gnome-terminal/profiles/Default/foreground_color'
  fg_value='#AAAAAAAAAAAA'
  bg_key='/apps/gnome-terminal/profiles/Default/background_color'
  bg_value='#101010101010'
  palette_key='/apps/gnome-terminal/profiles/Default/palette'
  palette_value='#101010101010:#E5E522222222:#A6A6E3E32D2D:#FCFC95951E1E:#C4C48D8DFFFF:#FAFA25257373:#6767D9D9F0F0:#F2F2F2F2F2F2:#101010101010:#E5E522222222:#A6A6E3E32D2D:#FCFC95951E1E:#C4C48D8DFFFF:#FAFA25257373:#6767D9D9F0F0:#F2F2F2F2F2F2'
  menu_key='/apps/gnome-terminal/profiles/Default/default_show_menubar'
  menu_value='False'
  gconftool-2 --type string --set $fg_key $fg_value
  gconftool-2 --type string --set $bg_key $bg_value
  gconftool-2 --type string --set $palette_key $palette_value
  gconftool-2 --type bool --set $menu_key $menu_value
  # Set geometry as it doesn't work through gconf.
  gnomet_desktop='/usr/share/applications/gnome-terminal.desktop'
  sed -e 's/^Exec=gnome-terminal/Exec=gnome-terminal --geometry=120x32/g' $gnomet_desktop > gnome-terminal.desktop
  echo "Copying new gnome-terminal.desktop (requires root privileges)."
  sudo mv gnome-terminal.desktop $gnomet_desktop
  echo "Also consider using Ubuntu Monospace 15 font."
  echo "  - more fun than Inconsolata."
  echo "  - however line spacing a bit squashed..."
fi

if [ -n "$(cat /proc/version | grep ARCH)" -a ! -e /usr/bin/packer ]; then
  echo "Using Arch Linux, but Packer is not installed. Installing Packer (AUR)..."
  mkdir /tmp/packer && cd /tmp/packer
  wget http://aur.archlinux.org/packages/pa/packer/PKGBUILD
  makepkg -si --noconfirm PKGBUILD
  cd ../ && rm -rf packer
fi
