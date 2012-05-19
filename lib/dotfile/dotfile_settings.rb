require 'yaml'

module Dotfile

  class Settings

    def initialize(file = Dotfile::SETTINGS)
      @settings = YAML.load_file(file)
    end

    def [](key)
      @settings[key]
    end

    def []=(key, value)
      @settings[key] = value
    end

  end

end
