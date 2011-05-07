# Kelsey's ZSH Configuration
# --------------------------

# Easy access to this config file.
alias zshconfig='vim ~/.zshrc'

# Source oh-my-zsh configurations if installed...
if [ -d $HOME/.oh-my-sh ]; then
  source ~/.zsh_config/oh-my-zsh
fi

# Source aliases.
source ~/.zsh_config/aliases

# Source custom prompt.
source ~/.zsh_config/prompt

# Source custom key bindings.
source ~/.zsh_config/keybindings
