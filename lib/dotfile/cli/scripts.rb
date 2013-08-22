module Dotfile
  class CLI

    # Defines methods for handling scripts.

    module Scripts

      private

      def execute_scripts(scripts)
        script_files = find_matching_scripts(scripts)
        script_files.each { |script| execute_script(script) }
      end

      # If a file extension is not given in the configuration file, then this
      # will be indiscriminate of similarly named scripts with different file
      # extensions. If this is the case, both scripts will be run.
      def find_matching_scripts(scripts)
        matches = []

        scripts.each do |script|
          matches += Dir.entries(SCRIPTS).select do |f|
            f.match(/^#{script}(\.\w+$|$)/)
          end
        end

        matches
      end

      def execute_script(script)
        f = "#{SCRIPTS}/#{script}"

        if File.executable?(f)
          # Simply execute if script is executable...
          system(f)
        elsif interpreter = guess_interpreter(script)
          # ... else, try to guess interpreter based on file extension.
          system("#{interpreter} #{f}")
        else
          # Shouldn't be crucial to successful update so just warn.
          puts "Warning: Script #{script} not executable."
        end
      end

      def guess_interpreter(filename)
        case filename
        when /\.rb$/ then 'ruby'
        when /\.py$/ then 'python'
        when /\.pl$/ then 'perl'
        when /\.sh$/ then 'sh'
        end
      end

      def execute_before
        puts "Executing preceeding scripts..."
        if scripts = @configuration.settings['execute_before']
          execute_scripts(scripts.split)
        end
        puts
      end

      def execute_after
        puts "Executing succeeding scripts..."
        if scripts = @configuration.settings['execute_after']
          execute_scripts(scripts.split)
        end
        puts
      end

    end

  end
end
