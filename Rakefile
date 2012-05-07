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
    puts "!!! Your local config file is not up to date.\n\n" +
         "You're missing the following keys:\n\n  #{Dotfile.missing.join("\n  ")}\n\n" +
         "Either add the keys listed above to your local config file, or remove it.\n\n" +
         "!!! Installation failed"
    abort
  end

  # Run preceeding optional scripts.
  puts "Executing preceeding optional shell scripts..."
  Dotfile.run_optional_before
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
  puts "Executing succeeding optional shell scripts..."
  Dotfile.run_optional_after
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
    path.sub('./resources/dotfiles/', '')
  end

  editor = ENV['EDITOR'] || 'vi'

  groups = Dotfile::GroupConfig.new('config/groups.conf')
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
