module Dotfile

  # A static dotfile's content is copied as is to it's destination. No special
  # processing is done.

  class Static < Base

    def initialize(dotfile)
      super
      @content = content
    end

    # Static file content is preserved exactly from the source file.
    def content
      File.readlines(@source)
    end

  end

end
