" Kelsey's Custom GVIM Settings
" -----------------------------

colorscheme freckle " Found in .vim/colors/ 

set guifont=Inconsolata\ Medium\ 15 " Default GUI font.
set guioptions-=T " Remove the GUI toolbar.
set guioptions-=m " Remove the GUI menu bar.

set lines=40 columns=130 " Slighty larger than my default terminal size.

" Following causes GVIM to automatically save sessions between... sessions.
autocmd VimLeave * mksession! ~/.gvimsession " Force save session.
autocmd VimEnter * source ~/.gvimsession " Load session on startup.
