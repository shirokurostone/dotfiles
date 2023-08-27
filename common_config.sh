
# ls
export LSCOLORS='ExGxFxdxCxDxDxhbadEcac'
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32'

case "$OSTYPE" in
  darwin* | FreeBSD*)
    alias ls="ls -G"
    ;;
  linux*)
    alias ls="ls --color=auto"
    ;;
esac

########################################
# alias

alias l='ls'
alias ll='ls -lh'
alias la='ls -a'
alias lla='ls -alh'
alias sl='ls'
alias e='emacs'
alias j='jobs'
alias v="vim ."

alias g="git"
alias k="kubectl"
alias kg="kubectl get"

alias gs="git status"
alias gf="git fetch"
alias ga="git add"
alias gp="git push"
alias gd="git diff"
alias gl="git log"

########################################
# シェル変数・環境変数

# grepオプション
export GREP_OPTIONS="--color=auto"
export GREP_COLOR='31;01'

# エディタ
export EDITOR=vim

# git用エディタ
export GIT_EDITOR=vim

# lessの文字コード
export LESSCHARSET=utf-8

# lessオプション
export LESS="-R --LONG-PROMPT "

# 言語環境
export LANG=ja_JP.UTF-8

# PATH
if [ -d "$HOME/local/bin" ]; then
  export PATH="$PATH:$HOME/local/bin"
fi

########################################
# 関数

workspace(){
  mkdir -p ~/workspace/$(date '+%Y-%m-%d')
  if which fzf > /dev/null 2>&1; then
    cd "$HOME/workspace/$( ls -1 ~/workspace/ | sort -r | fzf --reverse --preview 'ls -a --color=always ~/workspace/{}' --preview-window 'right,75%,border-left' )"
  else
    cd ~/workspace/$(date '+%Y-%m-%d')
  fi
  pwd
}
