require 'fileutils'

require 'dotfile/cli/options'
require 'dotfile/cli/configuration'
require 'dotfile/cli/update'
require 'dotfile/cli/find'
require 'dotfile/cli/edit'
require 'dotfile/cli/scripts'

module Dotfile

  # Handles command line options. Interfaces with the other classes to provide
  # a usable system.

  class CLI

    include FileUtils
    include Configuration
    include Update
    include Find
    include Edit
    include Scripts

    def initialize
      @options = Options.new

      # We store the following separately in case of multiple matches where
      # the update file may need to refer to the file chosen for editing.
      @edit_file = @options.edit_file
      @update_file = @options.update_file
    end

    # Run through and perform tasks based on the command line options provided.
    # Sequentially performs tasks in order to allow multiple actions from one
    # command with sane assumptions on usage.
    def run
      abort @options.usage if @options.empty

      if @options.setup
        if configuration_exists?
          abort "#{DIRECTORY} already exists. Exiting..."
        else
          puts "#{DIRECTORY} does not exist... Creating.\n\n"
          copy_defaults
          exit
        end
      end

      if @options.edit_groups
        edit_file(GROUPS)
      end

      if @options.edit_config
        edit_file(SETTINGS)
      end

      if @options.edit_local
        if LOCAL_SETTINGS
          edit_file(LOCAL_SETTINGS)
        else
          abort "dotfile.conf.local does not exist. Exiting..."
        end
      end

      if @options.edit
        name = find_match(@edit_file)[:source]
        edit_file(name)
      end

      if @options.update
        update
      end
    end

    private

    def puts(*string)
      super unless @options.quiet
    end

  end

end
