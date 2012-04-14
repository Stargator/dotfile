task :install do
  exec 'ruby install.rb'
end

task :test_install do
end

# Edit a dotfile - eg. rake edit['zsh/zshrc']
#   - no need to specify the template suffix.
task :edit, :relative_path do |t, args|
  directory = "resources/dotfiles/"
  dotfile = args[:relative_path]
  dotfile = File.exists?(directory + dotfile) ? dotfile : dotfile + '.template'
  exec ENV['EDITOR'] + ' ' + directory + dotfile
end
