export PATH=~/go/bin:$PATH
export PATH=~/dev/bin:$PATH
export EDITOR=nvim

alias vi="nvim"
alias vim="nvim"
alias editvim="vim ~/.config/nvim/init.vim"
alias editzsh="vim ~/.zshrc"
alias venv="source ./venv/bin/activate"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias gs="git status"
alias gco="git checkout"
alias gdiff="git diff"
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
alias grecent="git branch --sort=-committerdate"
alias l="ls -la"
alias docker-shell="docker run -it --entrypoint /bin/bash"

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history

# for a less noisy `dotfiles status`
dotfiles config --local status.showUntrackedFiles no

# source a virtualenv, if available
function check-venv() {
if [[ -d ./venv ]]; then
		source ./venv/bin/activate
fi
}

# homebrew completions
if type brew &>/dev/null; then
		FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
		autoload -Uz compinit
		compinit
fi

# case insensitive completions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# history search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line
bindkey -e

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' %F{green}on%f %s:%F{cyan}%b%f'
setopt PROMPT_SUBST
export PROMPT='%B%F{magenta}%~%f${vcs_info_msg_0_} %b'

FILES_TO_SOURCE=(
		~/.secrets
		~/.zprofile
		~/.cargo/env
		~/.fzf.sh
)

for i in ${FILES_TO_SOURCE[@]}; do
		[ -f $i ] && source $i
done

if command -v pyenv 1>/dev/null 2>&1; then
		export PYENV_ROOT="$HOME/.pyenv"
		export PATH="$PYENV_ROOT/bin:$PATH"
		eval "$(pyenv init --path)"
		eval "$(pyenv init -)" 
fi

# auto sources `venv` when available
autoload -U add-zsh-hook
add-zsh-hook -Uz chpwd check-venv
check-venv

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
export PATH=$HOME/bin:$PATH
