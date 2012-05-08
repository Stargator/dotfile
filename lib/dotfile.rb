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

  def self.dir
    File.expand_path('~/.dotfile')
  end

  def self.configure
    @config = Dotfile::Config.new

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

  def self.run_optional(scripts)
    if scripts
      scripts.each do |k, v|
        files = Dir.entries("#{dir}/optional").select do |f|
          f.match(k)
        end

        files.each do |f|
          interpreter = f =~ /\.rb$/ ? 'ruby' : 'sh'
          system("#{interpreter} #{dir}/optional/#{f}") if v
        end
      end
    end
  end

  def self.run_optional_before
    run_optional(@config.config['optional-before'])
  end

  def self.run_optional_after
    run_optional(@config.config['optional-after'])
  end

  def self.copy_defaults
    FileUtils.mkdir_p(dir)
    FileUtils.cp('default/dotfile.conf', dir)
    FileUtils.cp('default/groups.conf', dir)
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

end

# Handles any errors specific to the use of Dotfile.
class DotfileError < StandardError
end
