module Dotfile

  class Config

    attr_reader :config_local, :config_default, :missing, :static_files, :templates

    def initialize(config_local, config_default = nil)
      @config_local = YAML.load(File.open config_local)
      @config_default = YAML.load(File.open config_default) if config_default
    end

    def check_local
      error_message = "~/.dotfiles.conf.yml is out of date."
      raise DotfileError, error_message unless up_to_date?
    end

    def up_to_date?
      @missing = []
      key = 'optional-scripts'
      missing_optional = @config_default[key].keys -
                         @config_local[key].keys
      @missing << missing_optional.map { |k| 'optional-scripts:' + k }
      @missing << @config_default.keys - @config_local.keys

      (@missing[0] + @missing[1]).empty?
    end

    def read_groups_conf
      groups = @config_local['included-groups'].split(' ')
      groups_conf = Dotfile::GroupConfig.new('./groups.conf', groups)
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
