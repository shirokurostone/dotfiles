
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


########################################
# 補完機能
autoload -U compinit
compinit -u


########################################
# プロンプト
PROMPT="[${USER}@%m]%# "
PROMPT2=" > "
RPROMPT="[%~]"

if [ $UID = 0 ]; then
    PROMPT="%F{red}${PROMPT}%f"
    PROMPT2="%F{red}${PROMPT2}%f"
    RPROMPT="%F{red}${RPROMPT}%f"
fi


########################################
# ls
export LSCOLORS=Exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

case "$OSTYPE" in
    darwin*)
	alias ls="ls -G"
	;;
    linux*)
	alias ls="ls --color=auto"
	;;
esac
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'


########################################
# alias

alias l='ls'
alias ll='ls -lh'
alias la='ls -a'
alias lla='ls -alh'
alias sl='ls'


########################################
# シェル変数・環境変数

REPORTTIME=10;
#ZSH_HOME="$HOME/.zsh"
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# grepオプション
export GREP_OPTIONS="--color=auto"

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
if [ -d $HOME/bin ]; then
    export PATH=$PATH:$HOME/bin
fi

if [ -d $HOME/local/bin ]; then
    export PATH=$PATH:$HOME/local/bin
fi


########################################
# local設定

if [ -f $HOME/.zshrc.local ]; then
    source $HOME/.zshrc.local
fi

