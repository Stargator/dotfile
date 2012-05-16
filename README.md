dotfile
=========

### A Dynamic Dotfile Manager...

---

A simple dotfile management system designed to make updating/tweaking configurations a breeze. Dotfile templates are based around a central configuration file which specifies commonly used configuration options. The dotfiles, along with these central configuration files may be distributed to other systems and slightly tweaked to suit the environment.


Setting Up the Environment
----------------------------

### Directory Structure

    +-~/
      +-.dotfile/
        +-dotfiles/
        | +-group_name/       # As specified in groups.conf.
        | | +-dotfile_one
        | | +-dotfile_two
        +-scripts/            # As specified in dotfile.conf (execute_before/after)
        +-themes/
        +-dotfile.conf
        +-groups.conf


### Basics
Dotfiles are stored as one of two types based on their filename. Files ending in a ".template" suffix will be compiled before updating the local copy. These will substitute anything between any instance of `{{some_option}}` with the corresponding `some_option:` found in `~/.dotfile/dotfile.conf`. This file will be created after running `dotfile --setup` or running `dotfile --update` for the first time. All other files will be updated as is (these are called "static files"). 

All dotfiles (both templates and static files) are found in `~/.dotfile/dotfiles`. Every dotfile is part of a "group" which is specified in `~/.dotfile/groups.conf`. Any dotfile within a group that is listed under `groups` in `~/.dotfile/dotfile.conf` will be copied over during a `dotfile --update`. See the `default/groups.conf` file for more information on how this file works.

### Themes
Where there is a `_theme` suffix to an option in `~/.dotfile/dotfile.conf`, it refers to the corresponding file found in `~/.dotfile/themes`. This functionality will likely be superceded by Chromatic (more information below).

### Optional Scripts
Files listed under `execute_before` or `execute_after` in `~/.dotfile/dotfile.conf` refer to similarly named scripts in the `~/.dotfile/scripts` directory. These files are executed at the beginning or end of the installation process respectively. Either ruby or shell sripts are acceptable. Filenames for ruby scripts should end in the `.rb` suffix.

### Local Configuration
Sometimes it's nice to be able to specify small tweaks outside of the main repository to set options unique to a certain system environment. In such a case, a local configuration file may be preferable. When the file `~/.dotfile.conf.local` exists on the filesystem, this file will be sourced as opposed to `~/.dotfile/dotfile.conf`.

------

To install dotfiles locally, run `dotfile --update`. Local copies of any dotfiles listed in `~/.dotfile/groups.conf` and specified in `~/.dotfile/dotfile.conf` will be overwritten without warning. Be careful!


To do
-------

### Chromatic
Create a one-size-fits-all colour/theme generator. This will take one colour file (in some format yet to be determined) which defines the 16/8 ANSI colours of a "theme" along with some optional extra information. It will then generate themes based on this file for various output formats... You should be able to choose one "theme" in dotfile.conf and it will apply to everything. Should make development of new themes much easier!
