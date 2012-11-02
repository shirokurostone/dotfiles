
########################################
# シェル変数・環境変数

PS1="[\u@\h \W]\$ "
HISTCONTROL="ignoreboth"
HISTFILE=~/.bash_history
HISTSIZE=1000000
SAVEHIST=1000000

########################################
# alias

alias l='ls'
alias ll='ls -lh'
alias la='ls -a'
alias lla='ls -alh'
alias sl='ls'


########################################
# ls
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

case "$OSTYPE" in
    darwin* | FreeBSD*)
        alias ls="ls -G"
        ;;
    linux*)
        alias ls="ls --color=auto"
        ;;
esac


########################################
# SQL文誤爆防止

alias CREATE='echo CREATE'
alias SELECT='echo SELECT'
alias INSERT='echo INSERT'
alias UPDATE='echo UPDATE'
alias DELETE='echo DELETE'
alias DROP='echo DROP'
alias EXPLAIN='echo EXPLAIN'
alias WHERE='echo WHERE'
alias FROM='echo FROM'


########################################
# local設定

if [ -f $HOME/.bashrc.local ]; then
    source $HOME/.bashrc.local
fi

