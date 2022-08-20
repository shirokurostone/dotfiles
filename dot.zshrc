
########################################
# autoload
autoload -U compinit
compinit -u
autoload -Uz add-zsh-hook
autoload -Uz is-at-least


########################################
# option

# cdで自動pushd
setopt auto_pushd

# ディレクトリスタックに重複して記憶しない
setopt pushd_ignore_dups

# ビープ音無効化
setopt no_beep

# 履歴を共有
setopt share_history

# コマンドが登録済みなら古い方を削除
setopt hist_ignore_all_dups

# スペースを詰めて登録
setopt hist_reduce_blanks

# historyコマンドは登録しない
setopt hist_no_store

# 先頭がスペースなら履歴に追加しない
setopt hist_ignore_space

# ヒストリファイルに時刻も記録
setopt extended_history

# =以降でも補完
setopt magic_equal_subst

# 8ビット目を通す(補完時に日本語を表示可)
setopt print_eight_bit

# 補完候補を詰めて表示
setopt list_packed

# PROMPTに環境変数を含めるのに必要
setopt prompt_subst

# tabで補完候補を切り替える
setopt auto_menu

# !を使った履歴展開を行う
setopt bang_hist

# C-s / C-g を無効化
setopt no_flow_control


########################################
# key bind

# emacs キーバインドに
bindkey -e

# 先頭マッチのヒストリサーチ
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# globを含めるインクリメンタル検索
# http://subtech.g.hatena.ne.jp/secondlife/20110222/1298354852
if is-at-least 4.3.10; then
  bindkey '^R' history-incremental-pattern-search-backward
  bindkey '^S' history-incremental-pattern-search-forward
fi

bindkey '^[^[[D' backward-word # Alt + ←
bindkey '^[^[[C' forward-word  # Alt + →


########################################
# プロンプト

# kube-ps1
if [ -f /opt/homebrew/opt/kube-ps1/share/kube-ps1.sh ]; then
  source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
  export KUBE_PS1_PREFIX=""
  export KUBE_PS1_SUFFIX=""
  export KUBE_PS1_SYMBOL_ENABLE=false
  export KUBE_PS1_PREFIX_COLOR=black
  export KUBE_PS1_SUFFIX_COLOR=black
  export KUBE_PS1_CTX_COLOR=black
  export KUBE_PS1_NS_COLOR=black
fi

