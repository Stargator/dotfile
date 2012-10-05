require 'dotfile/version'
require 'dotfile/dotfile_configuration'
require 'dotfile/dotfile_settings'
require 'dotfile/dotfile_group_parser'
require 'dotfile/dotfile_base'
require 'dotfile/dotfile_static'
require 'dotfile/dotfile_template'

module Dotfile

  home = ENV['HOME']
  xdg_config = ENV['XDG_CONFIG_HOME'] || "#{home}/.config"

  # Default to XDG Base Directory Specification conformance.
  # We do not use XDG_DATA_HOME as we need to stick to a single directory.

  DIRECTORY       = Dir.exists?("#{xdg_config}/dotfile") ?
                    "#{xdg_config}/dotfile" :
                    "#{home}/.dotfile"

  LOCAL_SETTINGS  = "#{home}/.dotfile.conf.local"
  SETTINGS        = "#{DIRECTORY}/dotfile.conf"
  GROUPS          = "#{DIRECTORY}/groups.conf"
  DOTFILES        = "#{DIRECTORY}/dotfiles"
  FILES           = "#{DIRECTORY}/files"
  SCRIPTS         = "#{DIRECTORY}/scripts"

  class Error < StandardError
  end

end
