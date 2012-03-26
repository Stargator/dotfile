# encoding: utf-8

# Kelsey's Pry Configuration
# --------------------------

# ANSI colour escape codes and info for prompt.
bright = "\033[1m"
invert = "\033[7m"
white = "\033[37m"
green = "\033[32m"
blue = "\033[34m"
magenta = "\033[35m"
c_end = "\033[0m"
user = ENV['USER']
dir = Dir.pwd

prompt = Proc.new do |obj, _, _|
           blue + obj.to_s + white + " ▶ " + c_end
         end

# Other settings, some are defaults, but set in case of future change!
Pry.config.prompt = prompt
Pry.config.editor = "vim"
Pry.config.pager = true
Pry.config.color = true

# Greeting displayed on startup.
print "\n    Welcome to #{bright + blue}Pry#{c_end}! An Interactive Ruby Shell"
print "\n    You're running Pry in #{bright + green + dir + c_end}\n\n"
