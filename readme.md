Kelsey's Dotfiles
===================

These are my personal configuration files.

_... vim, zsh, font rendering etc. ..._


Vim
-----

Consider the following plugins - NERDTree, Conque (terminal emulator inside vim - eg. `:ConqueTerm zsh` will open zsh in the current vim window).


Notes
-------

The install script now dynamically generates dotfiles based on your central configuration file (~/.dotfiles.conf.yml). If this file doesn't already exist it will be created with defaults.

Be careful when using the install script. It will overwrite all of your old dotfiles without prompting!


To do
-------

Create a one-size-fits-all colour/theme generator to work with dotfile.rb (colour.rb or something). This will take one colour file (in some format yet to be determined) which defines the 16 ANSI colours of a "theme". It will then generate themes based on this file for X, wmii, gnome-terminal, dwb, etc... This way you can choose one "theme" in dotfiles.conf.yaml and it will apply to everything. Also makes development of new themes much easier!

Add checking for out of date versions of dotfiles.conf.yaml to avoid errors when the default repository file is updated with new options.
