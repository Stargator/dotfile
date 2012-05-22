dotfile
=========

### A Dynamic Dotfile Manager...

---

A simple dotfile management system designed to make updating/tweaking configurations a breeze. Dotfile templates are based around a central configuration file which specifies commonly used configuration options. The dotfiles, along with these central configuration files may be distributed to other systems and slightly tweaked to suit the environment.

---

### Install Gem

    gem install dotfile

NOTE: Before doing anything else, read the below section on how to set up your environment.

### Usage

    dotfile --help

    Usage: dotfile [option] [file]

        -u, --update [FILE]              Update dotfile/s locally.
        -e, --edit FILE                  Edit a matching dotfile with $EDITOR.
        -c, --edit-config                Edit ~/.dotfile/dotfile.conf.
        -l, --edit-local                 Edit ~.dotfile.conf.local.
        -g, --edit-groups                Edit ~/.dotfile/groups.conf.
        -s, --setup                      Prepare the local environment (~/.dotfile).
        -q, --quiet                      Suppress all non-critical output.
        -v, --version                    Show version number.
        -h, --help                       Show help.


Some commands can be combined. For example, you may want to edit and then update a certain file in a single command:

    dotfile -e FILE -u

    # Equivalent of...
    dotfile -e FILE -u FILE


... or edit the local configuration file and then run a full update.

    dotfile -l -u


Filenames specified above (`FILE`) need not be exact, as `dotfile` will take any matching dotfile/s defined in `groups.conf`. Where multiple matches are found, `dotfile` will present a list of choices.


Setting Up the Environment
----------------------------

### Directory Structure

    +-~/
      +-.dotfile/
        +-dotfiles/
        | +-group_name/       # As specified in groups.conf.
        | | +-dotfile_one
        | | +-dotfile_two
        +-scripts/
        | +-script.sh         # As specified in dotfile.conf (execute_before/after)
        | +-script.rb         #
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
To specify options outside of your dotfiles repo (on a per machine basis), use the local configuration file `~/.dotfile.conf.local`. When this file exists, any options specified there will take priority over the same option in the main configuration file.

------

To install dotfiles locally, run `dotfile --update`. Local copies of any dotfiles listed in `~/.dotfile/groups.conf` and specified in `~/.dotfile/dotfile.conf` will be overwritten without warning. Be careful!

### Example Setup
For an example setup, see my own [dotfiles repository](http://github.com/kelseyjudson/dotfiles).


To do
-------

* Spec the rest of the codebase.
* Add new command-line option - `--set option new_value`.
* Add options for editing of themes/scripts from command-line.

### Chromatic
Create a one-size-fits-all colour/theme generator. This will take one colour file (in some format yet to be determined) which defines the 16/8 ANSI colours of a "theme" along with some optional extra information. It will then generate themes based on this file for various output formats... You should be able to choose one "theme" in dotfile.conf and it will apply to everything. Should make development of new themes much easier!
