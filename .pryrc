# Kelsey's Pry Configuration
# --------------------------

# ANSI colour escape codes and info for prompt.
bright = "\033[1m"
white = "\033[37m"
green = "\033[32m"
blue = "\033[34m"
magenta = "\033[35m"
c_end = "\033[0m"
user = ENV['USER']

prompt = Proc.new do |obj, _, _|
           # For some reason, this pryrc file will not take unicode strings.
           "#{bright}pry #{magenta + user + white} in #{blue + obj.to_s + white} > #{c_end}"
         end

# Other settings, some are defaults, but set in case of future change!
Pry.config.prompt = prompt
Pry.config.editor = "vim"
Pry.config.pager = true
Pry.config.color = true

# Greeting displayed on startup.
# There is currently an issue with pryrc.
# Pry loads both the main ~/.pryrc and a local ./.pryrc at startup.
# However if you're in ~, it loads the same file twice!
# As when you're in ~, ~/.pryrc IS ./.pryrc.
print "\n    Welcome to #{blue}Pry#{c_end}! An Interactive Ruby Shell"
print "\n    You're running Pry in #{green + Dir.pwd + c_end}\n\n"
