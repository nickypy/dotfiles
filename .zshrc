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

# automatically source the venv if it exists
if [[ -f ./venv/bin/activate  ]]; then
    source ./venv/bin/activate
fi

# automatically source on cd
function cd() {
    builtin cd "$1" || exit

    if [[ -f ./venv/bin/activate  ]]; then
        source ./venv/bin/activate
    fi
}

# can do cool things like `some-long-command && notify-done DONE`
function notify-done() {
    osascript <<-EOM
    display notification "$1"
EOM
}

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{green}on%f %s:%F{cyan}%b%f'
setopt PROMPT_SUBST
export PROMPT='%B%F{magenta}%~%f${vcs_info_msg_0_} %b'
