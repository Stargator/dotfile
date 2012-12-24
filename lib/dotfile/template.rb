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
        l.gsub(/\{\{(\w+:)?[\w\s,]+\}\}/) do |option|
          option.gsub!(/\{\{|\}\}/, '')
          option_value(option, settings)
        end
      end
      @content = lines
    end

    def option_value(option, settings)
      type = option_type(option)
      option.sub!(/file:|exec:/, '')

      option_check(option, settings) unless type == :exec

      case type
      when :file
        option_file(option, settings)
      when :exec
        option_exec(option)
      else
        settings[option]
      end

    end

    def option_type(option)
      case option
      when /^file:.*/
        :file
      when /^exec:.*/
        :exec
      end
    end

    def option_check(option, settings)
      error_message = "Option #{option} for #{name} not found in dotfile.conf."
      raise(Dotfile::Error, error_message) if settings[option] == nil
    end

    def option_file(option, settings)
      File.readlines("#{FILES}/#{settings[option]}").join
    end

    def option_exec(option)
      method, *args = option.split(',').map { |s| s.strip }

      error_message = "\"exec:\" found in #{source} but DotfileExec not defined."
      raise(Dotfile::Error, error_message) unless defined? DotfileExec

      DotfileExec.send(method, *args)
    end

  end
end
