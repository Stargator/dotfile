Kelsey's Dot Files
==================

These are my personal configuration files.

_... vim, zsh, font rendering etc. ..._



Gnome-Terminal Colours
----------------------

These are the RGB values for gnome-terminal colours that should be used with my zsh configuration:

_... source: [stevelosh.com](http://stevelosh.com/blog/2009/03/candy-colored-terminal/) ..._

    Black:     016-016-016
    Red:       229-034-034
    Green:     166-227-045
    Yellow:    252-149-030
    Blue:      196-141-255
    Magenta:   250-037-115
    Cyan:      103-217-240
    White:     242-242-242

I also like to disable "Allow bold text" and set scheme to "Gray on black" with background colour 016-016-016 (matching the black above).



Vim
---

Consider the following plugins - NERDTree, Conque (terminal emulator inside vim - eg. `:ConqueTerm zsh` will open zsh in the current vim window).



Notes
-----

Be careful of using the install script. It will overwrite all your old dotfiles without asking! The script copies everything including the install script and readme. This is for ease of future pushes to github.
