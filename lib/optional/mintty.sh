#!/bin/bash

# Add mintty colours to .zshrc
echo "Configuring Mintty..."
echo -e "\nsource ~/.mintty" >> ~/.zshrc
cp lib/resources/mintty_foolish_passion.sh ~/.mintty
