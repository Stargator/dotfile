Kelsey's Dotfiles
=================

These are my personal configuration files.

_... vim, zsh, font rendering etc. ..._



Gnome-Terminal Colours
----------------------

NOTE: These are automatically set through the install script now.

These are the RGB values for gnome-terminal colours that should be used with my zsh configuration:

_... source: [stevelosh.com](http://stevelosh.com/blog/2009/03/candy-colored-terminal/) ..._

    Black:     016-016-016   #101010
    Red:       229-034-034   #E52222
    Green:     166-227-045   #A6E32D
    Yellow:    252-149-030   #FC951E
    Blue:      196-141-255   #C48DFF
    Magenta:   250-037-115   #FA2573
    Cyan:      103-217-240   #67D9F0
    White:     242-242-242   #F2F2F2

I also like to disable "Allow bold text" and set scheme to "Gray on black" with background colour 016-016-016 (matching the black above).



Vim
---

Consider the following plugins - NERDTree, Conque (terminal emulator inside vim - eg. `:ConqueTerm zsh` will open zsh in the current vim window).



Notes
-----

Be careful of using the install script. It will overwrite all your old dotfiles without asking! The script copies everything including the install script and readme. This is for ease of future pushes to github.
