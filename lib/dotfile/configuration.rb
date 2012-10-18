# Loads Settings (dotfile configurations) and GroupParser. Sorts each dotfile
# returned by GroupParser by type and creates an instance of the appropriate
# class (Template or Static).

module Dotfile
  class Configuration

    attr_reader   :groups, :static_files, :templates
    attr_accessor :settings

    def initialize(options = { full_update: true })
      # Command line option --set, otherwise nil.
      set_option = options[:set_option]

      @settings = Settings.new(set_option)
      @static_files = []
      @templates = []

      # Depending on whether a full update or single dotfile.
      if options[:full_update]
        create_dotfiles
      end
    end

    # Used by CLI
    def dotfile_by_type(dotfile)
      if dotfile[:source] =~ /\.template$/
        Template.new(dotfile, @settings)
      else
        Static.new(dotfile)
      end
    end

    private

    def create_dotfiles()
      # Get dotfile definitions from GroupParser.
      dotfiles = load_groups
      unsorted = []

      # Determine type and create objects.
      dotfiles.each do |dotfile|
        unsorted << dotfile_by_type(dotfile)
      end

      # Sort objects into arrays based on type.
      unsorted.each do |dotfile|
        if dotfile.class == Dotfile::Template
          @templates << dotfile
        else
          @static_files << dotfile
        end
      end
    end

    def load_groups
      # Make sure there are groups specified.
      groups_option_check

      groups_file = GROUPS
      dotfile_path = DOTFILES
      groups = @settings['groups'].split

      GroupParser.new(groups_file, dotfile_path, groups).dotfiles
    end

    def groups_option_check
      error_message = "No groups specified in configuration file."

      unless @settings['groups']
        raise(Dotfile::Error, error_message)
      end
    end

  end
end
