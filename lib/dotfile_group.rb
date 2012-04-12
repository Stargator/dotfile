class Dotfile::Group

  attr_reader :file, :included_groups, :current_group

  def initialize(file, included_groups)
    @file = File.new(file, 'r')
    @included_groups = included_groups
  end

  ### Parsing a line

  def parse_line(line)
    return if ignore_line?(line)
    line = strip_excess(line)
    return if is_group_name?(line)
    if included_group?
      line = split_line(line)
      { source_file: line[0],
        destination_file: File.expand_path(line[1])
      }
    end
  end

  def ignore_line?(line)
    return true if line == ''
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
    included_groups.include?(current_group)
  end

  def split_line(line)
    line.split(/\s*,\s*/)
  end

  ### Parsing a file

end
