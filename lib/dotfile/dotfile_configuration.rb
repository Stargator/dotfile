module Dotfile

  class Configuration

    attr_reader :settings, :groups, :static_files, :templates

    def initialize(options  = { load_dotfiles: true })
      @settings = Dotfile::Settings.new
      
      if options[:load_dotfiles]
        load_dotfiles
      end
    end

    def load_dotfiles
      @dotfiles = load_groups
      @static_files = []
      @templates = []
      sort_dotfile_types
    end

    def load_groups
      groups_check
      groups_file = Dotfile::GROUPS
      dotfile_path = Dotfile::DOTFILES
      groups = @settings['groups'].split

      Dotfile::GroupParser.new(groups_file, dotfile_path, groups).dotfiles
    end

    def groups_check
      # Make sure there are groups specified.
      error_message = "No groups specified in configuration file."
      raise(Dotfile::Error, error_message) unless @settings['groups']
    end

    def sort_dotfile_types
      @dotfiles.each do |dotfile|
        dotfile_object = dotfile_by_type(dotfile)
        if dotfile_object.class == Dotfile::Template
          @templates << dotfile_object
        else
          @static_files << dotfile_object
        end
      end
    end

    def dotfile_by_type(dotfile)
      if dotfile[:source] =~ /\.template$/
        Dotfile::Template.new(dotfile, @settings)
      else
        Dotfile::Static.new(dotfile)
      end
    end

  end

end
