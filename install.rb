#!/usr/bin/env ruby

Dir.chdir File.dirname($0)
$LOAD_PATH << './lib'

require 'fileutils'
require 'dotfile'

#   Kelsey's Dotfile Generation Script
#   ------------------------------------

#     Acts on configuration in ~/.dotfiles.conf.yml.
#     Will automatically create above file using defaults if it is not found.


puts "Installing Personal Configurations"
puts "------------------------------------\n\n"

# Check for existence of ~/.dotfiles.conf.yml
f = File.expand_path('~/.dotfiles.conf.yml')
unless File.exists?(f)
  puts "~/.dotfiles.conf.yml does not exist... creating.\n\n"
  FileUtils.cp('dotfiles.conf.yml', f)
end

Dotfile.load_config(f)

puts "The following static files/directories will be copied:"
Dotfile.static_files.each do |filename|
  puts "-> " + filename
end
puts "\n"

puts "The following dynamically generated files/directories will be copied:"
Dotfile.templates.each do |filename|
  puts "-> " + filename
end
puts "\n"

puts "Performing template substitutions..."
Dotfile.templates.each do |filename|
  dotfile = Dotfile.new("templates/" + filename)
  dotfile.configure
  dotfile.set_paths
  puts "-> " + dotfile.name
end
puts "\n"

puts "Installing new configuration files..."
Dotfile.all.each do |dotfile|
  FileUtils.mkdir_p(dotfile.destination_path)
  FileUtils.cp(dotfile.source, dotfile.destination)
  puts "-> " + dotfile.name
end

Dotfile.static_files.each do |filename|
  source_file = "static_files/#{filename}"
  FileUtils.cp_r(source_file, ENV['HOME'])
  puts "-> " + filename
end
puts "\n"

puts "Executing extra shell scripts..."
Dotfile.configure_optional
puts "\n"

puts "All done!"
