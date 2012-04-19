$LOAD_PATH << './lib'

require 'dotfile'

### Installation ###

desc "Install dotfiles based on personal configuration."
task :install do
  exec 'ruby install.rb'
end

desc "Run a test installation without modifying files."
task :test_install do
end

### Dotfile Manipulation ###

# Edits a matching file from groups.conf. If multiple matches occur, the user
# selects the appropriate file from a list.
desc "Edit a dotfile loosely matching a given name."
task :edit, :name do |t, args|
  def relative_path(path)
    path.sub('./resources/dotfiles/', '')
  end

  groups = Dotfile::GroupConfig.new('groups.conf')
  file_matches = groups.dotfiles.select { |d| relative_path(d[:source]).include? args[:name] }

  if file_matches.length == 1
    exec ENV['EDITOR'] + ' ' + file_matches[0][:source]
  elsif file_matches.length > 1
    puts "Multiple matches found. Select a file to edit:\n\n"
    file_matches.each_with_index do |d, i|
      puts "#{i + 1}. #{relative_path(d[:source])}"
    end
    print "\nChoice? "
    exec ENV['EDITOR'] + ' ' + file_matches[$stdin.gets.to_i - 1][:source]
  else
    puts "No matches found for '#{args[:name]}'."
  end
end
