require 'dotfile/version'
require 'dotfile/base'
require 'dotfile/static'
require 'dotfile/template'
require 'dotfile/configuration'
require 'dotfile/configuration/settings'
require 'dotfile/configuration/group_parser'

# A simple dotfile management system designed to make updating/tweaking
# configurations a breeze.
#
# Dotfile templates are based around a central configuration file which
# specifies commonly used configuration options. The dotfiles, along with these
# central configuration files may be distributed to other systems and slightly
# tweaked to suit the environment.

module Dotfile

  home = ENV['HOME']
  xdg_config = ENV['XDG_CONFIG_HOME'] || "#{home}/.config"

  # Default to XDG Base Directory Specification conformance.
  # We do not use XDG_DATA_HOME as we need to stick to a single directory.

  xdg_dir = "#{xdg_config}/dotfile"
  home_dir = "#{home}/.dotfile"

  DIRECTORY       = if Dir.exists?(xdg_dir)
                      xdg_dir
                    elsif Dir.exists?(home_dir)
                      home_dir
                    else
                      xdg_dir
                    end

  LOCAL_SETTINGS  = "#{home}/.dotfile.conf.local"
  SETTINGS        = "#{DIRECTORY}/dotfile.conf"
  GROUPS          = "#{DIRECTORY}/groups.conf"
  EXEC            = "#{DIRECTORY}/exec.rb"
  DOTFILES        = "#{DIRECTORY}/dotfiles"
  FILES           = "#{DIRECTORY}/files"
  SCRIPTS         = "#{DIRECTORY}/scripts"

  require EXEC if File.exists?(EXEC)

  class Error < StandardError
  end

end
