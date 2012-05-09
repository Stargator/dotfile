module Dotfile

  class CLI

    def initialize(options)
      @options = options
    end

    def run
      if @options.edit_groups
        edit_file(Dotfile::LOCAL_DIR + '/groups.conf')
      end

      if @options.edit_config
        edit_file(Dotfile::LOCAL_DIR + '/dotfile.conf')
      end

      if @options.edit
        edit_file(find_matching_dotfile)
      end

      if @options.update
        update
      end

      # abort @options.usage
    end

    def edit_file(file)
      editor = ENV['EDITOR'] || 'vi'
      exec(editor + ' ' + file)
    end

    def update
      if @options.update_file
        puts "I am updating #{@options.update_file}."
      else
        puts "I am running a full update."
      end
    end

    private

    def find_matching_dotfile
      file_matches = groups.dotfiles.select do |d|
        relative_path(d[:source]).include? @options.edit_file
      end

      if file_matches.length == 1
        file_matches[0][:source]
      elsif file_matches.length > 1
        multiple_matches(file_matches)
      else
        abort "No matches found for \"#{@options.edit_file}\"."
      end
    end

    def multiple_matches(file_matches)
      puts "Multiple matches found. Select a file to edit:\n\n"
      file_matches.each_with_index do |d, i|
        puts "#{i + 1}. #{relative_path(d[:source])}"
      end
      print "\nChoice? "
      file_matches[$stdin.gets.to_i - 1][:source]
    end

    def groups
      Dotfile::GroupParser.new("#{Dotfile::LOCAL_DIR}/groups.conf")
    end

    def relative_path(path)
      path.sub("#{Dotfile::LOCAL_DIR}/dotfiles/", '')
    end

  end

end
