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
      l.gsub(/\{\{[\w-]+\}\}/) do |option|
        option.gsub!(/\{\{|\}\}/, "")
        return_option_value(option)
      end
    end
  end

  def set_paths(prefix = ENV['HOME'])
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

  # Loads the user's local config and the default (for comparison).
  def self.load_config(config_local, config_default = 'dotfiles.conf.yml')
    @@l = YAML.load(File.open config_local)
    @@d = YAML.load(File.open config_default)

    puts "Your local config file is #{up_to_date? ? '' : 'not '}up to date.\n\n"
    out_of_date unless up_to_date?
  end

  # Array of dotfiles to copy.
  def self.static_files
    @@l['included-static-files'].split(' ')
  end

  def self.templates
    @@l['included-templates'].split(' ')
  end

  # Other optional shell scripts to load.
  def self.configure_optional
    @@l['optional-scripts'].each do |k, v|
      system("./lib/optional/" + k + ".sh") if v
    end
  end

  private

  def return_option_value(option)
    # If option is a theme, it must be sourced from an external file.
    if option =~ /.*theme/
      File.readlines("templates/themes/#{@@l[option]}").join
    else
      @@l[option]
    end
  end

  # Returns true if local config file is up to date.
  def self.up_to_date?
    # Must check for keys on multiple levels.
    @@d.keys == @@l.keys && @@d['optional-scripts'].keys == @@l['optional-scripts'].keys
  end

  # Called by load_config if up_to_date? returns false.
  # Current implementation just prints missing keys and exits.
  def self.out_of_date
    missing = []
    missing_optional =  @@d['optional-scripts'].keys - @@l['optional-scripts'].keys
    missing << missing_optional.map { |k| "optional-scripts:#{k}" }
    missing << @@d.keys - @@l.keys
    puts "You're missing the following keys: #{missing.join(', ')}."
    puts "\n!!! Installation failed"
    abort
  end
end