# https://qiita.com/mollifier/items/8d5a627d773758dd8078
if is-at-least 4.3.10; then
  autoload -Uz vcs_info
  zstyle ':vcs_info:git:*' formats '%b' '%c%u%m'
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+"
  zstyle ':vcs_info:git:*' unstagedstr "*"

  function _update_vcs_info_msg(){
    local -a segments
    local -a fgs
    local -a bgs

    # timestamp
    segments+=('%*')
    fgs+=(15)
    bgs+=(31)

    # cwd
    segments+=(' %~ ')
    fgs+=(250)
    bgs+=(237)

    # vsc
    LANG=en_US.UTF-8 vcs_info
    if [ -z "${vcs_info_msg_0_}" ]; then
      segments+=(" ")
      fgs+=(237)
      bgs+=(2)
    elif [ -z "$vcs_info_msg_1_" -a -z "$vcs_info_msg_2_" ]; then
      segments+=(" ${vcs_info_msg_0_} ")
      fgs+=(237)
      bgs+=(2)
    else
      segments+=(" ${vcs_info_msg_0_}${vcs_info_msg_1_}${vcs_info_msg_2_} ")
      fgs+=(237)
      bgs+=(9)
    fi

    # kube-ps1
    segments+=(" $(kube_ps1) ")
    fgs+=(237)
    bgs+=(250)

    # exit status
    segments+=(" %? ")
    fgs+=("%(?.250.15)")
    bgs+=("%(?.237.160)")

    # PROMPT構築
    local delimiter=$'\UE0B0'
    local p
    for i in {1..${#segments}}; do
      if [ $i -eq 1 ]; then
        p="%K{${bgs[$i]}}%F{${fgs[$i]}}${segments[$i]}%F{${bgs[$i]}}"
      else
        p="${p}%K{${bgs[$i]}}${delimiter}%F{${fgs[$i]}}${segments[$i]}%F{${bgs[$i]}}"
      fi
    done
    PROMPT="${p}%k${delimiter}%f%k%E
%# "
  }
  add-zsh-hook precmd _update_vcs_info_msg
fi

PROMPT=$'[%F{green}%n%f@%F{cyan}%m%f]%F{magenta}${vcs_message}%f [%*] %F{yellow}%d%f\n%# '
PROMPT2=" > "
RPROMPT=""


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
zstyle ':completion:*' list-colors 'di=34;01' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'


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

REPORTTIME=10;
#ZSH_HOME="$HOME/.zsh"
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# grepオプション
export GREP_OPTIONS="--color=auto"
export GREP_COLOR='31;01'

# Mercurialの文字コード
export HGENCODING=utf-8

# エディタ
export EDITOR=vim

# svn用エディタ
export SVN_EDITOR=vim

# git用エディタ
export GIT_EDITOR=vim

# lessの文字コード
export LESSCHARSET=utf-8

# lessオプション
export LESS="-R --LONG-PROMPT "

# 言語環境
export LANG=ja_JP.UTF-8

# PATH
if [ -d "$HOME/bin" ]; then
  export PATH="$PATH:$HOME/bin"
fi

if [ -d "$HOME/local/bin" ]; then
  export PATH="$PATH:$HOME/local/bin"
fi

if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

if [ -d "$HOME/local/google-cloud-sdk/bin/" ]; then
  export PATH="$PATH:$HOME/local/google-cloud-sdk/bin/"
fi

if [ $commands[go] ]; then
  export GOPATH="$HOME/Projects"
  export PATH="$PATH:$GOPATH/bin"
fi

if [ $commands[rbenv] ]; then
  eval "$(rbenv init - zsh)"
fi

# kubectl補完設定
if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi

########################################
# 関数

workspace(){
  mkdir -p ~/workspace/$(date '+%Y-%m-%d')
  cd "$HOME/workspace/$( ls -1 ~/workspace/ | sort -r | fzf --reverse --preview 'ls -alh ~/workspace/{}' )"
  pwd
}

fzf-select-history(){
  BUFFER=$(history -n 1 | fzf --reverse --prompt "> " --query "$LBUFFER" --tac --no-sort --exact)
  CURSOUR=$#BUFFER
  zle clear-screen
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

function repo(){
  local dir
  dir=$(ghq list -p | fzf --reverse --prompt "> " --preview "ls -lh '{}'" --preview-window 'down:50%' )
  if [ -n "$dir" ]; then
    cd $dir
  fi
}

function cdg(){
  local _toplevel=$(git rev-parse --show-toplevel 2> /dev/null)
  if [ -n "${_toplevel}" ]; then
    local _cddir=$( ( cd "${_toplevel}"; echo "."; git ls-tree -dr --name-only HEAD ) | fzf --reverse --height '50%' --prompt "${_toplevel} > " --query="$*")
    if [ -n "${_cddir}" ]; then
      echo "${_toplevel}/${_cddir}"
      cd "${_toplevel}/${_cddir}"
    fi
  fi
}

function cdc(){
  local _cddir=$((echo "."; echo ".."; ls -1F | grep "/$" ) | fzf --reverse --height '50%' --prompt "$(pwd) > ")
  while [ -n "${_cddir}" -a "${_cddir}" != "." ]; do
    cd "${_cddir}"
    _cddir=$((echo "."; echo ".."; ls -1F | grep "/$" ) | fzf --reverse --height '50%' --prompt "$(pwd) > ")
  done
}

function title(){
  local t=$1
  echo -e "\e]0;${t}\a"
}

function iterm2_foreground(){
  echo -e "\e]1337;StealFocus\a"
}

function iterm2_post_notification(){
  local message=$1
  echo -e "\e]9;${message}\a"
}

function iterm2_change_profile(){
  local profile=$1
  echo -e "\e]1337;SetProfile=${profile}\a"
}

function iterm2_tab_color(){
  local red=$1
  local green=$2
  local blue=$3

  if [ $# -eq 3 ]; then
    echo -e "\e]6;1;bg;red;brightness;${red}\a"
    echo -e "\e]6;1;bg;green;brightness;${green}\a"
    echo -e "\e]6;1;bg;blue;brightness;${blue}\a"
  else
    echo -e "\e]6;1;bg;*;default\a"
  fi
}

########################################
# local設定

if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi

