$LOAD_PATH << './lib'

require 'dotfile'

# With this I plan to write an addition to edit that makes it possible to
# specify only the filename. It shall search through the dotfiles in
# groups.conf and find the first match to edit.
# Perhaps if there is more than one match, it will ask the user which file
# to edit from a list.
groups = Dotfile::GroupConfig.new('groups.conf')

desc "Install dotfiles based on configuration."
task :install do
  exec 'ruby install.rb'
end

desc "Run a test install without modifying files."
task :test_install do
end

# eg. rake edit['zsh/zshrc'] - no need to specify the template suffix.
# CURRENTLY DOES NOT WORK - As I added group directories.
desc "Edit a dotfile."
task :edit, :relative_path do |t, args|
  directory = "resources/dotfiles/"
  dotfile = args[:relative_path]
  dotfile = File.exists?(directory + dotfile) ? dotfile : dotfile + '.template'
  exec ENV['EDITOR'] + ' ' + directory + dotfile
end
