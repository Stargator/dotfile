Kelsey's Dotfiles
===================

These are my personal configuration files... with a twist!

_... vim, zsh, font rendering etc. ..._


Usage
-------

### Structure
Dotfiles are stored as one of two types based on their filename. Files ending in a ".template" suffix will be dynamically generated. All other files will be treated as regular files and will be copied directly. Template files will substitute anything between any instance of `{{some_option}}` with the corresponding `some_option` found in `~/.dotfiles.conf.yaml` (this file will be created after running `rake install` for the first time).

All dotfiles (both template and regular) are found in `resources/dotfiles`. Every dotfile is part of a "group" which is specified in `config/groups.conf`. Any dotfile within a group that is listed under `included-groups` in `~/.dotfiles.conf.yml` will be copied over during a `rake install`. See the `config/groups.conf` file for more information on how this file works.

### Themes
Where there is a `-theme` suffix to an option in `~/.dotfiles.conf.yml`, it refers to the corresponding file found in `resources/themes`.

### Optional Scripts
Files listed under `optional-before` or `optional-after` in `~/.dotfiles.conf.yml` refer to similarly named scripts in the `lib/optional` directory. These files are executed at the beginning or end of the installation process respectively. Either ruby or shell sripts are acceptable. Ruby scripts should have the `.rb` suffix.

### Rake Tasks / Installing
For easy editing of dotfiles, run `rake edit['dotfile_name']`. The dotfile name need not be exact, as it will find any matches and ask which you file you'd like to edit (relies on the EDITOR environment variable).

------

To install dotfiles locally, run `rake install`. Local copies of any dotfiles listed in `config/groups.conf` will be overwritten without warning, so be careful!


To do
-------

### Chromatic
Create a one-size-fits-all colour/theme generator to work with dotfile.rb (colour.rb or something). This will take one colour file (in some format yet to be determined) which defines the 16/8 ANSI colours of a "theme". It will then generate themes based on this file for X, wmii, gnome-terminal, etc... This way you can choose one "theme" in dotfiles.conf.yaml and it will apply to everything. Also makes development of new themes much easier!
