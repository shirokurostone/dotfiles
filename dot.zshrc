
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
# 共通設定
source  "$(dirname $(readlink ~/.zshrc))/common_config.sh"

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

zstyle ':completion:*' list-colors "${LS_COLORS}"


########################################
# シェル変数・環境変数

REPORTTIME=10;
#ZSH_HOME="$HOME/.zsh"
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

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
source  "$(dirname $(readlink ~/.zshrc))/snippet.sh"

function _fzf_preview_window_option(){
  if [ $(tput cols) -ge 150 ]; then
    echo -n "right"
  else
    echo -n "down"
  fi
}

fzf-select-history(){
  BUFFER=$(
    history -n 1 | bat --color always --language bash --theme OneHalfDark --style plain \
    | fzf \
      --prompt "> " \
      --query "$LBUFFER" \
      --ansi \
      --reverse  \
      --tac \
      --no-sort \
      --exact \
      --bind 'ctrl-z:ignore' \
      --height '50%' \
  )
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N fzf-select-history
bindkey '^r' fzf-select-history

fzf-select-file(){
  # 参考
  # https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
  # https://github.com/junegunn/fzf?tab=readme-ov-file#2-switch-between-sources-by-pressing-ctrl-d-or-ctrl-f
  list=$(
    find . -name ".git" -prune -o -print | sed -e 's|^./||g' \
    | fzf \
      --ansi \
      --reverse  \
      --no-sort \
      --exact \
      --multi \
      --bind 'ctrl-z:ignore' \
      --bind 'ctrl-d:reload(find . -name ".git" -prune -o -type d -print | sed -e "s|^./||g")+change-prompt(dirs> )' \
      --bind 'ctrl-f:reload(find . -name ".git" -prune -o -type f -print | sed -e "s|^./||g")+change-prompt(files> )' \
      --height '50%' \
      --prompt '> '\
    | while read f; do
        echo -n "${(q)f} ";
      done
  )

  LBUFFER="${LBUFFER}${list}"
  zle reset-prompt
}
zle -N fzf-select-file
bindkey '^t' fzf-select-file

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^s^t' edit-command-line

function fzf-jq(){
  jsonfile=$(mktemp)
  export modefile=$(mktemp)
  trap "rm -f ${jsonfile} ${modefile}" EXIT

  cat > ${jsonfile}
  echo -n "json" > ${modefile}

 result=$(cat ${jsonfile} \
    | (echo "."; jq -rc '[paths] | sort | .[] | map(if  . | type == "number" then . | tostring | "[" + . + "]" else . end ) | join(".") | "." + .' )\
    | fzf \
      --reverse  \
      --prompt "[json]> " \
      --query "." \
      --bind 'tab:replace-query' \
      --bind 'ctrl-w:backward-kill-word' \
      --bind 'enter:print-query' \
      --bind 'ctrl-t:transform:[[ $FZF_PROMPT =~ json ]] && (echo "query" > $modefile; echo "change-prompt([query]> )") || (echo "json" > $modefile; echo "change-prompt([json]> )" )' \
      --preview "sleep 0.1; cat ${jsonfile} | jq --color-output {} " \
      --preview-window "$(_fzf_preview_window_option)" \
  )

  if [[ "$(cat $modefile)" == "json" ]]; then
    cat ${jsonfile} | jq "${result}"
  else
    echo ${result}
  fi

}

function fzf-git-status(){
  git -c color.ui=always status -s \
    | fzf \
      --ansi \
      --reverse  \
      --multi \
      --prompt "> " \
      --query "" \
      --preview 'sleep 0.1; git -c color.ui=always diff $(echo {} | awk "{print \$2}") || true' \
      --preview-window "$(_fzf_preview_window_option)" \
    | sed -e "s/\x1b\[[^m]*m//g" \
    | awk '{print $2}'
}

function fzf-git-branch(){
  git branch -a --format="%(if)%(HEAD)%(then)%(color:bold green)%(end)%(align:20)%(refname:short)%(end) %(objectname:short) %(if)%(upstream)%(then) -> %(upstream:track)%(upstream:short)%(end)" --color=always \
    | fzf \
      --ansi \
      --reverse  \
      --prompt "> " \
      --query "" \
      --preview 'sleep 0.1; git log $(echo {} | sed -e "s/\x1b\[[^m]*m//g" | awk "{print \$1}") --color=always|| true' \
      --preview-window "$(_fzf_preview_window_option)" \
    | sed -e "s/\x1b\[[^m]*m//g" \
    | awk '{print $1}'
}

function fzf-git-log(){
  git log --format="format:%C(yellow)%h%Creset %as %C(green)%<(20,trunc)%cn%Creset %<(20,trunc)%s %d" --color=always\
    | fzf \
      --ansi \
      --reverse  \
      --multi \
      --prompt "> " \
      --query "" \
      --preview 'sleep 0.1; git diff -u $(echo {} | sed -e "s/\x1b\[[^m]*m//g" | awk "{print \$1}") --color=always|| true' \
      --preview-window "$(_fzf_preview_window_option)" \
    | sed -e "s/\x1b\[[^m]*m//g" \
    | awk '{print $1}'
}

function repo(){
  local dir
  dir=$(ghq list -p | fzf --reverse --prompt "> " --preview "ls -alh --color=always '{}'" --preview-window "$(_fzf_preview_window_option)" )
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

