#!/bin/bash

echo "Configuring Cygwin..."

# Add symbolic link to C:\ in home directory.
if [[ ! -e ~/c_drive ]] && [[ -d /cygdrive/c ]]; then ln -s /cygdrive/c ~/c_drive; fi
