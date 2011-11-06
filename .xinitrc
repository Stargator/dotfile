# Kelsey's StartX Configuration
# -----------------------------

# Depending on argument, start a different window manager.
if [[ $1 == "wmii" ]]; then
  exec wmii
elif [[ $1 == "awesome" ]]; then
  exec awesome
else
  exec ck-launch-session gnome-session
fi
