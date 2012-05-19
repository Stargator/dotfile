$LOAD_PATH << "#{File.dirname(__FILE__)}/lib"

require 'dotfile/version'

task :build do
  system "gem build dotfile.gemspec"
end

task :release => :build do
  system "gem push dotfile-#{Dotfile::VERSION}.gem"
end
