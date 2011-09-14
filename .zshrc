# Kelsey's ZSH Configuration
# --------------------------

# Easy access to this config file.
alias zshconfig='vim ~/.zshrc'

# Add vless with vim pager mode (for syntax highlighting) if found directory.
# As an added note: press 'v' when in less to invoke your editor.
if [ -d /usr/share/vim/vim7? ]; then
  alias vless='vim -u /usr/share/vim/vim7?/macros/less.vim -c "set t_Co=256 | colo molokai"'
fi

# Add ~/Applications to path if directory exists.
if [ -d $HOME/Applications ]; then
  LOCALDIR="$HOME/Applications"
  export PATH="$PATH:$LOCALDIR/bin"
  export MANPATH="$MANPATH:$LOCALDIR/share/man"
fi

# Source oh-my-zsh configurations if installed...
if [ -d $HOME/.oh-my-sh ]; then
  source ~/.config/zsh/oh-my-zsh
fi

# Source aliases.
source ~/.config/zsh/aliases

# Source custom prompt.
source ~/.config/zsh/prompt

# Source custom key bindings.
source ~/.config/zsh/keybindings

# Source local customizations (edit these on a system by system basis).
if [ ! -e $HOME/.zshrc.local ]; then
  touch ~/.zshrc.local
fi

source ~/.zshrc.local
