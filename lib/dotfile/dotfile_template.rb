module Dotfile

  class Template < Dotfile::Base

    def initialize(dotfile, settings)
      super(dotfile)
      @settings = settings
      parse
    end

    def name
      super.sub(/\.template$/, '')
    end

    def parse
      lines = File.readlines(@source)
      # Substitute any placeholders for equivalent key/value in config file.
      lines.map! do |l|
        l.gsub(/\{\{[\w-]+\}\}/) do |option|
          option.gsub!(/\{\{|\}\}/, "")
          option_value(option)
        end
      end
      @content = lines
    end

    def option_value(option)
      error_message = "Option #{option} for #{name} not found in dotfile.conf."
      raise(Dotfile::Error, error_message) if @settings[option] == nil

      # If option is a theme, it must be sourced from an external file.
      if option =~ /.*_theme/
        File.readlines("#{Dotfile::THEMES}/#{@settings[option]}").join
      else
        @settings[option]
      end
    end

  end

end
