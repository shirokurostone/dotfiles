
########################################
# シェル変数・環境変数

#PS1="[\u@\h \W]\$ "
#PS1='[\[\e[32m\u\e[0m\]@\[\e[36m\h\e[0m\]]\[\e[35m${vcs_message}\e[0m\] [\t] \[\e[33m\w\e[0m\]\n\$ '
PS1='[\[\e[32m\u\e[0m\]@\[\e[36m\h\e[0m\]] [\t] \[\e[33m\w\e[0m\]\n\$ '

source /opt/homebrew/etc/bash_completion.d/git-prompt.sh
source /opt/homebrew/etc/bash_completion.d/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=yes
GIT_PS1_SHOWCONFLICTSTATE=yes

function _setup_prompt(){
  local -a segments
  local -a fgs
  local -a bgs

  # timestamp
  segments+=('\t')
  fgs+=(15)
  bgs+=(31)

  # hostname
  segments+=(' \h ')
  fgs+=(232)
  bgs+=(220)

  # cwd
  segments+=(' \w ')
  fgs+=(250)
  bgs+=(237)

  # git
  segments+=(' $(__git_ps1) ')
  fgs+=(237)
  bgs+=(9)

  local p
  local delimiter=$'\xee\x82\xb0' # U+E0B0
  local last_index=$(( ${#segments[*]} - 1 ))
  for i in $(seq 0 ${last_index}); do
    if [ $i -eq 0 ]; then
      p="\e[48;5;${bgs[$i]}m\e[38;5;${fgs[$i]}m${segments[$i]}\e[38;5;${bgs[$i]}m"
    else
      p="${p}\e[48;5;${bgs[$i]}m${delimiter}\e[38;5;${fgs[$i]}m${segments[$i]}\e[38;5;${bgs[$i]}m"
    fi
  done
  PS1="${p}\e[0m\e[38;5;${bgs[$last_index]}m${delimiter}\e[m\n\$ "
}
_setup_prompt

HISTCONTROL="ignoreboth"
HISTFILE=~/.bash_history
HISTSIZE=1000000
SAVEHIST=1000000
FIGNORE=${FIGNORE}:.svn:.git:.hg:CVS

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
export LS_COLORS='di=34;01:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30'

case "$OSTYPE" in
    darwin* | FreeBSD*)
	alias ls="ls -G"
	;;
    linux*)
	alias ls="ls --color=auto"
	;;
esac

########################################
# bash completion 

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi


########################################
# local設定

if [ -f $HOME/.bashrc.local ]; then
    source $HOME/.bashrc.local
fi

if `which peco > /dev/null 2>& 1`; then
  peco-select-history(){
    BUFFER=$(history | history | sed -e 's/^ *[0-9]* *//g' | tail -r | peco --query "$LBUFFER")
    READLINE_LINE=$BUFFER
    READLINE_POINT=$#BUFFER
  }
  bind -x '"\C-r": peco-select-history'
fi

