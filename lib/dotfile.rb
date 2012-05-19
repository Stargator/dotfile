require 'dotfile/version'
require 'dotfile/dotfile_config'
require 'dotfile/dotfile_group_parser'
require 'dotfile/dotfile_base'
require 'dotfile/dotfile_static'
require 'dotfile/dotfile_template'

module Dotfile

  LOCAL_DIR = File.expand_path('~/.dotfile')

  class Error < StandardError
  end

end
