files = Dir['lib/**/*'] +
        Dir['default/*'] +
        Dir['bin/*'] +
        %w{ LICENSE README.md dotfile.gemspec }

Gem::Specification.new do |s|

  s.name        = 'dotfile'
  s.summary     = "Dynamic dotfile management system."
  s.description = "A simple dotfile management system designed to make updating/tweaking configurations a breeze."

  s.version     = '0.1.1'
  s.date        = '2012-05-16'

  s.author      = 'Kelsey Judson'
  s.email       = 'kelseyjudson@gmail.com'
  s.homepage    = 'http://github.com/kelseyjudson/dotfile'

  s.files       = files
  s.bindir      = 'bin'
  s.executables = ['dotfile']

  s.platform    = Gem::Platform::RUBY
  s.has_rdoc    = false

end