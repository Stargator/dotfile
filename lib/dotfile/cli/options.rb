require 'optparse'

module Dotfile
  class CLI

    # Parses and provides command line options to +Dotfile::CLI+.

    class Options

      attr_accessor :empty, :update, :update_file, :edit, :edit_file, :set,
                    :edit_config, :edit_local, :edit_groups, :setup, :quiet,
                    :usage

      def initialize
        @empty = ARGV.empty?
        @update = false
        @update_file = nil
        @edit = false
        @edit_file = nil
        @set = nil
        @edit_config = false
        @edit_local = false
        @edit_groups = false
        @setup = false
        @quiet = false

        parse
      end

      def parse
        options = OptionParser.new do |opts|
          opts.banner = "Usage: dotfile [option] [file]\n\n"

          opts.on('-u', '--update [FILE]', "Update dotfile/s locally.") do |file|
            @update = true
            @update_file = file if file
          end

          opts.on('-e', '--edit FILE', "Edit a matching dotfile with $EDITOR.") do |file|
            @edit = true
            @edit_file = file
          end

          opts.on('-s', '--set OPTION:VALUE[,...]', "Temporarily set option values.") do |args|
            args_list = args.split(',').map { |arg| arg.split(':') }

            @set = {}
            args_list.each do |arg|
              if arg.length == 2
                @set.merge!({ arg[0] => arg[1] })
              else
                abort "Usage: dotfile --set OPTION:VALUE[,...] -u [FILE]"
              end
            end
          end

          opts.on('-c', '--edit-config', "Edit dotfile.conf.") do
            @edit_config = true
          end

          opts.on('-l', '--edit-local', "Edit ~/.dotfile.conf.local.") do
            @edit_local = true
          end

          opts.on('-g', '--edit-groups', "Edit groups.conf.") do
            @edit_groups = true
          end

          opts.on('-S', '--setup', "Prepare the local environment.") do
            @setup = true
          end

          opts.on('-q', '--quiet', "Suppress all non-critical output.") do
            @quiet = true
          end

          opts.on_tail('-v', '--version', "Show version number.") do
            puts "dotfile v#{VERSION}\n\n" +
                 "    Copyright (C) 2012 Kelsey David Judson\n" +
                 "    Web: http://github.com/kelseyjudson/dotfile"
            exit
          end

          opts.on_tail('-h', '--help', "Show help.") do
            puts opts.help
            exit
          end
        end

        handle_missing_arguments(options) { options.parse! }

        # Must update (full or single) when using --set.
        if @set && !@update
          abort "Usage: dotfile --set OPTION:VALUE[,...] -u [FILE]"
        end

        @usage = options.help
      end

      def handle_missing_arguments(options)
        yield
      rescue OptionParser::MissingArgument
        abort options.help
      end

    end

  end
end
