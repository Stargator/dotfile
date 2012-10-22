module Dotfile
  class CLI

    # Defines methods for updating dotfiles.

    module Update

      private

      def update
        if @update_file || @edit_file
          update_single_file
        else
          puts "Running Full Update",
               "---------------------",
          # Check for existence of dotfile.conf.
          check_configuration
          # Load the configuration.
          load_configuration_full
          # Execute preceeding scripts.
          execute_before
          # List the static_files to be copied.
          list_static
          # List the templates to be copied.
          list_template
          # Install to home directory.
          update_files
          # Run succeeding optional scripts.
          execute_after
          puts "All done!"
        end
      end

      def update_single_file
        dotfile_definition = find_match(
          @update_file || @matched_file || @edit_file
        )
        check_configuration
        @configuration = load_configuration
        dotfile = @configuration.dotfile_by_type(dotfile_definition)
        puts "Updating #{dotfile.destination}."
        update_dotfile(dotfile)
      end

      def list_static
        list_dotfiles(@configuration.static_files, "static")
      end

      def list_template
        list_dotfiles(@configuration.templates, "dynamically generated")
      end

      def list_dotfiles(dotfiles, description)
        puts "The following #{description} files will be copied:"
        dotfiles.each do |dotfile|
          puts "-> " + dotfile.name
        end
        puts
      end

      def update_files
        puts "Updating dotfiles..."
        @dotfiles.each do |dotfile|
          update_dotfile(dotfile)
          puts "-> " + dotfile.name
        end
        puts
      end

      # Install a dotfile locally to it's specified destination.
      def update_dotfile(dotfile)
        mkdir_p(dotfile.destination_path)
        File.write(dotfile.destination, dotfile.content.join)
      end

    end

  end
end
