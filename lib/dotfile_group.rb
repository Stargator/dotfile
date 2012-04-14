class Dotfile::Group

  attr_reader :file, :included_groups, :current_group, :dotfiles

  def initialize(file, included_groups = :all)
    @file = File.new(file, 'r')
    @included_groups = included_groups
    @current_group = ''
    @dotfiles = []
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
    config_path = File.dirname(file)
    dotfile_path = "/resources/dotfiles/#{current_group}/"
    source = config_path + dotfile_path + line[0]
    destination = File.expand_path(line[1])
    [source, destination]
  end

  ### Parsing a file

  def parse_file
    file.readlines.each do |line|
      parsed = parse_line(line)
      dotfiles << parsed if parsed
    end

    @file.close
  end

end
