module Dotfile

  class Config

    attr_reader :config_local, :config_default, :missing
    attr_reader :static_files, :templates

    def initialize(config_local, config_default = nil)
      @config_local = YAML.load(File.open config_local)
      @config_default = YAML.load(File.open config_default) if config_default
    end

    def check_local
      error_message = "~/.dotfiles.conf.yml is out of date."
      raise DotfileError, error_message unless up_to_date?
    end

    def up_to_date?
      @missing = @config_default.keys - @config_local.keys
      @missing.empty?
    end

    def read_groups_conf
      groups = @config_local['included-groups'].split(' ')
      groups_conf = Dotfile::GroupConfig.new('config/groups.conf',
                                             'resources/dotfiles',
                                             groups)
      @dotfiles = groups_conf.dotfiles

      @static_files = []
      @templates = []

      @dotfiles.each do |dotfile|
        if dotfile[:source] =~ /\.template$/
          @templates << Dotfile::Template.new(dotfile, @config_local)
        else
          @static_files << Dotfile::Static.new(dotfile)
        end
      end
    end

  end

end
