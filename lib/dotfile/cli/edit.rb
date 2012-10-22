module Dotfile
  class CLI

    # Defines methods for editing dotfiles.

    module Edit

      private

      def edit_file(file)
        editor = ENV['EDITOR'] || 'vi'
        system(editor + ' ' + file)
      end

    end

  end
end
