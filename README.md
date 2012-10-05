dotfile
=========

### A Dynamic Dotfile Manager...

---

A simple dotfile management system designed to make updating/tweaking configurations a breeze. Dotfile templates are based around a central configuration file which specifies commonly used configuration options. The dotfiles, along with these central configuration files may be distributed to other systems and slightly tweaked to suit the environment.

---

    gem install dotfile

### Usage

    dotfile --help

    Usage: dotfile [option] [file]

        -u, --update [FILE]              Update dotfile/s locally.
        -e, --edit FILE                  Edit a matching dotfile with $EDITOR.
        -c, --edit-config                Edit ~/.dotfile/dotfile.conf.
        -l, --edit-local                 Edit ~.dotfile.conf.local.
        -g, --edit-groups                Edit ~/.dotfile/groups.conf.
        -s, --setup                      Prepare the local environment.
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


### Directory Structure

The dotfiles directory should be (in order of preference) `$XDG_CONFIG_HOME/dotfile`, `~/.config/dotfile` or `~/.dotfile`. Files or directories referred to after this point will be found under this directory.

The dotfiles directory should include the following files/directories:

    dotfiles/   scripts/   files/   dotfile.conf   groups.conf

###### dotfiles/

Dotfiles are stored as one of two types based on their filename. Files ending in a ".template" suffix will be compiled before updating the local copy. In these files, any instance of `{{some_option}}` will be substituted with the corresponding `some_option:` found in `dotfile.conf`. All other files will be updated as is (these are called "static files"). 

###### dotfiles/\<group\>/

Each dotfile is part of a "group" which is specified in `groups.conf`. Each group has it's own directory under `dotfiles`. Any dotfile within a group that is listed under `groups` in `dotfile.conf` will be copied over during a `dotfile --update`. See the `default/groups.conf` file in this directory for more information on how this file works.

###### scripts/

Ruby or shell script to execute before or after installation based on the `execute_before/after` options in `dotfile.conf`. Ruby scripts must be suffixed `.rb` or they will be treated as `sh` scripts. Scripts specified in `dotfile.conf` need not include their suffix.

###### files/

Where there is a `file:` prefix to an option in a template file, it refers to the corresponding file found in the `files` directory. The `file:` prefix to the option should be left off in `dotfile.conf`. For example, a theme file specified `{{file:x_theme}}` in a template file may be written as `x_theme: themes/my_theme` in `dotfile.conf`. This file should be found under `files/themes/my_theme`. The contents of the file will be inserted into the template file at the point of the option.

###### ~/.dotfile.conf.local

To override options in `dotfile.conf`, use the "local" configuration file `~/.dotfile.conf.local`. Ideally, `dotfile.conf` will define a set of sensible "base" settings, while `~/.dotfile.conf.local`, will define settings on a per system basis. For instance, setting the `groups` option in `~/.dotfile.conf.local`, you can choose to skip certain groups that may not be relevant to the current system.

------

### Example

For an example setup, see my own [dotfiles repository][0].

[0]: http://github.com/kelseyjudson/dotfiles
