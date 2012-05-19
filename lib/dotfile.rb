require 'dotfile/version'
require 'dotfile/dotfile_configuration'
require 'dotfile/dotfile_settings'
require 'dotfile/dotfile_group_parser'
require 'dotfile/dotfile_base'
require 'dotfile/dotfile_static'
require 'dotfile/dotfile_template'

module Dotfile

  DIRECTORY       = File.expand_path('~/.dotfile')
  LOCAL_SETTINGS  = File.expand_path('~/.dotfile.conf.local')
  SETTINGS        = "#{DIRECTORY}/dotfile.conf"
  GROUPS          = "#{DIRECTORY}/groups.conf"
  DOTFILES        = "#{DIRECTORY}/dotfiles"
  THEMES          = "#{DIRECTORY}/themes"
  SCRIPTS         = "#{DIRECTORY}/scripts"

  class Error < StandardError
  end

end
