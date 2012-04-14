class Dotfile
end

require './lib/dotfile_group.rb'

groups = Dotfile::Group.new('groups.conf')

desc "Install dotfiles based on configuration."
task :install do
  exec 'ruby install.rb'
end

desc "Run a test install without modifying files."
task :test_install do
end

# eg. rake edit['zsh/zshrc'] - no need to specify the template suffix.
desc "Edit a dotfile."
task :edit, :relative_path do |t, args|
  directory = "resources/dotfiles/"
  dotfile = args[:relative_path]
  dotfile = File.exists?(directory + dotfile) ? dotfile : dotfile + '.template'
  exec ENV['EDITOR'] + ' ' + directory + dotfile
end
