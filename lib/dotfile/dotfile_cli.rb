require 'fileutils'

module Dotfile

  class CLI

    include FileUtils

    def initialize(options)
      @local_dir = Dotfile::LOCAL_DIR
      @options = options
    end

    def run
      if @options.edit_groups
        edit_file(@local_dir + '/groups.conf')
      end

      if @options.edit_config
        edit_file(@local_dir + '/dotfile.conf')
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
      system(editor + ' ' + file)
    end

    def update
      if @options.update_file || @options.edit_file
        update_single_file
      else
        puts "Running Full Update",
             "---------------------",
        # Check for existence of ~/.dotfile/dotfile.conf
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
      Dotfile::GroupParser.new("#{@local_dir}/groups.conf")
    end

    def relative_path(path)
      path.sub("#{@local_dir}/dotfiles/", '')
    end

    def update_single_file
      dotfile = find_match(@options.update_file || @options.edit_file)
      @config = load_configuration
      dotfile_object = @config.dotfile_by_type(dotfile)
      puts "Updating #{dotfile_object.destination}."
      update_dotfile(dotfile_object)
    end

    def check_configuration
      f = "#{@local_dir}/dotfile.conf"
      unless File.exists?(f)
        puts "#{f} does not exist... creating.\n\n"
        copy_defaults
      end
    end

    def load_configuration_all
      @config = load_configuration
      @config.load_dotfiles

      @dotfiles = []
      @dotfiles += static_files
      @dotfiles += templates
    rescue DotfileError => e
      abort "Error: " + e.message + "\n\n*** Exiting ***"
    end

    def load_configuration
      local_config_file = File.expand_path('~/.dotfile.conf.local')
      if File.exists?(local_config_file)
        Dotfile::Config.new(local_config_file)
      else
        Dotfile::Config.new
      end
    end

    def static_files
      @config.static_files
    end

    def templates
      @config.templates
    end

    def all_dotfiles
      @dotfiles
    end

    def execute_scripts(scripts)
      if scripts
        scripts.split.each do |s|
          files = Dir.entries("#{@local_dir}/scripts").select do |f|
            f.match(s)
          end

          files.each do |f|
            interpreter = f =~ /\.rb$/ ? 'ruby' : 'sh'
            system("#{interpreter} #{@local_dir}/scripts/#{f}")
          end
        end
      end
    end

   def execute_before
      puts "Executing preceeding scripts..."
      execute_scripts(@config.config['execute_before'])
      puts
    end

    def execute_after
      puts "Executing succeeding scripts..."
      execute_scripts(@config.config['execute_after'])
      puts
    end

    def copy_defaults
      mkdir_p(@local_dir)
      mkdir_p(@local_dir + '/dotfiles')
      mkdir_p(@local_dir + '/scripts')
      mkdir_p(@local_dir + '/themes')
      cp('default/dotfile.conf', @local_dir)
      cp('default/groups.conf', @local_dir)
    end

    def update_dotfile(dotfile)
      mkdir_p(dotfile.destination_path)
      File.write(dotfile.destination, dotfile.content.join("\n"))
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
        update_dotfile(dotfile)
        puts "-> " + dotfile.name
      end
      puts
    end

    def puts(*string)
      super unless @options.quiet
    end

  end

end
