#!/bin/bash

echo "Reloading ~/.Xresources..."
xrdb -load ~/.Xresources 2>&1 /dev/null
