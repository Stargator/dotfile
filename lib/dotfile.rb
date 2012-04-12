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
#     Every instance of the class is referenced in a class instance variable:
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
  @dotfiles = []
  
  def initialize(file_path)
    if File.directory?(file_path)
      raise ArgumentError, "Templates must be files, not directories."
    end

    unless File.exists?(file_path)
      raise ArgumentError, "File #{file_path} does not exist."
    end

    @file_path = file_path
    if defined? self.class.config_local
      @l = self.class.config_local
    else
      raise DotfileError, "A configuration file must be loaded before creating an instance."
    end

    # Add this instance to array of all instances.
    self.class.dotfiles << self
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
    @dotfiles
  end

  # Loads the user's local config and a default if specified (for comparison).
  def self.load_config(config_local, config_default = :none)
    @l = YAML.load(File.open config_local)

    unless config_default == :none
      @d = YAML.load(File.open config_default)
      raise DotfileError, "~/.dotfiles.conf.yaml is out of date." unless up_to_date?
    end
  end

  # Array of dotfiles to copy.
  def self.static_files
    raise DotfileError, "Local configuration file has not been loaded." unless defined? @l
    @l['included-static-files'].split(' ')
  end

  def self.templates
    raise DotfileError, "Default configuration file has not been loaded." unless defined? @l
    @l['included-templates'].split(' ')
  end

  # Other optional shell scripts to load.
  def self.configure_optional
    raise DotfileError, "Local configuration file has not been loaded." unless defined? @l
    @l['optional-scripts'].each do |k, v|
      system("./lib/optional/" + k + ".sh") if v
    end
  end

  # Prints missing keys from local dotfile. Use if load_config raises error.
  def self.out_of_date
    puts "You're missing the following keys:\n  #{@missing.join("\n  ")}"
    puts "\nEither add the keys listed above to your local config file, or remove it."
  end

  private

  # Access to class instance variable holding all instances of this class.

  # Instance level access to local configuration.
  def self.config_local
    @l
  end

  # Instance level access to dotfiles array.
  def self.dotfiles
    @dotfiles
  end

  def return_option_value(option)
    # If option is a theme, it must be sourced from an external file.
    if option =~ /.*theme/
      File.readlines("resources/themes/#{@l[option]}").join
    else
      @l[option]
    end
  end

  # Returns true if local config file is up to date.
  def self.up_to_date?
    @missing = []
    missing_optional = @d['optional-scripts'].keys - @l['optional-scripts'].keys
    @missing << missing_optional.map { |k| "optional-scripts:#{k}" }
    @missing << @d.keys - @l.keys

    @missing[0].empty? && @missing[1].empty?
  end
end

# Handles any errors specific to the use of Dotfile.
class DotfileError < Exception
end
