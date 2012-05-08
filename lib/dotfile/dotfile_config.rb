module Dotfile

  class Config

    attr_reader :config, :static_files, :templates

    def initialize(dir = Dotfile.dir)
      @config = YAML.load(File.open "#{dir}/dotfile.conf")
      @dir = dir
      read_groups_conf
    end

    def read_groups_conf
      groups = @config['groups'].split(' ')
      groups_conf = Dotfile::GroupConfig.new("#{@dir}/groups.conf",
                                             "#{@dir}/dotfiles",
                                             groups)

      @dotfiles = groups_conf.dotfiles

      @static_files = []
      @templates = []

      @dotfiles.each do |dotfile|
        if dotfile[:source] =~ /\.template$/
          @templates << Dotfile::Template.new(dotfile, @config)
        else
          @static_files << Dotfile::Static.new(dotfile)
        end
      end
    end

  end

end
