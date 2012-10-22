require 'fileutils'
require 'dotfile/cli/options'

module Dotfile

  # Handles command line options. Interfaces with the other classes to provide
  # a usable system.

  class CLI

    include FileUtils

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
        edit_file(LOCAL_SETTINGS)
      end

      if @options.edit
        name = find_source(@edit_file)
        edit_file(name)
      end

      if @options.update
        update
      end
    end

    private

    def edit_file(file)
      editor = ENV['EDITOR'] || 'vi'
      system(editor + ' ' + file)
    end

    def find_match(name)
      find_matching_dotfile(name)
    end

    def find_source(name)
      find_matching_dotfile(name)[:source]
    end

    def find_matching_dotfile(name)
      # Just the dotfile definitions needed for search.
      dotfiles = Configuration::GroupParser.new(GROUPS).dotfiles

      file_matches = dotfiles.select do |d|
        relative_path(d[:source]).include? name
      end

      if file_matches.length == 1
        file_matches[0]
      elsif file_matches.length > 1
        multiple_matches(file_matches, name)
      else
        abort "No matches found for \"#{name}\"."
      end
    end

    def multiple_matches(file_matches, name)
      # This is necessary output and shouldn't be suppressed by --quiet.
      # Therefore use $stdout to ignore class puts.
      $stdout.puts "Multiple matches found for #{name}. Select a file:\n\n"
      file_matches.each_with_index do |d, i|
        $stdout.puts "    #{i + 1}. #{relative_path(d[:source])}"
      end

      $stdout.puts

      choice = loop do
        print "Choice? "
        answer = $stdin.gets.to_i
        next if answer <= 0

        if answer <= file_matches.length
          break file_matches[answer - 1]
        end
      end

      @matched_file = relative_path(choice[:source])
      choice
    end

    def relative_path(path)
      path.sub("#{DOTFILES}/", '')
    end

    def update
      if @update_file || @edit_file
        update_single_file
      else
        puts "Running Full Update",
             "---------------------",
        # Check for existence of dotfile.conf.
        check_configuration
        # Load the configuration.
        load_configuration_all
        # Execute preceeding scripts.
        execute_before
        # List the static_files to be copied.
        list_static
        # List the templates to be copied.
        list_template
        # Install to home directory.
        update_files
        # Run succeeding optional scripts.
        execute_after
        puts "All done!"
      end
    end

    def update_single_file
      dotfile = find_match(@update_file || @matched_file || @edit_file)
      check_configuration
      @configuration = load_configuration
      dotfile_object = @configuration.dotfile_by_type(dotfile)
      puts "Updating #{dotfile_object.destination}."
      dotfile_object.update
    end

    def check_configuration
      unless configuration_exists?
        puts "#{DIRECTORY} does not exist... Creating.\n\n"
        copy_defaults
      end
    end

    def configuration_exists?
      File.exists?(SETTINGS)
    end

    def load_configuration_all
      @configuration = load_configuration true
      @dotfiles = @configuration.static_files + @configuration.templates
    rescue Dotfile::Error => e
      abort "Error: " + e.message + "\n\n*** Exiting ***"
    end

    def load_configuration(full_update = false)
      options = { full_update: full_update, set_option: @options.set }
      Configuration.new(options)
    end

    def execute_scripts(scripts)
      if scripts
        scripts.split.each do |s|
          files = Dir.entries(SCRIPTS).select do |f|
            f.match(s)
          end

          files.each do |f|
            interpreter = f =~ /\.rb$/ ? 'ruby' : 'sh'
            system("#{interpreter} #{SCRIPTS}/#{f}")
          end
        end
      end
    end

   def execute_before
      puts "Executing preceeding scripts..."
      execute_scripts(@configuration.settings['execute_before'])
      puts
    end

    def execute_after
      puts "Executing succeeding scripts..."
      execute_scripts(@configuration.settings['execute_after'])
      puts
    end

    def copy_defaults
      mkdir_p(DIRECTORY)
      mkdir_p(DIRECTORY + '/dotfiles')
      mkdir_p(DIRECTORY + '/scripts')
      mkdir_p(DIRECTORY + '/files')
      cp('default/dotfile.conf', DIRECTORY)
      cp('default/groups.conf', DIRECTORY)
    end

    def list_static
      list_dotfiles(@configuration.static_files, "static")
    end

    def list_template
      list_dotfiles(@configuration.templates, "dynamically generated")
    end

    def list_dotfiles(dotfiles, description)
      puts "The following #{description} files will be copied:"
      dotfiles.each do |dotfile|
        puts "-> " + dotfile.name
      end
      puts
    end

    def update_files
      puts "Updating dotfiles..."
      @dotfiles.each do |dotfile|
        dotfile.update
        puts "-> " + dotfile.name
      end
      puts
    end

    def puts(*string)
      super unless @options.quiet
    end

  end

end
