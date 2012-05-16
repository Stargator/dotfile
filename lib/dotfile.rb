require 'dotfile/dotfile_config'
require 'dotfile/dotfile_group_parser'
require 'dotfile/dotfile_base'
require 'dotfile/dotfile_static'
require 'dotfile/dotfile_template'

module Dotfile

  VERSION = 0.1
  LOCAL_DIR = File.expand_path('~/.dotfile')

end

# Handles any errors specific to the use of Dotfile.
class DotfileError < StandardError
end
