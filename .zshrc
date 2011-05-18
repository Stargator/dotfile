# Kelsey's ZSH Configuration
# --------------------------

# Easy access to this config file.
alias zshconfig='vim ~/.zshrc'

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
