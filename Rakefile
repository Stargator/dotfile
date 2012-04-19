$LOAD_PATH << './lib'

require 'dotfile'

def getkey
  system 'stty raw -echo'
  key = $stdin.getc
  system 'stty -raw echo'
  key
end

### Installation Tasks

desc "Install dotfiles based on configuration."
task :install do
  exec 'ruby install.rb'
end

desc "Run a test install without modifying files."
task :test_install do
end

# Edits a matching file from groups.conf. If multiple matches occur, the user
# selects the appropriate file from a list.
desc "Edit a dotfile."
task :edit, :filename do |t, args|
  groups = Dotfile::GroupConfig.new('groups.conf')
  file_matches = groups.dotfiles.select { |d| d[:source].include? args[:filename] }

  if file_matches.length == 1
    exec ENV['EDITOR'] + ' ' + file_matches[0][:source]
  elsif file_matches.length > 1
    puts "Multiple matches found. Select a file to edit:"
    file_matches.each_with_index do |d, i|
      puts "#{i + 1}. #{d[:source]}"
    end
    exec ENV['EDITOR'] + ' ' + file_matches[getkey.to_i - 1][:source]
  else
    puts "No match found."
  end
end
