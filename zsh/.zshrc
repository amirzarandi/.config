autoload -U colors && colors
bindkey -e
PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b "
source <(fzf --zsh)
finder() {
    open .
}
mkcd() {
  mkdir -p "$1" && cd "$1"
}

zle -N finder
bindkey '^f' finder
normalize() {
  ffmpeg -i "$1" -af loudnorm=I=-14:TP=-1.0:LRA=11 -c:v copy -c:a aac -b:a 192k output.mp4
}
_comp_options+=(globdots)

export PATH="/Users/$USER/.local/share/bob/nvim-bin/:$PATH"
export PATH="/Users/$USER/Library/Python/3.9/bin/:$PATH"
export PATH="/Users/$USER/.local/bin:$PATH"
export RIPGREP_CONFIG_PATH="/Users/$USER/.config/ripgrep/rgrc"
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
export MAILSYNC_MUTE=1
export HISTIGNORE='exit:cd:ls:bg:fg:history:f:fd:vim'
export NODE_ENV=development 
export PATH="/opt/homebrew/opt/php@7.4/bin:$PATH" 

autoload -U compinit && compinit
autoload -U colors && colors
autoload edit-command-line
zmodload zsh/complist
zle -N edit-command-line
bindkey '^Xe' edit-command-line

lazy_load_nvm() {
  unset -f node nvm
  export NVM_DIR=~/.nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
}

node() {
  lazy_load_nvm
  node $@
}

nvm() {
  lazy_load_nvm
  node $@
}

alias love="/Applications/love.app/Contents/MacOS/love"
alias cmake="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
alias venv="source .venv/bin/activate"
alias vim=nvim
alias vi="nvim"
alias im="nvim"
alias nm="neomutt"
alias p="poetry"
alias mb="~/Documents/projects/microbrew/target/debug/microbrew" 
alias yt="lux" 
alias dl="lux" 
alias dl-audio="yt-dlp -x --audio-format=\"mp3\"" 
alias ls="ls -C -t -U -A -p --color=auto" 
alias src="source ~/.config/zsh/.zshrc"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
