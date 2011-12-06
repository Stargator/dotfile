#!/usr/bin/env ruby

Dir.chdir File.dirname($0)
$LOAD_PATH << './lib'

require 'fileutils'
require 'dotfile'

#   Kelsey's Dotfile Generation Script
#   ------------------------------------

#     Acts on configuration in ~/.dotfiles.conf.yml.
#     Will automatically create above file using defaults if it is not found.


# Check for existence of ~/.dotfiles.conf.yml
f = File.expand_path('~/.dotfiles.conf.yml')
unless File.exists?(f)
  FileUtils.cp('./dotfiles.conf.yml', f)
end

Dotfile.load_config(f)

puts "The following dotfiles will be copied:"
Dotfile.included.each do |filename|
  puts "-> " + filename
end

Dotfile.config_optional
