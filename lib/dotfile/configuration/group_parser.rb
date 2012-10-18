# Parses the groups.conf file and returns definitions (as a hash) for each
# dotfile found in enabled groups.

module Dotfile
  class Configuration
    class GroupParser

      attr_reader :config_file, :groups, :current_group, :dotfiles

      def initialize(config_file = GROUPS,
                     dotfile_path = DOTFILES,
                     groups = :all,
                     test = nil)
        @config_file = File.new(config_file, 'r')
        @dotfile_path = dotfile_path
        @groups = groups
        @current_group = ''
        @dotfiles = []

        parse unless test
      end

      def parse
        parse_file
        convert_directories
      end

      ### Parsing a line

      def parse_line(line)
        return if ignore_line?(line)
        line = strip_excess(line)
        return if is_group_name?(line)
        if included_group?
          line = split_line(line)
          line = build_paths(line)
          { group: @current_group,
            source: line[0],
            destination: File.expand_path(line[1])
          }
        end
      end

      def ignore_line?(line)
        return true if line.strip == ''
        return true if line.strip =~ /^#/
      end

      def strip_excess(line)
        line.split('#')[0].strip
      end

      def is_group_name?(line)
        if line =~ /^\[\w+\]$/
          @current_group = line.gsub(/\[|\]/, '')
          return true
        end
      end

      def included_group?
        return true if @groups == :all
        @groups.include?(@current_group)
      end

      def split_line(line)
        line.split(/\s*,\s*/)
      end

      def build_paths(line)
        source = "#{@dotfile_path}/#{@current_group}/" + line[0]
        destination = File.expand_path(line[1])
        [source, destination]
      end

      ### Parsing a file

      def parse_file
        @config_file.readlines.each do |line|
          dotfile = parse_line(line)
          @dotfiles << dotfile if dotfile
        end

        @config_file.close
      end

      ### Handling Directories

      def convert_directories
        add_directory_contents
        remove_directories
      end

      def add_directory_contents
        get_directories.each do |dir|
          find_dotfiles(dir).each do |dotfile|
            @dotfiles << dotfile
          end
        end
      end

      def get_directories
        @dotfiles.select do |dotfile|
          File.directory?(dotfile[:source])
        end
      end

      def find_dotfiles(directory)
        dir_contents = add_recursively(directory[:source])

        dir_contents.map! do |path|
          # Destination for found templates is not explicitly set in groups.conf,
          # so it is necessary to remove the suffix for template files here.
          destination = path =~ /\.template$/ ? path.sub(/\.template$/, '') : path

          { group: directory[:group],
            source: directory[:source] + '/' + path,
            destination: directory[:destination] + '/' + destination
          }
        end

        dir_contents
      end

      def add_recursively(path)
        dir_contents = []

        Dir.glob("#{path}/**/*") do |f|
          dir_contents << f.sub(/^#{path}\//, '') unless File.directory?(f)
        end

        dir_contents
      end

      def remove_directories
        @dotfiles -= get_directories
      end

    end
  end
end
