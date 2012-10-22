module Dotfile

  # Parent class for dotfile types (eg. +Static+ and +Template+). Provides the
  # base specification for these classes.
  #
  # At the very minimum, child classes should assign +@content+ which is used to
  # write the final dotfile. +@content+ should take the form of an array of
  # lines.

  class Base

    attr_reader :name, :group, :content
    attr_reader :source, :destination, :destination_path

    # Takes a dotfile generated by +Dotfile::Configuration::GroupParser+ as
    # it's sole argument.
    def initialize(dotfile)
      @group = dotfile[:group]
      @source = dotfile[:source]
      @destination = dotfile[:destination]
      @destination_path = File.dirname(@destination)
      @content = []
    end

    # The actual filename of the dotfile (minus the path).
    def filename
      File.split(@source).last
    end

    # Aliased here to #filename, but may be different depending on the
    # implementation. See +Dotfile::Template+.
    def name
      filename
    end

  end
end
