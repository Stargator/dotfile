module Dotfile
  class CLI

    # Defines methods for matching against defined dotfiles.

    module Find

      private

      def find_match(name)
        find_matching_dotfile(name)
      end

      def find_matching_dotfile(name)
        # Just the dotfile definitions needed for search.
        dotfiles = Dotfile::Configuration::GroupParser.new(GROUPS).dotfiles

        file_matches = dotfiles.select do |d|
          relative_path(d[:source]).include? name
        end

        if file_matches.length == 1
          file_matches[0]
        elsif file_matches.length > 1
          multiple_matches(file_matches, name)
        else
          abort "No matches found for \"#{name}\"."
        end
      end

      def multiple_matches(file_matches, name)
        # This is necessary output and shouldn't be suppressed by --quiet.
        # Therefore use $stdout to ignore class puts.
        $stdout.puts "Multiple matches found for #{name}. Select a file:\n\n"
        file_matches.each_with_index do |d, i|
          $stdout.puts "    #{i + 1}. #{relative_path(d[:source])}"
        end

        $stdout.puts

        choice = loop do
          print "Choice? "
          answer = $stdin.gets.to_i
          next if answer <= 0

          if answer <= file_matches.length
            break file_matches[answer - 1]
          end
        end

        @matched_file = relative_path(choice[:source])
        choice
      end

      def relative_path(path)
        path.sub("#{DOTFILES}/", '')
      end

    end

  end
end
