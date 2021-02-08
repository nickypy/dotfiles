export PATH=~/go/bin:$PATH
export PATH=~/dev/bin:$PATH
export EDITOR=vim

alias vi="nvim"
alias vim="nvim"
alias editvim="vim ~/.vimrc"
alias editzsh="vim ~/.zshrc"
alias venv="source ./venv/bin/activate"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias gs="git status"
alias gco="git checkout"
alias l="ls -la"

# for a less noisy `dotfiles status`
dotfiles config --local status.showUntrackedFiles no

# can do cool things like `some-long-command && notify-done DONE`
function notify-done() {
    osascript <<-EOM
    display notification "$1"
EOM
}

# homebrew completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
    autoload -Uz compinit
    compinit
fi

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{green}on%f %s:%F{cyan}%b%f'
setopt PROMPT_SUBST
export PROMPT='%B%F{magenta}%~%f${vcs_info_msg_0_} %b'

if [[ -f ~/.secrets ]]; then
    source ~/.secrets
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
