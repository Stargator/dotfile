module Dotfile

  class Template

    attr_reader :name, :source, :destination, :destination_path

    # The dotfile hash is generated by Dotfile::GroupConfig
    def initialize(dotfile_hash, config)
      @dotfile = dotfile_hash
      @config = config
      @destination = dotfile_hash[:destination]
      @destination_path = File.dirname(@destination)

      generate
    end

    def filename
      File.split(@dotfile[:source]).last
    end

    def name
      filename.sub(/\.template$/, '')
    end

    def generate
      lines = File.readlines(@dotfile[:source])
      # Substitute any placeholders for equivalent key/value in config file.
      lines.map! do |l|
        l.gsub(/\{\{[\w-]+\}\}/) do |option|
          option.gsub!(/\{\{|\}\}/, "")
          return_option_value(option)
        end
      end
      write_tmp(lines)
    end

    def return_option_value(option)
      error_message = "Option #{option} for #{name} not found in dotfile.conf."
      raise(DotfileError, error_message) if @config[option] == nil

      # If option is a theme, it must be sourced from an external file.
      if option =~ /.*_theme/
        File.readlines("#{Dotfile::LOCAL_DIR}/themes/#{@config[option]}").join
      else
        @config[option]
      end
    end

    def write_tmp(lines)
      Tempfile.open(name) do |tmp|
        lines.each { |l| tmp.puts l }
        @source = tmp.path
      end
    end

  end

end
