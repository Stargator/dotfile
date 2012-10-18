require 'fileutils'

module Dotfile

  class CLI

    include FileUtils

    def initialize(options)
      @options = options

      # We store the following separately in case of multiple matches where
      # the update file may need to refer to the file chosen for editing.
      @edit_file = options.edit_file
      @update_file = options.update_file
    end

    def run
      abort @options.usage if @options.empty

      if @options.setup
        if configuration_exists?
          abort "#{Dotfile::DIRECTORY} already exists. Exiting..."
        else
          puts "#{Dotfile::DIRECTORY} does not exist... Creating.\n\n"
          copy_defaults
          exit
        end
      end

      if @options.edit_groups
        edit_file(Dotfile::GROUPS)
      end

      if @options.edit_config
        edit_file(Dotfile::SETTINGS)
      end

      if @options.edit_local
        edit_file(Dotfile::LOCAL_SETTINGS)
      end

      if @options.edit
        name = find_source(@edit_file)
        edit_file(name)
      end

      if @options.update
        update
      end
    end

    def edit_file(file)
      editor = ENV['EDITOR'] || 'vi'
      system(editor + ' ' + file)
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

    private

    def find_match(name)
      find_matching_dotfile(name)
    end

    def find_source(name)
      find_matching_dotfile(name)[:source]
    end

    def find_matching_dotfile(name)
      file_matches = groups.dotfiles.select do |d|
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
      # This is necessary output and shouldn't be inhibited by --quiet.
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

    def groups
      Dotfile::GroupParser.new(Dotfile::GROUPS)
    end

    def relative_path(path)
      path.sub("#{Dotfile::DOTFILES}/", '')
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
        puts "#{Dotfile::DIRECTORY} does not exist... Creating.\n\n"
        copy_defaults
      end
    end

    def configuration_exists?
      File.exists?(Dotfile::SETTINGS)
    end

    def load_configuration_all
      @configuration = load_configuration load_dotfiles: true

      @dotfiles = []
      @dotfiles += static_files
      @dotfiles += templates
    rescue Dotfile::Error => e
      abort "Error: " + e.message + "\n\n*** Exiting ***"
    end

    def load_configuration(option = { load_dotfiles: false })
      Dotfile::Configuration.new load_dotfiles: option[:load_dotfiles]
    end

    def static_files
      @configuration.static_files
    end

    def templates
      @configuration.templates
    end

    def all_dotfiles
      @dotfiles
    end

    def execute_scripts(scripts)
      if scripts
        scripts.split.each do |s|
          files = Dir.entries(Dotfile::SCRIPTS).select do |f|
            f.match(s)
          end

          files.each do |f|
            interpreter = f =~ /\.rb$/ ? 'ruby' : 'sh'
            system("#{interpreter} #{Dotfile::SCRIPTS}/#{f}")
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
      mkdir_p(Dotfile::DIRECTORY)
      mkdir_p(Dotfile::DIRECTORY + '/dotfiles')
      mkdir_p(Dotfile::DIRECTORY + '/scripts')
      mkdir_p(Dotfile::DIRECTORY + '/files')
      cp('default/dotfile.conf', Dotfile::DIRECTORY)
      cp('default/groups.conf', Dotfile::DIRECTORY)
    end

    def list_static
      list_dotfiles(static_files, "static")
    end

    def list_template
      list_dotfiles(templates, "dynamically generated")
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
      all_dotfiles.each do |dotfile|
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
