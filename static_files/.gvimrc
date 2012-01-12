" Kelsey's Custom GVIM Settings
" -----------------------------

colorscheme freckle " Found in .vim/colors/ 

set guifont=Inconsolata\ Medium\ 15 " Default GUI font.
set guioptions-=T " Remove the GUI toolbar.
set guioptions-=m " Remove the GUI menu bar.
set guioptions-=r " Remove the GUI right scrollbar.
set guioptions-=L " Remove the GUI left scrollbar.

set lines=40 columns=130 " Slighty larger than my default terminal size.

" Following causes GVIM to automatically save sessions. Restore with :Restore.
autocmd VimLeave * mksession! ~/.gvimsession " Force save session.
command Restore source ~/.gvimsession
