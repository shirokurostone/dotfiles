
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
# local設定

if [ -f $HOME/.bashrc.local ]; then
    source $HOME/.bashrc.local
fi

