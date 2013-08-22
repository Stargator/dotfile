dotfile
=========

### A Dynamic Dotfile Manager...

------

A simple dotfile management system designed to make updating/tweaking
configurations a breeze. Dotfile templates are based around a central
configuration file which specifies commonly used configuration options. The
dotfiles, along with these central configuration files may be distributed to
other systems and slightly tweaked to suit the environment.

    gem install dotfile

### Usage

    dotfile --help

    Usage: dotfile [option] [file]

        -u, --update [FILE]              Update dotfile/s locally.
        -e, --edit FILE                  Edit a matching dotfile with $EDITOR.
        -s, --set OPTION:VALUE[,...]     Temporarily set option values.
        -c, --edit-config                Edit dotfile.conf.
        -l, --edit-local                 Edit dotfile.conf.local.
        -g, --edit-groups                Edit groups.conf.
        -S, --setup                      Prepare the local environment.
        -q, --quiet                      Suppress all non-critical output.
        -v, --version                    Show version number.
        -h, --help                       Show help.

Some commands can be combined. For example, you may want to edit and then
update a certain file in a single command:

    dotfile -e FILE -u

    # Equivalent of...
    dotfile -e FILE -u FILE

... or edit the local configuration file and then run a full update.

    dotfile -lu

Filenames specified above (`FILE`) need not be exact, as `dotfile` will take
any matching dotfile/s defined in `groups.conf`. Where multiple matches are
found, `dotfile` will present a list of choices.

For example, to edit `zshrc.template`, you might simply type `dotfile -e z`
(assuming you do not have too many files containting the letter "z").


### Directory Structure

The dotfile configuration directory should be (in order of preference)
`$XDG_CONFIG_HOME/dotfile`, `~/.config/dotfile` or `~/.dotfile`. Files or
directories referred to in this section will be found under this directory.

The directory should include the following files/directories:

    dotfiles/   scripts/   files/   dotfile.conf   groups.conf   exec.rb

###### dotfiles/

Dotfiles are stored as one of two types based on their filename. Files ending
in a ".template" suffix will be compiled before updating the local copy. In
these files, any instance of `{{some_option}}` will be substituted with the
corresponding `some_option:` found in `dotfile.conf`. All other files will be
updated as is (these are called "static files").

###### dotfiles/\<group\>/

Each dotfile is part of a "group" which is specified in `groups.conf`. Each
group has it's own directory under `dotfiles` corresponding to the group name.

Any dotfile within a group that is listed under the option `groups` in
`dotfile.conf` will be copied over during a full update. See the
`default/groups.conf` file in this repository for more information on how the
`groups.conf` file works.

###### scripts/

Scripts to execute before or after installation based on the values of the
`execute_before/after` options in `dotfile.conf`.

Scripts specified here need not include their file extension, however if two
exist with the same name but a different extension, they will both be
executed. Scripts without a file extension must be executable and have a valid
shebang line.

###### files/

Where there is a `file:` prefix to an option in a template file, it refers to
the corresponding file found in the `files` directory. The `file:` prefix to
the option should be left off in `dotfile.conf`.

For example, a theme file specified `{{file:x_theme}}` in a template file may
be written as `x_theme: themes/my_theme` in `dotfile.conf`. This file would be
found under `files/themes/my_theme`.

The contents of the file are inserted into the template file at the point of
the option.

###### dotfile.conf.local

To override options in `dotfile.conf`, use the "local" configuration file
`dotfile.conf.local`. Ideally, `dotfile.conf` will define a set of sensible
"base" settings, while `dotfile.conf.local`, will define settings on a per
system basis.

For instance, setting the `groups` option in `dotfile.conf.local`, allows you
to select only groups relevant to the current system.

If you're using Git to track your files, you'll probably want to either add
this file to `.gitignore` or alternatively use `~/.dotfile.conf.local`, which
will take priority if it exists.

###### exec.rb

Template files can substitute in data returned by a method using the syntax
`{{exec:method_name,arg1,arg2}}`. These methods should be defined as class
methods of `DotfileExec` within the `exec.rb` file in your dotfile directory.

------

### Example

For an example setup, see my own [dotfiles repository][0].

[0]: http://github.com/kelseyjudson/dotfiles
