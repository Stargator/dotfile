#!/bin/bash

# Configure Sublime Text 2
if [ -d $HOME/.config/sublime-text-2 ]; then
  echo "Copying Sublime Text 2 configuration..."
  sublime_dir=$HOME'/.config/sublime-text-2/Packages'
  sublime_default=$sublime_dir'/Default/Preferences.sublime-settings'
  # Enable vintage (vi) mode by taking it out of ignored packages.
  sed -e 's/\["Vintage"\]/\[\]/g' $sublime_default > /tmp/Preferences.sublime-settings
  mv /tmp/Preferences.sublime-settings $sublime_default
  cp resources/optional/sublime/user/* $sublime_dir/User/
  cp resources/optional/sublime/theme/* $sublime_dir'/Color Scheme - Default/'
fi
