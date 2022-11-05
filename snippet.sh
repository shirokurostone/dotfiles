
_snippet_usage(){
  echo <<EOS
snippet

Usage:
  snippet add  [snippet]  add snippet
  snippet show [snippet]  show snippet
  snippet rm   [snippet]  remove snippet
  snippet list            show snippet list
EOS
}

snippet(){
  local snippet_dir="$HOME/.snippet"

  case $1 in
    "list")
      if [ $# -ne 1 ]; then
        _snippet_usage
        return 1
      fi
      ls -1 "${snippet_dir}"
    ;;
    "show")
      if [ $# -ne 2 ]; then
        _snippet_usage
        return 1
      fi
      cat "${snippet_dir}/$2"
    ;;
    "add")
      if [ $# -ne 2 ]; then
        _snippet_usage
        return 1
      fi
      vim "${snippet_dir}/$2"
    ;;
    "rm")
      if [ $# -ne 2 ]; then
        _snippet_usage
        return 1
      fi
      rm "${snippet_dir}/$2"
    ;;
  esac

  return 0
}

_snippet(){
  
  _arguments '1: :->subcommand' '2: :->snippets'

  case "$state" in
    subcommand)
      _values \
        "$state" \
        "list" \
        "show" \
        "add" \
        "rm"
    ;;
    snippets)
      _values \
        "$state" \
        $(snippet list)
    ;;
  esac
}
compdef _snippet snippet

fzf-select-snippet(){
  local snippet_dir="$HOME/.snippet"
  BUFFER="$(
    snippet show $(snippet list |  fzf --prompt "snippet> " \
        --ansi --reverse --no-sort --exact --bind=ctrl-z:ignore \
        --preview "bat --color=always --style=numbers -l zsh '${snippet_dir}/{}'")
  )"
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N fzf-select-snippet
bindkey '^s' fzf-select-snippet
