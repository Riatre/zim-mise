(( ${+commands[mise]} )) && () {
  local command="${commands[mise]}"

  # generating activation file
  local activatefile="$1/mise-activate.zsh"
  if [[ ! -e "$activatefile" || "$activatefile" -ot "$command" ]]; then
    "$command" activate zsh >| "$activatefile"
    zcompile -UR "$activatefile"
  fi

  source "$activatefile"

  # generating completions
  local compfile="$1/functions/_mise"
  if [[ ! -e "$compfile" || "$compfile" -ot "$command" ]]; then
    "$command" complete --shell zsh >| "$compfile"
  fi
} ${0:h}
