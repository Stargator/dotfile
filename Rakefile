$LOAD_PATH << './lib'

require 'dotfile'

### Aliases ###
task :i => :install
task :t => :test
task :e, [:name] => :edit

### Installation ###

desc "Install dotfiles based on personal configuration."
task :install do
  puts "Installing Personal Configurations\n" + 
       "------------------------------------\n\n"

  # Check for existence of ~/.dotfiles.conf.yml
  f = File.expand_path('~/.dotfile/dotfile.conf')
  unless File.exists?(f)
    puts "~/.dotfile/dotfile.conf does not exist... creating.\n\n"
    Dotfile.copy_defaults
  end

  #Load the configuration.
  begin
    Dotfile.configure
  rescue DotfileError
    abort "No groups specified in configuration file. Exiting..."
  end

  # Run preceeding optional scripts.
  puts "Executing preceeding scripts..."
  Dotfile.execute_before
  puts

  # List the static_files to be copied.
  puts "The following static files will be copied:"
  Dotfile.static_files.each do |dotfile|
    puts "-> " + dotfile.name
  end
  puts

  # List the templates to be copied.
  puts "The following dynamically generated files will be copied:"
  Dotfile.templates.each do |dotfile|
    puts "-> " + dotfile.name
  end
  puts

  # Install to home directory.
  puts "Installing new configuration files..."
  Dotfile.all.each do |dotfile|
    Dotfile.copy_dotfile(dotfile)
    puts "-> " + dotfile.name
  end
  puts

  # Run succeeding optional scripts.
  puts "Executing succeeding scripts..."
  Dotfile.execute_after
  puts

  puts "All done!"
end

desc "Run a test installation without modifying files."
task :test do
end

### Dotfile Manipulation ###

# Edits a matching file from config/groups.conf. If multiple matches occur, the user
# selects the appropriate file from a list.
desc "Edit a dotfile loosely matching a given name."
task :edit, [:name] do |t, args|
  def relative_path(path)
    path.sub("#{Dotfile.dir}/dotfiles/", '')
  end

  editor = ENV['EDITOR'] || 'vi'

  groups = Dotfile::GroupConfig.new("#{Dotfile.dir}/groups.conf")
  file_matches = groups.dotfiles.select do |d|
    relative_path(d[:source]).include? args[:name]
  end

  if file_matches.length == 1
    exec editor + ' ' + file_matches[0][:source]
  elsif file_matches.length > 1
    puts "Multiple matches found. Select a file to edit:\n\n"
    file_matches.each_with_index do |d, i|
      puts "#{i + 1}. #{relative_path(d[:source])}"
    end
    print "\nChoice? "
    exec editor + ' ' + file_matches[$stdin.gets.to_i - 1][:source]
  else
    puts "No matches found for '#{args[:name]}'."
  end
end
