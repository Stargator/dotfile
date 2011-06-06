" Kelsey's Custom VIM Settings

set autoindent " Set automatic indentation on.

set number " Set line numbers on.

set expandtab " Spaces replace tabs.

set tabstop=2 " Default tab length.
set shiftwidth=2 " Setting for autoindent.

" The following changes default directories so that vim files are not saved in the same directory as the working file. Make sure that the directory specified here does in fact exist!

set directory=~/.vim/backup " Directory for swap (file.swp - stores changes) files.
set backupdir=~/.vim/backup " Directory for backup (file~) files.

" Commenting out lines, or a range of lines with Visual mode.
map ,# :s/^/# /<CR>:nohlsearch<CR>
map ,/ :s/^/\/\/ /<CR>:nohlsearch<CR>
map ," :s/^/" /<CR>:nohlsearch<CR>
map ,c :s/^[#"/]\/\=\s\=//<CR>:nohlsearch<CR>

set t_Co=256 " Set VIM to 256 color mode. Make sure your terminal is setup correctly.

syntax on " Syntax highlighting is on.
colorscheme molokai " Colorschemes are stored in /usr/share/vim/vim72/colors

set guifont=Inconsolata\ Medium\ 15 " Default GUI font.
set guioptions-=T " Remove the GUI toolbar.
set guioptions-=m " Remove the GUI menu bar.

set lines=32 columns=110
