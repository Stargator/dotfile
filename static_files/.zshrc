# Kelsey's ZSH Configuration
# --------------------------

# Exit if shell is not interactive.
if [[ $- != *i* ]]; then return; fi

# Start tmux if installed and not already running ($TERM == screen).
if [[ $(ps -e | grep wmii) != "" ]]; then # pgrep not universally available.
  wmii_running=true
fi

if [[ $(which tmux) != "tmux not found" ]] && \
   [[ $TERM != "screen" ]] && \
   [ ! $wmii_running ]; then
  if [[ $TERM == "xterm" ]]; then
    tmux -2 && exit # 256 colours.
  else
    tmux && exit
  fi
elif [ $wmii_running ]; then
  # This fixes trouble I had with backspace-key/ssh/urxvt/wmii.
  TERM='rxvt-unicode'
fi

# Easy access to this config file.
alias zshconfig='vim ~/.zshrc'

# Set default editor.
export EDITOR='vim'

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

# Run dircolors to set coloured ls output.
if [ -e $HOME/.dircolors ]; then
  eval `dircolors ~/.dircolors`
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