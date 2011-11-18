require 'yaml'

#   dotfile.rb
#   ------------
#
#     Generate dotfiles based on configurations found in ~/.dotfiles.conf.yml.
#     New files are based on the dotfiles found in this git repository. They
#     are loaded in, edited, and finally written out to the home directory.
#
#       pryrc = Dotfile.new(".pryrc")
#       pryrc.configure
#       pryrc.create
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
  
  def initialize(f)
    @@dotfiles << self

    @type = :placeholder # Type of dotfile
  end

  def configure
    # Modify file differently based on @type
  end

  def create
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

  # Other optional settings to load.
  def self.config_optional
    @@y['other-settings'].each do |k, v|
      system("./lib/" + k + ".sh") if v
    end
  end
end
