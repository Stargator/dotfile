#!/usr/bin/env ruby

Dir.chdir File.dirname($0)
$LOAD_PATH << './lib'

require 'dotfile'

#   install.rb
#   ------------
#
#     Acts on configuration in ~/.dotfiles.conf.yml.
#     Will automatically create above file using defaults if it is not found.


puts "Installing Personal Configurations"
puts "------------------------------------\n\n"

# Check for existence of ~/.dotfiles.conf.yml
f = File.expand_path('~/.dotfiles.conf.yml')
unless File.exists?(f)
  puts "~/.dotfiles.conf.yml does not exist... creating.\n\n"
  Dotfile.copy_config
end

#Load the configuration.
begin
  Dotfile.configure
  puts "Your local config file is up to date.\n\n"
rescue DotfileError
  puts "!!! Your local config file is not up to date.\n\n"
  puts "You're missing the following keys:\n  #{Dotfile.missing.join("\n  ")}"
  puts "\nEither add the keys listed above to your local config file, or remove it."
  puts "\n!!! Installation failed"
  abort
end

# List the static_files to be copied.
puts "The following static files will be copied:"
Dotfile.static_files.each do |dotfile|
  puts "-> " + dotfile.name
end
puts "\n"

# List the templates to be copied.
puts "The following dynamically generated files will be copied:"
Dotfile.templates.each do |dotfile|
  puts "-> " + dotfile.name
end
puts "\n"

# Install to home directory.
puts "Installing new configuration files..."
Dotfile.all.each do |dotfile|
  Dotfile.copy_dotfile(dotfile)
  puts "-> " + dotfile.name
end

# Run any optional scripts.
puts "Executing extra shell scripts..."
Dotfile.run_optional_scripts
puts "\n"

puts "All done!"
