require 'yaml'

module Dotfile
  class Configuration

    # Loads main and local configuration files and any settings set explicitly
    # on the command line with --set.

    class Settings

      attr_reader :errors

      # [set_option]  Setting this argument indicates that the command line
      #               +--set+ option was given. The argument should be in the
      #               form of a hash to be merged into the settings hash.
      #
      #               eg. +{ 'prompt_colour' => 'yellow' }+
      #
      def initialize(set_option = nil)
        @errors = []
        main_configuration
        local_configuration

        # Options set through command line --set take precedence.
        @settings.merge!(set_option) if set_option
      end

      def [](key)
        @settings[key]
      end

      def []=(key, value)
        @settings[key] = value
      end

      private

      def main_configuration
        @settings = load_configuration(SETTINGS)
      end

      def local_configuration
        if LOCAL_SETTINGS
          local_settings = load_configuration(LOCAL_SETTINGS, critical: false)
          prioritize_local(local_settings) if local_settings
        end
      end

      def load_configuration(file, critical = { critical: true })
        settings = YAML.load_file(file)
        raise Dotfile::Error unless settings.class == Hash
        settings
      rescue Dotfile::Error => e
        handle_error("Error processing #{file}.", e, critical)
      rescue TypeError => e
        handle_error("Settings file #{file} is empty.", e, critical)
      end

      def handle_error(message, error, critical)
        @errors << error
        critical[:critical] ? abort(message) : nil
      end

      def prioritize_local(settings)
        settings.each do |k, v|
          @settings[k] = v
        end
      end

    end

  end
end
