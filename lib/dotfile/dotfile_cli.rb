module Dotfile

  class CLI

    def initialize(options)
      @options = options
    end

    def run
      if @options.edit
        edit_file(@options.edit_file)
      end

      if @options.update
        update
      end
    end

    def edit_file(file)
      puts "I am editing #{file}."
    end

    def update
      puts "I am updating a file."
    end

  end

end
