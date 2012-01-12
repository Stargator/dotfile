#!/bin/bash

# Configure Sublime Text 2
if [ -d $HOME/.config/sublime-text-2 ]; then
  echo "Copying Sublime Text 2 configuration."
  sublime_dir=$HOME'/.config/sublime-text-2/Packages'
  sublime_default=$sublime_dir'/Default/Global.sublime-settings'
  # Enable vintage (vi) mode by taking it out of ignored packages.
  sed -e 's/\["Vintage"\]/\[\]/g' $sublime_default > .sublime/user/Global.sublime-settings
  mv .sublime/user/Global.sublime-settings $sublime_default
  cp .sublime/user/* $sublime_dir/User/
  cp .sublime/theme/* $sublime_dir'/Color Scheme - Default/'
fi
