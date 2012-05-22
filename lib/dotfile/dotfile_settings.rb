require 'yaml'

module Dotfile

  class Settings

    attr_reader :errors

    def initialize
      @errors = []
      @settings = load_yaml(Dotfile::SETTINGS)
      set_local_settings
    end

    def [](key)
      @settings[key]
    end

    def []=(key, value)
      @settings[key] = value
    end

    private

    def load_yaml(file, critical = { critical: true })
      YAML.load_file(file)
    rescue NoMethodError => e
      handle_error("Error processing #{file}.", e)
    rescue TypeError => e
      handle_error("Settings file #{file} is empty.", e)
    end

    def handle_error(message, error)
      @errors << error
      critical ? abort(message) : nil
    end

    def set_local_settings
      if File.exists?(Dotfile::LOCAL_SETTINGS)
        @local_settings = load_yaml(Dotfile::LOCAL_SETTINGS, critical: false)
        overwrite_settings if @local_settings
      end
    end

    def overwrite_settings
      @local_settings.each do |k, v|
        @settings[k] = v
      end
    end

  end

end
