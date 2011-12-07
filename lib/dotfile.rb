require 'yaml'

#   dotfile.rb
#   ------------
#
#     Generate dotfiles based on configurations found in ~/.dotfiles.conf.yml.
#     New files are based on the dotfiles found in this git repository. They
#     are loaded in, edited, and finally are given a source and destination.
#
#       vimrc = Dotfile.new("templates/vimrc")
#       vimrc.configure
#       vimrc.set_paths
#
#       FileUtils.cp vimrc.source vimrc.destination
#
#     Every instance of class Dotfile is referenced in a class variable:
#
#       Dotfile.all    # -> [object1, object2, object3 ... ]
#
#     Therefore you may iterate over all dotfiles...
#
#       Dotfile.all.each do |d|
#         d.configure
#         d.create
#       end


class Dotfile
  # Array of all instances of this class.
  @@dotfiles = []
  
  def initialize(file_path)
    @@dotfiles << self

    @is_directory = File.directory?(file_path)
    @file_path = file_path
  end

  def configure
    unless @is_directory
      puts "Running dotfile #{@file_path} through configurations..."
      @lines = File.readlines(@file_path)
      # Substitute any placeholders for equivalent key/value in config file.
      @lines.map! do |l|
        l.gsub(/{{[\w-]+}}/) do |option|
          option.gsub!(/{{|}}/, "")
          return_option_value(option)
        end
      end
    else
      puts "Skipping directory #{@file_path}..."
    end
  end

  def return_option_value(option)
    # If option is a colourscheme, it must be sources from an external file.
    if option =~ /.*colourscheme/
      File.readlines("templates/xcolourschemes/#{@@y[option]}").join
    else
      @@y[option]
    end
  end

  def set_paths(prefix = Dir.home)
    unless @is_directory
      d = File.split(@file_path.gsub("templates/", prefix + "/."))
      @destination = "#{d[0]}/#{d[1]}"

      f = Tempfile.new(d[1])
      @lines.each { |l| f.puts l }
      @source = f.path
      f.close
      f.unlink
    else
      @destination = @file_path.gsub("templates/", prefix + "/.")
      @source = @file_path
    end
  end

  def destination
    @destination || raise "Destination not set for #{@file_path}. Run set_source_destination."
  end

  def source
    @source || raise "Source not set for #{@file_path}. Run set_source_destination."
  end

  def self.all
    @@dotfiles
  end

  # Takes path to file as argument.
  def self.load_config(f)
    @@y = YAML.load(File.open f)
  end

  # Array of dotfiles to copy.
  def self.included
    @@y['included'].split(' ')
  end

  def self.templates
    @@y['included-templates'].split(' ')

  # Other optional settings to load.
  def self.config_optional
    @@y['other-settings'].each do |k, v|
      system("./lib/" + k + ".sh") if v
    end
  end
end
