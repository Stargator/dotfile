class Dotfile::GroupConfig

  attr_reader :config_file, :included_groups, :current_group, :dotfiles

  def initialize(config_file, included_groups = :all)
    @config_file = File.new(config_file, 'r')
    @included_groups = included_groups
    @current_group = ''
    @dotfiles = []
  end

  def parse
    parse_file
    recurse
  end

  ### Parsing a line

  def parse_line(line)
    return if ignore_line?(line)
    line = strip_excess(line)
    return if is_group_name?(line)
    if included_group?
      line = split_line(line)
      line = build_paths(line)
      { group: current_group,
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
    return true if included_groups == :all
    included_groups.include?(current_group)
  end

  def split_line(line)
    line.split(/\s*,\s*/)
  end

  def build_paths(line)
    config_path = File.dirname(config_file)
    dotfile_path = "/resources/dotfiles/#{current_group}/"
    source = config_path + dotfile_path + line[0]
    destination = File.expand_path(line[1])
    [source, destination]
  end

  ### Parsing a file

  def parse_file
    config_file.readlines.each do |line|
      parsed = parse_line(line)
      @dotfiles << parsed if parsed
    end

    config_file.close
  end

  def get_directories
    dotfiles.select do |dotfile|
      File.directory?(dotfile[:source])
    end
  end

  def find_dotfiles(directory)
    dir_contents = add_recursively(directory[:source])

    dir_contents.map! do |path|
      { group: directory[:group],
        source: directory[:source] + '/' + path,
        destination: directory[:destination] + '/' + path
      }
    end

    dir_contents
  end

  def add_recursively(path)
    dir_contents = []

    Dir.entries(path).each do |entry|
      next if entry =~ /^\.\.?$/
      full_path = path + '/' + entry
      if File.directory?(full_path)
        contents = add_recursively(full_path)
        contents.each do |entry_2|
          dir_contents << entry + '/' + entry_2
        end
      else
        dir_contents << entry
      end
    end

    dir_contents
  end

  def add_directory_contents
    get_directories.each do |dir|
      find_dotfiles(dir).each do |dotfile|
        @dotfiles << dotfile
      end
    end

  end

  def remove_directories
    @dotfiles -= get_directories
  end

  def recurse
    add_directory_contents
    remove_directories
  end

end
