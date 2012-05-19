files = Dir['lib/**/*'] +
        Dir['default/*'] +
        Dir['bin/*'] +
        %w{ LICENSE README.md dotfile.gemspec }

Gem::Specification.new do |s|

  s.name        = 'dotfile'
  s.summary     = "Dynamic dotfile management system."
  s.description = "A simple dotfile management system designed to make updating/tweaking configurations a breeze."
  s.license     = 'MIT'

  s.version     = '0.1.2'
  s.date        = '2012-05-17'

  s.author      = 'Kelsey Judson'
  s.email       = 'kelseyjudson@gmail.com'
  s.homepage    = 'http://github.com/kelseyjudson/dotfile'

  s.files       = files
  s.bindir      = 'bin'
  s.executables = ['dotfile']

  s.platform    = Gem::Platform::RUBY
  s.has_rdoc    = false

  s.required_ruby_version = '>= 1.9.3'

end
