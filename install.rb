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

begin
  Dotfile.load_config(f, 'dotfiles.conf.yml')
  puts "Your local config file is up to date.\n\n"
rescue DotfileError
  puts "!!! Your local config file is not up to date.\n\n"
  Dotfile.out_of_date
  puts "\n!!! Installation failed"
  abort
end

# List the static_files to be copied.
begin
  puts "The following static files/directories will be copied:"
  Dotfile.static_files.each do |filename|
    puts "-> " + filename
  end
rescue DotfileError
  puts "!!! Configuration file has not been loaded. No files listed."
end
puts "\n"

# List the templates to be copied.
begin
  puts "The following dynamically generated files/directories will be copied:"
  Dotfile.templates.each do |filename|
    puts "-> " + filename
  end
rescue DotfileError
  puts "!!! Configuration file has not been loaded. No files listed."
end
puts "\n"

puts "Performing template substitutions..."
begin
  Dotfile.templates.each do |filename|
    dotfile = Dotfile.new("templates/" + filename)
    dotfile.configure
    dotfile.set_paths
    puts "-> " + dotfile.name
  end
rescue ArgumentError
  puts "!!! The file #{filename} doesn't exist, or is a directory."
rescue DotfileError
  puts "!!! Must load a configuration file before configuring templates."
  abort
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

begin
  puts "Executing extra shell scripts..."
  Dotfile.configure_optional
rescue DotfileError
  puts "!!! Configuration file has not been loaded. No files listed."
end
puts "\n"

puts "All done!"
