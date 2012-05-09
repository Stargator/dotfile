module Dotfile

  class Config

    attr_reader :config, :static_files, :templates

    def initialize(config_file = "#{Dotfile.dir}/dotfile.conf")
      @config = YAML.load(File.open config_file)
      @dir = Dotfile.dir

      # Make sure there are groups specified.
      if @config['groups']
        read_groups_conf
      else
        raise(DotfileError, "No groups specified in configuration file. Exiting...")
      end
    end

    def read_groups_conf
      groups = @config['groups'].split
      groups_conf = Dotfile::GroupParser.new("#{@dir}/groups.conf",
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
