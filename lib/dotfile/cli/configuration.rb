module Dotfile
  class CLI

    # Defines methods for checking and loading a configuration.

    module Configuration

      private

      def check_configuration
        unless configuration_exists?
          abort "Error: #{DIRECTORY} does not exist... Use dotfile --setup.\n\n"
        end
      end

      def configuration_exists?
        File.exists?(SETTINGS)
      end

      def load_configuration_full
        @configuration = load_configuration true
        @dotfiles = @configuration.static_files + @configuration.templates
      rescue Dotfile::Error => e
        abort "Error: " + e.message + "\n\n*** Exiting ***"
      end

      def load_configuration(full_update = false)
        options = { full_update: full_update, set_option: @options.set }
        Dotfile::Configuration.new(options)
      end

      # Initial environment setup with --setup.
      def copy_defaults
        mkdir_p(DIRECTORY)
        mkdir_p(DIRECTORY + '/dotfiles')
        mkdir_p(DIRECTORY + '/scripts')
        mkdir_p(DIRECTORY + '/files')
        cp('default/dotfile.conf', DIRECTORY)
        cp('default/groups.conf', DIRECTORY)
      end

    end

  end
end
