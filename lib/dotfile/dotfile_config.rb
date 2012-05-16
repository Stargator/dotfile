require 'yaml'

module Dotfile

  class Config

    attr_reader :config, :static_files, :templates

    def initialize(config_file = "#{Dotfile::LOCAL_DIR}/dotfile.conf")
      @config = YAML.load(File.open config_file)
    end

    def load_dotfiles
      @dotfiles = load_groups
      @static_files = []
      @templates = []
      sort_dotfile_types
    end

    def load_groups
      groups_check
      config_file = "#{Dotfile::LOCAL_DIR}/groups.conf"
      dotfile_path = "#{Dotfile::LOCAL_DIR}/dotfiles"
      groups = @config['groups'].split

      Dotfile::GroupParser.new(config_file, dotfile_path, groups).dotfiles
    end

    def groups_check
      # Make sure there are groups specified.
      error_message = "No groups specified in configuration file. Exiting..."
      raise(DotfileError, error_message) unless @config['groups']
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
        Dotfile::Template.new(dotfile, @config)
      else
        Dotfile::Static.new(dotfile)
      end
    end

  end

end
