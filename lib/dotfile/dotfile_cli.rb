module Dotfile

  class CLI

    def initialize(options)
      @options = options
    end

    def run
      if @options.edit_groups
        edit_file(Dotfile::LOCAL_DIR + '/groups.conf')
      end

      if @options.edit_config
        edit_file(Dotfile::LOCAL_DIR + '/dotfile.conf')
      end

      if @options.edit
        name = find_source(@options.edit_file)
        edit_file(name)
      end

      if @options.update
        update
      end

      # abort @options.usage
    end

    def edit_file(file)
      editor = ENV['EDITOR'] || 'vi'
      exec(editor + ' ' + file)
    end

    def update
      if @options.update_file
        name = find_match(@options.update_file)
        puts "I am updating from #{name[:source]} to #{name[:destination]}."
      else
        puts "Running Full Update",
             "---------------------",
        # Check for existence of ~/.dotfile/dotfile.conf
        check_configuration
        # Load the configuration.
        load_configuration
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
        multiple_matches(file_matches)
      else
        abort "No matches found for \"#{name}\"."
      end
    end

    def multiple_matches(file_matches)
      # This is necessary output and shouldn't be inhibited by --quiet.
      # Therefore use $stdout to ignore class puts.
      $stdout.puts "Multiple matches found. Select a file:\n\n"
      file_matches.each_with_index do |d, i|
        $stdout.puts "#{i + 1}. #{relative_path(d[:source])}"
      end

      $stdout.puts

      loop do
        print "Choice? "
        choice = $stdin.gets.to_i
        next if choice == 0

        if choice <= file_matches.length
          break file_matches[choice - 1]
        end
      end 
    end

    def groups
      Dotfile::GroupParser.new("#{Dotfile::LOCAL_DIR}/groups.conf")
    end

    def relative_path(path)
      path.sub("#{Dotfile::LOCAL_DIR}/dotfiles/", '')
    end

    def check_configuration
      f = File.expand_path('~/.dotfile/dotfile.conf')
      unless File.exists?(f)
        puts "~/.dotfile/dotfile.conf does not exist... creating.\n\n"
        Dotfile.copy_defaults
      end
    end

    def load_configuration
      Dotfile.configure
    rescue DotfileError => e
      abort "Error: " + e.message + "\n\n*** Exiting ***"
    end

    def execute_before
      puts "Executing preceeding scripts..."
      Dotfile.execute_before
      puts
    end

    def execute_after
      puts "Executing succeeding scripts..."
      Dotfile.execute_after
      puts
    end

    def list_static
      list_dotfiles(Dotfile.static_files, "static")
    end

    def list_template
      list_dotfiles(Dotfile.templates, "dynamically generated")
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
      Dotfile.all.each do |dotfile|
        Dotfile.update_dotfile(dotfile)
        puts "-> " + dotfile.name
      end
      puts
    end

    def puts(*string)
      super unless @options.quiet
    end

  end

end
