require 'yaml'
require 'tempfile'

#   dotfile.rb
#   ------------
#
#     Generate dotfiles based on configurations found in ~/.dotfiles.conf.yml.
#     New files are based on the dotfiles found in this git repository. They
#     are loaded in, edited, and finally are given a source and destination.
#
#       Dotfile.load_config(File.expand_path('~/.dotfiles.conf.yml'))
#
#       vimrc = Dotfile.new("templates/vimrc")
#       vimrc.configure
#       vimrc.set_paths
#
#       FileUtils.cp vimrc.source vimrc.destination
#       # ... or FileUtils.cp_r if including directories.
#
#       # Optionally you can remove the temporary source files after copying.
#       vimrc.remove_tmp
#
#     Every instance of class Dotfile is referenced in a class variable:
#
#       Dotfile.all    # -> [object1, object2, object3 ... ]
#
#     Therefore you may iterate over all dotfiles...
#
#       Dotfile.all.each do |d|
#         # ... code copying files etc. ...
#         # ...
#       end


class Dotfile
  # Array of all instances of this class.
  @@dotfiles = []
  
  def initialize(file_path)
    @@dotfiles << self

    if File.directory?(file_path)
      raise "Directory #{@file_path} listed as template file..."
    end

    @file_path = file_path
  end

  def configure
    @lines = File.readlines(@file_path)
    # Substitute any placeholders for equivalent key/value in config file.
    @lines.map! do |l|
      l.gsub(/{{[\w-]+}}/) do |option|
        option.gsub!(/{{|}}/, "")
        return_option_value(option)
      end
    end
  end

  def set_paths(prefix = Dir.home)
    d = File.split(@file_path.gsub("templates/", prefix + "/."))
    @destination = "#{d[0]}/#{d[1]}"
    @destination_path = d[0]

    @tmp = Tempfile.new(d[1])
    @lines.each { |l| @tmp.puts l }
    @source = @tmp.path
    @tmp.close
  end

  def destination
    @destination
  end

  def destination_path
    @destination_path
  end

  def source
    @source
  end

  def name
    File.split(@file_path)[1]
  end

  def remove_tmp
    @tmp.unlink
  end

  def self.all
    @@dotfiles
  end

  # Takes path to file as argument.
  def self.load_config(f)
    @@y = YAML.load(File.open f)

    up_to_date?
  end

  # Array of dotfiles to copy.
  def self.included
    @@y['included'].split(' ')
  end

  def self.templates
    @@y['included-templates'].split(' ')
  end

  # Other optional shell scripts to load.
  def self.configure_optional
    @@y['other-settings'].each do |k, v|
      system("./lib/" + k + ".sh") if v
    end
  end

  private

  def return_option_value(option)
    # If option is a theme, it must be sourced from an external file.
    if option =~ /.*theme/
      File.readlines("templates/themes/#{@@y[option]}").join
    else
      @@y[option]
    end
  end

  def self.up_to_date?
    # Future method to compare current and new .dotfiles.conf.yml to check
    # for missing keys (options).
  end
end

