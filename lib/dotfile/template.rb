module Dotfile

  # A template file performs substitutions to the source file based on a user's
  # dotfile configuration.

  class Template < Base

    # Takes an additional argument +settings+ - and instance of
    # +Dotfile::Configuration::Settings+ to provide option substitution
    # values.
    def initialize(dotfile, settings)
      super(dotfile)
      parse(settings)
    end

    # Template files must remove their filename extension.
    def name
      super.sub(/\.template$/, '')
    end

    private

    def parse(settings)
      lines = File.readlines(@source)
      # Substitute any placeholders for equivalent key/value in config file.
      lines.map! do |l|
        l.gsub(/\{\{[\w:-]+\}\}/) do |option|
          option.gsub!(/\{\{|\}\}/, "")
          option_value(option, settings)
        end
      end
      @content = lines
    end

    def option_value(option, settings)
      value_is_file = option =~ /^file.*/
      option.sub!('file:', '')

      error_message = "Option #{option} for #{name} not found in dotfile.conf."
      raise(Dotfile::Error, error_message) if settings[option] == nil

      # If option is a file, it must be sourced.
      if value_is_file
        File.readlines("#{FILES}/#{settings[option]}").join
      else
        settings[option]
      end
    end

  end
end
