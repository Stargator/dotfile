# Kelsey's ZSH Configuration
# --------------------------

# Source oh-my-zsh configurations if installed...
if [ -d $HOME/.oh-my-sh ]; then
  source ~/.zsh_config/oh-my-zsh
fi

# Easy access to this config file.
alias zshconfig='vim ~/.zshrc'

# Coloured ls output.
alias ls='ls --color'

# Git aliases.
alias g='git'
alias ga='git add'
alias gs='git status'
alias gl='git log --oneline'
alias gc='git commit -am'
alias gb='git branch'
alias gco='git checkout'
alias gm='git merge'
alias gpush='git push origin master'
alias gpull='git pull origin master'

# Not so commonly Git aliases.
alias gitinit='git init'
alias gitname='git config --global user.name'
alias gitemail='git config --global user.email'

# Git Version Control System integration.
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats ' %s' ' %b'
zstyle ':vcs_info:*' actionformats ' %s' ' %b'
precmd () { vcs_info }

# Prompt appearance.
setopt PROMPT_SUBST # Needed for dynamic prompt substitution.
PROMPT='
%B%n %F{green}@%f %m %F{green}on%f %y%F{green}${vcs_info_msg_0_}%f${vcs_info_msg_1_}
%F{green}%~%f ▶ %b' # (Bold) User @ Host on Line \n Working Directory ▶
RPROMPT='%D{%H:%M:%S %A}' # Hour:Minute:Second Weekday

# Key bindings for delete, home, end etc.
# I may need to have another look at this - only works for numpad on my desktop.
bindkey  "\033[3~"    delete-char
bindkey  "\033[3;5~"  delete-char
bindkey  "\033[1~"    beginning-of-line
bindkey  "\033[4~"    end-of-line
bindkey  "\033[7~"    beginning-of-line
bindkey  "\033[8~"    end-of-line
