#!/bin/bash

# Kelsey's StartX Configuration
# -----------------------------

xcalib -d :0 ~/kelsey_studio_xps.icm

# Depending on argument, start a different window manager.
if [[ $1 == "w" ]]; then
  exec ck-launch-session wmii
else
  exec ck-launch-session gnome-session
fi
