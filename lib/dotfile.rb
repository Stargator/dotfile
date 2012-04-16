require 'yaml'
require 'tempfile'
require 'fileutils'
require 'dotfile/dotfile_config'
require 'dotfile/dotfile_groupconfig'
require 'dotfile/dotfile_static'
require 'dotfile/dotfile_template'

#   dotfile.rb
#   ------------
#
#     Generate dotfiles based on configurations found in ~/.dotfiles.conf.yml.
#
#     Example of usage:
#     
#         begin
#           Dotfile.configure
#         rescue DotfileError
#           print "Missing keys:\n  "
#           Dotfile.missing.join("\n  ")
#           abort
#         end
#         
#         puts "Copying dotfiles..."
#         Dotfile.all.each do |dotfile|
#           Dotfile.copy_dotfile(dotfile)
#           puts "-> " + dotfile.name
#         end


module Dotfile

  def self.all
    @dotfiles
  end

  def self.configure
    local = File.expand_path('~/.dotfiles.conf.yml')
    default = './dotfiles.conf.yml'
    @config = Dotfile::Config.new(local, default)
    @config.check_local
    @config.read_groups_conf

    @dotfiles = []
    @dotfiles += static_files
    @dotfiles += templates
  end

  # Arrays of dotfiles to copy.

  def self.static_files
    @config.static_files
  end

  def self.templates
    @config.templates
  end

  # Other optional shell scripts to load.

  def self.run_optional_scripts
    @config.config_local['optional-scripts'].each do |k, v|
      system('./resources/optional/' + k + '.sh') if v
    end
  end

  def self.copy_config
    destination = File.expand_path('~/.dotfiles.conf.yml')
    FileUtils.cp('dotfiles.conf.yml', destination)
  end

  def self.copy_dotfile(dotfile)
    FileUtils.mkdir_p(dotfile.destination_path)
    FileUtils.cp(dotfile.source, dotfile.destination)
  end

  def self.copy_all
    all.each do |dotfile|
      copy_dotfile(dotfile)
    end
  end

  def self.missing
    @config.missing
  end

end

# Handles any errors specific to the use of Dotfile.
class DotfileError < StandardError
end
