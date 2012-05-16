require 'yaml'
require 'tempfile'
require 'fileutils'
require 'dotfile/dotfile_config'
require 'dotfile/dotfile_group_parser'
require 'dotfile/dotfile_static'
require 'dotfile/dotfile_template'

#   dotfile.rb
#   ------------
#
#     Generate dotfiles based on configurations found in ~/.dotfile/dotfile.conf
#
#     Example of usage:
#     
#         Dotfile.configure
#         
#         puts "Copying dotfiles..."
#         Dotfile.all.each do |dotfile|
#           Dotfile.copy_dotfile(dotfile)
#           puts "-> " + dotfile.name
#         end


module Dotfile

  VERSION = 0.1
  LOCAL_DIR = File.expand_path('~/.dotfile')

  extend FileUtils

  def self.all
    @dotfiles
  end

  def self.configure
    local_config_file = File.expand_path('~/.dotfile.conf.local')
    if File.exists?(local_config_file)
      @config = Dotfile::Config.new(local_config_file)
    else
      @config = Dotfile::Config.new
    end

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

  def self.execute_scripts(scripts)
    if scripts
      scripts.split.each do |s|
        files = Dir.entries("#{LOCAL_DIR}/scripts").select do |f|
          f.match(s)
        end

        files.each do |f|
          interpreter = f =~ /\.rb$/ ? 'ruby' : 'sh'
          system("#{interpreter} #{LOCAL_DIR}/scripts/#{f}")
        end
      end
    end
  end

  def self.execute_before
    execute_scripts(@config.config['execute_before'])
  end

  def self.execute_after
    execute_scripts(@config.config['execute_after'])
  end

  def self.copy_defaults
    mkdir_p(LOCAL_DIR)
    mkdir_p(LOCAL_DIR + '/dotfiles')
    mkdir_p(LOCAL_DIR + '/scripts')
    mkdir_p(LOCAL_DIR + '/themes')
    cp('default/dotfile.conf', LOCAL_DIR)
    cp('default/groups.conf', LOCAL_DIR)
  end

  def self.update_dotfile(dotfile)
    mkdir_p(dotfile.destination_path)
    File.write(dotfile.destination, dotfile.content.join("\n"))
  end

  def self.update_all
    all.each do |dotfile|
      update_dotfile(dotfile)
    end
  end

end

# Handles any errors specific to the use of Dotfile.
class DotfileError < StandardError
end
