
########################################
# 外部ファイル読み込み
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
  source /usr/share/git-core/contrib/completion/git-prompt.sh
fi

if [ -f /opt/homebrew/etc/bash_completion.d/git-prompt.sh ]; then
  source /opt/homebrew/etc/bash_completion.d/git-prompt.sh
fi

if [ -f /opt/homebrew/etc/bash_completion.d/git-completion.bash ]; then
  source /opt/homebrew/etc/bash_completion.d/git-completion.bash
fi

########################################
# 共通設定
source  "$(dirname $(readlink ~/.zshrc))/common_config.sh"

########################################
# シェル変数・環境変数

#PS1="[\u@\h \W]\$ "
#PS1='[\[\e[32m\u\e[0m\]@\[\e[36m\h\e[0m\]]\[\e[35m${vcs_message}\e[0m\] [\t] \[\e[33m\w\e[0m\]\n\$ '
PS1='[\[\e[32m\u\e[0m\]@\[\e[36m\h\e[0m\]] [\t] \[\e[33m\w\e[0m\]\n\$ '

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
# local設定

if [ -f $HOME/.bashrc.local ]; then
    source $HOME/.bashrc.local
fi

workspace(){
  mkdir -p ~/workspace/$(date '+%Y-%m-%d')
  if which fzf > /dev/null 2>&1; then
    cd "$HOME/workspace/$( ls -1 ~/workspace/ | sort -r | fzf --reverse --preview 'ls -alh ~/workspace/{}' )"
  else
    cd ~/workspace/$(date '+%Y-%m-%d')
  fi
  pwd
}

repo(){
  local match=$(cd ~/Projects; find * -maxdepth 4 -name .git -exec dirname \{\} \; | grep -c "$1")
  if [ "${match}" -eq 1 ]; then
    cd "$HOME/Projects/$(cd ~/Projects; find * -maxdepth 4 -name .git -exec dirname \{\} \; | grep "$1")"
  else
    (cd ~/Projects; find * -maxdepth 4 -name .git -exec dirname \{\} \; | grep "$1")
  fi
}

_repo(){
  _get_comp_words_by_ref cur prev
  local repos="$(cd ~/Projects; find * -maxdepth 4 -name .git -exec dirname \{\} \;)"
  COMPREPLY=( $(compgen -W "${repos}" -- "${cur}") )
}
complete -F _repo repo

cdg(){
  local _toplevel=$(git rev-parse --show-toplevel 2> /dev/null)
  if [ -n "${_toplevel}" ]; then
    if [ -d "${_toplevel}/${1}" ]; then
      cd "${_toplevel}/${1}"
    fi
  fi
}

_cdg(){
  _get_comp_words_by_ref cur prev
  local _toplevel=$(git rev-parse --show-toplevel 2> /dev/null)
  local dirs="$(cd "${_toplevel}"; find * -type d)"
  COMPREPLY=( $(compgen -W "${dirs}" -- "${cur}") )
}
complete -F _cdg cdg