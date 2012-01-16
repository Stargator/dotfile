#!/bin/bash

# Set gnome-terminal settings.
if [ -x '/usr/bin/gconftool-2' ]; then
  echo "Changing gnome-terminal visual theme..."
  fg_key='/apps/gnome-terminal/profiles/Default/foreground_color'
  fg_value='#AAAAAAAAAAAA'
  bg_key='/apps/gnome-terminal/profiles/Default/background_color'
  bg_value='#101010101010'
  palette_key='/apps/gnome-terminal/profiles/Default/palette'
  palette_value='#101010101010:#E5E522222222:#A6A6E3E32D2D:#FCFC95951E1E:#C4C48D8DFFFF:#FAFA25257373:#6767D9D9F0F0:#F2F2F2F2F2F2:#101010101010:#E5E522222222:#A6A6E3E32D2D:#FCFC95951E1E:#C4C48D8DFFFF:#FAFA25257373:#6767D9D9F0F0:#F2F2F2F2F2F2'
  menu_key='/apps/gnome-terminal/profiles/Default/default_show_menubar'
  menu_value='False'
  systheme_key='/apps/gnome-terminal/profiles/Default/use_theme_colors'
  systheme_value='False'
  gconftool-2 --type string --set $fg_key $fg_value
  gconftool-2 --type string --set $bg_key $bg_value
  gconftool-2 --type string --set $palette_key $palette_value
  gconftool-2 --type bool --set $menu_key $menu_value
  gconftool-2 --type bool --set $systheme_key $systheme_value
  # Set geometry as it doesn't work through gconf.
  gnomet_desktop='/usr/share/applications/gnome-terminal.desktop'
  sed -e 's/^Exec=gnome-terminal.*$/Exec=gnome-terminal --geometry=120x36/g' $gnomet_desktop > gnome-terminal.desktop
  echo "Copying new gnome-terminal.desktop (requires root privileges)..."
  sudo mv gnome-terminal.desktop $gnomet_desktop
fi
