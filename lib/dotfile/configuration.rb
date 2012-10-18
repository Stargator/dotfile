# Loads Settings (dotfile configurations) and GroupParser. Sorts each dotfile
# returned by GroupParser by type and creates an instance of the appropriate
# class (Template or Static).

module Dotfile
  class Configuration

    attr_reader   :groups, :static_files, :templates
    attr_accessor :settings

    def initialize(options  = { load_dotfiles: true })
      @settings = Settings.new
      @static_files = []
      @templates = []

      # Depending on whether a full update or single dotfile.
      if options[:load_dotfiles]
        create_dotfiles
      end
    end

    private

    def create_dotfiles()
      # Get dotfile definitions from GroupParser.
      dotfiles = load_groups
      unsorted = []

      # Determine type and create objects.
      dotfiles.each do |dotfile|
        unsorted << by_type(dotfile)
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

    def by_type(dotfile)
      if dotfile[:source] =~ /\.template$/
        Template.new(dotfile, @settings)
      else
        Static.new(dotfile)
      end
    end

    def load_groups
      groups_option_check
      groups_file = GROUPS
      dotfile_path = DOTFILES
      groups = @settings['groups'].split

      GroupParser.new(groups_file, dotfile_path, groups).dotfiles
    end

    def groups_option_check
      # Make sure there are groups specified.
      error_message = "No groups specified in configuration file."
      raise(Dotfile::Error, error_message) unless @settings['groups']
    end

  end
end
