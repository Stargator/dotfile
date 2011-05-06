# Source oh-my-zsh configurations if installed...
if [ -d $HOME/.oh-my-sh ]; then
  export ZSH=$HOME/.oh-my-zsh
  export ZSH_THEME="cloud"
  if [ -d $ZSH/plugins/zsh-syntax-highlighting ]; then
    plugins=(git zsh-syntax-highlighting)
  else
    plugins=(git)
  fi
  source $ZSH/oh-my-zsh.sh
  unsetopt correct_all # Turn off annoying auto correction.
fi

# Easy access to config file.
alias zshconfig='vim ~/.zshrc'

# Coloured ls output.
alias ls='ls --color'

# Prompt appearance.
setopt PROMPT_SUBST # Needed for dynamic prompt substitution.
PROMPT='
%B%n %F{green}@%F{default} %m %F{green}on%F{default} %l
%F{green}%~%F{default} ▶ %b' # (Bold) User @ Host on Line \n Working Directory ▶
RPROMPT='%D{%H:%M:%S %A}' # Hour:Minute:Second Weekday

# Key bindings for delete, home, end etc.
bindkey  "\033[3~"    delete-char
bindkey  "\033[3;5~"  delete-char
bindkey  "\033[1~"    beginning-of-line
bindkey  "\033[4~"    end-of-line
bindkey  "\033[7~"    beginning-of-line
bindkey  "\033[8~"    end-of-line
