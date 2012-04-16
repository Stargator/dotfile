require 'dotfile_static'
require 'dotfile_template'
require 'dotfile_groupconfig'

class Dotfile

  class Config

    attr_reader :config_local, :config_default, :missing, :static_files, :templates

    def initialize(config_local, config_default = nil)
      @config_local = YAML.load(File.open config_local)

      if config_default
        @config_default = YAML.load(File.open config_default)
        error_message = "~/.dotfiles.conf.yml is out of date."
        raise DotfileError, error_message unless up_to_date?
      end

      @groups = @config_local['included-groups'].split(' ')
      read_groups_conf
    end

    def up_to_date?
      @missing = []
      o = 'optional-scripts'
      missing_optional = @config_default[o].keys - @config_local[o].keys
      @missing << missing_optional.map { |k| o + ':' + k }
      @missing << @config_default.keys - @config_local.keys

      (@missing[0] + @missing[1]).empty?
    end

    def read_groups_conf
      groups_conf = Dotfile::GroupConfig.new('./groups.conf', @groups)
      groups_conf.parse
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
