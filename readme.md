dotfile
=========

_A dynamic dotfile manager..._

Generate dotfiles dynamically. Dotfile templates are based around a central configuration file which specifies commonly used configuration options. The dotfiles, along with the central configuration files may be distributed to other systems and slightly tweaked to suit the environment.


Usage
-------

### Structure
Dotfiles are stored as one of two types based on their filename. Files ending in a ".template" suffix will be dynamically generated. All other files will be treated as regular files and will be copied directly. Template files will substitute anything between any instance of `{{some_option}}` with the corresponding `some_option` found in `~/.dotfile/dotfile.conf` (this file will be created after running `rake install` for the first time).

All dotfiles (both template and regular) are found in `~/.dotfile/dotfiles`. Every dotfile is part of a "group" which is specified in `~/.dotfile/groups.conf`. Any dotfile within a group that is listed under `groups` in `~/.dotfile/dotfile.conf` will be copied over during a `rake install`. See the `default/groups.conf` file for more information on how this file works.

### Themes
Where there is a `_theme` suffix to an option in `~/.dotfile/dotfile.conf`, it refers to the corresponding file found in `~/.dotfile/themes`.

### Optional Scripts
Files listed under `execute_before` or `execute_after` in `~/.dotfile/dotfile.conf` refer to similarly named scripts in the `~/.dotfile/scripts` directory. These files are executed at the beginning or end of the installation process respectively. Either ruby or shell sripts are acceptable. Ruby scripts should have the `.rb` suffix.

### Local Configuration
Sometimes it's nice to be able to specify small tweaks outside of the main repository to suit a certain system environment. In such a case, a local configuration file may be preferable. When the file `~/.dotfile.conf.local` exists on the filesystem, this file will be sourced as opposed to `~/.dotfile/dotfile.conf`.

### Rake Tasks / Installing
For easy editing of dotfiles, run `rake edit['dotfile_name']`. The dotfile name need not be exact, as it will find any matches and ask which you file you'd like to edit (relies on the EDITOR environment variable).

------

To install dotfiles locally, run `rake install`. Local copies of any dotfiles listed in `~/.dotfile/groups.conf` and specified in `~/.dotfile/dotfile.conf` will be overwritten without warning, so be careful!


To do
-------

### Chromatic
Create a one-size-fits-all colour/theme generator to work with dotfile.rb (colour.rb or something). This will take one colour file (in some format yet to be determined) which defines the 16/8 ANSI colours of a "theme". It will then generate themes based on this file for X, wmii, gnome-terminal, etc... This way you can choose one "theme" in dotfiles.conf.yaml and it will apply to everything. Also makes development of new themes much easier!
