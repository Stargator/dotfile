module Dotfile

  class Static < Dotfile::Base

    def initialize(dotfile)
      super
      @content = content
    end

    def content
      File.readlines(@source)
    end

  end

end
